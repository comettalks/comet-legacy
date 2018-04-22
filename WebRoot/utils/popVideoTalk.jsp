<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%
	
	int req_days = -1;
	int req_year = -1;
	if(request.getParameter("days")!=null){
    	req_days = Integer.parseInt(request.getParameter("days"));
	}
	if(request.getParameter("year")!=null){
    	req_year = Integer.parseInt(request.getParameter("year"));
	}
	if(req_year > 0){
		req_days = -1;
	}else{
		req_days = 90;
	}
	
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
			Past Popular Talks with Video 
			<%=req_days==30?"30 days":"<a href='popVideo.do?days=30'>30 days</a>" %> 
			<%=req_days==60?"60 days":"<a href='popVideo.do?days=60'>60 days</a>" %> 
			<%=req_days==90?"90 days":"<a href='popVideo.do?days=90'>90 days</a>" %> 
			<%=req_days==180?"180 days":"<a href='popVideo.do?days=180'>180 days</a>" %> 
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<tiles:insert template="/utils/loadTalks.jsp?topvideo=1"/>
		</td>
	</tr>
</table>