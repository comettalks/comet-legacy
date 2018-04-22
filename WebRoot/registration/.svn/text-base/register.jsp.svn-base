<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


<html:form action="/registration" method="post">
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td width="85%" colspan="3" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.95em;font-weight: bold;">
				Signup
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>

		<logic:present name="RegisterError">
		<tr>
			<td colspan="3">		
				<font class="error">
					<b><bean:write name="RegisterError" property="errorDescription" /></b>
				</font>
			</td>
		</tr>
		</logic:present>

		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">Screen Name:</td>
			<td><html:text style="font-size: 0.75em;" property="name" size="30" /></td>
			<td style="font-size: 0.75em;color: red;font-weight: bold;""><html:errors property="name" /></td>
		</tr>
		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">E-Mail Address:</td>
			<td><html:text style="font-size: 0.75em;" property="userEmail" size="30" /></td>
			<td style="font-size: 0.75em;color: red;font-weight: bold;"><html:errors property="userEmail"/></td>
		</tr>
		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">Choose a Password:</td>
			<td><html:password style="font-size: 0.75em;" property="password" size="30" /></td>
			<td style="font-size: 0.75em;color: red;font-weight: bold;"><html:errors property="password"/></td>
		</tr>
		<tr>
			<td width="25%" style="font-size: 0.75em;font-weight: bold;">Re-enter Password:</td>
			<td><html:password style="font-size: 0.75em;" property="repassword" size="30" /></td>
			<td style="font-size: 0.75em;color: red;font-weight: bold;"><html:errors property="repassword"/></td>
		</tr>
		<tr>
			<td colspan="3">
				<tiles:insert template="affiliation.jsp" />
			</td>
		</tr>
		<tr>	
			<td colspan="3">
<% 
	//Halley Machine
	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6Ldamb4SAAAAAIOIeAP8KHcnyZ7IZ889Rg0ZyzxT", "6Ldamb4SAAAAAHTCLlHVW2TSPp2Mn-YkByFU5EXB", false);
	//ReCaptcha c = ReCaptchaFactory.newReCaptcha("6Ld4YtsSAAAAAJPwFv9sX5mxKKidxrWIPNIKcBZG", "6Ld4YtsSAAAAAJHYWgHwR9nGH_AK_cTiRPd2khd2", false);
	//Washington Machine
	//ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LfZ6b4SAAAAADmXK0NFuzK98qbk6p0Ta3xUfdO5", "6LfZ6b4SAAAAABgyEW4S1NiKrZBLR_077NCw_-xz", false);
	out.print(c.createRecaptchaHtml(null, null));
%>
			</td>
		</tr>
		<tr>	
			<td colspan="3" style="font-size: 0.75em;color: red;font-weight: bold;">
				<html:errors property="recaptcha"/>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td width="10%" align="left">
				<input type="submit" id="btnRegister" class="btn" value="Register" />
				&nbsp;
			</td>
			<td colspan="2">&nbsp;<html:link style="font-size: 0.75em;" forward="aaa.authentication.login">Sign in?</html:link></td>
		</tr>
	</table>
</html:form> 
