<%@ page language="java" %><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="java.sql.PreparedStatement"%><%
	session = request.getSession(false);
	
	//No user bean -> redirect to sign in page
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String outputMode = request.getParameter("outputMode");
	if(ub == null){
		if(outputMode != null && outputMode.equalsIgnoreCase("json")){
			response.setContentType("application/json");
%>{
"status":"ERROR",
"message":"No User Session"
}<%			
		}else{
%>
<script type="text/javascript">
<!--
	window.onload = function(){
		parent.redirect('login.do');
	}
//-->
</script>
<%
		}
	}else if(request.getParameter("col_id") != null){
		String deletedCols = (String)request.getParameter("col_id");
		connectDB conn = new connectDB();
		if(request.getParameter("post") != null){
			String sql = "DELETE FROM colloquium WHERE user_id = " + ub.getUserID() +
							" AND col_id IN (" + deletedCols + ")";	
			conn.executeUpdate(sql);
			if(outputMode != null && outputMode.equalsIgnoreCase("json")){
				response.setContentType("application/json");
%>{
"status":"OK",
"message":"Delete talk(s) successfully."
}<%			
			}
		}else{
			String sql = "DELETE FROM userprofile WHERE user_id = " + ub.getUserID() +
							" AND col_id IN (" + deletedCols + ")";
			conn.executeUpdate(sql);
			
			sql = "DELETE FROM tags WHERE user_id = " + ub.getUserID() +
					" AND col_id IN (" + deletedCols + ")";	
			conn.executeUpdate(sql);
			
			sql = "DELETE FROM contribute WHERE user_id = " + ub.getUserID() +
					" AND col_id IN (" + deletedCols + ")";
			conn.executeUpdate(sql);
									
			if(outputMode != null && outputMode.equalsIgnoreCase("json")){
				response.setContentType("application/json");
%>{
"status":"OK",
"message":"Unbookmark talk(s) successfully."
}<%			
			}
		}
		
		
		conn.conn.close();
		conn = null;
	}else{
		if(outputMode != null && outputMode.equalsIgnoreCase("json")){
			response.setContentType("application/json");
%>{
"status":"ERROR",
"message":"col_id variable is required."
}<%			
		}else{
%>
<%=(String)request.getParameter("id")%>
<%
		}
	}
%>

