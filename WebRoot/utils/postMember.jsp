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
	String join = "Join";
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
	if(request.getParameter("join") != null){
		join = (String)request.getParameter("join");
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
			String sql = "INSERT INTO member (member_date,user_id,unmembered) " +
					"VALUES (NOW(),?,?)";	        
			PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1,ub.getUserID());
			pstmt.setInt(2,(join.equalsIgnoreCase("Join")?0:1));
			pstmt.executeUpdate();
			pstmt.close();
			
			sql = "SELECT LAST_INSERT_ID()";
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String memberID = rs.getString(1);
				
				String objMemberTag = "&nbsp;";

				if(comm_id > 0){
					sql = "INSERT INTO member_community (m_id,comm_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(memberID));
					pstmt.setInt(2,comm_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					sql = "SELECT COUNT(*) _no FROM final_member_community WHERE comm_id=" + comm_id + " AND user_id=" + ub.getUserID();
					rs = conn.getResultSet(sql);
					if(rs.next()){
						int memberno = rs.getInt(1);

						if(memberno > 0){
							objMemberTag = "&nbsp;Joined&nbsp;";
							//Is it you?
							/*boolean isyou = false;
							sql = "SELECT COUNT(*) _no FROM final_member_community WHERE comm_id=" + comm_id + " AND user_id=" + ub.getUserID();
							rs = conn.getResultSet(sql);
							if(rs.next()){
								isyou = (rs.getInt(1)>0?true:false);
							}
							
							//Any friends?Pick 3 randomly
							HashMap<Integer,String> friends = new HashMap<Integer,String>();
							sql = "SELECT u.user_id,u.name FROM userinfo u JOIN final_member_community fmc ON u.user_id=fmc.user_id WHERE fmc.comm_id=" + comm_id +
									" AND u.user_id<>" + ub.getUserID() + " ORDER BY RAND() LIMIT 3";
							rs = conn.getResultSet(sql);
							while(rs.next()){
								friends.put(rs.getInt(1),rs.getString(2));
							}

							String spanTitle = "";
							int shownno = 0;
							if(isyou){
								spanTitle = "You";
								shownno++;
							}
							
							for(String friend : friends.values()){
								if(shownno == memberno-1){
									if(shownno > 0){
										spanTitle += " and ";
									}
								}else{
									spanTitle += ", ";
								}
								spanTitle += friend;
								shownno++;
							}
							
							if(shownno < memberno){
								spanTitle += " and " + (memberno-shownno) + " " + (memberno-shownno>1?"people":"person"); 
							}

							objMemberTag = "<img border='0' src='images/member.gif' />&nbsp;";
							objMemberTag += "<span title='" + spanTitle + "'>" + memberno + " " + (memberno>1?"people":"person") + "</span>";
							
							*/	
						}else{
							//If left the group, we need to unsubscribe it too
							sql = "SELECT COUNT(*) _no FROM final_subscribe_community WHERE comm_id=" + comm_id + " AND user_id=" + ub.getUserID();
							rs = conn.getResultSet(sql);
							if(rs.next()){
								if(rs.getInt(1) > 0){
									sql = "INSERT INTO subscribe (subscribe_date,user_id,unsubscribed) " +
											"VALUES (NOW(),?,?)";	        
									pstmt = conn.conn.prepareStatement(sql);
									pstmt.setLong(1,ub.getUserID());
									pstmt.setInt(2,1);
									pstmt.executeUpdate();
									pstmt.close();
									
									sql = "SELECT LAST_INSERT_ID()";
									rs = conn.getResultSet(sql);
									if(rs.next()){
										String subscribeID = rs.getString(1);
									
										sql = "INSERT INTO subscribe_community (s_id,comm_id) VALUES (?,?)";
										pstmt = conn.conn.prepareStatement(sql);
										pstmt.setInt(1,Integer.parseInt(subscribeID));
										pstmt.setInt(2,comm_id);
										pstmt.executeUpdate();
										pstmt.close();
									}
								}
							}

							
						}
					}
					
					rs.close();
				}
				
%>{
"status": "OK",
"member_id": "<%=memberID %>",
"member_tag": "<%=objMemberTag %>" 
}<%					
			}
			
			conn.conn.close();

		}catch(Exception e){
			out.println("{\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"}");
			return;
		}
	}
%>