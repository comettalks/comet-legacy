
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
		<script type="text/javascript">
		</script>
	</head>
<body topmargin="0">
	<div align="center">
		<table width="1000" border="0" cellpadding="0" cellspacing="0" bordercolor="black">
			<tr>
				<td align="left" valign="top" colspan="2"> 		
					<tiles:insert attribute="header">
						<tiles:put name="title" beanName="title" direct="true"/>
					</tiles:insert>
				</td>
			</tr>
			<tr>
				<td align="left" valign="top" width="850">
					<div id="divMain">
						<tiles:insert attribute="mainwindow"/>
					</div>
		        </td>
				<td align="right" valign="top" width="150"> 		
					<div id="divCal">
						<tiles:insert attribute="rightsidebar"/>
					</div>
<%-- 
					<logic:present name="UserSession">
						<div id="divExtension">&nbsp;</div>
					</logic:present>
--%>
		        </td>
			</tr>
			<tr>
				<td colspan="2">
					<tiles:insert attribute="footer"/>			
				</td>
			</tr>
		</table>				
	</div>				
</body>
</html>
