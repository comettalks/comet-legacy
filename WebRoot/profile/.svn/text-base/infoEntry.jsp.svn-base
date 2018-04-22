<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<% 
	String user_id = (String)request.getParameter("user_id");
	if(user_id==null){
%>
<form action="infoEntry.jsp" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">user_id:</td>
	 	<td><input type="text" id="user_id" name="user_id" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Name:</td>
	 	<td><input type="text" id="name" name="name" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Email:</td>
	 	<td><input type="text" id="email" name="email" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Location:</td>
	 	<td><input type="text" id="location" name="location" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Job Title:</td>
	 	<td><input type="text" id="job" name="job" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Affiliation:</td>
	 	<td><input type="text" id="affiliation" name="affiliation" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Website:</td>
	 	<td><input type="text" id="website" name="website" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">About me:</td>
	 	<td><input type="text" id="aboutme" name="aboutme" /></td>
	</tr>
	<tr> 
		<td width="15%" valign="top" style="font-weight: bold;">Interests:</td>
	 	<td><input type="text" id="interests" name="interests" /></td>
	</tr>

</table>	
</form>
<% 
	}else{
		boolean nameError = false;
		boolean emailError = false;
		String name = (String)request.getParameter("name");
		String email = (String)request.getParameter("email");
		if(name==null){
			nameError = true;
		}else if(name.trim().length()==0){
			nameError = true;
		}
		if(email==null){
			emailError = true;
		}else if(email.trim().length()==0){
			emailError = true;
		}
		if(nameError||emailError){
%>
	<script type="text/javascript">
		window.onload = function(){
<%
			if(nameError){
%>
				if(parent.displayNameInfoError){
					parent.displayNameInfoError("Name cannot be blank.");
				}
<%
			}
			if(emailError){
%>
				if(parent.displayEmailInfoError){
					parent.displayEmailInfoError("Email cannot be blank.");
				}
<%
			}
%>
		}
	</script>	
<%
			return;
		}
		String location = (String)request.getParameter("location");
		String job = (String)request.getParameter("job");
		String affiliation = (String)request.getParameter("affiliation");
		String website = (String)request.getParameter("website");
		String aboutme = (String)request.getParameter("aboutme");
		String interests = (String)request.getParameter("interests");
		
		connectDB conn = new connectDB();
		String sql = "UPDATE userinfo SET name=?,email=?,location=?,job=?,affiliation=?,website=?,aboutme=?,interests=? " +
				"WHERE user_id=?";
		try {
			PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1,name);
			pstmt.setString(2,email);
			pstmt.setString(3,location);
			pstmt.setString(4,job);
			pstmt.setString(5,affiliation);
			pstmt.setString(6,website);
			pstmt.setString(7,aboutme);
			pstmt.setString(8,interests);
			pstmt.setInt(9,Integer.parseInt(user_id));
			pstmt.executeUpdate();
			pstmt.close();
		} catch (SQLException e) {
%>
	<script type="text/javascript">
		window.onload = function(){
			if(parent.displayUpdateInfoError){
				parent.displayUpdateInfoError("Error: Please try again.");
			}
		}
	</script>	
<%			
			return;
		}
%>
OK
	<script type="text/javascript">
		window.onload = function(){
			if(parent.displayUpdatedInfo){
				parent.displayUpdatedInfo();
			}
		}
	</script>	
<%
	}
%>