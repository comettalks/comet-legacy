<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.Date"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>

<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%><div id="divUserActivityContent">
<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	Calendar calendar = new GregorianCalendar();
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
	Format formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	String hideRightBar = (String)request.getParameter("hiderightbar");
	if(user_id==null&&ub==null){
%>
	<script type="text/javascript">
		redirect("login.do");
		//window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td id="tdUserSubInfo" width="<%=hideRightBar==null?"75":"100" %>%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
<% 
			if(ub!=null){
				boolean allowed2shareComment = false;
				if(user_id==null||user_id==String.valueOf(ub.getUserID())){
					allowed2shareComment = true;
				}else if(user_id!=null){//Is there a friendship
					String user0_id = user_id;
					String user1_id = "" + ub.getUserID();
					if(Integer.parseInt(user_id) > ub.getUserID()){
						user0_id = "" + ub.getUserID();
						user1_id = user_id;
					}
					String sql = "SELECT SQL_CACHE friend_id FROM friend WHERE user0_id=" + user0_id + " AND user1_id=" + user1_id + " AND breaktime IS NULL";
					connectDB conn = new connectDB();
					ResultSet rs = conn.getResultSet(sql);
					if(rs.next()){
						String friend_id = rs.getString("friend_id");
						allowed2shareComment = true;
					}
				}
				if(allowed2shareComment){
%>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Share Your Thought
					</td>
				</tr>
				<tr>
					<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td>
						<table width="98%" border="0" cellspacing="0" cellpadding="0" >
							<tr>
								<td style="text-align: center;">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" >
										<tr>
											<td style="text-align: right;">
												<textarea id="txtShare" rows="2" cols="80" onfocus="autohintGotFocus(this,tdShareButton);" onblur="autohintGotBlur(this,tdShareButton);" 
													class="auto-hint" style="border-style: solid;" title="Collaborate, share an idea, or recommend an article">Collaborate, share an idea, or recommend an article</textarea>
											</td>
										</tr>
										<tr>
											<td id="tdShareButton" style="text-align: right;display: none;">
												<input class="btn" id="btnShareComment" onclick="postComment(<%=(user_id==null?"" + ub.getUserID():user_id) %>,txtShare,tdShareButton);" type="button" value="Share"></input>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td><input type="hidden" id="latestTime" value="<%=formatter.format(new Date()) %>" /><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
				</tr>
<% 
				}
			}
%>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Recent Activity
					</td>
				</tr>
				<tr>
					<td id="tdRecentActivity">
						<tiles:insert template="/profile/recentActivity.jsp" />
<%-- 
						<script type="text/javascript">
							$(document).ready(function(){
								$.get('/profile/recentActivity.jsp',function(data){
									$('#tdRecentActivity').html(data);
								});
							});
						</script>
--%>
					</td>
				</tr>
			</table>
		</td>
<% 
			if(hideRightBar==null){
%>
		<td>&nbsp;</td>
		<td width="25%" valign="top">
			<tiles:insert template="/profile/basicInfo.jsp" />
		</td>
<%
			}
%>
	</tr>
</table>	
<%
	}
%>
</div>
<script type="text/javascript">
/*
	window.onload = function(){
		if(divUserActivityContent){
			if(parent.displayTalks){
				parent.displayTalks(divUserActivityContent.innerHTML);
			}
		}
	}
*/
</script>	
