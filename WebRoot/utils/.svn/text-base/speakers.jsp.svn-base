<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>


<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	String keywords = request.getParameter("q");
	String sql = "SELECT name, picURL, affiliation FROM speaker WHERE name REGEXP '^" + keywords + "' ORDER BY name";

	
	connectDB conn = new connectDB();
	ResultSet series_rs = conn.getResultSet(sql);
	String output = new String();
	
	while(series_rs.next()){
		output += (series_rs.getString("name") + ";" + series_rs.getString("affiliation") + ";" + series_rs.getString("picURL") + "\n"); 
	}
	

	
	out.print(output);
%>