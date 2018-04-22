
<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<html>
 	<head>  	
  		<link rel="CoMeT Icon" href="images/favicon.ico" />
    	<title>
    		<tiles:getAsString name="title"/>
	    </title>
		<tiles:importAttribute name="title"/>
	</head>
<body topmargin="0">
	<div align="center">
		<table width="1000" border="0" cellpadding="0" cellspacing="0" bordercolor="#0080ff">
			<tr>
				<td>
					<tiles:insert attribute="header">
						<tiles:put name="title" beanName="title" direct="true"/>
					</tiles:insert>
				</td>
			</tr>
			<tr>
				<td>
					<tiles:insert attribute="mainwindow"/>
				</td>
			</tr>
			<tr>
				<td>
					<tiles:insert attribute="footer"/>			
				</td>
			</tr>
		</table>
	</div>				

</body>
</html>
