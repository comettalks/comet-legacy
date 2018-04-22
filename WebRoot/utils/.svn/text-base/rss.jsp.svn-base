<?xml version="1.0" encoding="UTF-8" ?>
<%@ page contentType="text/xml" language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.Html2Text"%>
<% 
	session = request.getSession(false);
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int owner_id = 0;
	int comm_id = 0;
	int series_id = 0;
	int rows = 100;
	int start = 0;
	int affiliate_id = -1;
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	if(request.getParameter("tag_id")!=null){
		tag_id = Integer.parseInt((String)request.getParameter("tag_id"));
	}	
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
	}
	if(request.getParameter("owner_id") != null){
		owner_id = Integer.parseInt((String)request.getParameter("owner_id"));
	}
	if(request.getParameter("comm_id") != null){
		comm_id = Integer.parseInt((String)request.getParameter("comm_id"));
	}
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	String[] entity_id_value = request.getParameterValues("entity_id");
	String[] type_value = request.getParameterValues("_type");
	String entity_id_list = "";
	String type_list = "";
	if(entity_id_value !=null){
		for(int i=0;i<entity_id_value.length;i++){
			if(i!=0)entity_id_list += ",";
			entity_id_list += entity_id_value[i];
		}
	}
	if(type_value != null){
		for(int i=0;i<type_value.length;i++){
			if(i!=0)type_list += ",";
			type_list += "'" + type_value[i].replaceAll("'","''") + "'";
		}
	}
	
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT c.col_id,date_format(c.lastupdate,_utf8'%a, %e %b %Y %T') _lastupdate,c.title," +
					"cast(c.detail as char character set utf8) detail,date_format(c._date,_utf8'%b %d, %Y') AS `day`," +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.name,c.location,c.owner_id,u.name owner " +
					"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
					"JOIN userinfo u ON c.owner_id = u.user_id "  +
					"WHERE c._date >= (SELECT beginterm FROM sys_config) AND c._date <= (SELECT endterm FROM sys_config) ";

	if(affiliate_id > 0 ){
		sql += " AND c.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(select child_id from relation where path like concat((SELECT path FROM relation WHERE child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
	}
	if(tag_id > 0){
		sql += " AND c.col_id IN (SELECT u.col_id FROM userprofile u JOIN tags tt ON u.userprofile_id = tt.userprofile_id WHERE tt.tag_id=" + tag_id + ")";
	}
	if(col_id > 0){
		sql += " AND c.col_id=" + col_id; 
	}
	if(user_id > 0){
		sql += " AND c.col_id IN (SELECT u.col_id FROM userprofile u WHERE u.user_id=" + user_id +")";
	}
	if(owner_id > 0){
		sql += " AND c.owner_id =" + owner_id;
	}
	if(comm_id > 0){
		sql += " AND c.col_id IN " +
				"(SELECT u.col_id FROM contribute ct JOIN userprofile u ON ct.userprofile_id = u.userprofile_id " +
				"WHERE ct.comm_id=" + comm_id + ")";
	}
	if(series_id > 0){
		sql += " AND c.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id + ")";
	}
	if(entity_id_value != null){
		sql += " AND c.col_id IN (SELECT col_id FROM entities WHERE entity_id IN (" + entity_id_list + "))";
	}
	if(type_value != null){
		sql+=" AND c.col_id IN (SELECT ee.col_id FROM entities ee,entity e " +
				"WHERE ee.entity_id = e.entity_id AND e._type  IN (" + type_list + "))"; 
	}
	sql += " ORDER BY c.lastupdate DESC";
    //out.println(sql);
    try{
		//response.setContentType("application/xml");
		//response.setHeader("Content-Disposition","attachment; filename=\"rss.xml\"");
		
		out.println("<rss version=\"2.0\" xmlns:content=\"http://purl.org/rss/1.0/modules/content/\" >");
		out.println("<channel>");
		out.println("<title>CoMeT</title>");
		out.println("<description>Collaborative Management of Talks: A social web system for research communities</description>");
		out.println("<link>http://washington.sis.pitt.edu/comet/</link>");
		
		Html2Text parser = new Html2Text();
		
    	rs = conn.getResultSet(sql);
        while(rs.next()){
        	String title = rs.getString("title");
        	String _col_id = rs.getString("col_id");
        	String description = rs.getString("detail");
        	String link = "http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=" + _col_id;
        	String _lastupdate = rs.getString("_lastupdate");
        	String author = rs.getString("owner");
        	String speaker = rs.getString("name");
        	String day = rs.getString("day");
        	String _begin = rs.getString("_begin");
        	String _end = rs.getString("_end");
        	String location = rs.getString("location");

			out.println("<item>");
			out.println("<title><![CDATA[" + title.trim() + "]]></title>");
			out.println("<pubDate>" + _lastupdate + " -0600</pubDate>");
			out.println("<link>" + link + "</link>");
			
			String content = "<b>Speaker:</b>&nbsp;" + speaker + "<br/>";
			content += "<b>Date:</b>&nbsp;" + day + " on " + _begin + " - " + _end + "<br/>";
			content += "<b>Location:</b>&nbsp;" + location;
			
			//Tags
			sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t,tags tt,userprofile u " +
					"WHERE t.tag_id = tt.tag_id AND " +
					"tt.userprofile_id = u.userprofile_id AND " +
					"u.col_id = " + _col_id +
					" GROUP BY t.tag_id,t.tag " +
					"ORDER BY t.tag";
			ResultSet rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String tag = rsExt.getString("tag");
				long _tag_id = rsExt.getLong("tag_id");
				long _no = rsExt.getLong("_no");
				content += "<br/><b>Tags:</b>&nbsp;<a href=\"http://washington.sis.pitt.edu/comet/tag.do?tag_id=" + _tag_id + "\">" + tag + "</a>";
			}
			while(rsExt.next()){
				String tag = rsExt.getString("tag");
				long _tag_id = rsExt.getLong("tag_id");
				long _no = rsExt.getLong("_no");
				content += "&nbsp;<a href=\"http://washington.sis.pitt.edu/comet/tag.do?tag_id=" + _tag_id + "\">" + tag + "</a>";
			}
			
			sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no FROM community c,contribute ct,userprofile u " +
					"WHERE c.comm_id = ct.comm_id AND " +
					"ct.userprofile_id = u.userprofile_id AND " + 
					"u.col_id = " + _col_id +
					" GROUP BY c.comm_id,c.comm_name " +
					"ORDER BY c.comm_name";
			rsExt.close();
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String comm_name = rsExt.getString("comm_name");
				long _comm_id = rsExt.getLong("comm_id");
				long _no = rsExt.getLong("_no");
				content += "<br/><b>Posted to communities:</b>&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/community.do?comm_id=" + _comm_id + "\">" + comm_name + "</a>";
			}
			while(rsExt.next()){
				String comm_name = rsExt.getString("comm_name");
				long _comm_id = rsExt.getLong("comm_id");
				long _no = rsExt.getLong("_no");
				content += "&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/community.do?comm_id=" + _comm_id + "\">" + comm_name + "</a>";
			}
			//Bookmark by
			sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u,userprofile up " +
					"WHERE u.user_id = up.user_id AND up.col_id = " + _col_id +
					" GROUP BY u.user_id,u.name ORDER BY u.name";
			rsExt.close();
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String user_name = rsExt.getString("name");
				long _user_id = rsExt.getLong("user_id");
				long _no = rsExt.getLong("_no");
				content += "<br/><b>Bookmarked by:</b>&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/calendar.do?user_id=" + _user_id + "\">" + user_name + "</a>";
			}
			while(rsExt.next()){
				String user_name = rsExt.getString("name");
				long _user_id = rsExt.getLong("user_id");
				long _no = rsExt.getLong("_no");
				content += "&nbsp;" +
							"<a href=\"http://washington.sis.pitt.edu/comet/calendar.do?user_id=" + _user_id + "\">" + user_name + "</a>";
			}

			if(description != null){			
				description = description.trim();
				content += "<br/><b>Detail:<b>" + description;
				
			}

			out.println("<content:encoded><![CDATA[" + content + "]]></content:encoded>");
			content = content.replaceAll("\\<.*?>","");
			parser.parse(content);				
			content = "<![CDATA[" + parser.getText().trim() + "]]>";
			out.println("<description>" + content + "</description>");

			out.println("<author>" + author + "</author>");
			out.println("</item>");
		}
		rs.close();
		out.println("</channel>");
		out.println("</rss>");
		
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