<?xml version="1.0" encoding="utf-8" ?>
<%@ page language="java" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="edu.pitt.sis.MailNotifier"%>
<%@page import="java.sql.ResultSet"%>
<%
	session = request.getSession(false);
	
	if(request.getParameter("col_id") != null && request.getParameter("emails") != null && request.getParameter("user_id") != null){
		int col_id = Integer.parseInt((String)request.getParameter("col_id"));
		String emails = (String)request.getParameter("emails");
		long user_id = Long.parseLong(request.getParameter("user_id"));
		connectDB conn = new connectDB();
		//Log email notification
		String sql = "INSERT INTO emailfriends (col_id,user_id,emails,timesent) VALUES (?,?,?,NOW())";
		PreparedStatement pstmt = conn.conn.prepareStatement(sql);
		pstmt.setInt(1,col_id);
		pstmt.setLong(2,user_id);
		pstmt.setString(3,emails);	
		pstmt.execute();
		//Commit sending emails
		sql = "SELECT name,email FROM userinfo WHERE user_id=" +  user_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String sender_name = rs.getString("name");
			String sender_email = rs.getString("email");
			String[] email = emails.split(",");
			MailNotifier.suggestionNotify(col_id,email,sender_name,sender_email);
		}
		conn.conn.close();
		conn = null;
		//Tell parent to reset send email friends function		
%>
<status>OK</status>
<%		
	}else{
%>
<status>ERROR</status>
<message>Missing parameters</message>
<%	
	}
%>

