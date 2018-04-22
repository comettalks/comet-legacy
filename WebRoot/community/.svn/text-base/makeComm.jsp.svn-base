
<%@ page language="java" pageEncoding="UTF-8"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%><logic:notPresent name="UserSession">
	<script type="text/javascript">
		window.location = "login.do";
	</script>
</logic:notPresent>
<logic:present name="makeComm">
	<div style="font-size: 0.8em;font-weight: bold;color: green;">Create your group successful!</div>
	<div style="font-size: 0.8em;">
		Questions can be directed to CoMeT via email at 
		<a href="mailto:comet.paws@gmail.com">comet.paws@gmail.com</a>.
	</div>
<%-- 
	<html:link style="font-size: 0.75em;" forward="aaa.pre.make.community">Create New Group</html:link>
--%>
</logic:present>

<logic:notPresent name="makeComm">
<% 
	session=request.getSession(false);
	connectDB conn = new connectDB();
	String sql = "SELECT comm_id,comm_name,comm_desc FROM community WHERE comm_id = " + request.getParameter("comm_id");
	ResultSet rs = conn.getResultSet(sql);
	String comm_id = "0";
	String comm_name = "";
	String comm_desc = "";
	if(rs.next()){
		comm_id = rs.getString("comm_id");
		comm_name = rs.getString("comm_name");
		comm_desc = rs.getString("comm_desc");
	}	
%>
	<html:form action="/PostNewCommunity" method="POST">
		<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center" style="font-size: 0.85em;">
			<tr>
				<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
			</tr>
			<tr>
				<td colspan="2" bgcolor="#efefef">
					<b><%=comm_id=="0"?"Create New":"Update" %> Group</b>
				</td>
			</tr>
			<tr>
				<td width="10%" align="left">
						Group Name
				</td>
				<td align="left">
					<html:text maxlength="200" property="name" size="100" value="<%=comm_name %>" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="name" /></td>
			</tr>
			<tr>
				<td width="10%" align="left" valign="top">
					Description
				</td>
				<td align="left">
					<html:textarea property="description" rows="10" cols="80" value="<%=comm_desc %>"></html:textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="description" /></td>
			</tr>
			<tr>
				<td>
					<input name="comm_id" type="hidden" value="<%=comm_id %>" /><input type="submit" class="btn" name="btnSubmit" value="Submit" />
				</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</html:form> 
</logic:notPresent>
	