<%@ page language="java" %><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="java.sql.PreparedStatement"%><%@page import="edu.pitt.sis.MailNotifier"%><%@page import="java.sql.ResultSet"%><%
	session = request.getSession(false);
	
	String outputMode = "html";//request.getParameter("outputMode");
	
	if(request.getParameter("outputMode") !=null){
		outputMode = request.getParameter("outputMode");
	}
	//No user bean -> redirect to sign in page
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	if(ub == null){
		if(outputMode.equalsIgnoreCase("html")){
%>
<script type="text/javascript">
<!--
	window.onload = function(){
		parent.redirect('login.do');
	}
//-->
</script>
<%		
		}else if(outputMode.equalsIgnoreCase("json")){
			response.setContentType("application/json");
			out.print("{\"status\": \"ERROR\",");
			out.print("\"message\": \"Authentication is required.\"}");
		}else{//XML
			response.setContentType("application/xml");
			out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
			out.print("<sendEmails>");
			out.print("<status>ERROR</status>");
			out.print("<message>Authentication is required.</message>");
			out.print("</sendEmails>");
		}
	}else if(request.getParameter("col_id") != null && request.getParameter("emails") != null){
		int col_id = Integer.parseInt((String)request.getParameter("col_id"));
		String emails = (String)request.getParameter("emails");
		String usermessage = request.getParameter("usermessage");
		connectDB conn = new connectDB();
		//Log email notification
		String sql = "INSERT INTO emailfriends (col_id,user_id,emails,timesent,message) VALUES (?,?,?,NOW(),?)";
		PreparedStatement pstmt = conn.conn.prepareStatement(sql);
		pstmt.setInt(1,col_id);
		pstmt.setLong(2,ub.getUserID());
		pstmt.setString(3,emails);	
		pstmt.setString(4,usermessage);
		pstmt.execute();
		//Commit sending emails
		sql = "SELECT name,email FROM userinfo WHERE user_id=" +  ub.getUserID();
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String sender_name = rs.getString("name");
			String sender_email = rs.getString("email");
			String[] email = emails.split(",");
			MailNotifier.suggestionNotify(col_id,email,sender_name,sender_email,usermessage);
		}
		conn.conn.close();
		conn = null;
		
		if(outputMode.equalsIgnoreCase("html")){
		//Tell its parent to reset send email friends function		
%>
<script type="text/javascript">
<!--
	window.onload = function(){
		parent.enableEmailFriends();
	}
//-->
</script>
<%	
		}else if(outputMode.equalsIgnoreCase("json")){
			response.setContentType("application/json");
			out.print("{\"status\": \"OK\"}");
		}else{//XML
			response.setContentType("application/xml");
			out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
			out.print("<sendEmails>");
			out.print("<status>OK</status>");
			out.print("<message>Authentication is required.</message>");
			out.print("</sendEmails>");
		}
	}else{
		
		if(outputMode.equalsIgnoreCase("html")){
%>
<%=(String)request.getParameter("id")%>
<%	
		}else if(outputMode.equalsIgnoreCase("json")){
			response.setContentType("application/json");
			out.print("{\"status\": \"ERROR\",");
			out.print("\"message\": \"col_id and emails are required.\"}");
		}else{//XML
			response.setContentType("application/xml");
			out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
			out.print("<sendEmails>");
			out.print("<status>ERROR</status>");
			out.print("<message>col_id and emails are required.</message>");
			out.print("</sendEmails>");
		}
	}
%>

