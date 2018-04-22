<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.beans.UserBean"%>
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
			Popular Series
		</td>
	</tr>
	<tr>
		<td>
			<ol start="<%=start+1 %>">
<%
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT SQL_CACHE s.series_id,s.name, bsc._count, tbsc._count totalcount,sc._no, tsc._no totalno " +
					"FROM series s JOIN " +
					"(SELECT sc.series_id,COUNT(*) _count FROM seriescol sc JOIN colloquium c ON sc.col_id = c.col_id " +
					"JOIN userprofile u ON u.col_id = c.col_id " +
					"AND c._date >= (SELECT beginterm FROM sys_config) AND " +
					"c._date < (SELECT endterm FROM sys_config) " +
					"GROUP BY sc.series_id) bsc ON s.series_id = bsc.series_id " +
					"JOIN " +
					"(SELECT sc.series_id,COUNT(*) _count FROM seriescol sc JOIN colloquium c ON sc.col_id = c.col_id " +
					"JOIN userprofile u ON u.col_id = c.col_id " +
					"GROUP BY sc.series_id) tbsc ON s.series_id = tbsc.series_id " +
					"LEFT JOIN " +
					"(SELECT sc.series_id,COUNT(*) _no FROM seriescol sc JOIN colloquium c ON sc.col_id = c.col_id " +
					"AND c._date >= (SELECT beginterm FROM sys_config) AND " +
					"c._date < (SELECT endterm FROM sys_config) " +
					"GROUP BY sc.series_id) sc ON s.series_id = sc.series_id " +
					"LEFT JOIN " +
					"(SELECT sc.series_id,COUNT(*) _no FROM seriescol sc JOIN colloquium c ON sc.col_id = c.col_id " +
					"GROUP BY sc.series_id) tsc ON s.series_id = tsc.series_id " +
					"WHERE TRUE ";
	if(affiliate_id > 0){
		sql += "AND s.series_id IN " +
				"(SELECT afs.series_id FROM affiliate_series afs," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE afs.affiliate_id = cc.child_id " +
				"UNION SELECT series_id FROM affiliate_series WHERE affiliate_id = " + affiliate_id + ") ";
	}
	sql += "GROUP BY s.series_id,s.name,s.description " +
			//"HAVING _min <= CURDATE() AND _max >= CURDATE() " +
	  			"ORDER BY _count DESC,totalcount DESC " +
			"LIMIT " + start + "," + rows;
	//out.println(sql);
    try{
		UserBean ub = (UserBean)session.getAttribute("UserSession");
    	rs = conn.getResultSet(sql);
        while(rs.next()){
        	String _talk_no = "";
        	if(rs.getString("totalno") != null){
            	int _no = rs.getInt("_no");
            	int totalno = rs.getInt("totalno");
            	_talk_no += _no + "(<b>" + totalno + "</b>) talk";
            	if(totalno > 1){
            		_talk_no += "s";
            	}
        	}

        	String _bookmark_no = "";
        	if(rs.getString("totalcount") != null){
            	int _count = rs.getInt("_count");
            	int totalcount = rs.getInt("totalcount");
            	_bookmark_no += _count + "(<b>" + totalcount + "</b>) bookmark";
            	if(totalcount > 1){
            		_bookmark_no += "s";
            	}
        	}

        	String series_id = rs.getString("series_id");
%>
				<li>
					<a href="series.do?series_id=<%=rs.getString("series_id")%>" style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
						>
						<span style="font-size: 0.8em;"><%=rs.getString("name") %></span>
					</a>
					<span style="font-size: 0.6375em;"><%=_talk_no.length() > 0?"&nbsp;" + _talk_no + "&nbsp;":""%>&nbsp;<%=_bookmark_no %>&nbsp;</span>
<%-- 
					<a href="PreCreateSeries.do?series_id=<%=rs.getString("series_id")%>"
						style="text-decoration: none;font-size: 0.6375em;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
					>Edit</a>&nbsp;
--%>
<% 
			int subno = 0;
			if(ub != null){
				sql = "SELECT SQL_CACHE COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
				ResultSet rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					subno = rsExt.getInt("_no");
				}
			}
			/*sql = "SELECT COUNT(*) _no FROM final_like_series WHERE series_id=" + series_id;
			rsExt = conn.getResultSet(sql);
			int likeno = 0;
			if(rsExt.next()){
				likeno = rsExt.getInt("_no");
			}*/
%>					
					<span class="spansubsid<%=series_id %>" id="spansubpsid<%=series_id %>" 
						style="display: <%=subno==0?"none":"inline" %>;font-size: 0.75em;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
						onclick="window.location='series.do?series_id=<%=series_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
					</span>
<%-- 
					<span class="spansubsid<%=series_id %>" id="spansubpsid<%=series_id %>" style="display: <%=subno==0?"none":"inline" %>;font-size: 0.6375em;">
						<img border="0" src="images/subscribe.gif" /> <%=subno %> <%=subno>1?"people":"person" %>
						&nbsp;
					</span>
					<span class="spanlikesid<%=series_id %>" id="spanlikepsid<%=series_id %>" style="display: <%=likeno==0?"none":"inline" %>;font-size: 0.6375em;">
						<img border="0" src="images/like_icon.png" /> <%=likeno %> <%=likeno>1?"people":"person" %>
						&nbsp;
					</span>
--%>
					<logic:present name="UserSession">
<% 
			sql = "SELECT SQL_CACHE user_id FROM final_subscribe_series WHERE user_id=" + ub.getUserID() +
					" AND series_id=" + series_id;
			ResultSet rsExt = conn.getResultSet(sql);
			boolean subscribed = false;
			if(rsExt.next()){
				subscribed = true;
			}
			
			/*sql = "SELECT user_id FROM final_like_series WHERE user_id=" + ub.getUserID() +
					" AND series_id=" + series_id;
			rsExt = conn.getResultSet(sql);
			boolean liked = false;
			if(rsExt.next()){
				liked = true;
			}*/
%>
<%-- 
						<a class="alikesid<%=series_id %>" href="javascript:return false;" 					
							style="text-decoration: none;font-size: 0.6375em;"
							onmouseover="this.style.textDecoration='underline'" 
							onmouseout="this.style.textDecoration='none'"
							onclick="likeSeries(<%=ub.getUserID() %>,<%=series_id %>,this,'spanlikepsid<%=series_id %>')"
						><%=liked?"Unlike":"Like" %></a>
						<span style="font-size: 0.6375em;">&nbsp;</span>
--%>
						<span style="font-size: 0.6375em;">&nbsp;</span>
						<a class="asubsid<%=series_id %>" href="javascript:return false;" 					
							style="text-decoration: none;font-size: 0.6375em;"
							onmouseover="this.style.textDecoration='underline'" 
							onmouseout="this.style.textDecoration='none'"
							onclick="subscribeSeries(<%=ub.getUserID() %>,<%=series_id %>, this, 'spansubpsid<%=series_id %>')"
						><%=subscribed?"Unsubscribe":"Subscribe" %></a>
					</logic:present>
				</li>
<%
		}
		rs.close();
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	 conn.conn.close();
	 conn = null;
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
							onclick="window.location='series.do'"
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