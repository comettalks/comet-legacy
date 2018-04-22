<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<% 
	session = request.getSession(false);
	int rows = 20;
	int start = 0;
	int affiliate_id = -1;
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center" style="<%=rows<=5?"border: 1px #EFEFEF solid;":"" %>">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
			Popular Groups
		</td>
	</tr>
	<tr>
		<td>
			<ol start="<%=start+1 %>">
<%
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT SQL_CACHE c.comm_id,c.comm_name,ct._no curtalkno,tct._no ttalkno,cn._no curbno,tcn._no tbno " +
					"FROM community c LEFT JOIN " +
					"(SELECT ct.comm_id,COUNT(*) _no FROM contribute ct JOIN colloquium c ON ct.col_id = c.col_id " +
					"AND c._date >= CURDATE() " +
					"GROUP BY ct.comm_id) ct ON c.comm_id = ct.comm_id " +
					"LEFT JOIN " +
					"(SELECT ct.comm_id,COUNT(*) _no FROM contribute ct JOIN colloquium c ON ct.col_id = c.col_id " +
					"GROUP BY ct.comm_id) tct ON c.comm_id = tct.comm_id " +
					"LEFT JOIN " +
					"(SELECT c.comm_id,COUNT(up.col_id) _no FROM contribute ct JOIN community c ON ct.comm_id=c.comm_id " +
					"JOIN userprofile up ON ct.col_id=up.col_id " + 
					"WHERE ct.col_id IN " +
					"(SELECT col_id FROM colloquium WHERE _date >= CURDATE())" +
					"GROUP BY ct.comm_id) cn ON c.comm_id = cn.comm_id " +
					"LEFT JOIN " +
					"(SELECT c.comm_id,COUNT(up.col_id) _no FROM contribute ct JOIN community c ON ct.comm_id=c.comm_id " +
					"JOIN userprofile up ON ct.col_id=up.col_id " + 
					"GROUP BY ct.comm_id) tcn ON c.comm_id = tcn.comm_id ";
	if(affiliate_id > 0){
		sql += "WHERE c.comm_id IN " +
				"(SELECT c.comm_id FROM contribute c " +
				"WHERE c.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")) ";
	}
	sql += "GROUP BY c.comm_id,c.comm_name " +
			"HAVING tbno IS NOT NULL " +
			"ORDER BY curbno DESC, tbno DESC " +
			"LIMIT " + start + "," + rows;
	
    try{
    	rs = conn.getResultSet(sql);
        while(rs.next()){
			String comm_id = rs.getString("comm_id");
			String  comm_name = rs.getString("comm_name");
			int curtalkno = rs.getInt("curtalkno");
			int ttalkno = rs.getInt("ttalkno");
			int curbno = rs.getInt("curbno");
			int tbno = rs.getInt("tbno");

%>
				<li>
					<a href="community.do?comm_id=<%=rs.getString("comm_id")%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'">
						<span style="font-size: 0.8em;"><%=rs.getString("comm_name") %></span>
						&nbsp;
					</a>
					<span style="font-size: 0.6375em;">
						<%=ttalkno>0?curtalkno + "(<b>" + ttalkno + "</b>)&nbsp;talk" + (ttalkno>1?"s":""):""%>&nbsp;
						<%=tbno>0?curbno + "(<b>" + tbno + "</b>)&nbsp;bookmark" + (tbno>1?"s":""):"" %>&nbsp;
					</span>
<% 
			sql = "SELECT SQL_CACHE COUNT(*) _no FROM final_member_community WHERE comm_id=" + comm_id;
			ResultSet rsExt = conn.getResultSet(sql);
			int memberno = 0;
			if(rsExt.next()){
				memberno = rsExt.getInt("_no");
			}
%>					
					<logic:present name="UserSession">
<% 
			UserBean ub = (UserBean)session.getAttribute("UserSession");
			sql = "SELECT SQL_CACHE user_id FROM final_member_community WHERE user_id=" + ub.getUserID() +
					" AND comm_id=" + comm_id;
			rsExt = conn.getResultSet(sql);
			boolean membered = false;
			if(rsExt.next()){
				membered = true;
			}
%>
						<span class="spanmemcid<%=comm_id %>" id="spanmempcid<%=comm_id %>"
							style="display: <%=!membered?"none":"inline" %>;font-size: 0.75em;cursor: pointer;background-color: Khaki;font-weight: bold;color: white;"
							onclick="window.location='community.do?comm_id=<%=comm_id %>'"><%=membered?"&nbsp;Joined&nbsp;":"" %>
						</span>&nbsp;
						<a class="amemcid<%=comm_id %>" href="javascript:return false;" 					
							style="text-decoration: none;font-size: 0.6375em;"
							onmouseover="this.style.textDecoration='underline'" 
							onmouseout="this.style.textDecoration='none'"
							onclick="joinCommunity(<%=ub.getUserID() %>,<%=comm_id %>,this,'spanmempcid<%=comm_id %>')"
						><%=membered?"Leave":"Join" %></a>
					</logic:present>
				</li>
<%
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>
			</ol>
		</td>
	</tr>
	<tr>
		<td>
<% 
	if(rows<=5){
%>
			<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
				<tr>
					<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.9em;font-weight: bold;text-align: center;">
						&nbsp;
						<input class="btn" type="button" id="btnShowRecentMore"
							onclick="window.location='community.do'"
							value="Show More" />
					</td>
				</tr>
				<tr>
					<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
				</tr>
			</table>	
<%	
	}else{

	}
%>
		</td>
	</tr>
</table>