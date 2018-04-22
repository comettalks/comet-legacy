<%@page import="java.io.IOException"%><%@page import="java.net.MalformedURLException"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	String user_id = request.getParameter("user_id");
	String col_id = request.getParameter("col_id");
	String comment = request.getParameter("comment");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<addcomment>");
	if(user_id == null){
		out.print("<status>ERROR: user_id required</status>");
	}else if(user_id.trim().length()==0){
		out.print("<status>ERROR: user_id cannot be blank</status>");
	}else if(col_id == null){
		out.print("<status>ERROR: col_id required</status>");
	}else if(col_id.trim().length()==0){
		out.print("<status>ERROR: col_id cannot be blank</status>");
	}else if(comment == null){
		out.print("<status>ERROR: comment required</status>");
	}else if(comment.trim().length()==0){
		out.print("<status>ERROR: comment cannot be blank</status>");
	}else{
		
		connectDB conn = new connectDB();

		String sql = "INSERT INTO comment (comment,comment_date,user_id) " +
		"VALUES (?,NOW(),?)";	        
		
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1,comment);
			pstmt.setInt(2,Integer.parseInt(user_id));
			pstmt.executeUpdate();
			pstmt.close();

			sql = "SELECT LAST_INSERT_ID()";
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String commentID = rs.getString(1);
				sql = "INSERT INTO comment_col (comment_id,col_id) VALUES (?,?)";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setInt(1,Integer.parseInt(commentID));
				pstmt.setInt(2,Integer.parseInt(col_id));
				pstmt.executeUpdate();
				pstmt.close();
				
				rs.close();
			}
			
			out.print("<status>OK</status>");
			
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
	out.print("</addcomment>");
%>