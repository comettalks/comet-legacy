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
	String profile_id = (String)request.getParameter("profile_id");
	if(profile_id==null&&ub==null){
%>
	
<script type="text/javascript">
		window.setTimeout(function(){window.location="login.do";},50);
</script>
<%		
	}else{
		connectDB conn = new connectDB();
		ResultSet rs;
		String sql;
		
		if(profile_id!=null){
			sql = "SELECT ext_id FROM extmapping WHERE user_id=" + ub.getUserID() + " AND exttable='extprofile.mendeley'";
			rs = conn.getResultSet(sql);
			if(rs.next()){
				String ext_id = rs.getString("ext_id");
				if(ext_id == null){
					sql = "INSERT INTO extmapping (user_id,ext_id,exttable,mappedtime) VALUES (" + ub.getUserID() + "," + profile_id + ",'extprofile.mendeley',NOW())";
					conn.executeUpdate(sql);
				}
			}
		}
		
		sql = "SELECT m.profile_id,m.name,m.photo,m.profileURL,m.title,m.researchField FROM extprofile.mendeley_profile m " +
				"JOIN extmapping e ON m.profile_id=e.ext_id WHERE e.user_id=" + ub.getUserID() + " AND e.exttable='extprofile.mendeley'";
		rs = conn.getResultSet(sql);
		if(rs.next()){
%>
					<table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size: 1em;">
						<tr>
							<td style="width: 100px;text-align: left;" rowspan="3"><a target="_blank" href="<%=rs.getString("profileURL") %>"><img border="0" src="<%=rs.getString("photo") %>"></img></a></td>
							<td style="width: 100px;"> Name:</td>
							<td><%=rs.getString("name") %></td>
							<td style="text-align: right">
								<a href="javascript: return false;" onclick="showMendeleyCrawler('../extprofile/mendeley.jsp?extjs=getExtMDProfile&extTokenID=<%=ub.getUserID() %>&callback=http://<%=request.getServerName() + request.getContextPath() + "/utils/postExternalProfile.jsp"%>');">
									<img alt="update mendeley profile" src="images/update_icon.png" border="0">
								</a>
							</td>
						</tr>
<% 
			if(rs.getString("title") != null){
%>
						<tr>
							<td style="width: 100px;"> Title:</td>
							<td colspan="2"><%=rs.getString("title") %></td>
						</tr>
<%							
			}
			if(rs.getString("researchField") != null){
%>											
						<tr>
							<td style="width: 100px;vertical-align: top;"> Research Field:</td>
							<td colspan="2" style="vertical-align: top;"><%=rs.getString("researchField") %></td>
						</tr>
<%							
			}
%>
					</table>
<%						
		}else{
%>
		  			<iframe frameborder="0" scrolling="no" 
		  				src="../extprofile/mendeley.jsp?extjs=getExtMDProfile&extTokenID=<%=ub.getUserID() %>&callback=http://<%=request.getServerName() + request.getContextPath() + "/utils/postExternalProfile.jsp"%>" 
		  				 style="height: 400px;width: 600px;"></iframe>
<%
		}
	}
%>
