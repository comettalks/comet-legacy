<%@ page language="java"%><%@ page import="edu.pitt.sis.beans.*" %><%@ page import="java.sql.*" %><%@ page import="java.util.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.Html2Text"%><% 
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	String comm_id = (String)request.getParameter("comm_id");
	connectDB conn = new connectDB();
	Html2Text parser = new Html2Text();
	if(comm_id == null){
		String sql = "SELECT comm_id,comm_name,comm_desc FROM community ORDER BY comm_name";
		ResultSet rs = conn.getResultSet(sql);
		out.print("<groups>");
		while(rs.next()){
			String _comm_id = rs.getString("comm_id");
			String comm_name = rs.getString("comm_name");
			String comm_desc = rs.getString("comm_desc");
			comm_desc = comm_desc.replaceAll("\\<.*?>","");
			parser.parse(comm_desc);
			comm_desc = parser.getText();
			out.print("<group>");
			out.print("<comm_id><![CDATA[" + _comm_id + "]]></comm_id>");
			out.print("<title><![CDATA[" + comm_name + "]]></title>");
			out.print("<description><![CDATA[" + comm_desc + "]]></description>");
			out.print("</group>");
		}
		out.print("</groups>");
	}else{
		String sql = "SELECT comm_name,comm_desc FROM community WHERE comm_id = " + comm_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			out.print("<group>");
			String comm_name = rs.getString("comm_name");
			String comm_desc = rs.getString("comm_desc");

			comm_desc = comm_desc.replaceAll("\\<.*?>","");
			parser.parse(comm_desc);
			comm_desc = parser.getText();
			
			out.print("<title><![CDATA[" + comm_name + "]]></title>");
			out.print("<description><![CDATA[" + comm_desc + "]]></description>");
			rs.close();
			conn.conn.close();
			out.print("</group>");
		}else{
			out.print("<status>ERROR: Group Not Found</status>");
		}
	}
%>
