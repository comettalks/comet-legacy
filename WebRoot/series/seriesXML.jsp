<%@page import="edu.pitt.sis.Html2Text"%><%@ page language="java"%><%@ page import="edu.pitt.sis.beans.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="edu.pitt.sis.db.*" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %><% 
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	String series_id = (String)request.getParameter("series_id");
	connectDB conn = new connectDB();
	if(series_id == null){
		String sql = "SELECT s.series_id,s.name,s.description,s.owner_id,u.name owner,s.url " +
			"FROM series s JOIN userinfo u ON s.owner_id = u.user_id ORDER BY s.name";
		ResultSet rs = conn.getResultSet(sql);
		out.print("<results>");
		while(rs.next()){
			out.print("<series>");
			String _series_id = rs.getString("series_id");
			String name = rs.getString("name");
			String description = rs.getString("description");
			String owner_id = rs.getString("owner_id");
			String owner = rs.getString("owner");
			String url = rs.getString("url");
			
			description = description.replaceAll("\\<.*?>","");
			Html2Text parser = new Html2Text();
			parser.parse(description);
			description = parser.getText();
			
			out.print("<series_id><![CDATA[" + _series_id + "]]></series_id>");
			out.print("<title><![CDATA[" + name + "]]></title>");
			out.print("<description><![CDATA[" + description + "]]></description>");
			out.print("<owner id=\"" + owner_id + "\"><![CDATA[" + owner + "]]></owner>");
			if(url.length() > 4){
				out.print("<url><![CDATA[" + url + "]]></url>");
			}
			out.print("</series>");
		}
		out.print("</results>");
	}else{
		session=request.getSession(false);
		String sql = "SELECT s.name,s.description,s.owner_id,u.name owner,s.url " +
						"FROM series s JOIN userinfo u ON s.owner_id = u.user_id WHERE s.series_id = " + series_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			out.print("<series>");
			String name = rs.getString("name");
			String description = rs.getString("description");
			String owner_id = rs.getString("owner_id");
			String owner = rs.getString("owner");
			String url = rs.getString("url");
			
			description = description.replaceAll("\\<.*?>","");
			Html2Text parser = new Html2Text();
			parser.parse(description);
			description = parser.getText();
			
			out.print("<title><![CDATA[" + name + "]]></title>");
			out.print("<description><![CDATA[" + description + "]]></description>");
			out.print("<owner id=\"" + owner_id + "\"><![CDATA[" + owner + "]]></owner>");
			if(url.length() > 4){
				out.print("<url><![CDATA[" + url + "]]></url>");
			}
			out.print("</series>");
		}else{
			out.print("<status>ERROR: Series Not Found</status>");
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}
%>