<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<script type="text/javascript">
	function ShowSeries(){
		if(btnShowSeries){
			btnShowSeries.style.width = "0px";
			btnShowSeries.style.display = "none";
			divSeries.style.height = "auto";
			divSeries.style.overflow = "visible";
		}
	}
</script>
<% 
	connectDB conn = new connectDB();
	HashSet<String> seriesSet = new HashSet<String>();
	String col_id = (String)request.getParameter("col_id");
	if(col_id!=null){
		String sql = "SELECT series_id FROM seriescol WHERE col_id = " + col_id;
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			seriesSet.add(rs.getString("series_id"));	
		}
	}
	String sql = "SELECT series_id,name FROM series " +
					//"WHERE semester = (SELECT currsemester FROM sys_config) " + 
					"ORDER BY name";
	ResultSet rs = conn.getResultSet(sql);
	if(seriesSet.size()==0){
%>
<input class="btn" type="button" id="btnShowSeries" value="Show Series" 
onclick="ShowSeries();" />
<%		
	}
%>
<div id="tree_series" style="<%=seriesSet.size()==0?"height: 0px;overflow: hidden;":"" %>">
<% 
	while(rs.next()){
		String series_id = rs.getString("series_id");
		String name = rs.getString("name");
%>
		<input type="checkbox" name="series_id" value="<%=series_id%>" 
			<%=seriesSet.contains(series_id)?"checked='checked'":""%>/>&nbsp;<%=name%><br/>
<%
	}
%>
</div>
