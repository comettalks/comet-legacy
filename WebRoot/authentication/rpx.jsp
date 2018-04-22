<%@page import="java.util.Map"%><%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="org.w3c.dom.NodeList"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.w3c.dom.Element"%><%@page import="edu.pitt.sis.Rpx"%>
<%@page import="java.io.IOException"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
	
<%
	/**
	 * The RPX base URL.
	*/	
	final String RPX_BASEURL = "https://rpxnow.com";  
	
	/**
	 * Your secret API code.
	 */	
	final String RPX_APIKEY = "3402b121cffb98806313db238f8cb3686f88cb9c";

	try{		

		String rpxToken = request.getParameter("token");
	    Rpx rpx = new Rpx(RPX_APIKEY,RPX_BASEURL);
		
	    Element rpxAuth = rpx.authInfo(rpxToken);
		// Check if authentication failed.
	    String stat = rpxAuth.getAttribute("stat");
	    if (!"ok".equals(stat)) {
	        String error = "User authentication failed";
	        try {
				response.sendError(HttpServletResponse.SC_FORBIDDEN, error);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
%>
<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" style="font-size: 0.95em;color: red;font-weight: bold;"><%=error%></td>
	</tr>
</table>
<%
	    }else{
		// Generate a map of the profile attributes.
	    Map<String, String> openIdMap = new HashMap<String, String>();
	    Node profile = rpxAuth.getFirstChild();
	    NodeList profileFields = profile.getChildNodes();
	    for(int k = 0; k < profileFields.getLength(); k++) {
	        Node n = profileFields.item(k);
	        if (n.hasChildNodes()) {
	            NodeList nFields = n.getChildNodes();
	            for (int j = 0; j < nFields.getLength(); j++) {
	                Node nn = nFields.item(j);
	                String nodename = n.getNodeName();
	                if (!nn.getNodeName().startsWith("#"))
	                    nodename += "." + nn.getNodeName();
	                openIdMap.put(nodename, nn.getTextContent());
	            }

	        } else
	            openIdMap.put(n.getNodeName(), n.getTextContent());
	    }

		// Now openIdMap contains a hash map of all the profile fields we got back.
		//String openid = openIdMap.get("identifier");
		String username = openIdMap.get("preferredUsername");
		// Nested elements can be accessed with the full path:
		//String name = openIdMap.get("name.formatted");
	    String email = openIdMap.get("email");
	    session.setAttribute("rpx",rpx);
	    session.setAttribute("openIdMap",openIdMap);
	    
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
<%	    
	    }
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
%>
<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" style="font-size: 0.95em;color: red;font-weight: bold;">User authentication failed</td>
	</tr>
</table>
<%
	}
%>
 