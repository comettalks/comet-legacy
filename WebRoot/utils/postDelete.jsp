<%@ page language="java" pageEncoding="ISO-8859-1"%><%@page import="java.util.HashMap"%><%@page import="java.sql.*"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><% 
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
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(ub != null){

		connectDB conn = new connectDB();

		try{
			if(series_id > 0){
				String name = null;
				String sql = "SELECT name,owner_id FROM series WHERE series_id=" + series_id;
				ResultSet rs = conn.getResultSet(sql);
				if(rs.next()){
					name = rs.getString("name");
					if(ub.getUserID() != rs.getLong("owner_id")){
%>{
"status": "ERROR",
"message": "Only the owner can delete this series."
}<%					
						return;
					}
				}
				
				sql = "INSERT INTO series_bk " +
						"(timestamp,series_id,name,description,lastupdate,user_id,url,owner_id) " +
						"SELECT NOW(),series_id,name,description,lastupdate,user_id,url,owner_id " +
						"FROM series WHERE series_id=" + series_id;
				conn.executeUpdate(sql);
				
				sql = "DELETE FROM series WHERE series_id=" + series_id;
				conn.executeUpdate(sql);
					
%>{
"status": "OK"
}<%					
				
				session.setAttribute("DeleteSeries",name);
			}else if(comm_id > 0){
				String name = null;
				String sql = "SELECT comm_name,owner_id FROM community WHERE comm_id=" + comm_id;
				ResultSet rs = conn.getResultSet(sql);
				if(rs.next()){
					name = rs.getString("comm_name");
					if(ub.getUserID() != rs.getLong("owner_id")){
%>{
"status": "ERROR",
"message": "Only the owner can delete this group."
}<%					
						return;
					}
				}
				
				sql = "INSERT INTO community_bk " +
						"(timestamp,comm_id,comm_name,comm_desc,lastupdate,user_id,url,owner_id) " +
						"SELECT NOW(),comm_id,comm_name,comm_desc,lastupdate,user_id,url,owner_id " +
						"FROM community WHERE comm_id=" + series_id;
				conn.executeUpdate(sql);
				
				sql = "DELETE FROM community WHERE comm_id=" + comm_id;
				conn.executeUpdate(sql);
					
%>{
"status": "OK"
}<%					
				
				session.setAttribute("DeleteGroup",name);
			}

			conn.conn.close();

		}catch(Exception e){
			out.println("{\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"}");
			return;
		}
	}else{
%>{
"status": "ERROR",
"message": "Please login to delete this series."
}<%		
	}
%>