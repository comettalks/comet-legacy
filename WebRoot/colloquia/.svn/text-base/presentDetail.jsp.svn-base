<%@page import="edu.pitt.sis.Html2Text"%><%@page import="java.util.ArrayList"%><%@page import="java.util.HashSet"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="java.util.HashMap"%><%@page import="java.util.Vector"%><%@page import="java.util.Collections"%><%@page import="java.util.Iterator"%><%
	session=request.getSession(false);

	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String col_id = (String)request.getParameter("col_id");
	String cleantxt = (String)request.getParameter("cleantxt");
	if(col_id == null){
		out.print("ERROR: col_id must be submitted");
	}else{
		String sql = "SELECT c.detail " +
						"FROM colloquium c JOIN speaker s ON c.speaker_id=s.speaker_id " +
						"JOIN userinfo u ON c.owner_id = u.user_id " +
						"LEFT OUTER JOIN host h ON c.host_id = h.host_id " +
						"LEFT OUTER JOIN loc_col lc ON c.col_id = lc.col_id " +
						"WHERE c.col_id = " + col_id;

		connectDB conn = new connectDB();
		try{
			ResultSet rs = conn.getResultSet(sql);
			if(!rs.next()){
				out.print("ERROR: Talk Not Found");
			}else{
				if(cleantxt==null){
					out.print(rs.getString("detail"));//out.print("<detail><![CDATA[" + rs.getString("detail") + "]]></detail>");				
				}else{
					String detail = rs.getString("detail");
					detail = detail.replaceAll("\\<.*?>"," ");
					Html2Text h2t = new Html2Text();
					h2t.parse(detail);
					out.print(h2t.getText());
				}
			}	
			rs.close();	
			conn.conn.close();
			conn = null;																					
		}catch(SQLException e){

		}
	}
	//out.print("</colloquium>");
%>