<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	String listtype = (String)request.getParameter("listtype");//snapshot,mutual,like
	if(user_id==null&&ub==null){
%>
	<script type="text/javascript">
		redirect("login.do");
		//window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<% 
		connectDB conn = new connectDB();
		String sql = "SELECT SQL_CACHE COUNT(*) _no FROM (SELECT user0_id,user1_id FROM friend WHERE true ";
		if(user_id==null){
			sql += "AND (user0_id=" + ub.getUserID() + " OR user1_id=" + ub.getUserID() + ") ";
		}else{
			sql += "AND (user0_id=" + user_id + " OR user1_id=" + user_id + ") ";
		}
		if(listtype!=null && listtype.equalsIgnoreCase("mutual")){
			sql += "AND friend_id IN (SELECT friend_id FROM friend WHERE user0_id=" + ub.getUserID() + " OR user1_id=" + ub.getUserID() + ") ";
		}
		sql += "AND breaktime IS NULL GROUP BY user0_id,user1_id) t";
		int friendno = 0;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			friendno = rs.getInt(1);
		}
		
		sql = "SELECT SQL_CACHE f.user0_id,u0.name u0name,f.user1_id,u1.name u1name FROM friend f " +
				"JOIN userinfo u0 ON f.user0_id=u0.user_id JOIN userinfo u1 ON f.user1_id=u1.user_id WHERE TRUE ";
		if(user_id==null){
			sql += "AND (f.user0_id=" + ub.getUserID() + " OR f.user1_id=" + ub.getUserID() + ") ";
		}else{
			sql += "AND (f.user0_id=" + user_id + " OR f.user1_id=" + user_id + ") ";
		}
		int col=1;
		if(listtype!=null){
			if(listtype.equalsIgnoreCase("mutual")){
				sql += "AND friend_id IN (SELECT friend_id FROM friend WHERE user0_id=" + ub.getUserID() + " OR user1_id=" + ub.getUserID() + ") ";
			}
			/*if(listtype.equalsIgnoreCase("like")){
				sql += "AND (user0_id=" + ub.getUserID() + " OR user1_id=" + ub.getUserID() + ") ";
			}*/
			if(listtype.equalsIgnoreCase("snapshot")){
				sql += " ORDER BY RAND() LIMIT 9;";
				col=3;
			}
		}
		
%>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
			Friend<%=friendno>1?"s":"" %> <%=friendno>0?"(" + (friendno) + ")":"" %>
		</td>
	</tr>
	<tr>
		<td style="border: 1px #EFEFEF solid;">
			<table width="100%" border="0" cellspacing="0" cellpadding="1" style="font-size: 0.7em;padding: 5px;">	
<%		
		int i=0;
		rs = conn.getResultSet(sql);
		while(rs.next()){
			String uid = null;
			String uname = null;
			if(user_id==null){
				if(ub.getUserID()!=rs.getLong("user0_id")){
					uid = rs.getString("user0_id");
					uname = rs.getString("u0name");
				}else{
					uid = rs.getString("user1_id");
					uname = rs.getString("u1name");
				}
			}else{
				if(listtype!=null && listtype.equalsIgnoreCase("mutual")){
					
				}else{
					if(Long.parseLong(user_id)!=rs.getLong("user0_id")){
						uid = rs.getString("user0_id");
						uname = rs.getString("u0name");
					}else{
						uid = rs.getString("user1_id");
						uname = rs.getString("u1name");
					}
				}
			}
			if(i%col==0){
				out.println("<tr>");
			}
			if(uid!=null){
				out.print("<td><a href=\"profile.do?user_id=" + uid + "\">" + uname + "</a></td>");
			}
			if(i%col==col-1){
				out.println("</tr>");
			}
			i++;
		}
		if(i%col>0){
			out.println("<td colspan='" + (i%col) + "'>&nbsp;</td></tr>");	
		}
		if(i==0){
			out.print("<tr><td>No Friend</td></tr>");
		}
		if(listtype!=null && listtype.equalsIgnoreCase("snapshot") && i > 9){
			out.print("<tr><td colspan='" + col + "'><a href='javascript:return false;' onclick='loadFriends();return false;'>View All</a></td></tr>");
		}	
%>
			</table>
		</td>
	</tr>
</table>	
<%			
	}
%>
