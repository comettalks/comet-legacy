<%@page import="java.util.HashSet"%><%@ page language="java" pageEncoding="ISO-8859-1"%><%@page import="java.util.HashMap"%><%@page import="java.sql.*"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	response.setContentType("application/json");
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int comment_id = 0;
	int series_id = 0;
	int affiliate_id = -1;
	String bookmark = "Bookmark";
	if(request.getParameter("tag_id")!=null){
		tag_id = Integer.parseInt((String)request.getParameter("tag_id"));
	}	
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
	}
	if(request.getParameter("comm_id") != null){
		comm_id = Integer.parseInt((String)request.getParameter("comm_id"));
	}
	if(request.getParameter("comment_id") != null){
		comment_id = Integer.parseInt((String)request.getParameter("comment_id"));
	}
	if(request.getParameter("bookmark") != null){
		bookmark = (String)request.getParameter("bookmark");
	}
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(ub != null){

		connectDB conn = new connectDB();

		try{
			String sql = "SELECT COUNT(*) _no FROM userprofile WHERE user_id=" + user_id +
					" AND col_id=" + col_id;	        
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				int _no = rs.getInt("_no");
				
				String objBookmarkTag = "&nbsp;";

				if(_no > 0){
					if(bookmark.equalsIgnoreCase("Unbookmark")){
						sql = "DELETE FROM userprofile WHERE user_id=" + user_id + " AND col_id=" + col_id;
						conn.executeUpdate(sql);
						
						ub.getBookSet().remove(new Integer(col_id));
					}else{
						objBookmarkTag = "&nbsp;Bookmarked&nbsp;";
					}
				}else{
					if(bookmark.equalsIgnoreCase("Bookmark")){
						sql = "INSERT INTO userprofile (user_id,col_id,lastupdate) VALUES (" + user_id + "," + col_id + ",NOW())";
						conn.executeUpdate(sql);
						objBookmarkTag = "&nbsp;Bookmarked&nbsp;";
					}
				}
				
				//How many emails
				int emailno = 0;
				
				//How many views
				int viewno = 0;
				
				//Bookmark by
				HashSet<Integer> bookSet = null; 
				if(ub != null){
					bookSet = new HashSet<Integer>();
				}
				String bookmarks = "";
				int bookmarkno = 0;
				sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u,userprofile up " +
						"WHERE u.user_id = up.user_id AND up.col_id = " + col_id +
						" GROUP BY u.user_id,u.name ORDER BY u.name";
				ResultSet rsExt = conn.getResultSet(sql);
				if(rsExt!=null){
					while(rsExt.next()){
						String user_name = rsExt.getString("name");
						long _user_id = rsExt.getLong("user_id");
						if(user_name.length() > 0){
							bookmarks += "&nbsp;<a href=\\\"calendar.do?user_id=" + user_id + "\\\">" + user_name + "</a>";
							bookmarkno++;				
						}
						if(ub != null){
							if(ub.getUserID()==user_id){
								bookSet.add(col_id);
							}
						}
					}
				}
				
				sql = "SELECT viewno,emailno FROM col_impact WHERE col_id=" + col_id;
				rsExt = conn.getResultSet(sql);
				while(rsExt.next()){
					viewno = rsExt.getInt("viewno");
					emailno = rsExt.getInt("emailno");
				}
				
%>{
"status": "OK",
"bookmark_tag": "<%=objBookmarkTag %>",
"emailno": "<%=emailno %>",
"viewno": "<%=viewno %>",
"bookmarkno": "<%=bookmarkno %>",
"whombookmark": "<%=bookmarks %>" 
}<%					
			}
			
			rs.close();
			conn.conn.close();

		}catch(Exception e){
			out.println("{\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"}");
			return;
		}
	}
%>