<%@page import="java.sql.ResultSet"%><%@page import="edu.pitt.sis.db.connectDB"%><%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%><%
	session=request.getSession(false);
	String col_id = request.getParameter("col_id");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	
	if(col_id == null){
		out.print("<status>ERROR: col_id required</status>");
	}else{
		connectDB conn = new connectDB();
		
		String sql = "SELECT t.tag,t.tag_id FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
					"JOIN userprofile u ON tt.userprofile_id = u.userprofile_id WHERE u.col_id=" + col_id + 
					" GROUP BY t.tag,t.tag_id";
		ResultSet rs = conn.getResultSet(sql);
		out.print("<tags>");
		while(rs.next()){
			String tag_id = rs.getString("tag_id");
			String tag = rs.getString("tag");
			
			out.print("<tag id=\"" + tag_id + "\">");
			out.print("<![CDATA[" + tag + "]]>");
			out.print("</tag>");
		}
		out.print("</tags>");		
	}
%>