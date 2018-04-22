<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
<html>
 	<head>  	
    	<title>
    		<tiles:getAsString name="title"/>
	    </title>
		<tiles:importAttribute name="title"/>
	</head>
<body topmargin="0">
	<div align="left">
		<table width="1000" border="0" cellpadding="0" cellspacing="0" bordercolor="black">
			<tr>
				<td colspan="3">
					<tiles:insert attribute="header">
						<tiles:put name="title" beanName="title" direct="true"/>
					</tiles:insert>
				</td>
			</tr>
			<tr>
				<td valign="top" bgcolor="#EEEEEE" width="90">		
					<tiles:insert attribute="sidebar" />	
				</td>     
				<td align="left" valign="top" width="600"> 		
					<tiles:insert attribute="mainwindow"/>
		        </td>
				<td width="90" align="left">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3">
					<tiles:insert attribute="footer"/>			
				</td>
			</tr>
		</table>				
	</div>				
</body>
</html>
