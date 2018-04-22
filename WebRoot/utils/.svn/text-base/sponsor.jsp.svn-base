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
	


	//String sql = "select child_id, fullPath from relation where fullPath REGEXP '^" + request.getParameter("q") + "' order by fullPath";
	String sql = "select child_id, fullPath from relation where fullPath REGEXP '[[:<:]]" + request.getParameter("q") + "' order by fullPath";

	
	connectDB conn = new connectDB();
	ResultSet sponsor_rs = conn.getResultSet(sql);
	String output = new String();
	while(sponsor_rs.next()){
		output += (sponsor_rs.getString("fullPath") + ";" + sponsor_rs.getString("child_id") + ";" + "\n"); 
	}

	
	out.print(output);
%>