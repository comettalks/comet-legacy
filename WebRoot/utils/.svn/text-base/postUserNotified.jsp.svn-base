<%@ page language="java" pageEncoding="ISO-8859-1"%><%@page import="java.sql.*"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	//response.setContentType("application/json");
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	/*int user_id = 0;
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
	}*/
	String outputMode = "json";//request.getParameter("outputMode");
	
	if(request.getParameter("outputMode") !=null){
		outputMode = request.getParameter("outputMode");
	}
	
	if(outputMode.equalsIgnoreCase("json")){
		response.setContentType("application/json");
		out.print("{");
	}else{
		response.setContentType("application/xml");
		out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
		out.print("<postUserNotified>");
	}
	if(/*request.getParameter("user_id")!=null &&*/ ub == null){

%>
"status": "ERROR",
"message": "User not login!"
<%
	}else{
		connectDB conn = new connectDB();

		try{
			String sql = "INSERT INTO usernotified (user_id,notified_date) " +
					"VALUES (?,NOW())";	        
			PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1,ub.getUserID());
			pstmt.executeUpdate();
			pstmt.close();
			
			if(outputMode.equalsIgnoreCase("json")){
%>
"status": "OK"
<%					
			}else{
				out.print("<status>OK</status>");
			}
			
			conn.conn.close();

		}catch(Exception e){
			if(outputMode.equalsIgnoreCase("json")){
				out.print("\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"");
			}else{
				out.print("<status>ERROR</status>");
				out.print("<message><![CDATA[" + e.toString() + "]]></message>");
			}
			//return;
		}
		
	}
	if(outputMode.equalsIgnoreCase("json")){
		out.print("}");
	}else{
		out.print("</postUserNotified>");
	}

%>