<%@page import="edu.pitt.sis.Html2Text"%><%@page import="java.util.ArrayList"%><%@page import="java.util.HashSet"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="java.util.HashMap"%><%@page import="java.util.Vector"%><%@page import="java.util.Collections"%><%@page import="java.util.Iterator"%><%
	session=request.getSession(false);
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<colloquium>");
	
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String col_id = (String)request.getParameter("col_id");
	if(col_id == null){
		out.print("<status>ERROR: col_id must be submitted</status>");
	}else{
		String sql = "SELECT c.title,date_format(c._date,_utf8'%b %d, %Y') _date," +
						"date_format(c.begintime,_utf8'%l:%i %p') _begin," +
						"date_format(c.endtime,_utf8'%l:%i %p') _end, " +
						"c.detail,h.host_id,h.host,s.speaker_id,s.name,c.location," +
						"c.user_id,c.url,u.name owner,c.owner_id,lc.abbr,c.video_url,s.affiliation " +
						"FROM colloquium c JOIN speaker s ON c.speaker_id=s.speaker_id " +
						"JOIN userinfo u ON c.owner_id = u.user_id " +
						"LEFT OUTER JOIN host h ON c.host_id = h.host_id " +
						"LEFT OUTER JOIN loc_col lc ON c.col_id = lc.col_id " +
						"WHERE c.col_id = " + col_id;

		connectDB conn = new connectDB();
		try{
			ResultSet rs = conn.getResultSet(sql);
			if(!rs.next()){
				out.print("<status>ERROR: Talk Not Found</status>");
			}else{
				String url = rs.getString("url");
				String title = rs.getString("title");
				String host = rs.getString("host");
				String speaker = rs.getString("name");
				out.print("<status>OK</status>");
				out.print("<owner id=\"" + rs.getString("owner_id") + "\">" + rs.getString("owner") + "</owner>");

				sql = "SELECT date_format(MIN(lastupdate),_utf8'%b %d %r') posttime " +
						"FROM (SELECT lastupdate FROM colloquium WHERE col_id = "+col_id+" " +
						"UNION " +
						"SELECT MIN(lastupdate) lastupdate FROM col_bk WHERE col_id = "+col_id+") ptime";
				ResultSet rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					String posttime = rsExt.getString("posttime");
					out.print("<posttime>" + posttime + "</posttime>");
				}
				
				out.print("<title><![CDATA[" + title + "]]></title>");
				out.print("<speaker>" + speaker + "</speaker>");
				String affiliation = rs.getString("affiliation");
				if(affiliation != null){
					if(!affiliation.equalsIgnoreCase("N/A")){
						out.print("<affiliation>" + affiliation + "</affiliation>");
					}
				}
				if(host!=null){
					if(host.trim().length() > 0){
						out.print("<host>" + host + "</host>");
					}
				}

				String _sql = "SELECT s.series_id,s.name FROM series s,seriescol sc " +
								"WHERE s.series_id = sc.series_id AND sc.col_id=" + col_id;

				ResultSet rsSeries = conn.getResultSet(_sql);
				if(rsSeries.next()){
					String series_id = rsSeries.getString("series_id");
					String series_name = rsSeries.getString("name");
					out.print("<series id=\"" + series_id + "\"><![CDATA[" + series_name + "]]></series>");	
				}
				rsSeries.close();
				
				out.print("<date>" + rs.getString("_date") + "</date>");
				out.print("<begintime>" + rs.getString("_begin") + "</begintime>");
				out.print("<endtime>" + rs.getString("_end") + "</endtime>");
				out.print("<location><![CDATA[" + rs.getString("location") + "]]></location>");
				if(url.trim().length() > 3){
					out.print("<url><![CDATA[" + url + "]]></url>");
				}
				String video = rs.getString("video_url");
				if(video!=null){
					if(video.length() > 0){
						out.print("<video_url><![CDATA[" + video + "]]></video_url>");
					}
				}
				out.print("<detail><![CDATA[http://washington.sis.pitt.edu/comet/colloquia/presentDetail.jsp?col_id=" + col_id + "]]></detail>");//out.print("<detail><![CDATA[" + rs.getString("detail") + "]]></detail>");
				//Insert time log
				long uid = 0;
				if(ub != null){
					uid = ub.getUserID();
				}
				String sessionID = session.getId();
				Cookie cookies[] = request.getCookies();
				//Find session id
				boolean foundSessionID = false;
				if(cookies != null){
					for(int i=0;i<cookies.length;i++){
						Cookie c = cookies[i];
					    if (c.getName().equalsIgnoreCase("sessionid")) {
					        sessionID = c.getValue();
					    	foundSessionID = true;
					    }			
					}
				}
				String ipaddress = request.getRemoteAddr();
				sql = "INSERT INTO talkview (user_id,viewTime,col_id,ipaddress,sessionid) VALUES (" + uid + ",NOW()," + col_id + ",'" + ipaddress + "','" + sessionID + "')";
				conn.executeUpdate(sql);

				//Tags
				String tags = "";
				sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t,tags tt,userprofile u " +
						"WHERE t.tag_id = tt.tag_id AND " +
						"tt.userprofile_id = u.userprofile_id AND " +
						"u.col_id = " + col_id;
				sql +=	" GROUP BY t.tag_id,t.tag " +
							"ORDER BY t.tag";
				rsExt = conn.getResultSet(sql);
				if(rsExt != null){
					out.print("<tags>");
					while(rsExt.next()){
						String tag = rsExt.getString("tag");
						long tag_id = rsExt.getLong("tag_id");
						long _no = rsExt.getLong("_no");
						if(tag.length() > 0){
							out.print("<tag id=\"" + tag_id + "\"><![CDATA[" + tag + "]]></tag>");
						}
					}
					out.print("</tags>");
				}

				String communities = "";		
				sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no FROM community c,contribute ct,userprofile u " +
						"WHERE c.comm_id = ct.comm_id AND " +
						"ct.userprofile_id = u.userprofile_id AND " + 
						"u.col_id = " + col_id;
				sql +=	" GROUP BY c.comm_id,c.comm_name " +
						"ORDER BY c.comm_name";
				rsExt.close();
				rsExt = conn.getResultSet(sql);
				if(rsExt != null){
					out.print("<groups>");
					while(rsExt.next()){
						String comm_name = rsExt.getString("comm_name");
						long comm_id = rsExt.getLong("comm_id");
						long _no = rsExt.getLong("_no");
						if(comm_name.length() > 0){
							out.print("<group id=\"" + comm_id + "\">" + comm_name + "</group>");
							communities += "&nbsp;<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>"; 
						}
					}
					out.print("</groups>");
				}
				//Bookmark by
				int bookmarkno = 0;
				String bookmarks = "";
				sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u,userprofile up " +
						"WHERE u.user_id = up.user_id AND up.col_id = " + col_id;
				sql +=	" GROUP BY u.user_id,u.name ORDER BY u.name";
				rsExt.close();
				rsExt = conn.getResultSet(sql);
				if(rsExt!=null){
					while(rsExt.next()){
						String user_name = rsExt.getString("name");
						long user_id = rsExt.getLong("user_id");
						long _no = rsExt.getLong("_no");
						if(user_name.length() > 0){
							out.print("<bookmarkby>");
							out.print("<userid>" + user_id + "</userid>");
							out.print("<bookmarkedname>" + user_name + "</bookmarkedname>");
							out.print("</bookmarkby>");
							bookmarkno++;				
						}
					}
				}
				if(bookmarkno > 0){
					out.print("<bookmarkno>" + bookmarkno + "</bookmarkno>");
				}

				//How many emails
				int emailno = 0;
				sql = "SELECT emails FROM emailfriends WHERE col_id=" + col_id;
				rsExt.close();
				rsExt = conn.getResultSet(sql);
				if(rsExt!=null){
					HashSet<String> setEmails = new HashSet<String>();
					while(rsExt.next()){
						String emails = rsExt.getString("emails");
						String[] email = emails.split(",");
						if(email != null){
							for(int i=0;i<email.length;i++){
								String aEmail = email[i].trim().toLowerCase();
								setEmails.add(aEmail);
							}
						}
					}
					emailno = setEmails.size();
				}
				if(emailno > 0){
					out.print("<emailno>" + emailno + "</emailno>");
				}
				
				//How many views
				int viewno = 0;
				sql = "SELECT ipaddress,sessionid,COUNT(*) _no FROM talkview WHERE col_id=" + col_id + " GROUP BY ipaddress,sessionid";
				rsExt = conn.getResultSet(sql);
				if(rsExt!=null){
					while(rsExt.next()){
						ipaddress = rsExt.getString("ipaddress");
						String sessionid = rsExt.getString("sessionid").trim().toLowerCase();
						if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
							viewno += rsExt.getInt("_no");
						}else{
							viewno++;
						}
						
					}
				}
				if(viewno > 0){
					out.print("<viewno>" + viewno + "</viewno>");
				}
				
				sql = "SELECT r.path FROM affiliate_col ac INNER JOIN relation r ON ac.affiliate_id = r.child_id WHERE ac.col_id = " + col_id;
				ResultSet rsSponsor = conn.getResultSet(sql);
				ArrayList<String> relationList = new ArrayList<String>();
				HashMap<String,String> aList = new HashMap<String,String>();
				while(rsSponsor.next()){
					String relation = rsSponsor.getString("path");
					relationList.add(relation);
					String[] path = relation.split(",");
					for(int i=0;i<path.length;i++){
						aList.put(path[i],null);
					}
					
				}
				String affList = null;
				for(Iterator<String> i=aList.keySet().iterator();i.hasNext();){
					if(affList ==null){
						affList = "";
					}else{
						affList +=",";
					}
					affList +=i.next();
				}

				sql = "SELECT affiliate_id,affiliate FROM affiliate WHERE affiliate_id IN ("+affList+")";
				rsSponsor = conn.getResultSet(sql);
				while(rsSponsor.next()){
					aList.put(rsSponsor.getString("affiliate_id"),rsSponsor.getString("affiliate"));
				}
				rsSponsor.close();
				int sponsorno = 0;
				if(relationList.size()>0){
					for(int i=0;i<relationList.size();i++){
						String[] path = relationList.get(i).split(",");
						if(path.length > 0){
							out.print("<sponsors no=\"" + sponsorno + "\">");
							for(int j=0;j<path.length;j++){
								out.print("<sponsor id=\"" + path[j] + "\">");		
								out.print("<level>" + j + "</level>");
								out.print("<name><![CDATA[" + (String)aList.get(path[j]) + "]]></name>");
								out.print("</sponsor>");
							}			
							out.print("</sponsors>");
							sponsorno++;
						}
					}
				}
				
				//Comments
				sql = "SELECT c.comment_id,c.user_id,u.name,c.comment,date_format(c.comment_date,_utf8'%b %d %r') commenttime " +
						"FROM comment c JOIN userinfo u ON c.user_id = u.user_id " +
						"WHERE c.comment_id IN (SELECT cc.comment_id FROM comment_col cc WHERE cc.col_id=" + col_id + ")";
				rsExt.close();
				rsExt = conn.getResultSet(sql);
				if(rsExt != null){
					out.print("<comments>");
					while(rsExt.next()){
						long c_user_id = rsExt.getLong("user_id");
						String c_name = rsExt.getString("name");
						String c_posttime = rsExt.getString("commenttime");
						String comment = rsExt.getString("comment");
						if(comment.trim().length() > 0){
							out.print("<comment>");
							out.print("<user id=\"" + c_user_id + "\">" + c_name + "</user>");
							out.print("<commenttime>" + c_posttime + "</commenttime>");
							
							comment = comment.replaceAll("\\<.*?>","");
							Html2Text parser = new Html2Text();
							parser.parse(comment);
							comment = parser.getText();
							
							out.print("<commentdetail><![CDATA[" + comment + "]]></commentdetail>");
							out.print("</comment>");
						}
					}
					out.print("</comments>");
				}
				
			}
			rs.close();	
			conn.conn.close();
			conn = null;																					
		}catch(SQLException e){

		}
	}
	out.print("</colloquium>");
%>