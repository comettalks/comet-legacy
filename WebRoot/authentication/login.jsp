<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<logic:present name="RegisterSuccess">
		<tr>
			<td style="font-weight: bold;font-size: 0.85em;color:#003399;">		
				Sign Up Successful!!!
			</td>
		</tr>
		</logic:present>

		<tr>
			<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.95em;font-weight: bold;">
				Login
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="47%">
							<table border="0" width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td bgcolor="#efefef" style="background-color: #efefef;">
										<span style="font-size: 0.95em;font-weight: bold;">Login or signup</span> <span style="font-size: 0.65em;color: #ff0000;">recommended</span>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>
										 <iframe src="http://washington.rpxnow.com/openid/embed?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do" 
										 	scrolling="no"  frameBorder="no"  allowtransparency="true"  style="width:400px;height:240px"></iframe> 
									</td>
								</tr>
							</table>
						</td>
						<td width="6%" valign="middle" align="center" style="color: #bebebe;">
							OR
						</td>
						<td width="47%" valign="top">
							<html:form action="/youraccount" method="post">
								<table border="0" width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
									</tr>
									<tr>
										<td colspan="3" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.95em;font-weight: bold;">
											Login using a CoMeT account
										</td>
									</tr>
								
									<tr>
										<td colspan="3">&nbsp;</td>
									</tr>
		
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
											<input id="btnSignin" class="btn" type="submit" value="Sign in" />
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