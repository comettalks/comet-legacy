<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<div id="divUserInfoContent">
<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	if(user_id==null&&ub==null){
%>
	<script type="text/javascript">
		redirect("login.do");
		//window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
		connectDB conn = new connectDB();
		String sql = "SELECT name,email,location,job,affiliation,website,aboutme,interests FROM userinfo WHERE user_id=";
		if(user_id==null){
			sql += ub.getUserID();
		}else{
			sql += user_id;
		}
		String name=null;
		String email=null;
		String location=null;
		String job=null;
		String affiliation=null;
		String website=null;
		String aboutme=null;
		String interests=null;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			name = rs.getString("name");
			email = rs.getString("email");
			location = rs.getString("location");
			job = rs.getString("job");
			affiliation = rs.getString("affiliation");
			website = rs.getString("website");
			aboutme = rs.getString("aboutme");
			interests = rs.getString("interests");
			
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td colspan="3">
			<iframe id="infoFrame" name="infoFrame" style="width: 0px;height: 0px;border: 0px;position: absolute;" src="profile/infoEntry.jsp"></iframe>
		</td>
	</tr>
	<tr>
		<td id="tdUserSubInfo" width="75%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td width="80%" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Info
					</td>
					<td width="20%" align="right" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
<% 
			if(ub!=null){
				if(user_id==null||user_id==String.valueOf(ub.getUserID())){
%>
						<input class="btn" style="width: 0px;visibility: hidden;display: none;overflow: hidden;" id="btnEditInfo" type="button" value="Update" onclick="updateInfo()" />&nbsp;<input class="btn" id="btnCancelEditInfo" type="button" value="Edit" onclick="cancelEditInfo()" />
<%				
				}
			}
%>
					</td>
				</tr>
				<tr>
					<td colspan="2">
<% 
			if(ub!=null){
				if(user_id==null||user_id==String.valueOf(ub.getUserID())){
%>
						<div style="display: none;" id="divEditInfo">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
								<tr>
									<td colspan="3"><span id="updateError" style="font-weight: bold;color: red;"></span></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Name:<input type="hidden" id="user_id" value="<%=ub.getUserID() %>" /></td>
							  		<td colspan="2"><input type="text" id="name" size="80" value="<%if(name!=null){out.print(name);} %>" /><span id="nameError" style="font-weight: bold;color: red;"></span></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Email:</td>
							  		<td colspan="2"><input type="text" id="email" size="80" value="<%if(email!=null){out.print(email);} %>" /><span id="emailError" style="font-weight: bold;color: red;"></span></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Location:</td>
							  		<td colspan="2"><input type="text" id="location" size="80" value="<%if(location!=null){out.print(location);} %>" /></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Job Title:</td>
							  		<td colspan="2"><input type="text" id="job" size="80" value="<%if(job!=null){out.print(job);} %>" /></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Affiliation:</td>
							  		<td colspan="2"><input type="text" id="affiliation" size="80" value="<%if(affiliation!=null){out.print(affiliation);} %>" /></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Website:</td>
							  		<td colspan="2"><input type="text" id="website" size="80" value="<%if(website!=null){out.print(website);} %>" /></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">About me:</td>
							  		<td colspan="2"><textarea id="aboutme" name="aboutme" rows="5" cols="45"><%if(aboutme!=null){out.print(aboutme);} %></textarea>
							  		</td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Interests:</td>
							  		<td colspan="2"><textarea id="interests" name="interests" rows="5" cols="45"><%if(interests!=null){out.print(interests);} %></textarea>
							  		</td>
								</tr>
							</table>
						</div>
<%					
				}
			}
%>			
						<div id="divInfo">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
								<tr> 
									<td colspan="3" align="center"><span id="infoDesc" style="font-weight: bold;color: blue;"></span></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Name:</td>
							  		<td id="infoName" colspan="2"><%if(name==null){out.print("Not specified");}else{out.print(name);} %></td>
								</tr>
<% 
			if(ub!=null){
				if(user_id==null||user_id==String.valueOf(ub.getUserID())){
%>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Email:</td>
							  		<td id="infoEmail" colspan="2"><%if(email==null){out.print("Not specified");}else{out.print(email);} %></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">&nbsp;</td>
							  		<td colspan="2"><span style="color: red;font-style: italic;">(only you can see this)</span></td>
								</tr>
<%				
				}	
			}
%>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Location:</td>
							  		<td id="infoLocation" colspan="2"><%if(location==null){out.print("Not specified");}else{out.print(location);} %></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Job Title:</td>
							  		<td id="infoJob" colspan="2"><%if(job==null){out.print("Not specified");}else{out.print(job);} %></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Affiliation:</td>
							  		<td id="infoAffiliation" colspan="2"><%if(affiliation==null){out.print("Not specified");}else{out.print(affiliation);} %></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Website:</td>
							  		<td id="infoWebsite" colspan="2"><%if(website==null){out.print("Not specified");}else{out.print(website);} %></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">About me:</td>
							  		<td id="infoAboutme" colspan="2"><%if(aboutme==null){out.print("Not specified");}else{out.print(aboutme);} %></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Interests:</td>
							  		<td id="infoInterests" colspan="2"><%if(interests==null){out.print("Not specified");}else{out.print(interests);} %></td>
								</tr>
								
							</table>
						</div>		
					</td>
				</tr>
<% 
			if(ub!=null){
				if(user_id==null||user_id==String.valueOf(ub.getUserID())){
%>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td colspan="2" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					External Profiles <span style="color: red;font-style: italic;">(only you can see these)</span>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="divExtProfile">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
								<tr> 
									<td colspan="3" align="center"><span id="extProfileDesc" style="font-weight: bold;color: blue;"></span></td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">LinkedIn:</td>
							  		<td id="tdLinkedIn" colspan="2">
										<tiles:insert template="/profile/linkedinProfile.jsp" />							  			
							  		</td>
								</tr>
								<tr>
									<td colspan="3" style="border-bottom: 1px solid #efefef;">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="3" style="border-top: 1px solid #efefef;">&nbsp;</td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Facebook:</td>
							  		<td id="tdFacebook" colspan="2">
										<tiles:insert template="/profile/facebookProfile.jsp" />							  			
							  		</td>
								</tr>
								<tr>
									<td colspan="3" style="border-bottom: 1px solid #efefef;">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="3" style="border-top: 1px solid #efefef;">&nbsp;</td>
								</tr>
								<tr> 
									<td width="15%" valign="top" style="font-weight: bold;">Mendeley:</td>
							  		<td id="tdMendeley" colspan="2">
										<tiles:insert template="/profile/mendeleyProfile.jsp" />							  			
							  		</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
<% 
				}
			}	
%>
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="25%" valign="top">
			<tiles:insert template="/profile/basicInfo.jsp" />
		</td>
	</tr>
</table>	
<%			
		}
	}
%>
	<script type="text/javascript">
		window.onload = function(){
			if(divUserInfoContent){
				if(parent.displayTalks){
					parent.displayTalks(divUserInfoContent.innerHTML);
				}
			}
		}
	</script>	
</div>
