<%@ page language="java"%>
<%@page import="edu.pitt.sis.GoogleScholarCitation"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<% 
	String col_id = (String)request.getParameter("col_id");
	if(col_id == null){
%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashSet"%><table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td>
			<i>col_id is required</i>
		</td>
	</tr>
</table>
<% 
	}else{
		connectDB conn = new connectDB();
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		String sql = "SELECT comm_id FROM contribute WHERE (col_id=" + col_id  + " AND user_id=" + ub.getUserID() + ") " +
						"OR userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id=" + col_id  + " AND user_id=" + ub.getUserID() + ")";
		ResultSet rs = conn.getResultSet(sql);
		HashSet<Integer> postGroupSet = new HashSet<Integer>();
		while(rs.next()){
			postGroupSet.add(rs.getInt("comm_id"));
		}
		sql = "SELECT c.comm_id,c.comm_name FROM community c JOIN final_member_community fmc ON c.comm_id = fmc.comm_id " +
						"WHERE fmc.user_id=" + ub.getUserID() +
						" GROUP BY c.comm_name,c.comm_id";
		rs = conn.getResultSet(sql);
%>					
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td style="font-size: 0.85em;font-weight: bold;">
			&nbsp;Post to Groups
		</td>
	</tr>
<% 
		while(rs.next()){
%>
	<tr>
		<td valign="top" style="font-size: 0.75em;">
			&nbsp;
			<input class="chkPostGroup" type="checkbox" 
				<%=postGroupSet.contains(rs.getInt("comm_id"))?"checked='checked'":"" %> 
				value="<%=rs.getString("comm_id") %>">
			&nbsp;<%=rs.getString("comm_name") %>
		</td>
	</tr>
<% 
		}
%>
	<tr>
		<td><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
</table>
<%		
		conn.conn.close();
	}
%>
