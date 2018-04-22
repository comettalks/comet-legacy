<%@page import="java.util.Map"%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.w3c.dom.NodeList"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.w3c.dom.Element"%>
<%@page import="java.io.IOException"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
	
<%
	String uid = "";
	String username = "";
	String email = "";
	String fAutoID = request.getParameter("fAutoID");
	if(fAutoID == null){
%>
<script>
			window.location="index.do";
</script>
<%
	}else{
		session.setAttribute("fAutoID",fAutoID);
		connectDB conn = new connectDB();
		String sql = "SELECT uid,username,email FROM extprofile.facebook WHERE fAutoID = " + fAutoID;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			uid = rs.getString("uid");
			username = rs.getString("username");
			email = rs.getString("email");
		}
		rs.close();
		
		//Did user login before?
		sql = "SELECT u.name,u.user_id FROM userinfo u JOIN extmapping e ON u.user_id=e.user_id " +
				"JOIN extprofile.facebook f ON e.ext_id = f.fAutoID " +
				"WHERE e.ext_id=" + fAutoID + " AND e.exttable='extprofile.facebook' " + 
				"GROUP BY u.name,u.user_id";
		rs = conn.getResultSet(sql);
		if(rs.next()){
			username = rs.getString("name");
			int user_id = rs.getInt("user_id");
			
			UserBean ub = new UserBean();
			ub.setName(username);
			ub.setUserID(user_id);
			
			session.setAttribute("UserSession",ub);
			
			Cookie cid = new Cookie("comet_user_id", "" + ub.getUserID());
	        cid.setMaxAge(365*24*60*60);
	        cid.setPath("/");
	        response.addCookie(cid);
			Cookie cname = new Cookie("comet_user_name", ub.getName());
	        cname.setMaxAge(365*24*60*60);
	        cname.setPath("/");
	        response.addCookie(cname);
			
			String redirect = (String)session.getAttribute("redirect");
			if(redirect == null){
				redirect = "index.do";
			}
			session.removeAttribute("redirect");
%>
<script>
	window.location="<%=redirect%>";
</script>
<%
		}
	}
%>
<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.95em;font-weight: bold;">
			Signup
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>

	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="47%" valign="top">
						<html:form action="/registration">
							<table border="0" width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td colspan="3" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.95em;font-weight: bold;">
										Complete Signup
									</td>
								</tr>
							
								<tr>
									<td colspan="3">&nbsp;</td>
								</tr>
	
								<logic:present name="SignupError">
								<tr>
									<td colspan="3" style="font-size: 0.75em;color: red;font-weight: bold;" >
											<bean:write name="SignupError" property="errorDescription" />
									</td>
								</tr>
								</logic:present>
							
								<tr>
									<td width="25%" style="font-size: 0.75em;font-weight: bold;">
										Screen Name:
									</td>
									<td><html:text style="font-size: 0.75em;" property="name" size="30" value="<%=username %>" /></td>
									<td style="font-size: 0.75em;color: red;"><html:errors property="userEmail"/></td>
								</tr>
								<tr>
									<td width="25%" style="font-size: 0.75em;font-weight: bold;">
										Email Address:
									</td>
									<td><html:text style="font-size: 0.75em;" property="userEmail" size="30" value="<%=email %>" /></td>
									<td style="font-size: 0.75em;color: red;"><html:errors property="userEmail"/></td>
								</tr>
								<tr>
									<td colspan="3">
										<tiles:insert template="/registration/affiliation.jsp" />
									</td>
								</tr>
								<tr>
									<td colspan="3">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="3" align="right">
										<input type="submit" id="btnRegister" class="btn" value="Register" />
									</td>
								</tr>

							</table>
						</html:form> 
					</td>
					<td width="6%" valign="middle" align="center" style="color: #bebebe;font-weight: bold;">
						OR
					</td>
					<td width="47%" valign="top">
							<table border="0" width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td bgcolor="#efefef" style="background-color: #efefef;">
										<span style="font-size: 0.95em;font-weight: bold;">Link to existing CoMeT account</span>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>
										<html:form action="/youraccount">
											<table border="0" width="100%" cellpadding="0" cellspacing="0">
					
												<logic:present name="LoginError">
												<tr>
													<td colspan="3" style="font-size: 0.75em;color: red;font-weight: bold;" >
															<bean:write name="LoginError" property="errorDescription" />
													</td>
												</tr>
												</logic:present>
										
												<tr>
													<td width="25%" style="font-size: 0.75em;font-weight: bold;">
														Email Address:
													</td>
													<td><html:text style="font-size: 0.75em;" property="userEmail" size="30" /></td>
													<td style="font-size: 0.75em;color: red;"><html:errors property="userEmail"/></td>
												</tr>
												<tr>
													<td width="25%" style="font-size: 0.75em;font-weight: bold;">
														Password:
													</td>
													<td><html:password style="font-size: 0.75em;" property="password" size="30" /></td>
													<td style="font-size: 0.75em;color: red;"><html:errors property="password"/></td>
												</tr>
												<tr>
													<td colspan="3">&nbsp;</td>
												</tr>
												<tr>
													<td align="right">
														<input id="btnLogin" class="btn" type="submit" value="Login" />
													</td>
													<td colspan="2">&nbsp;<html:link style="font-size: 0.75em;" forward="aaa.registration.register">New User?</html:link>
													&nbsp;&nbsp;<html:link style="font-size: 0.75em;" forward="aaa.authentication.lostpassword">Lost Password</html:link></td>
												</tr>
			
											</table>
										</html:form> 
									</td>
								</tr>
							</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table> 
 