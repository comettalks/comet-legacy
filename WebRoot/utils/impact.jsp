<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<% 
	session = request.getSession(false);
	int col_id = 0;
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	connectDB conn = new connectDB();
	ResultSet rs = null;
    try{
    	
		//How many emails
		int emailno = 0;
		String sql = "SELECT emails FROM emailfriends WHERE col_id=" + col_id;
		rs = conn.getResultSet(sql);
		if(rs!=null){
			HashSet<String> setEmails = new HashSet<String>();
			while(rs.next()){
				String emails = rs.getString("emails");
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
		
		//How many views
		int viewno = 0;
		sql = "SELECT ipaddress,sessionid,COUNT(*) _no FROM talkview WHERE col_id=" + col_id + " GROUP BY ipaddress,sessionid";
		rs = conn.getResultSet(sql);
		if(rs!=null){
			while(rs.next()){
				String ipaddress = rs.getString("ipaddress");
				String sessionid = rs.getString("sessionid").trim().toLowerCase();
				if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
					viewno += rs.getInt("_no");
				}else{
					viewno++;
				}
				
			}
		}
		
		//Bookmark by
		HashSet<Integer> bookSet = new HashSet<Integer>();
		//String bookmarks = "";
		int bookmarkno = 0;
		sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u JOIN userprofile up " +
				"ON u.user_id = up.user_id AND up.col_id = " + col_id +
				" GROUP BY u.user_id,u.name ORDER BY u.name";
		rs = conn.getResultSet(sql);
		if(rs!=null){
			while(rs.next()){
				String user_name = rs.getString("name");
				long user_id = rs.getLong("user_id");
				long _no = rs.getLong("_no");
				if(user_name.length() > 0){
					//bookmarks += "&nbsp;<a href=\"calendar.do?user_id=" + user_id + "\">" + user_name + "</a>";
					bookmarkno++;				
				}
			}
		}
		rs.close();
		
		if(viewno > 0 || emailno > 0 || bookmarkno > 0){
	    	int column = 0;
%>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
			Impact
		</td>
	</tr>
	<tr>
<% 
			if(bookmarkno > 0){
				column++;
				String strBookmark = "<b>" + bookmarkno + "</b><br/><span style='font-size: 0.55em;'>bookmark";
				if(bookmarkno > 1){
					strBookmark += "s";
				}
				strBookmark += "</span>";
%>
		<td width="33%" valign="top" align="center" class="tdBookNoColID<%=col_id %>"
			style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
			<%=strBookmark%>
		</td>
<%			
			}
			if(emailno > 0){
				column++;
				String strEmail = "<b>" + emailno + "</b><br/><span style='font-size: 0.55em;'>email";
				if(emailno > 1){
					strEmail += "s";
				}
				strEmail += "</span>";
%>
		<td width="33%" valign="top" align="center" class="tdEmailNoColID<%=col_id %>"
			style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
			<%=strEmail%>
		</td>
<%			
			}
			if(viewno > 0){
				column++;
				String strView = "<b>" + viewno + "</b><br/><span style='font-size: 0.55em;'>view";
				if(viewno > 1){
					strView += "s";
				}
				strView += "</span>";
%>
		<td width="33%" valign="top" align="center" class="tdViewNoColID<%=col_id %>"
			style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
			<%=strView%>
		</td>
<%			
			}
			if(column < 3){
				%>
		<td width="<%=33*(3-column)%>%" colspan="<%=(3-column) %>">&nbsp;</td>
		<%			
			}
%>											
	</tr>
</table><br/>
<%
			//Update talks impact into db
			sql = "INSERT INTO col_impact (col_id,viewno,bookmarkno,emailno,timestamp) VALUES (" + 
					col_id + "," + viewno + "," + bookmarkno + "," + emailno + ",NOW())";
			conn.executeUpdate(sql);
		}
		
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
