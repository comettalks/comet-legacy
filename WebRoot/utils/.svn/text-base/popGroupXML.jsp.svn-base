<%@ page language="java"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><% 
	session = request.getSession(false);
	int rows = 20;
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
	String sql = "SELECT SQL_CACHE c.comm_id,c.comm_name,ct._no curtalkno,tct._no ttalkno,cn._no curbno,tcn._no tbno " +
					"FROM community c LEFT JOIN " +
					"(SELECT ct.comm_id,COUNT(*) _no FROM contribute ct JOIN colloquium c ON ct.col_id = c.col_id " +
					"AND c._date >= CURDATE() " +
					"GROUP BY ct.comm_id) ct ON c.comm_id = ct.comm_id " +
					"LEFT JOIN " +
					"(SELECT ct.comm_id,COUNT(*) _no FROM contribute ct JOIN colloquium c ON ct.col_id = c.col_id " +
					"GROUP BY ct.comm_id) tct ON c.comm_id = tct.comm_id " +
					"LEFT JOIN " +
					"(SELECT c.comm_id,COUNT(up.col_id) _no FROM contribute ct JOIN community c ON ct.comm_id=c.comm_id " +
					"JOIN userprofile up ON ct.col_id=up.col_id " + 
					"WHERE ct.col_id IN " +
					"(SELECT col_id FROM colloquium WHERE _date >= CURDATE())" +
					"GROUP BY ct.comm_id) cn ON c.comm_id = cn.comm_id " +
					"LEFT JOIN " +
					"(SELECT c.comm_id,COUNT(up.col_id) _no FROM contribute ct JOIN community c ON ct.comm_id=c.comm_id " +
					"JOIN userprofile up ON ct.col_id=up.col_id " + 
					"GROUP BY ct.comm_id) tcn ON c.comm_id = tcn.comm_id ";
	if(affiliate_id > 0){
		sql += "WHERE c.comm_id IN " +
				"(SELECT c.comm_id FROM contribute c " +
				"WHERE c.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(SELECT child_id FROM relation " +
				"WHERE path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")) ";
	}
	sql += "GROUP BY c.comm_id,c.comm_name " +
			"HAVING tbno IS NOT NULL " +
   			"ORDER BY curbno DESC, tbno DESC " +
			"LIMIT " + start + "," + rows;
	
    try{
    	response.setContentType("application/xml");
    	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");

    	rs = conn.getResultSet(sql);
    	out.print("<popgroup>");
        while(rs.next()){
			String comm_id = rs.getString("comm_id");
			String  comm_name = rs.getString("comm_name");
			int curtalkno = rs.getInt("curtalkno");
			int ttalkno = rs.getInt("ttalkno");
			int curbno = rs.getInt("curbno");
			int tbno = rs.getInt("tbno");
			
			out.print("<group id=\"" + comm_id + "\">");
        	out.print("<name><![CDATA[" + rs.getString("comm_name") + "]]></name>");
        	out.print("<bookmark>" + curbno + "</bookmark>");
        	out.print("<totalbookmark>" + tbno + "</totalbookmark>");
        	out.print("<talk>" + curtalkno + "</talk>");
        	out.print("<totaltalk>" + ttalkno + "</totaltalk>");
			out.print("</group>");
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 out.print("</popgroup>");
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>