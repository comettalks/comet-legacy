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
	String subscribe = "Subscribe";
	int speaker_id = 0;
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
	if(request.getParameter("subscribe") != null){
		subscribe = (String)request.getParameter("subscribe");
	}
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(request.getParameter("speaker_id") != null){
		speaker_id = Integer.parseInt((String)request.getParameter("speaker_id"));
	}
	if(ub != null){

		connectDB conn = new connectDB();

		try{
			String sql = "INSERT INTO subscribe (subscribe_date,user_id,unsubscribed) " +
					"VALUES (NOW(),?,?)";	        
			PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1,ub.getUserID());
			pstmt.setInt(2,(subscribe.equalsIgnoreCase("Subscribe")?0:1));
			pstmt.executeUpdate();
			pstmt.close();
			
			sql = "SELECT LAST_INSERT_ID()";
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String subscribeID = rs.getString(1);
				
				String objSubscribeTag = "&nbsp;";

				if(series_id > 0){
					sql = "INSERT INTO subscribe_series (s_id,series_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(subscribeID));
					pstmt.setInt(2,series_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					//Is it you?
					sql = "SELECT COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
					rs = conn.getResultSet(sql);
					if(rs.next()){
						if(rs.getInt(1) > 0){
							objSubscribeTag = "&nbsp;Subscribed&nbsp;";
								/*"<span style=\"cursor: pointer;font-size: 1em;background-color: blue;font-weight: bold;color: white;\" " +
								"onclick=\"window.location='series.do?series_id=" + series_id + "'\">&nbsp;Subscribed&nbsp;</span>";*/
						}
					}
					
					/*sql = "SELECT COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id;
					rs = conn.getResultSet(sql);
					if(rs.next()){
						int subscribeno = rs.getInt(1);

						if(subscribeno > 0){
							//Is it you?
							boolean isyou = false;
							sql = "SELECT COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
							rs = conn.getResultSet(sql);
							if(rs.next()){
								isyou = (rs.getInt(1)>0?true:false);
							}
							
							//Any friends?Pick 3 randomly
							HashMap<Integer,String> friends = new HashMap<Integer,String>();
							sql = "SELECT u.user_id,u.name FROM userinfo u JOIN final_subscribe_series fss ON u.user_id=fss.user_id WHERE fss.series_id=" + series_id +
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
								if(shownno == subscribeno-1){
									spanTitle += " and ";
								}else{
									spanTitle += ", ";
								}
								spanTitle += friend;
								shownno++;
							}
							
							if(shownno < subscribeno){
								spanTitle += " and " + (subscribeno-shownno) + " " + (subscribeno-shownno>1?"people":"person"); 
							}

							objSubscribeTag = "<img border='0' src='images/subscribe.gif' />&nbsp;";
							objSubscribeTag += "<span title='" + spanTitle + "'>" + subscribeno + " " + (subscribeno>1?"people":"person") + "</span>";
							
						}
						
					}*/
					
				}else if(comm_id > 0){
					sql = "INSERT INTO subscribe_community (s_id,comm_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(subscribeID));
					pstmt.setInt(2,comm_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					//Is it you?
					sql = "SELECT COUNT(*) _no FROM final_subscribe_community WHERE comm_id=" + comm_id + " AND user_id=" + ub.getUserID();
					rs = conn.getResultSet(sql);
					if(rs.next()){
						if(rs.getInt(1) > 0){
							objSubscribeTag = "&nbsp;Subscribed&nbsp;";
								/*"<span style=\"cursor: pointer;font-size: 1em;background-color: blue;font-weight: bold;color: white;\" " +
								"onclick=\"window.location='series.do?series_id=" + series_id + "'\">&nbsp;Subscribed&nbsp;</span>";*/
						}
					}
					
				}else if(affiliate_id > 0){
					sql = "INSERT INTO subscribe_affiliate (s_id,affiliate_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(subscribeID));
					pstmt.setInt(2,affiliate_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					//Is it you?
					sql = "SELECT COUNT(*) _no FROM final_subscribe_affiliate WHERE affiliate_id=" + affiliate_id + " AND user_id=" + ub.getUserID();
					rs = conn.getResultSet(sql);
					if(rs.next()){
						if(rs.getInt(1) > 0){
							objSubscribeTag = "&nbsp;Subscribed&nbsp;";
								/*"<span style=\"cursor: pointer;font-size: 1em;background-color: blue;font-weight: bold;color: white;\" " +
								"onclick=\"window.location='series.do?series_id=" + series_id + "'\">&nbsp;Subscribed&nbsp;</span>";*/
						}
					}
				}else if(speaker_id > 0){
					sql = "INSERT INTO subscribe_speaker (s_id,speaker_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(subscribeID));
					pstmt.setInt(2,speaker_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					//Is it you?
					sql = "SELECT COUNT(*) _no FROM final_subscribe_speaker WHERE speaker_id=" + speaker_id + " AND user_id=" + ub.getUserID();
					rs = conn.getResultSet(sql);
					if(rs.next()){
						if(rs.getInt(1) > 0){
							objSubscribeTag = "&nbsp;Subscribed&nbsp;";
								/*"<span style=\"cursor: pointer;font-size: 1em;background-color: blue;font-weight: bold;color: white;\" " +
								"onclick=\"window.location='series.do?series_id=" + series_id + "'\">&nbsp;Subscribed&nbsp;</span>";*/
						}
					}					
				}
				
%>{
"status": "OK",
"subscribe_id": "<%=subscribeID %>",
"subscribe_tag": "<%=objSubscribeTag %>" 
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