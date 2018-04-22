<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.ArrayList"%>


<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	
	String sql = "select relation_id, path from relation";
	connectDB conn = new connectDB();
	ResultSet sponsor_rs = conn.getResultSet(sql);
	String output = new String();
	while(sponsor_rs.next()){
		String sponsor = "";
		String pathStr = sponsor_rs.getString("path");
		int id = sponsor_rs.getInt("relation_id");
		String path[] = pathStr.split(",");
		
		for(int i = path.length - 1; i >= 0; i--){
			String sql2 = "select affiliate from affiliate where affiliate_id = " + path[i];
			ResultSet rs2 = conn.getResultSet(sql2);
			while (rs2.next()){
				sponsor += rs2.getString("affiliate") + ", ";
			}
			rs2.close();
		}
		
		sponsor = sponsor.substring(0, sponsor.length() - 2);
		String sql3 = "update relation set fullPath = \"" + sponsor + "\" where relation_id = " + id;
		System.out.println(sql3);
		conn.executeUpdate(sql3);
	}
	sponsor_rs.close();
	
	out.print(output);
%>