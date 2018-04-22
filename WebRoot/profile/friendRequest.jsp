<%@ page language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	response.setContentType("application/json");
	String user_id = (String)request.getParameter("user_id");
	String request_type = "add";
	if(request.getParameter("request_type")!=null){
		request_type = (String)request.getParameter("request_type");
	}
	if(user_id==null){
%>{
	"status": "ERROR",
	"message": "No user id specified."
}<%	
	}else{
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		if(ub == null){
%>{
	"status": "ERROR",
	"message": "Please login to send Friend Request!"	
}<%
			return;
		}
		
		connectDB conn = new connectDB();
		//Need to check whether there request exists
		String sql = "SELECT request_id FROM request WHERE ";
		if(request_type.equalsIgnoreCase("drop")){
			sql += "requester_id=" + ub.getUserID() + " AND target_id=" + user_id;
		}else{
			sql += "requester_id=" + user_id + " AND target_id=" + ub.getUserID();
		}
		sql += " AND accepttime IS NULL AND rejecttime IS NULL AND droprequesttime IS NULL" +
			" ORDER BY requesttime DESC LIMIT 1";
		int request_id = 0;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			request_id = rs.getInt(1);
		}
		try {
			if(request_type.equalsIgnoreCase("add")){
				if(request_id==0){
					sql ="INSERT INTO request (requester_id,target_id,requesttime) VALUES (?,?,NOW())";
					PreparedStatement pstmt = conn.conn.prepareStatement(sql);
					pstmt.setLong(1,ub.getUserID());
					pstmt.setLong(2,Long.parseLong(user_id));
					pstmt.executeUpdate();
					pstmt.close();
				}
			}else{//Update Mode: Accept, Reject, Drops request
				
				sql = "UPDATE request SET ";
				if(request_type.equalsIgnoreCase("accept")){
					sql += "accepttime=NOW()";
				}else
				if(request_type.equalsIgnoreCase("notnow")){
					sql += "notnowtime=NOW()";
				}else
				if(request_type.equalsIgnoreCase("reject")){
					sql += "rejecttime=NOW()";
				}else
				if(request_type.equalsIgnoreCase("drop")){
					sql += "droprequesttime=NOW()";
				}else{
%>{
	"status": "ERROR",
	"message": "Request Type cannot be blank"
}<%					
					return;
				}
				sql += " WHERE request_id=" + request_id;
				conn.executeUpdate(sql);
				
				if(request_type.equalsIgnoreCase("accept")){
					String user0_id = "" + ub.getUserID();
					String user1_id = user_id;
					if(ub.getUserID() > Long.parseLong(user_id)){
						user0_id = user_id;
						user1_id = "" + ub.getUserID();
					}
					sql = "SELECT COUNT(*) _no FROM friend WHERE user0_id=" + user0_id + 
							" AND user1_id=" + user1_id + " AND breaktime IS NULL";
					rs = conn.getResultSet(sql);
					if(rs.next()){
						int _no = rs.getInt(1);
						if(_no <= 0){
							sql = "INSERT INTO friend (user0_id,user1_id,friendtime) VALUES (" + user0_id + "," + user1_id + ",NOW())";
							conn.executeUpdate(sql);
						}
					}
				}
			}
		} catch (SQLException e) {
%>{
	"status": "ERROR",
	"message": "<%=e.getMessage() %>"
}<%			
			return;
		}
%>{
	"status": "OK"
}<%
	}
%>