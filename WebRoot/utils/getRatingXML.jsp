<%@page import="java.io.IOException"%><%@page import="java.net.MalformedURLException"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	String user_id = request.getParameter("user_id");
	String col_id = request.getParameter("col_id");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<getrating>");
	if(user_id == null){
		out.print("<status>ERROR: user_id required</status>");
	}else if(user_id.trim().length()==0){
		out.print("<status>ERROR: user_id cannot be blank</status>");
	}else if(col_id == null){
		out.print("<status>ERROR: col_id required</status>");
	}else if(col_id.trim().length()==0){
		out.print("<status>ERROR: col_id cannot be blank</status>");
	}else{
		
		connectDB conn = new connectDB();

		String sql = "SELECT rating FROM lastuserfeedback WHERE " + 
						"user_id = ? AND col_id = ?";
		
		PreparedStatement pstmt = null;
		try{
			out.print("<status>OK</status>");

			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1, Long.parseLong(user_id));
			pstmt.setLong(2, Long.parseLong(col_id));
			rs = pstmt.executeQuery();
			
			String rating = "null";
			while(rs.next()){
				rating = rs.getString("rating");
			}
			
			out.print("<rating>" + rating + "</rating>");
			
			rs = null;
			pstmt.close();
			conn.conn.close();
			conn = null;
		}catch(SQLException e){
			try {
				if (pstmt != null) pstmt.close();			
				if (conn.conn !=null) conn.conn.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}	
	out.print("</getrating>");
%>