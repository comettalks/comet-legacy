<%@page import="java.util.HashSet"%><%@ page language="java" pageEncoding="ISO-8859-1"%><%@page import="java.util.HashMap"%><%@page import="java.sql.*"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	//response.setContentType("application/json");
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int col_id = 0;
	String note = request.getParameter("note");
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(note != null){
		if(note.equalsIgnoreCase("null")){
			note = null;
		}
	}
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
		out.print("<postNote>");
	}
	if(ub != null){

		connectDB conn = new connectDB();

		try{
			String sql = "DELETE FROM usernote WHERE user_id=" + ub.getUserID() +
					" AND col_id=" + col_id;	        
			conn.executeUpdate(sql);
			
			if(note != null){
				sql = "INSERT INTO usernote (user_id,col_id,usernote,lastupdate) VALUES (?,?,?,NOW())";
				PreparedStatement pstmt = conn.conn.prepareStatement(sql);
				pstmt.setLong(1,ub.getUserID());
				pstmt.setInt(2,col_id);
				pstmt.setString(3,note);
				pstmt.executeUpdate();
			}
			
			if(outputMode.equalsIgnoreCase("json")){
%>"status": "OK"<%					
			}else{
				out.print("<status>OK</status>");	
			}
			
			conn.conn.close();

		}catch(Exception e){
			if(outputMode.equalsIgnoreCase("json")){
				out.print("\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"");
			}else{
				out.print("<status>OK</status>");
				out.print("<message><![CDATA[" + e.toString() + "]]></message>");
			}
			//return;
		}
	}
	if(outputMode.equalsIgnoreCase("json")){
		out.print("}");
	}else{
		out.print("</postNote>");
	}
	
%>