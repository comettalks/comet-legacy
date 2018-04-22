<%@ page language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %><%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %><% 
	session = request.getSession(false);
	int rows = -1;
	int start = 0;
	int affiliate_id = -1;
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT SQL_CACHE s.series_id,s.name,st._no curtalkno,tst._no ttalkno,sb._no curbno,tsb._no tbno " +
					"FROM series s LEFT JOIN " +
					"(SELECT sc.series_id,COUNT(*) _no FROM seriescol sc " +
					"JOIN colloquium c ON sc.col_id=c.col_id AND c._date >= CURDATE() "+
					"GROUP BY sc.series_id) st ON s.series_id = st.series_id " +
					"LEFT JOIN " +
					"(SELECT sc.series_id,COUNT(*) _no FROM seriescol sc " +
					"JOIN colloquium c ON sc.col_id=c.col_id "+
					"GROUP BY sc.series_id) tst ON s.series_id = tst.series_id " +
					"LEFT JOIN " +
					"(SELECT sc.series_id,COUNT(*) _no FROM seriescol sc " +
					"JOIN colloquium c ON sc.col_id=c.col_id AND c._date >= CURDATE() "+
					"JOIN userprofile up ON sc.col_id=up.col_id "+
					"GROUP BY sc.series_id) sb ON s.series_id = sb.series_id " +
					"LEFT JOIN " +
					"(SELECT sc.series_id,COUNT(*) _no FROM seriescol sc " +
					"JOIN colloquium c ON sc.col_id=c.col_id "+
					"JOIN userprofile up ON sc.col_id=up.col_id "+
					"GROUP BY sc.series_id) tsb ON s.series_id = tsb.series_id " +
					"";
	if(affiliate_id > 0){
		sql += "WHERE s.series_id IN " +
				"(SELECT afs.series_id FROM affiliate_series afs," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE afs.affiliate_id = cc.child_id " +
				"UNION SELECT series_id FROM affiliate_series WHERE affiliate_id = " + affiliate_id + ") ";
	}
	sql += "GROUP BY s.series_id,s.name " +
			"HAVING ttalkno > 0 " +
			"ORDER BY s.name,s.series_id ";
	if(rows > 0){
		sql += "LIMIT " + start + "," + rows;
	}
	//out.println(sql);
	
    try{
    	response.setContentType("application/xml");
    	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");

    	rs = conn.getResultSet(sql);
    	out.print("<recentseries>");
        while(rs.next()){
        	String series_id = rs.getString("series_id");
        	String name = rs.getString("name").trim();
			int curtalkno = rs.getInt("curtalkno");
			int ttalkno = rs.getInt("ttalkno");
			int curbno = rs.getInt("curbno");
			int tbno = rs.getInt("tbno");

			out.print("<series id=\"" + series_id + "\">");
        	out.print("<name><![CDATA[" + name + "]]></name>");
        	out.print("<bookmark>" + curbno + "</bookmark>");
        	out.print("<totalbookmark>" + tbno + "</totalbookmark>");
        	out.print("<talk>" + curtalkno + "</talk>");
        	out.print("<totaltalk>" + ttalkno + "</totaltalk>");
        	out.print("</series>");
        }
    	out.print("</recentseries>");
		rs.close();
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	 conn.conn.close();
	 conn = null;
	}
%>