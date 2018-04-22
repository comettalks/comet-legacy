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
<%@page import="java.text.SimpleDateFormat"%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 1em;">
<% 
	String comment_id = (String)request.getParameter("comment_id");
	String timeStamp = (String)request.getParameter("timestamp");
	Date today = new Date();
	Format formatterDay = new SimpleDateFormat("MMMMM d"); 
	Format formatterDayYear = new SimpleDateFormat("MMMMM d, yyyy"); 
	final long MILLISECS_PER_DAY = 24*60*60*1000;
	final long MILLISECS_PER_HOUR = 60*60*1000;
	final long MILLISECS_PER_MIN = 60*1000;
	final long MILLISECS = 1000;
	connectDB conn = new connectDB();
	String sql = "SELECT c.comment_id,c.comment,c.comment_date,c.user_id,u.name " +
					"FROM comment c JOIN comment_comment cc ON c.comment_id=cc.comment_id " +
					"JOIN userinfo u ON c.user_id=u.user_id " +
					"WHERE cc.commentee_id=" + comment_id + 
					" AND c.comment_date > '" + timeStamp + "'" +
					" ORDER BY c.comment_date";
	
	ResultSet rs = conn.getResultSet(sql);
	while(rs.next()){
		String cc_id = rs.getString("comment_id");
		String replycomment = rs.getString("comment").replaceAll("\\n","<br/>");
		String replyuid = rs.getString("user_id");
		String replyer = rs.getString("name");
		Timestamp replytime = rs.getTimestamp("comment_date");
%>
	<tr>
		<td colspan="2" style="border-top: 1px solid white;" />
	</tr>
	<tr>
		<td valign="top" style="width: 55px;">
			<a href="profile.do?user_id=<%=replyuid %>"><%=replyer %></a>
		</td>
		<td align="left">
		<%=replycomment %><br/>
		<span style="color: #aeaeae;font-size: 0.9em;">
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
				<%=(replytime.getYear()==today.getYear()?formatterDay.format(replytime):formatterDayYear.format(replytime)) %>
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
%>													
			</span>
		</td>
	</tr>
<%								

	}
%>
</table>
