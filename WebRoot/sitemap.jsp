<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="java.sql.ResultSet"%><%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+path+"/";
	response.setContentType("text/plain");
	//out.println(basePath);
	connectDB conn = new connectDB();
	String sql;
	ResultSet rs;
	//index.do with its affiliations
	/*out.println(basePath + "index.do");
	sql = "SELECT affiliate_id FROM affiliate";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		out.println(basePath + "index.do?affiliate_id="+rs.getString(1));
	}*/
	//series.do
	/*out.println(basePath + "series.do");
	sql = "SELECT series_id FROM series";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		out.println(basePath + "series.do?series_id="+rs.getString(1));
	}*/
	//calendar.do
	/*out.println(basePath + "calendar.do");
	sql = "SELECT user_id FROM userinfo";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		out.println(basePath + "calendar.do?user_id="+rs.getString(1));
	}*/
	//community.do
	/*out.println(basePath + "community.do");
	sql = "SELECT comm_id FROM community";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		out.println(basePath + "community.do?comm_id="+rs.getString(1));
	}*/
	//tag.do
	/*out.println(basePath + "tag.do");
	sql = "SELECT tag_id FROM tag";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		out.println(basePath + "tag.do?tag_id="+rs.getString(1));
	}*/
	//facet.do
	/*out.println(basePath + "facet.do");
	sql = "SELECT entity_id FROM entity";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		out.println(basePath + "facet.do?entity_id="+rs.getString(1));
	}*/
	//presentColloquium.do?col_id=
	sql = "SELECT col_id FROM colloquium";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		out.println(basePath + "presentColloquium.do?col_id="+rs.getString(1));
	}
	rs.close();
	conn.conn.close();
	conn = null;
%>