<%@ page language="java" pageEncoding="ISO-8859-1"%><%@page import="java.util.HashMap"%><%@page import="java.sql.*"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="edu.pitt.sis.MailNotifier"%><%@page import="java.util.HashSet"%><% 
	//response.setContentType("application/json");
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int comment_id = 0;
	int series_id = 0;
	int affiliate_id = -1;
	String groups = request.getParameter("group");
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
	}
	if(groups != null){
		if(groups.equalsIgnoreCase("null")){
			groups = null;
		}
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
		out.print("<postGroups>");
	}
	if(ub != null){

		connectDB conn = new connectDB();

		try{
			HashSet<Integer> noNotifiedGroup = new HashSet<Integer>();
			HashSet<Integer> notifiedGroup = new HashSet<Integer>();
			HashMap<Integer,String> groupMap = new HashMap<Integer,String>();
			if(groups != null){
				String sql = "SELECT comm_id FROM contribute WHERE col_id=" + col_id + " GROUP BY comm_id";
				ResultSet rs = conn.getResultSet(sql);
				while(rs.next()){
					noNotifiedGroup.add(rs.getInt("comm_id"));
				}
			}
			
			String sql = "DELETE FROM contribute WHERE (user_id=" + user_id +
					" AND col_id=" + col_id + ") OR "+
					"userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE user_id=" + user_id + 
					" AND col_id=" + col_id + ")";	        
			conn.executeUpdate(sql);
			
			if(groups != null){
				String sqlInsertGroups = "";
				String[] agroup = groups.trim().split(";;");
				for(int i=0;i<agroup.length;i++){
					comm_id = Integer.parseInt(agroup[i]);
					if(sqlInsertGroups.length() == 0){
						sqlInsertGroups = "INSERT INTO contribute (user_id,col_id,comm_id,lastupdate) VALUES ";
					}else{
						sqlInsertGroups += ",";
					}
					sqlInsertGroups += "(" + user_id + "," + col_id + "," + comm_id + ",NOW())";
					
					if(!noNotifiedGroup.contains(comm_id)){
						notifiedGroup.add(comm_id);
					}
				}
				if(sqlInsertGroups.length() > 0){
					conn.executeUpdate(sqlInsertGroups);
				}
			}
			
			sql = "SELECT COUNT(*) _no FROM contribute WHERE (user_id=" + user_id +
					" AND col_id=" + col_id + ") OR "+
					"userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE user_id=" + user_id + 
					" AND col_id=" + col_id + ")";
			ResultSet rs = conn.getResultSet(sql);
			boolean userposted = false;
			if(rs != null){
				while(rs.next()){
					long _no = rs.getLong("_no");
					if(_no>0)userposted = true;
				}
			}
			
			if(outputMode.equalsIgnoreCase("json")){
%>"status": "OK",
"group_tag": "<%=userposted?"Edit Groups Posted":"Post to Groups" %>",
"groups": [<% 
		 		//Groups
		 		sql = "SELECT c.comm_id,c.comm_name FROM community c JOIN contribute ct ON c.comm_id = ct.comm_id " +
		 				"WHERE  ct.col_id = " + col_id +
						" OR ct.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id=" + col_id + ")" +
						" GROUP BY c.comm_name,c.comm_id";
		 		rs = conn.getResultSet(sql);
		 		if(rs != null){
		 			int i=0;
		 			while(rs.next()){
		 				String cname = rs.getString("comm_name");
		 				int cid = rs.getInt("comm_id");
		 				groupMap.put(cid,cname);
		 				if(cname.length() > 0){
%><%=i>0?",":"" %>{"comm_id":"<%=cid %>","comm_name":"<%=cname.replaceAll("\"","\\\"") %>"}<%
							i++;
 						}
 					}
 				}

%>]<%					
			}else{
				out.print("<status>OK</status>");
				out.print("<group_tag><![CDATA[" + (userposted?"Edit Groups Posted":"Post to Groups") + "]]></group_tag>");
				out.print("<groups>");
		 		//Groups
		 		sql = "SELECT c.comm_id,c.comm_name FROM community c JOIN contribute ct ON c.comm_id = ct.comm_id " +
		 				"WHERE  ct.col_id = " + col_id +
						" OR ct.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id=" + col_id + ")" +
						" GROUP BY c.comm_name,c.comm_id";
		 		rs = conn.getResultSet(sql);
	 			while(rs.next()){
	 				String cname = rs.getString("comm_name");
	 				int cid = rs.getInt("comm_id");
	 				groupMap.put(cid,cname);
	 				if(cname.length() > 0){
						out.print("<group id=\"" + cid + "\"><![CDATA[" + cname + "]]></group>");
	 				}
	 			}
				out.print("</groups>");
			}
			
			//Notify members of new posted groups
			//But not for user itself
			if(notifiedGroup.size() > 0){
				sql = "SELECT u.name,u.email FROM userinfo u WHERE u.user_id=" + user_id;
				String sender_name = null;
				String sender_email = null;
				rs = conn.getResultSet(sql);
				if(rs.next()){
					sender_name = rs.getString("name");
					sender_email = rs.getString("email");
				}
				
				for(int cid : notifiedGroup){
					String comm_name = groupMap.get(cid);
					if(comm_name!=null){
						sql = "SELECT GROUP_CONCAT(DISTINCT u.email SEPARATOR ',') email " +
								"FROM final_member_community fm JOIN userinfo u ON fm.user_id=u.user_id " + 
								"JOIN final_subscribe_community fs ON fm.comm_id=fs.comm_id AND fm.user_id=fs.user_id " +
								"WHERE fm.comm_id=" + cid + " AND u.user_id<>" + user_id + 
								" GROUP BY fm.comm_id";
								//out.print(sql + "\n");
						rs = conn.getResultSet(sql);
						while(rs.next()){
							String[] email = rs.getString("email").split(",");
							//out.print("email" + rs.getString("email") + "\n");
							MailNotifier.groupNotify(col_id,email,sender_name,sender_email,comm_name);
						}
					}
				}
			}//~Notify
			
			conn.conn.close();

		}catch(Exception e){
			if(outputMode.equalsIgnoreCase("json")){
				out.print("\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"");
			}else{
				out.print("<status>OK</status>");
				out.print("<message><![CDATA[" + e.toString() + "]]></message>");
			}
			//return;
		}
	}
	if(outputMode.equalsIgnoreCase("json")){
		out.print("}");
	}else{
		out.print("</postGroups>");
	}	
%>