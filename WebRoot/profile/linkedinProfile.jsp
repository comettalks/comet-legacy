<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%>

<% 
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String lAutoID = (String)request.getParameter("lAutoID");
	if(lAutoID==null&&ub==null){
%>
	
<script type="text/javascript">
		window.setTimeout(function(){window.location="login.do";},50);
</script>
<%		
	}else{
		connectDB conn = new connectDB();
		ResultSet rs;
		String sql;
		
		if(lAutoID!=null){
			sql = "SELECT MAX(ext_id) lAutoID FROM extmapping WHERE user_id=" + ub.getUserID() + " AND exttable='extprofile.linkedin'";
			rs = conn.getResultSet(sql);
			if(rs.next()){
				long _lAutoID = rs.getLong("lAutoID");
				if(Long.parseLong(lAutoID) > _lAutoID){
					sql = "INSERT INTO extmapping (user_id,ext_id,exttable,mappedtime) VALUES (" + ub.getUserID() + "," + _lAutoID + ",'extprofile.linkedin',NOW())";
					conn.executeUpdate(sql);
				}
			}
		}
		
		sql = "SELECT firstname,lastname,headline,pictureurl,siteprofileurl FROM extprofile.linkedin " +
				"WHERE lAutoID = (SELECT MAX(ext_id) lAutoID FROM extmapping WHERE user_id=" + ub.getUserID() + " AND exttable='extprofile.linkedin')";
		rs = conn.getResultSet(sql);
		if(rs.next()){
%>
					<table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size: 1em;">
						<tr>
							<td style="width: 100px;text-align: left;" rowspan="3"><a target="_blank" href="<%=rs.getString("siteprofileurl") %>"><img border="0" src="<%=rs.getString("pictureurl") %>"></img></a></td>
							<td style="width: 80px;">Firstname:</td>
							<td><%=rs.getString("firstname") %></td>
							<td style="text-align: right">
								<a href="javascript: return false;" onclick="showLinkedInCrawler('../extprofile/linkedin.jsp?appID=O9aW2MKcw2Uwv42xuFnfBywwYQ4oSdAkBL7NtNyCYUktF7v0Jcs8uKwmqSDOnxl8&extjs=getExtInProfile&extTokenID=<%=ub.getUserID() %>&callback=http://<%=request.getServerName() + request.getContextPath() + "/utils/postExternalProfile.jsp"%>');">
									<img alt="update linkedin profile" src="images/update_icon.png" border="0">
								</a>
							</td>
						</tr>
						<tr>
							<td style="width: 80px;">Lastname:</td>
							<td colspan="2"><%=rs.getString("lastname") %></td>
						</tr>
						<tr valign="top">
							<td style="width: 80px;">Headline:</td>
							<td colspan="2"><%=rs.getString("headline") %></td>
						</tr>
					</table>
<%						
		}else{
%>
<%-- 
		  			<iframe frameborder="0" scrolling="no" src="utils/linkedin.html" style="height: 30px;width: auto;"></iframe>
--%>
		  			<iframe frameborder="0" scrolling="no" src="../extprofile/linkedin.jsp?appID=O9aW2MKcw2Uwv42xuFnfBywwYQ4oSdAkBL7NtNyCYUktF7v0Jcs8uKwmqSDOnxl8&extjs=getExtInProfile&extTokenID=<%=ub.getUserID() %>&callback=http://<%=request.getServerName() + request.getContextPath() + "/utils/postExternalProfile.jsp"%>" style="height: 30px;width: 400px;"></iframe>
<%						
		}
	}
%>
