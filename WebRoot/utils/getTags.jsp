<%@page import="java.io.IOException"%><%@page import="java.net.MalformedURLException"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	String user_id = request.getParameter("user_id");
	String col_id = request.getParameter("col_id");
	String outputMode = "xml";//request.getParameter("outputMode");
	
	if(request.getParameter("outputMode") !=null){
		outputMode = request.getParameter("outputMode");
	}
	
	if(outputMode.equalsIgnoreCase("json")){
		response.setContentType("application/json");
		out.print("{");
	}else{
		response.setContentType("application/xml");
		out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
		out.print("<getTags>");
	}
	
	if(user_id == null && col_id == null){
		if(outputMode.equalsIgnoreCase("json")){
			out.print("\"status\": \"ERROR\",");
			out.print("\"message\": \"col_id and/or user_id are required.\"}");
		}else{
			out.print("<status>ERROR</status>");
			out.print("<message>col_id and/or user_id are required.</message>");
		}
	}else{
		
		connectDB conn = new connectDB();

		String sql = "SELECT t.tag,t.tag_id FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id WHERE LENGTH(TRIM(t.tag))>0";
		if(user_id!=null){
			sql += " AND tt.user_id=" + user_id;
		}
		if(col_id!=null){
			sql += " AND tt.col_id=" + col_id;
		}
		sql += " GROUP BY t.tag,t.tag_id";
		if(user_id!=null && col_id == null){
			sql += " ORDER BY COUNT(*) DESC LIMIT 10";
		}
		
		try{
			if(outputMode.equalsIgnoreCase("json")){
				out.print("\"status\": \"OK\",");
			}else{
				out.print("<status>OK</status>");
			}

			rs = conn.getResultSet(sql);
			
			if(outputMode.equalsIgnoreCase("json")){
				out.print("\"tags\": [");
			}else{
				out.print("<tags>");
			}
			int tagno = 0;
			while(rs.next()){
				if(outputMode.equalsIgnoreCase("json")){
					if(tagno!=0){
						out.print(",");
					}
					out.print("{\"tag_id\":\"" + rs.getString("tag_id") + "\",");
					out.print("\"tag\":\"" + rs.getString("tag") + "\"}");
					tagno++;
				}else{
					out.print("<tag id=\"" + rs.getString("tag_id") + "\">");
					out.print("<![CDATA[" + rs.getString("tag") + "]]>");
					out.print("</tag>");
				}
			}
			if(outputMode.equalsIgnoreCase("json")){
				out.print("]");
			}else{
				out.print("</tags>");
			}
			
			rs = null;
			conn.conn.close();
			conn = null;
		}catch(SQLException e){
			try {
				if (conn.conn !=null) conn.conn.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}	
	if(outputMode.equalsIgnoreCase("json")){
		out.print("}");
	}else{
		out.print("</getTags>");
	}

%>