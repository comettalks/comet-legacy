<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<% 
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int series_id = 0;
	int affiliate_id = -1;
	if(request.getParameter("tag_id")!=null){
		tag_id = Integer.parseInt((String)request.getParameter("tag_id"));
	}	
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
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

	String sql = "SELECT c.comment_id,c.user_id,u.name,c.comment,date_format(c.comment_date,_utf8'%b %d %r') commenttime " +
					"FROM comment c JOIN comment_col cc ON c.comment_id = cc.comment_id " +
					"JOIN userinfo u ON c.user_id=u.user_id " +
					"WHERE cc.col_id=" + col_id;
	connectDB conn = new connectDB();
	ResultSet rs = conn.getResultSet(sql);
%>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="left">
<%	
	int commentno = 0;
	if(rs != null){
		while(rs.next()){
			String comment_id = rs.getString("comment_id");
			user_id = rs.getInt("user_id");
			String name = rs.getString("name");
			String comment = rs.getString("comment");
			String commenttime = rs.getString("commenttime");
			commentno++;
%>
	<tr>
		<td valign="top" style="font-size: 0.75em;">
			<a href="profile.do?user_id=<%=user_id%>"><%=name %></a><br/>
			<span style="color: #bebebe;font-size: 0.75em;"><%=commenttime %></span>
			<a name="comment<%=comment_id %>"></a>
		</td>
	</tr>
	<tr>	
		<td valign="top" style="font-size: 0.75em;">
			<%=comment %>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
<%		
		}
	}
	if(commentno==0){
%>
	<tr><td>No Comment</td></tr>
<%		
	}
%>
</table>		
