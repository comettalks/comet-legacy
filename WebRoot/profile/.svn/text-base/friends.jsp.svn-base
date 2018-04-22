<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	String listtype = (String)request.getParameter("listtype");//snapshot,mutual,like
	if(user_id==null&&ub==null){
%>
	<script type="text/javascript">
		redirect("login.do");
		//window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td width="75%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
						Friends
					</td>
				</tr>
				<tr>
					<td>&nbsp;
<% 
		connectDB conn = new connectDB();
		String sql = "SELECT user0_id,user1_id FROM friend WHERE TRUE ";
		if(user_id==null){
			sql += "AND (user0_id=" + ub.getUserID() + " OR user1_id=" + ub.getUserID() + ") ";
		}else{
			sql += "AND (user0_id=" + user_id + " OR user1_id=" + user_id + ") ";
		}
		if(listtype!=null){
			if(listtype.equalsIgnoreCase("mutual")){
				sql += "AND (user0_id=" + ub.getUserID() + " OR user1_id=" + ub.getUserID() + ") ";
			}
			if(listtype.equalsIgnoreCase("like")){
				sql += "AND (user0_id=" + ub.getUserID() + " OR user1_id=" + ub.getUserID() + ") ";
			}
			if(listtype.equalsIgnoreCase("snapshot")){
				sql += " ORDER BY RAND() LIMIT 6;";
			}
		}
%>
					</td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="25%" valign="top">
			&nbsp;
		</td>
	</tr>
</table>	
<%			
	}
%>
