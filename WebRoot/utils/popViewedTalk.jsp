<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
			Popular Viewed Talks
		</td>
	</tr>
<% 
	session = request.getSession(false);
	int rows = 20;
	int start = 0;
	int affiliate_id = -1;
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
%>
	<tr>
		<td>
			<ol start="<%=start+1 %>">
<%
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT c.col_id,c.title,date_format(c._date,'%b %e') talkdate, " +
					"date_format(c.begintime,'%l:%i %p') talktime,s.name " +  
					"FROM colloquium c,speaker s, " +
	    			"(SELECT col_id,COUNT(*) _no " +
	    			"FROM talkview t ";

	if(affiliate_id > 0 ){
		sql += "WHERE col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ") ";
	}
	
	sql += "GROUP BY col_id " +
	    	"ORDER BY _no DESC " +
	    	") cc " +
	    	"WHERE cc.col_id = c.col_id AND " +
	    	"c._date >= (SELECT beginterm FROM sys_config) AND c._date <= (SELECT endterm FROM sys_config) AND " +
	    	"c.speaker_id = s.speaker_id " +
	    	"LIMIT " + start + "," + rows;
	
    try{
    	rs = conn.getResultSet(sql);
        while(rs.next()){
%>
				<li>						
					<a href="#" style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
						onclick="window.location='presentColloquium.do?col_id=<%=rs.getString("col_id")%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>'">
						<%=rs.getString("title") %>
						<br/><font size="0.6em"><%=rs.getString("name")%>&nbsp;<%=rs.getString("talkdate")%>&nbsp;<%=rs.getString("talktime")%></font>					
					</a>
				</li>
<%
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>
			</ol>
		</td>
	</tr>
	<tr>
		<td>
<% 
	if(rows==5){
%>
				<div style="color:#0080ff;cursor:pointer;" 
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="window.location='popView.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
<%	
	}else{

	}
%>
		</td>
	</tr>
</table>