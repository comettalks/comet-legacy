<%@page import="java.sql.ResultSet"%><%@page import="edu.pitt.sis.db.connectDB"%><%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%><%
	session=request.getSession(false);
	String col_id = request.getParameter("col_id");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	
	if(col_id == null){
		out.print("<status>ERROR: col_id required</status>");
	}else{
		connectDB conn = new connectDB();
		
		String sql = "SELECT c.comment_id,c.comment,date_format(c.comment_date,_utf8'%W, %b %d, %Y') _date,u.user_id,u.name " +
					"FROM comment c JOIN comment_col cc ON c.comment_id = cc.comment_id " +
					"JOIN userinfo u ON c.user_id = u.user_id WHERE cc.col_id=" + col_id + 
					" ORDER BY c.comment_date";
		ResultSet rs = conn.getResultSet(sql);
		out.print("<comments>");
		while(rs.next()){
			String comment_id = rs.getString("comment_id");
			String comment = rs.getString("comment");
			String _date = rs.getString("_date");
			String user_id = rs.getString("user_id");
			String name = rs.getString("name");
			
			out.print("<comment id=\"" + comment_id + "\">");
			out.print("<user_id><![CDATA[" + user_id + "]]></user_id>");
			out.print("<name><![CDATA[" + name + "]]></name>");
			out.print("<date><![CDATA[" + _date + "]]></date>");
			out.print("<c><![CDATA[" + comment + "]]></c>");
			out.print("</comment>");
		}
		out.print("</comments>");		
	}
%>