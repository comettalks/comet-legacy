<%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<authentication>");
	session.removeAttribute("UserSession");
	out.print("<status>OK</status>");	
	out.print("<message>Logout successful</message>");	
	out.print("</authentication>");
%>