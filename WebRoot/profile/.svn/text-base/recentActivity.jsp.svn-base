<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashSet"%>

<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	Calendar calendar = new GregorianCalendar();
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	String insertFirst = (String)request.getParameter("insertfirst");
	String appendLast = (String)request.getParameter("appendlast");
	String timeStamp = (String)request.getParameter("timestamp");
	String req_activity_id = (String)request.getParameter("activity_id");
	String req_speaker_id = (String)request.getParameter("speaker_id");
	String req_activity = (String)request.getParameter("activity");
	String req_show_stream = (String)request.getParameter("showstream");
	String req_rows = (String)request.getParameter("rows");
	if((user_id==null&&ub==null)&&(req_activity_id==null&&req_activity==null)&&(req_speaker_id==null)){

	}else{

		if(user_id==null&&req_speaker_id==null){
			user_id = "" + ub.getUserID();
		}
		
		String _user_id = user_id;
		
		connectDB conn = new connectDB();
		if(req_show_stream!=null&&req_speaker_id==null){
			String sql = "SELECT user0_id,user1_id FROM friend WHERE user0_id=" + user_id + " OR user1_id=" + user_id + 
							" GROUP BY user0_id,user1_id";
			HashSet<String> fList = new HashSet<String>();
			ResultSet rs = conn.getResultSet(sql);
			while(rs.next()){
				String u0_id = rs.getString("user0_id");
				String u1_id = rs.getString("user1_id");
				if(!u0_id.trim().equalsIgnoreCase(user_id.trim())){
					fList.add(u0_id.trim());
				}
				if(!u1_id.trim().equalsIgnoreCase(user_id.trim())){
					fList.add(u1_id.trim());
				}
			}
			if(fList.size() > 0){
				for(String uid : fList){
					user_id += "," + uid;
				}
			}
		}
		String sql = "SELECT u.user_id,u.name,a.activity,a.activity_id,a.activitytime,a.day,a._year,a._time " +
						"FROM activities a JOIN userinfo u ON a.user_id=u.user_id WHERE a.user_id IN (" + 
						user_id + ")";
		boolean showAll = false;
		if(req_activity_id!=null&&req_activity!=null){
			sql = "SELECT u.user_id,u.name,a.activity,a.activity_id,a.activitytime,a.day,a._year,a._time " +
					"FROM activities a JOIN userinfo u ON a.user_id=u.user_id WHERE a.activity='" + req_activity + 
					"' AND a.activity_id=" + req_activity_id;
			showAll = true;
		}
		if(req_speaker_id!=null){
			sql = "SELECT u.user_id,u.name,a.activity,a.activity_id,a.activitytime,a.day,a._year,a._time " +
					"FROM activities a JOIN userinfo u ON a.user_id=u.user_id " +
					"WHERE (a.activity IN ('posted','updated') " + 
					"AND a.activity_id IN (SELECT col_id FROM col_speaker WHERE speaker_id=" + req_speaker_id + ")" +
					") OR (" +
					"a.activity = 'bookmarked' " +
					"AND a.activity_id IN " +
					"(SELECT up.userprofile_id FROM userprofile up JOIN col_speaker cs ON up.col_id=cs.col_id WHERE cs.speaker_id=" + req_speaker_id + ")" +
					")";
			showAll = true;
		}
		if(insertFirst!=null){
			sql += " AND a.activitytime > " + (timeStamp==null?"NOW()":"'" + timeStamp + "'");
		}else if(appendLast!=null){
			sql += " AND a.activitytime < " + (timeStamp==null?"NOW()":"'" + timeStamp + "'");
		}
		if(req_speaker_id!=null){
			sql += " GROUP BY u.user_id,u.name,a.activity,a.activity_id,a.activitytime,a.day,a._year,a._time";
		}
		sql += " ORDER BY a.activitytime DESC ";
		if(!showAll){
			sql += "LIMIT 0," + (req_rows==null?"10":req_rows);
		}
		
		//out.println(sql);
		
		String lastTime = null;
		String lastTimeID = null;
		ResultSet rsExt;
		Format formatter = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss"); 
		Format formatterDay = new SimpleDateFormat("MMMMM d"); 
		Format formatterDayYear = new SimpleDateFormat("MMMMM d, yyyy"); 
		ResultSet rs = conn.getResultSet(sql);
		Date today = new Date();
		final long MILLISECS_PER_DAY = 24*60*60*1000;
		final long MILLISECS_PER_HOUR = 60*60*1000;
		final long MILLISECS_PER_MIN = 60*1000;
		final long MILLISECS = 1000;
		int ii = 0;
%>

<table width="<%=showAll?"70":"100" %>%" align="left" border="0" cellspacing="0" cellpadding="0" style="font-size: <%=appendLast!=null?"1":"0.7" %>em;">
<% 
		if(appendLast==null){
%>
	<tr>
		<td colspan="2"><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
	</tr>
<%
		}
		HashSet<Long> commentSet = new HashSet<Long>();
		//Bookmark by
		HashSet<Integer> bookSet = null; 
		if(ub != null){
			if(ub.getBookSet() != null){
				bookSet = ub.getBookSet();				
			}else{
				bookSet = new HashSet<Integer>();
			}
		}
		HashSet<String> friendSet = new HashSet<String>();
		HashMap<Long,String> usernameMap = new HashMap<Long,String>();
		while(rs.next()){
			String _day = null;
			user_id = rs.getString("user_id");
			String name = rs.getString("name");
			String activity = rs.getString("activity");
			long activity_id = rs.getLong("activity_id");
			String activitytime = rs.getString("activitytime");
			Timestamp _atime = rs.getTimestamp("activitytime");
			int _year = rs.getInt("_year");
			String _time = rs.getString("_time");
			lastTime = activitytime.substring(0, activitytime.length()-2);
			lastTimeID = formatter.format(_atime);
			
			//out.println("lasttime: " + lastTime + " lastTimeID: " + lastTimeID);
			
			long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
			long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
			long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
			long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
			if(_dateDiff >= 1){
				if(_dateDiff == 1){
					_day = "Yesterday";
				}else{
					_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
				}
			}else if(_hourDiff >= 1){
				_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
			}else if(_minDiff >= 1){
				_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
			}else if(_secDiff > 0){
				_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
			}else{
				_day = "a second ago";
			}
			if(ii>0||appendLast!=null){
				if((!activity.equalsIgnoreCase("user-commented")&&!activity.equalsIgnoreCase("was-user-commented"))||
						((activity.equalsIgnoreCase("user-commented")||activity.equalsIgnoreCase("was-user-commented"))&&!commentSet.contains(activity_id))){
%>
<%-- 
	<tr>
		<td colspan="2"><hr style="border: none;height: 2px;color: #efefef;background-color: #efefef;" /></td>
	</tr>
--%>
	<tr>
		<td colspan="2" style="border-bottom: 1px solid #efefef;" ><div style="height: 5px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td colspan="2" style="border-top: 1px solid #efefef;" ><div style="height: 5px;overflow: hidden;">&nbsp;</div></td>
	</tr>
<%
				}
			}

			if((activity.equalsIgnoreCase("user-commented")||activity.equalsIgnoreCase("was-user-commented"))&&!commentSet.contains(activity_id)){
				commentSet.add(activity_id);
				sql = "SELECT  u.user_id,u.name,c.comment FROM userinfo u JOIN comment c ON u.user_id = c.user_id WHERE c.comment_id=" + activity_id;
				if(activity.equalsIgnoreCase("user-commented")){
					sql = "SELECT  u.user_id,u.name,c.comment FROM userinfo u JOIN comment_user cu ON u.user_id = cu.user_id JOIN comment c ON cu.comment_id = c.comment_id WHERE cu.comment_id=" + activity_id;
				}
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String _uid = rsExt.getString("user_id");
					String commenter = rsExt.getString("name");
					String comment = rsExt.getString("comment").replaceAll("\\n","<br/>");
					
					int commentno = 0;
					sql = "SELECT  COUNT(*) _no FROM comment_comment WHERE commentee_id=" + activity_id;
					rsExt = conn.getResultSet(sql);
					if(rsExt.next()){
						commentno = rsExt.getInt(1);
					}
					
					int likeno = 0;
					sql = "SELECT  COUNT(*) _no FROM final_like_comment WHERE comment_id=" + activity_id;
					rsExt = conn.getResultSet(sql);
					if(rsExt.next()){
						likeno = rsExt.getInt(1);
					}
					String objLikeTag = "";
					boolean isyou = false;
					if(likeno > 0){
						if(ub!=null){
							//Is it you?
							sql = "SELECT  COUNT(*) _no FROM final_like_comment WHERE comment_id=" + activity_id + " AND user_id=" + ub.getUserID();
							rsExt = conn.getResultSet(sql);
							if(rsExt.next()){
								isyou = (rsExt.getInt(1)>0?true:false);
							}
							
							//Any friends?Pick 3 randomly
							HashMap<Integer,String> friends = new HashMap<Integer,String>();
							sql = "SELECT  u.user_id,u.name FROM userinfo u JOIN final_like_comment flc ON u.user_id=flc.user_id WHERE flc.comment_id=" + activity_id +
									" AND u.user_id<>" + ub.getUserID() + " ORDER BY RAND() LIMIT 3";
							rsExt = conn.getResultSet(sql);
							while(rsExt.next()){
								friends.put(rsExt.getInt(1),rsExt.getString(2));
							}
							
							int shownno = 0;
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
						}else{
							objLikeTag += (likeno) + " " + (likeno>1?"people":"person"); 
							objLikeTag += " like" + (likeno==1?"s":"") + " this";
							
						}
					}
					
					//Here it is the rule: #comment + #like > 40 then hide detail just show only icons
					//For comment, #comment <=5 show all, else, show latest 2, the rest hidden
					//For like, if 1 like then show the user, else show only the 3 friends (randomly, if any, including youself) and the rest just shown the number
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 60px;">
			<a href="profile.do?user_id=<%=activity.equalsIgnoreCase("user-commented")?user_id:_uid %>"><%=activity.equalsIgnoreCase("user-commented")?name:commenter %></a>
<% 
 					if(!_uid.equalsIgnoreCase(user_id)){
%>
			&nbsp;<img alt="activity arrow" src="images/arrow_icon.gif" border="0">
<% 						
 					}
%>			
		</td>
 		<td valign="top" align="left">
<% 
 					if(!_uid.equalsIgnoreCase(user_id)){
%>
			<a href="profile.do?user_id=<%=activity.equalsIgnoreCase("user-commented")?_uid:user_id%>"><%=activity.equalsIgnoreCase("user-commented")?commenter:name %></a>
<% 						
 					}
%>			
 			&nbsp;<%=comment %><br/>
	  		&nbsp;<span style="color: #aeaeae;font-size: 0.9em;"><%=_day %></span>&nbsp;
<% 
					if(commentno + likeno > 40){
%>
			<a href="javascript:return false;" onclick="document.getElementById('cid<%=activity_id %>').style.display='block';">
<%
						if(commentno > 0){
%>
				<img border="0" src="images/comment_icon.gif" /><%=commentno %>&nbsp;
<%							
						}
						if(likeno > 0){
%>
				<img border="0" src="images/like_icon.png" /><%=likeno %>
<%							
						}
%>
			</a>
<%
					}
%>				  		
			<logic:present name="UserSession">
		  		<a href="javascript:return false;" 
		  			onclick="likeComment(<%=ub.getUserID() %>,<%=activity_id %>,this,'tdlikecid<%=activity_id %>');document.getElementById('cid<%=activity_id %>').style.display='block';"><%=isyou?"Unlike":"Like" %></a>
		  		&nbsp;
		  		<a href="javascript:return false;" onclick="document.getElementById('cid<%=activity_id %>').style.display='block';">Comment</a>
			</logic:present>
	  		<div id="cid<%=activity_id %>" style="<%=(commentno + likeno > 0?(commentno + likeno <= 40?"":"display: none;"):"display: none;") %>">
	  			<div style="height: 5px;overflow: hidden;">&nbsp;</div>
	  			<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="background-color: #efefef;">
	  				<tr>
	  					<td align="center">
	  						<table width="98%" border="0" cellpadding="0" cellspacing="2" style="font-size: 0.7em;">
								<tr>
									<td colspan="2" id="tdlikecid<%=activity_id %>" style="<%=likeno>0?"":"display:none;" %>">
										<img border="0" src="images/like_icon.png" /> <%=objLikeTag %>
									</td>
								</tr>
<%
					if(commentno > 0){
						if(commentno <= 20 || showAll){
							if(commentno > 5 && !showAll){
%>
								<tr>
									<td id="tdccid<%=activity_id %>" colspan="2" style="vertical-align: middle;border-top: 1px solid white;">
										<img border="0" src="images/comment_icon.gif" /> 
										<a href="javascript:return false;" onclick="document.getElementById('tdccid<%=activity_id %>').style.display='none';document.getElementById('ccid<%=activity_id %>').style.display='block';">
											View all <%=commentno %> comments 
										</a>
									</td>
								</tr>
<%								
							}
							sql = "SELECT  c.comment_id,c.comment,c.comment_date,c.user_id,u.name " +
									"FROM comment c JOIN comment_comment cc ON c.comment_id=cc.comment_id " +
									"JOIN userinfo u ON c.user_id=u.user_id " +
									"WHERE cc.commentee_id=" + activity_id + " ORDER BY c.comment_date";
							rsExt = conn.getResultSet(sql);
							int i=0;
							while(rsExt.next()){
								String comment_id = rsExt.getString("comment_id");
								String replycomment = rsExt.getString("comment").replaceAll("\\n","<br/>");
								String replyuid = rsExt.getString("user_id");
								String replyer = rsExt.getString("name");
								Timestamp replytime = rsExt.getTimestamp("comment_date");
								if(commentno > 5 && i==0 && !showAll){
%>
								<tr>
									<td colspan="2">
							  			<table id="ccid<%=activity_id %>" width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="font-size: 1em;background-color: #efefef;display: none;">
<%									
								}
%>
								<tr>
									<td colspan="2" style="border-top: 1px solid white;" />
								</tr>
								<tr>
									<td valign="top" style="width: 55px;">
										<a href="profile.do?user_id=<%=replyuid %>"><%=replyer %></a>
									</td>
									<td align="left">
										<%=replycomment %>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td align="left">
										<table cellpadding="0" cellspacing="0" border="0" style="font-size: 0.9em;">
											<tr>
												<td style="color: #aeaeae;margin-left: 0px;margin-right: 0px;">
<% 
								long dateDiff = (today.getTime() - replytime.getTime())/MILLISECS_PER_DAY;
								long hourDiff = (today.getTime() - replytime.getTime())/MILLISECS_PER_HOUR;
								long minDiff = (today.getTime() - replytime.getTime())/MILLISECS_PER_MIN;
								long secDiff = (today.getTime() - replytime.getTime())/MILLISECS;
								if(dateDiff >= 1){
									if(dateDiff == 1){
%>
													Yesterday
<%										
									}else{
										
%>
											<%=(replytime.getYear()==year?formatterDay.format(replytime):formatterDayYear.format(replytime)) %>
<%										
									}
								}else if(hourDiff >= 1){
%>
											<%=(hourDiff==1&&minDiff>0?"about ":"") %><%=hourDiff %> hour<%=hourDiff>1?"s":"" %> ago
<%									
								}else if(minDiff >= 1){
%>
											<%=minDiff %> minute<%=minDiff>1?"s":"" %> ago
<%									
								}else if(secDiff > 0){
%>
											<%=(secDiff<=1?"a":"" + secDiff) %> second<%=secDiff>1?"s":"" %> ago
<%									
								}else{
%>
											a second ago
<%													
								}
								likeno = 0;
								sql = "SELECT  COUNT(*) _no FROM final_like_comment WHERE comment_id=" + comment_id;
								ResultSet _rsExt = conn.getResultSet(sql);
								if(_rsExt.next()){
									likeno = _rsExt.getInt(1);
								}
								objLikeTag = "";
								isyou = false;
								if(likeno > 0){
									if(ub!=null){
										//Is it you?
										sql = "SELECT COUNT(*) _no FROM final_like_comment WHERE comment_id=" + comment_id + " AND user_id=" + ub.getUserID();
										_rsExt = conn.getResultSet(sql);
										if(_rsExt.next()){
											isyou = (_rsExt.getInt(1)>0?true:false);
										}
										
										/*//Any friends?Pick 3 randomly
										HashMap<Integer,String> friends = new HashMap<Integer,String>();
										sql = "SELECT  u.user_id,u.name FROM userinfo u JOIN final_like_comment flc ON u.user_id=flc.user_id WHERE flc.comment_id=" + comment_id +
												" AND u.user_id<>" + ub.getUserID() + " ORDER BY RAND() LIMIT 3";
										_rsExt = conn.getResultSet(sql);
										while(_rsExt.next()){
											friends.put(_rsExt.getInt(1),_rsExt.getString(2));
										}
										
										int shownno = 0;
										if(isyou){
											objLikeTag += "You";
											shownno++;
										}
										
										for(int friendid : friends.keySet()){
											if(shownno == likeno-1){
												objLikeTag += " and ";
											}else{
												objLikeTag += ", ";
											}
											objLikeTag += "<a href='profile.do?user_id=" + friendid + "'>" + friends.get(friendid) + "</a>";
											shownno++;
										}
										
										if(shownno < likeno){
											objLikeTag += " and " + (likeno-shownno) + " " + (likeno-shownno>1?"people":"person"); 
										}
										
										objLikeTag += " like" + (likeno==1&&!isyou?"s":"") + " this";*/
									}else{
										//objLikeTag += (likeno) + " " + (likeno>1?"people":"person"); 
										//objLikeTag += " like" + (likeno==1?"s":"") + " this";
										
									}
									objLikeTag = "<img border='0' src='images/like_icon.png' />&nbsp;" + likeno + " " + (likeno>1?"people":"person");

								}
%>													
														<logic:present name="UserSession">
															&nbsp;
															<a href="javascript:return false;" 
																onclick="likeComment(<%=ub.getUserID() %>,<%=comment_id %>,this,'tdlikeccid<%=comment_id %>')"><%=isyou?"Unlike":"Like" %></a>
															&nbsp;
														</logic:present>
													</td>
													<td align="left" id="tdlikeccid<%=comment_id %>" style="margin-left: 0px;margin-right: 0px;">
														<%=objLikeTag %>&nbsp;						
													</td>
												</tr>
										</table>	
									</td>
								</tr>
<%								
								if(commentno > 5 && i==commentno-3 && !showAll){
%>
										</table>
									</td>
								</tr>
<%									
								}
								i++;
							}
							
						}else{//Here it should redirect to that post --- in the future :D
%>
								<tr>
									<td id="tdccid<%=activity_id %>" colspan="2" style="vertical-align: middle;border-top: 1px solid white;">
										<a href="javascript:return false;" onclick="loadAnActivity('was-user-commented','<%=activity_id %>');">
											<img border="0" src="images/comment_icon.gif" /> View all <%=commentno %> comments 
										</a>
									</td>
								</tr>
<%								
						}
					}
%>				  				
	  							<tr>
	  								<td id="tdcommentcid<%=activity_id %>" colspan="2" style="display: none;">
	  									<input type="hidden" id="commenttimeccid<%=activity_id %>" value="<%=formatter.format(today) %>" />&nbsp;
	  								</td>
	  							</tr>
<% 
					if(commentno + likeno > 0){
%>
								<tr>
									<td colspan="2" style="border-top: 1px solid white;" />
								</tr>		
<% 
					}
%>
								<logic:present name="UserSession">
									<tr>
										<td style="width: 55px;vertical-align: top;">
											<a href="profile.do?user_id=<%=ub.getUserID() %>"><%=ub.getName() %></a>
										</td>
										<td align="right">
											<textarea id="txtcid<%=activity_id %>" rows="1" cols="64" 
												onfocus="autohintGotFocus(this,tdcb<%=activity_id %>);" 
												onblur="autohintGotBlur(this,tdcb<%=activity_id %>);" 
												class="auto-hint" style="border-style: solid;" title="Write a comment...">Write a comment...</textarea>	  								
										</td>
									</tr>
									<tr style="border-top: 1px solid white;">
										<td colspan="2" id="tdcb<%=activity_id %>" style="text-align: right;display: none;">
											<input class="btn" id="btnReplyComment<%=activity_id %>" 
												onclick="replyComment(<%=activity_id %>,'txtcid<%=activity_id %>','tdcb<%=activity_id %>');" 
												type="button" value="Comment"></input>
										</td>
									</tr>
								</logic:present>
	  						</table>
	  					</td>
	  				</tr>
	  			</table>
	  		</div>
  		</td>
	</tr>
<%
				}
			}
			if(activity.equalsIgnoreCase("joined")){
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
  		<td valign="top" align="left">joined CoMeT <br/><span style="color: #aeaeae; font-size: 0.9em;"><%=_day %></span></td>
	</tr>
<%			
			}
			
			
			boolean bookmarked = false;
			
			if(activity.equalsIgnoreCase("posted")){
				sql = "SELECT a.title FROM activitypost a WHERE activity_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String title = rsExt.getString("title");
					
					if(bookSet != null && !bookmarked){
						if(bookSet.contains(activity_id)){
							bookmarked = true;
						}
					}
					
					if(!bookmarked){
						sql = "SELECT COUNT(*) _no FROM userprofile WHERE user_id=" + ub.getUserID() + " AND col_id=" + activity_id;
						rsExt = conn.getResultSet(sql);
						if(rsExt.next()){
							int _no = rsExt.getInt(1);
							
							if(_no > 0){
								if(bookSet == null){
									bookSet = new HashSet<Integer>();
								}
								bookSet.add((int)activity_id);
								bookmarked = true;
							}
						}
					}
					
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id %>"><%=name %></a></td>
  		<td valign="top" align="left">posted 
	 		<a href="presentColloquium.do?col_id=<%=activity_id %>"><%=title.length() > 100?title.substring(0, 100) + "...":title %></a>

			&nbsp;
			<span id="spanbookcolid<%=activity_id %>" class="spanbookcolid<%=activity_id %>" 
			style="display:<%=bookmarked?"inline":"none" %>;">&nbsp;
			<span style="cursor: pointer;font-size: 1em;background-color: green;font-weight: bold;color: white;"
			onclick="window.location='myaccount.do'">&nbsp;Bookmarked&nbsp;</span></span>
			&nbsp;
			<a class="abookcolid<%=activity_id %>" href="javascript:return false;" 					
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="$('#spanBookmarkHeader').show();bookmarkTalk(<%=ub.getUserID() %>, <%=activity_id %>, this, 'spanbookcolid<%=activity_id %>');"
			><%=bookmarked?"Unbookmark":"Bookmark" %></a>

  			<br/><span style="color: #aeaeae;font-size: 0.9em;"><%=_day %></span>
  		</td>
	</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("updated")){
				sql = "SELECT a.title FROM activitypost a WHERE activity_id=" + activity_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String title = rsExt.getString("title");
					
					if(bookSet != null && !bookmarked){
						if(bookSet.contains(activity_id)){
							bookmarked = true;
						}
					}
					
					if(!bookmarked){
						sql = "SELECT COUNT(*) _no FROM userprofile WHERE user_id=" + ub.getUserID() + " AND col_id=" + activity_id;
						rsExt = conn.getResultSet(sql);
						if(rsExt.next()){
							int _no = rsExt.getInt(1);
							
							if(_no > 0){
								if(bookSet == null){
									bookSet = new HashSet<Integer>();
								}
								bookSet.add((int)activity_id);
								bookmarked = true;
							}
						}
					}

%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
  		<td valign="top" align="left">updated 
	 		<a href="presentColloquium.do?col_id=<%=activity_id %>"><%=title.length() > 100?title.substring(0, 100) + "...":title %></a> 

			&nbsp;
			<span id="spanbookcolid<%=activity_id %>" class="spanbookcolid<%=activity_id %>" 
			style="display:<%=bookmarked?"inline":"none" %>;">&nbsp;
			<span style="cursor: pointer;font-size: 1em;background-color: green;font-weight: bold;color: white;"
			onclick="window.location='myaccount.do'">&nbsp;Bookmarked&nbsp;</span></span>
			&nbsp;
			<a class="abookcolid<%=activity_id %>" href="javascript:return false;" 					
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="$('#spanBookmarkHeader').show();bookmarkTalk(<%=ub.getUserID() %>, <%=activity_id %>, this, 'spanbookcolid<%=activity_id %>');"
			><%=bookmarked?"Unbookmark":"Bookmark" %></a>

	  		<br/><span style="color: #aeaeae;font-size: 0.9em;"><%=_day %></span>
	  	</td>
	</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("bookmarked")){
				sql = "SELECT  a.col_id,a.title FROM activitybookmark a WHERE activity_id=" + activity_id;//It's userprofile_id
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String col_id = rsExt.getString("col_id");
					String title = rsExt.getString("title");
					
					String tags = "";
					sql = "SELECT  t.tag,t.tag_id FROM tags tt JOIN tag t ON tt.tag_id=t.tag_id " +
							"WHERE tt.userprofile_id=" + activity_id +
							" AND LENGTH(TRIM(t.tag)) > 0 ";
					rsExt.close();
					rsExt = conn.getResultSet(sql);
					while(rsExt.next()){
						String tag = rsExt.getString("tag");
						String tag_id = rsExt.getString("tag_id");
						
						if(tags.length() > 0){
							tags += ", ";
						}
						
						tags += "<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
					}
					
					String groups = "";
					sql = "SELECT  c.comm_id,c.comm_name FROM community c JOIN contribute ct ON c.comm_id=ct.comm_id WHERE ct.userprofile_id=" + activity_id;
					rsExt.close();
					rsExt = conn.getResultSet(sql);
					while(rsExt.next()){
						String comm_id = rsExt.getString("comm_id");
						String comm_name = rsExt.getString("comm_name");
						
						if(groups.length() > 0){
							groups += ", ";
						}
						
						groups += "<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>";
					}
					
					String extraAct = "";
					if(tags.trim().length() > 0){
						extraAct += ", and tagged with " + tags;
					}
					if(groups.trim().length() > 0){
						extraAct += ", and  contributed to " + groups;
					}
					
					if(bookSet != null && !bookmarked){
						if(bookSet.contains(activity_id)){
							bookmarked = true;
						}
					}
					
					if(!bookmarked){
						sql = "SELECT COUNT(*) _no FROM userprofile WHERE user_id=" + ub.getUserID() + " AND col_id=" + col_id;
						rsExt = conn.getResultSet(sql);
						if(rsExt.next()){
							int _no = rsExt.getInt(1);
							
							if(_no > 0){
								if(bookSet == null){
									bookSet = new HashSet<Integer>();
								}
								bookSet.add(Integer.parseInt(col_id));
								bookmarked = true;
							}
						}
					}
					
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
 		<td valign="top"  align="left">bookmarked 
 			 <a href="presentColloquium.do?col_id=<%=col_id %>"><%=title.length() > 100?title.substring(0, 100) + "...":title %></a>  <%=extraAct %> 
 
 			&nbsp;
			<span id="spanbookcolid<%=col_id %>" class="spanbookcolid<%=col_id %>" 
			style="display:<%=bookmarked?"inline":"none" %>;">&nbsp;
			<span style="cursor: pointer;font-size: 1em;background-color: green;font-weight: bold;color: white;"
			onclick="window.location='myaccount.do'">&nbsp;Bookmarked&nbsp;</span></span>
			&nbsp;
			<a class="abookcolid<%=col_id %>" href="javascript:return false;" 					
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="$('#spanBookmarkHeader').show();bookmarkTalk(<%=ub.getUserID() %>, <%=col_id %>, this, 'spanbookcolid<%=col_id %>');"
			><%=bookmarked?"Unbookmark":"Bookmark" %></a>
 
 			<br/><span style="color: #aaaaaa;font-size: 0.9em;"><%=_day %></span></td>
	</tr>
<%			
				}
			}
			if(activity.equalsIgnoreCase("commented-col")){
				sql = "SELECT  c.col_id,c.title,cm.comment FROM comment cm JOIN comment_col cc ON cm.comment_id = cc.comment_id JOIN colloquium c ON cc.col_id = c.col_id WHERE cc.comment_id=" + activity_id;//It's userprofile_id
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String col_id = rsExt.getString("col_id");
					String title = rsExt.getString("title");
					String comment = rsExt.getString("comment");
					
					if(bookSet != null && !bookmarked){
						if(bookSet.contains(activity_id)){
							bookmarked = true;
						}
					}
					
					if(!bookmarked){
						sql = "SELECT COUNT(*) _no FROM userprofile WHERE user_id=" + ub.getUserID() + " AND col_id=" + col_id;
						rsExt = conn.getResultSet(sql);
						if(rsExt.next()){
							int _no = rsExt.getInt(1);
							
							if(_no > 0){
								if(bookSet == null){
									bookSet = new HashSet<Integer>();
								}
								bookSet.add(Integer.parseInt(col_id));
								bookmarked = true;
							}
						}
					}

%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
 		<td valign="top"  align="left">commented <span style="font-style: italic;">"<%=(comment!=null&&comment.length() > 100)?comment.substring(0, 100) + "...":comment %>"</span> on 
 			<a href="presentColloquium.do?col_id=<%=col_id %>"><%=title.length() > 100?title.substring(0, 100) + "...":title %></a> 

 			&nbsp;
			<span id="spanbookcolid<%=col_id %>" class="spanbookcolid<%=col_id %>" 
			style="display:<%=bookmarked?"inline":"none" %>;">&nbsp;
			<span style="cursor: pointer;font-size: 1em;background-color: green;font-weight: bold;color: white;"
			onclick="window.location='myaccount.do'">&nbsp;Bookmarked&nbsp;</span></span>
			&nbsp;
			<a class="abookcolid<%=col_id %>" href="javascript:return false;" 					
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="$('#spanBookmarkHeader').show();bookmarkTalk(<%=ub.getUserID() %>, <%=col_id %>, this, 'spanbookcolid<%=col_id %>');"
			><%=bookmarked?"Unbookmark":"Bookmark" %></a>

 			<br/><span style="color: #aaaaaa;font-size: 0.9em;"><%=_day %></span>
 		</td>
	</tr>
<%			
				}
			}
			
			//Friendship activity
			if(activity.equalsIgnoreCase("friended")){
				String friendship = user_id + "-" + activity_id;
				if(Long.parseLong(user_id) > activity_id){
					friendship = activity_id + "-" + user_id;
				}
				if(!friendSet.contains(friendship)){
					friendSet.add(friendship);
					
					if(!usernameMap.containsKey(Long.parseLong(user_id))){
						usernameMap.put(Long.parseLong(user_id),name);
					}
					if(!usernameMap.containsKey(activity_id)){
						sql = "SELECT name FROM userinfo WHERE user_id=" + activity_id;
						rsExt = conn.getResultSet(sql);
						if(rsExt.next()){
							String _name = rsExt.getString("name");
							
							usernameMap.put(activity_id,_name);
						}
					}
					
%>
	<tr> 
		<td valign="top" style="font-weight: bold;width: 55px;"><a href="profile.do?user_id=<%=user_id%>"><%=name %></a></td>
 		<td valign="top"  align="left"> is friend with <a href="profile.do?user_id=<%=activity_id%>"><%=usernameMap.get(activity_id) %></a>
			&nbsp;
<% 
					if(ub.getUserID()!=activity_id){//Not the same user
%>
		<span id="spanClassAddFriend<%=user_id %>_<%=activity_id %>" class="spanClassAddFriend<%=activity_id %>">
<%
						friendship = ub.getUserID() + "-" + activity_id;
						if(ub.getUserID() > activity_id){
							friendship = activity_id + "-" + ub.getUserID();
						}
						if(!friendSet.contains(friendship)){
							sql = "SELECT COUNT(*) _no FROM friend WHERE breaktime IS NULL AND ";
							if(ub.getUserID() > activity_id){
								sql += "user0_id=" + activity_id + " AND user1_id=" + ub.getUserID();
							}else{
								sql += "user1_id=" + activity_id + " AND user0_id=" + ub.getUserID();
							}
							rsExt = conn.getResultSet(sql);
							if(rsExt.next()){
								int _no = rsExt.getInt(1);
								
								if(_no==0){//They r not a friend yet
									//Is there any friend request from any of them
									//1) the user made a friend request
									//What was the last request action
									sql = "SELECT accepttime FROM request " +
											"WHERE requester_id=" + ub.getUserID() + " AND target_id=" + activity_id +
											" ORDER BY request_id DESC LIMIT 1";
									rsExt = conn.getResultSet(sql);
									if(rsExt.next()){
										String accepttime = rsExt.getString(1);
										if(accepttime == null){//Target is not acceptted the request yet so show the message "Friend Request Sent"
%>
			<span style="font-size: 0.8em;font-style: italic;color: #aaaaaa;">Friend Request Sent</span> 
			<a href="javascript:return false;" 
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="sendFriendRequest(spanClassAddFriend<%=user_id %>_<%=activity_id %>,null,<%=activity_id %>,'drop');return false;">
			<img border='0' src='images/x.gif' /></a>
<%											
										}
									}else{
										//2) the target made a request to a user
										//What was the last request action
										sql = "SELECT accepttime,notnowtime,rejecttime FROM request " +
												"WHERE target_id=" + ub.getUserID() + " AND requester_id=" + activity_id +
												" ORDER BY request_id DESC LIMIT 1";
										rsExt = conn.getResultSet(sql);
										if(rsExt.next()){
											String accepttime = rsExt.getString("accepttime");
											String notnowtime = rsExt.getString("notnowtime");
											String rejecttime = rsExt.getString("rejecttime");
											
											if(accepttime == null&&notnowtime == null&&rejecttime == null){//User does not respond the request yet so show reponse choices
%>
			<a href="javascript:return false;" 
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="sendFriendRequest(spanClassAddFriend<%=activity_id %>,null,<%=activity_id %>,'accept');return false;">
			Confirm As Friend</a>
			&nbsp;
			<a href="javascript:return false;" 
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="sendFriendRequest(spanClassAddFriend<%=activity_id %>,null,<%=activity_id %>,'reject');return false;">
			Reject Request</a>
<%											
											}
										}else{
											//3) No request yet why don't make it!!!
%>
			<a href="javascript:return false;" 
				style="text-decoration: none;"
				onmouseover="this.style.textDecoration='underline'" 
				onmouseout="this.style.textDecoration='none'"
				onclick="sendFriendRequest(spanClassAddFriend<%=activity_id %>,null,<%=activity_id %>,'add');return false;">
			Add As Friend</a>
<%											
										}
									}
									
									
								}
							}
						}
%>
		</span>
<%
					}
%>			
 			<br/><span style="color: #aaaaaa;font-size: 0.9em;"><%=_day %></span>
 		</td>
	</tr>
<%					
				}
			}
			
			ii++;
		}
		if(ii>0&&insertFirst!=null){
%>
<%-- 
	<tr>
		<td colspan="2"><hr style="border: none;height: 2px;color: #efefef;background-color: #efefef;" /></td>
	</tr>
--%>
	<tr>
		<td colspan="2" style="border-bottom: 1px solid #efefef;" ><div style="height: 5px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td colspan="2" style="border-top: 1px solid #efefef;" ><div style="height: 5px;overflow: hidden;">&nbsp;</div></td>
	</tr>
<%
		}
		if(insertFirst==null&&!showAll){
			sql = "SELECT  COUNT(*) _no " +
					"FROM activities a JOIN userinfo u ON a.user_id=u.user_id WHERE a.user_id=" + 
					_user_id;
			sql += " AND a.activitytime < " + (lastTime==null?"NOW()":"'" + lastTime + "'");
			rs = conn.getResultSet(sql);
			if(rs.next()){
				int _no = rs.getInt(1);
				if(_no > 0){
%>
	<tr>
		<td id="moreAct" colspan="2">
			<div id="divOlderPosts<%=lastTimeID %>" align="center">
				<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
					<tr>
						<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.9em;font-weight: bold;text-align: center;">&nbsp;
							<input id="btnLoadAct" class="btn" type="button" 
								onclick="this.value='Loading...';this.style.disabled='disabled';<%=req_show_stream==null?"showOlderPosts":"showOlderFeedPosts" %>(<%=_user_id %>,'divOlderPosts<%=lastTimeID %>','<%=lastTime %>');return false;" 
								value="Older Posts" />
						</td>
					</tr>
					<tr>
						<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
					</tr>
				</table>	
				<script type="text/javascript">
					AutoLoadActivity();
				</script>
			</div>
		</td>
	</tr>
<%					
				}
			}
		}
%>
</table>
<%

		conn.conn.close();
		conn = null;
	}
%>