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
	
	String sql = "select max(cv_id) as maxid from contribute_vote";
	connectDB conn = new connectDB();
	ResultSet rs = conn.getResultSet(sql);
	int cv_id = 0;
	int comm_id = Integer.parseInt((String)request.getParameter("comm_id"));
	int user_id = Integer.parseInt((String)request.getParameter("user_id"));
	int col_id = Integer.parseInt((String)request.getParameter("col_id"));
	int vote = Integer.parseInt((String)request.getParameter("vote"));
	if(rs.next()){
		cv_id = rs.getInt("maxid");
		cv_id++;
	}
	PreparedStatement pstmt = null;
	sql = "insert into contribute_vote values(?,?,?,?,?,NOW())";
	pstmt = conn.conn.prepareStatement(sql);
	pstmt.setInt(1, cv_id);
	pstmt.setInt(2, comm_id);
	pstmt.setInt(3, user_id);
	pstmt.setInt(4, col_id);
	pstmt.setInt(5, vote);
	pstmt.execute();
	pstmt.close();
	
	
%>