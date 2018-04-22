<%@page import="edu.pitt.sis.Html2Text"%><%@page import="java.util.ArrayList"%><%@page import="java.util.HashSet"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="java.util.HashMap"%><%@page import="java.util.Vector"%><%@page import="java.util.Collections"%><%@page import="java.util.Iterator"%><%
	session=request.getSession(false);
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String col_id = (String)request.getParameter("col_id");
	if(col_id == null){
		out.print("<status>ERROR: col_id must be submitted</status>");
	}else{
		String sql = "SELECT c.col_id " +
						"FROM colloquium c " +
						"WHERE c.col_id = " + col_id;

		connectDB conn = new connectDB();
		try{
			ResultSet rs = conn.getResultSet(sql);
			if(!rs.next()){
				out.print("<status>ERROR: Talk Not Found</status>");
			}else{
				//out.print("<status>OK</status>");
				out.print("<colloquium id=\"" + col_id + "\">");

				//Insert time log
				long uid = 0;
				if(ub != null){
					uid = ub.getUserID();
				}
				String sessionID = session.getId();
				Cookie cookies[] = request.getCookies();
				//Find session id
				boolean foundSessionID = false;
				if(cookies != null){
					for(int i=0;i<cookies.length;i++){
						Cookie c = cookies[i];
					    if (c.getName().equalsIgnoreCase("sessionid")) {
					        sessionID = c.getValue();
					    	foundSessionID = true;
					    }			
					}
				}
				String ipaddress = request.getRemoteAddr();
				sql = "INSERT INTO talkview (user_id,viewTime,col_id,ipaddress,sessionid) VALUES (" + uid + ",NOW()," + col_id + ",'" + ipaddress + "','" + sessionID + "')";
				conn.executeUpdate(sql);

				//Bookmark by
				int bookmarkno = 0;
				String bookmarks = "";
				sql = "SELECT COUNT(*) _no FROM userinfo u JOIN userprofile up " +
						"ON u.user_id = up.user_id WHERE up.col_id = " + col_id;
				sql +=	" GROUP BY u.user_id";
				rs = conn.getResultSet(sql);
				if(rs!=null){
					while(rs.next()){
						bookmarkno = rs.getInt("_no");
					}
				}
				if(bookmarkno > 0){
					out.print("<bookmarkno>" + bookmarkno + "</bookmarkno>");
				}

				//How many emails
				int emailno = 0;
				sql = "SELECT emails FROM emailfriends WHERE col_id=" + col_id;
				rs = conn.getResultSet(sql);
				if(rs!=null){
					HashSet<String> setEmails = new HashSet<String>();
					while(rs.next()){
						String emails = rs.getString("emails");
						String[] email = emails.split(",");
						if(email != null){
							for(int i=0;i<email.length;i++){
								String aEmail = email[i].trim().toLowerCase();
								setEmails.add(aEmail);
							}
						}
					}
					emailno = setEmails.size();
				}
				if(emailno > 0){
					out.print("<emailno>" + emailno + "</emailno>");
				}
				
				//How many views
				int viewno = 0;
				sql = "SELECT ipaddress,sessionid,COUNT(*) _no FROM talkview WHERE col_id=" + col_id + " GROUP BY ipaddress,sessionid";
				rs = conn.getResultSet(sql);
				if(rs!=null){
					while(rs.next()){
						ipaddress = rs.getString("ipaddress");
						String sessionid = rs.getString("sessionid").trim().toLowerCase();
						if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
							viewno += rs.getInt("_no");
						}else{
							viewno++;
						}
						
					}
				}
				
				//Update talks impact into db
				sql = "SELECT COUNT(*) _no FROM col_impact WHERE col_id=" + col_id;
				rs = conn.getResultSet(sql);
				if(rs.next()){
					int found = rs.getInt("_no");
					if(found == 0){
						sql = "INSERT INTO col_impact (col_id,viewno,bookmarkno,emailno,timestamp) VALUES (" + 
								col_id + "," + viewno + "," + bookmarkno + "," + emailno + ",NOW())";
					}else{
						sql = "UPDATE col_impact SET viewno=" + viewno + ",bookmarkno=" + bookmarkno + 
								",emailno=" + emailno + ",timestamp=NOW() WHERE col_id=" + col_id;
					}
					conn.executeUpdate(sql);
				}

				if(viewno > 0){
					out.print("<viewno>" + viewno + "</viewno>");
				}
				out.print("</colloquium>");
			}
			rs.close();	
			conn.conn.close();
			conn = null;																					
		}catch(SQLException e){

		}
	}
%>