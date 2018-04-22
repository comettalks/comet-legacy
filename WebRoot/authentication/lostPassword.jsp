<%@ page language="java"%>
<%@page import="edu.pitt.sis.StringEncrypter"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="edu.pitt.sis.BasicFunctions"%>
<%@page import="edu.pitt.sis.MailNotifier"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	if(request.getParameter("submitForgotEmail") == null){
%>
<form method="post" action="lostPassword.do">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td style="font-weight: bold;" colspan="2">To recover your password, please enter your email.</td>
		</tr>
		<tr>
			<td align="left" width="60">E-mail:</td>
			<td><input type="text" maxlength="100" width="100" name="email" />&nbsp;<input name="submitForgotEmail" type="submit" value="Submit" /></td>
		</tr>
	</table>
</form>
<%	
	}else{
		String[] requst_email = new String[1]; 
		requst_email[0] = request.getParameter("email");
		String encryptionScheme = StringEncrypter.DESEDE_ENCRYPTION_SCHEME;		
		StringEncrypter encrypter;
		String DecryptedPassword = "";
		String EncryptedPassword = "";
		String name = "";
		
		String sql = "SELECT Pass,name FROM userinfo WHERE TRIM(LOWER(Email)) = '"+ 
						requst_email[0].replaceAll("'", "''").trim().toLowerCase() + "'";
		connectDB conn = new connectDB();

		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			EncryptedPassword = rs.getString("Pass");
			name = rs.getString("name");
		}else{
%>
	<p style="color: red;font-size: 1.5em;">Your Email Does Not Exist in The Database. Please Sign Up.</p>
<%
			return;
		}
	
		try {
			encrypter = new StringEncrypter(encryptionScheme, BasicFunctions.encKey);
			DecryptedPassword = encrypter.decrypt(EncryptedPassword);
		} catch (StringEncrypter.EncryptionException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
%>
	<p style="color: red;font-weight: bold;">Requesting Password was Error. Please Try Again.</p>
<%
			return;
		}
		
		String localhost= "halley.exp.sis.pitt.edu";
		String mailhost= "smtp.gmail.com";
		String mailuser= "NoReply";
		MailNotifier mail = new MailNotifier(localhost,mailhost,mailuser,requst_email);
		String emailContent = "Dear " + name + "\n\n" +
		"This automated e-mail is from the CoMeT System:\n\n" + 
		"Your password is " + DecryptedPassword + "\n\n" +
		"CoMeT Website: http://pittcomet.info/ ";
		
		try {
			mail.send("Lost Password | CoMeT", emailContent);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		conn.conn.close();
		conn = null;
%>
	<p style="font-size: 1.5em;">Your password will be sent to your inbox shortly.</p>
<%
	}
%>
