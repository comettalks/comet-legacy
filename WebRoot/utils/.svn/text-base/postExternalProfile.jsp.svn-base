<%@ page language="java" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%
	String extTokenID = request.getParameter("extTokenID");
	String profileID = request.getParameter("profileID");
	String service = request.getParameter("service");

	connectDB conn = new connectDB();
						
	String sql = "SELECT COUNT(*) _no FROM extmapping WHERE user_id=" + extTokenID + " AND ext_id=" + profileID + " AND exttable='" + service + "'";
	ResultSet rs = conn.getResultSet(sql);
	boolean isIDUp2Date = false;
	if(rs.next()){
		int no = rs.getInt(1);
		if(no > 0){
			isIDUp2Date = true;
		}
	}
	if(!isIDUp2Date){
		sql = "INSERT INTO extmapping (user_id,ext_id,exttable,mappedtime) VALUES (" + 
				extTokenID +"," +profileID + ",'" + service + "',NOW())";
		conn.executeUpdate(sql);
	}

	conn.conn.close();
	conn = null;
%>