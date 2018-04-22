<%@page import="java.io.IOException"%><%@page import="java.net.MalformedURLException"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	String screenname = request.getParameter("screenname");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<getuserid>");
	if(screenname == null){
		out.print("<status>ERROR: screenname required</status>");
	}else if(screenname.trim().length()==0){
		out.print("<status>ERROR: screenname cannot be blank</status>");
	}else{
		
		connectDB conn = new connectDB();

		String sql = "SELECT user_id FROM userinfo " + 
						"WHERE name = ?";
		
		conn.executeUpdate(sql);
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1, screenname);
			rs = pstmt.executeQuery();
			if(rs.next()){
				int user_id = rs.getInt("user_id");
				out.print("<user_id>" + user_id + "</user_id>");
			}else{
				out.print("<user_id>null</user_id>");
			}
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
	out.print("</getuserid>");
%>