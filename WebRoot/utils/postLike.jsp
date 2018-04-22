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
	String like = "Like";
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
	if(request.getParameter("like") != null){
		like = (String)request.getParameter("like").trim();
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
			String sql = "INSERT INTO _like (like_date,user_id,unliked) " +
					"VALUES (NOW(),?,?)";	        
			PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1,user_id);
			pstmt.setInt(2,(like.equalsIgnoreCase("Like")?0:1));
			pstmt.executeUpdate();
			pstmt.close();
			
			sql = "SELECT LAST_INSERT_ID()";
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String likeID = rs.getString(1);
				
				String objLikeTag = "&nbsp;";

				if(comment_id > 0){
					sql = "INSERT INTO like_comment (like_id,comment_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(likeID));
					pstmt.setInt(2,comment_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					sql = "SELECT COUNT(*) _no FROM final_like_comment WHERE comment_id=" + comment_id;
					rs = conn.getResultSet(sql);
					if(rs.next()){
						int likeno = rs.getInt(1);

						if(likeno > 0){
							//Is it you?
							boolean isyou = false;
							sql = "SELECT COUNT(*) _no FROM final_like_comment WHERE comment_id=" + comment_id + " AND user_id=" + user_id;
							rs = conn.getResultSet(sql);
							if(rs.next()){
								isyou = (rs.getInt(1)>0?true:false);
							}
							
							//Any friends?Pick 3 randomly
							HashMap<Integer,String> friends = new HashMap<Integer,String>();
							sql = "SELECT u.user_id,u.name FROM userinfo u JOIN final_like_comment flc ON u.user_id=flc.user_id WHERE flc.comment_id=" + comment_id +
									" AND u.user_id<>" + user_id + " ORDER BY RAND() LIMIT 3";
							rs = conn.getResultSet(sql);
							while(rs.next()){
								friends.put(rs.getInt(1),rs.getString(2));
							}
													
							//Find out this is comment2comment or not
							sql = "SELECT COUNT(*) _no FROM comment_comment WHERE comment_id=" + comment_id;
							rs = conn.getResultSet(sql);
							if(rs.next()){
								int _no = rs.getInt(1);
								String spanTitle = "";
								int shownno = 0;
								if(_no > 0){

									if(isyou){
										spanTitle = "You";
										shownno++;
									}
									
									for(String friend : friends.values()){
										if(shownno == likeno-1){
											if(shownno > 0){
												spanTitle += " and ";
											}
										}else{
											spanTitle += ", ";
										}
										spanTitle += friend;
										shownno++;
									}
									
									if(shownno < likeno){
										spanTitle += " and " + (likeno-shownno) + " " + (likeno-shownno>1?"people":"person"); 
									}
									
									objLikeTag = "<img border='0' src='images/like_icon.png' />&nbsp;";
									objLikeTag += "<span title='" + spanTitle + "'>" + likeno + " " + (likeno>1?"people":"person") + "</span>";

								}else{//This is a like to status comment so show more detail
								
									objLikeTag = "<img border='0' src='images/like_icon.png' />&nbsp;";
									if(isyou){
										objLikeTag += "You";
										shownno++;
									}
									
									for(int friendid : friends.keySet()){
										if(shownno == likeno-1){
											if(shownno > 0){
												objLikeTag += " and ";
											}
										}else{
											objLikeTag += ", ";
										}
										objLikeTag += "<a href='profile.do?user_id=" + friendid + "'>" + friends.get(friendid) + "</a>";
										shownno++;
									}
									
									if(shownno < likeno){
										objLikeTag += " and " + (likeno-shownno) + " " + (likeno-shownno>1?"people":"person"); 
									}
									
									objLikeTag += " like" + (likeno==1&&!isyou?"s":"") + " this";
								}
							}
						}
						
					}
					
					rs.close();
				}else if(series_id > 0){
					sql = "INSERT INTO like_series (like_id,series_id) VALUES (?,?)";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1,Integer.parseInt(likeID));
					pstmt.setInt(2,series_id);
					pstmt.executeUpdate();
					pstmt.close();
					
					sql = "SELECT COUNT(*) _no FROM final_like_series WHERE series_id=" + series_id;
					rs = conn.getResultSet(sql);
					if(rs.next()){
						int likeno = rs.getInt(1);

						if(likeno > 0){
							//Is it you?
							boolean isyou = false;
							sql = "SELECT COUNT(*) _no FROM final_like_series WHERE series_id=" + series_id + " AND user_id=" + user_id;
							rs = conn.getResultSet(sql);
							if(rs.next()){
								isyou = (rs.getInt(1)>0?true:false);
							}
							
							//Any friends?Pick 3 randomly
							HashMap<Integer,String> friends = new HashMap<Integer,String>();
							sql = "SELECT u.user_id,u.name FROM userinfo u JOIN final_like_series fls ON u.user_id=fls.user_id WHERE fls.series_id=" + series_id +
									" AND u.user_id<>" + user_id + " ORDER BY RAND() LIMIT 3";
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
								if(shownno == likeno-1){
									if(shownno > 0){
										spanTitle += " and ";
									}
								}else{
									spanTitle += ", ";
								}
								spanTitle += friend;
								shownno++;
							}
							
							if(shownno < likeno){
								spanTitle += " and " + (likeno-shownno) + " " + (likeno-shownno>1?"people":"person"); 
							}

							objLikeTag = "<img border='0' src='images/like_icon.png' />&nbsp;";
							objLikeTag += "<span title='" + spanTitle + "'>" + likeno + " " + (likeno>1?"people":"person") + "</span>";
							
						}
						
					}
					
					rs.close();
				}
				
%>{
"status": "OK",
"like_id": "<%=likeID %>",
"like_tag": "<%=objLikeTag %>" 
}<%					
			}
			
			conn.conn.close();

		}catch(Exception e){
			out.println("{\"status\":\"ERROR\",\"message\":\"" + e.toString() + "\"}");
			return;
		}
	}
%>