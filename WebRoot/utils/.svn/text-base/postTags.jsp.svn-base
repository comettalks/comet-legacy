<%@page import="java.util.HashSet"%><%@ page language="java" pageEncoding="ISO-8859-1"%><%@page import="java.util.HashMap"%><%@page import="java.sql.*"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	//response.setContentType("application/json");
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int comment_id = 0;
	int series_id = 0;
	int affiliate_id = -1;
	String tags = request.getParameter("tag");
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
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
		out.print("<postTags>");
	}
	if(tags != null){
		if(tags.equalsIgnoreCase("null")){
			tags = null;
		}
	}
	if(ub != null){

		connectDB conn = new connectDB();

		try{
			String sql = "DELETE FROM tags WHERE user_id=" + user_id +
							" AND col_id=" + col_id;	        
			conn.executeUpdate(sql);
			
			if(tags != null){
				String sqlInsertTags = "";
				String[] atag = tags.trim().split(";;");
				for(int i=0;i<atag.length;i++){
					String tag = atag[i];
					sql = "SELECT tag_id FROM tag WHERE tag = ?";
					PreparedStatement pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1, tag.toLowerCase());
					long tag_id = -1;
					ResultSet rs = pstmt.executeQuery();
					if(rs.next()){
						tag_id = rs.getInt(1);
					}else{
						sql = "INSERT INTO tag (tag,lastupdate) VALUES (?,NOW())";
						pstmt.close();
						pstmt = conn.conn.prepareStatement(sql);
						pstmt.setString(1, tag.toLowerCase());
						pstmt.executeUpdate();
						
						rs.close();
						sql = "SELECT LAST_INSERT_ID()";
						rs = conn.getResultSet(sql);
						if(rs.next()){
							tag_id = rs.getLong(1);
						}
						rs.close();
					}
					if(sqlInsertTags.length() == 0){
						sqlInsertTags = "INSERT INTO tags (user_id,col_id,tag_id,lastupdate) VALUES ";
					}else{
						sqlInsertTags += ",";
					}
					sqlInsertTags += "(" + user_id + "," + col_id + "," + tag_id + ",NOW())";
				}
				if(sqlInsertTags.length() > 0){
					conn.executeUpdate(sqlInsertTags);
				}
			}
			
			sql = "SELECT COUNT(*) _no FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
					"WHERE LENGTH(t.tag) > 0 AND tt.col_id = " + col_id + " AND tt.user_id=" + user_id +
					" GROUP BY t.tag_id ";
			boolean usertagged = false;
			ResultSet rs = conn.getResultSet(sql);
			if(rs != null){
				while(rs.next()){
					long _no = rs.getLong("_no");
					if(_no > 0)usertagged = true;
				}
			}
			if(outputMode.equalsIgnoreCase("json")){
%>
"status": "OK",
"tag_tag": "<%=usertagged?"Edit Keywords":"Add Keywords" %>",
"tags": [<% 
 		//Tags
 		sql = "SELECT t.tag_id,t.tag FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
 				"WHERE  tt.col_id = " + col_id +
 				" GROUP BY t.tag_id,t.tag " +
 				"ORDER BY t.tag";
 		rs = conn.getResultSet(sql);
 		if(rs != null){
 			int i=0;
 			while(rs.next()){
 				String tag = rs.getString("tag");
 				long tag_id = rs.getLong("tag_id");
 				if(tag.length() > 0){
%><%=i>0?",":"" %>{"tag_id":"<%=tag_id %>","tag":"<%=tag.replaceAll("\"","\\\"") %>"}<%
					i++;
 				}
 			}
 		}

%>]<%					
			}else{
				out.print("<status>OK</status>");
				out.print("<tag_tag><![CDATA[" + (usertagged?"Edit Keywords":"Add Keywords") + "]]></tag_tag>");
		 		//Tags
		 		sql = "SELECT t.tag_id,t.tag FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
		 				"WHERE  tt.col_id = " + col_id +
		 				" GROUP BY t.tag_id,t.tag " +
		 				"ORDER BY t.tag";
		 		rs = conn.getResultSet(sql);
		 		if(rs != null){
		 			out.print("<tags>");
		 			while(rs.next()){
		 				String tag = rs.getString("tag");
		 				long tag_id = rs.getLong("tag_id");
		 				if(tag.length() > 0){
		 					out.print("<tag tag_id=\"" + tag_id + "\"><![CDATA[" + tag + "]]></tag>");
		 				}
		 			}
		 			out.print("</tags>");
		 		}
			}
			
			conn.conn.close();

		}catch(Exception e){
			if(outputMode.equalsIgnoreCase("json")){
				out.println("\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"");
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
		out.print("</postTags>");
	}

%>