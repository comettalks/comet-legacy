<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	String col_id = (String)request.getParameter("col_id");
		String sql = "SELECT s.name from speaker s JOIN colloquium c ON s.speaker_id = c.speaker_id WHERE c.col_id=" + col_id;
		connectDB conn = new connectDB();
		ResultSet rs = conn.getResultSet(sql);
		String name = "";
%>					
<table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-left: 1px #efefef solid;border-right: 1px #efefef solid;border-bottom: 1px #efefef solid;">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.95em;font-weight: bold;">
			Comments
		</td>
	</tr>
	<tr>
		<td style="font-size: 0.9em;"></td>
	</tr>
	<tr>
		<td><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
</table>
<%		
	conn.conn.close();
%>
