<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<%
	session=request.getSession(false);	
	String redirect = (String)session.getAttribute("redirect");
	if(redirect != null){
		session.removeAttribute("redirect");
%>
	<script>
		window.location="<%=redirect%>";
	</script>
<%		
	}
%>
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td width="70%" valign="top">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">This Week Events</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/loadTalks.jsp?mostrecent=1"/>
						</td>
					</tr>
				</table>
			</td>			
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<tiles:insert template="/utils/feed.jsp?mostrecent=1"/>
						</td>
					</tr>
<%--					
					<tr>
						<td>
							<tiles:insert template="/utils/tagCloud.jsp"/>
						</td>
					</tr>
--%>
					<tr>
						<td>
							<tiles:insert template="/utils/popAnnotatedTalk.jsp?rows=5"/>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/popCommunity.jsp?rows=5"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<%-- 
		<tr>
			<td width="30%" valign="top">				
				<tiles:insert template="/utils/recentAnnotatedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/recentViewedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/tagCloud.jsp?rows=20"/>
			</td>
		</tr>
		<tr>
			<td colspan="5">&nbsp;</td>
		</tr>
		<tr>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/popAnnotatedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/popViewedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/popCommunity.jsp?rows=5"/>
			</td>
		</tr>
--%>
	</table>
