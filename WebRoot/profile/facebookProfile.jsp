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
	String fAutoID = (String)request.getParameter("fAutoID");
	if(fAutoID==null&&ub==null){
%>
	
<script type="text/javascript">
		window.setTimeout(function(){window.location="login.do";},50);
</script>
<%		
	}else{
		connectDB conn = new connectDB();
		ResultSet rs;
		String sql;
		
		if(fAutoID!=null){
			sql = "SELECT MAX(ext_id) fAutoID FROM extmapping WHERE user_id=" + ub.getUserID() + " AND exttable='extprofile.facebook'";
			rs = conn.getResultSet(sql);
			if(rs.next()){
				long _fAutoID = rs.getLong("fAutoID");
				if(Long.parseLong(fAutoID) > _fAutoID){
					sql = "INSERT INTO extmapping (user_id,ext_id,exttable,mappedtime) VALUES (" + ub.getUserID() + "," + _fAutoID + ",'extprofile.facebook',NOW())";
					conn.executeUpdate(sql);
				}
			}
		}
		
		sql = "SELECT uid,first_name,middle_name,last_name,pic_square_with_logo,profile_url FROM extprofile.facebook " +
				"WHERE fAutoID = (SELECT MAX(ext_id) fAutoID FROM extmapping WHERE user_id=" + ub.getUserID() + " AND exttable='extprofile.facebook')";
		rs = conn.getResultSet(sql);
		if(rs.next()){
%>
					<table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size: 1em;">
						<tr>
							<td style="width: 100px;text-align: left;" rowspan="3"><a target="_blank" href="<%=rs.getString("profile_url") %>"><img border="0" src="<%=rs.getString("pic_square_with_logo") %>"></img></a></td>
							<td style="width: 80px;">Firstname:</td>
							<td><%=rs.getString("first_name") %></td>
							<td style="text-align: right">
								<a href="javascript: return false;" onclick="showFacebookCrawler('../extprofile/facebook.jsp?appID=1389944597930969&extjs=getExtFBProfile&extTokenID=<%=ub.getUserID() %>&callback=http://<%=request.getServerName() + request.getContextPath() + "/utils/postExternalProfile.jsp"%>');">
									<img alt="update facebook profile" src="images/update_icon.png" border="0">
								</a>
							</td>
						</tr>
<% 
			if(rs.getString("middle_name").trim().length()>0){
%>
						<tr>
							<td style="width: 80px;">Middlename:</td>
							<td colspan="2"><%=rs.getString("middle_name") %></td>
						</tr>
<%							
			}
%>											
						<tr>
							<td style="width: 80px;">Lastname:</td>
							<td colspan="2"><%=rs.getString("last_name") %></td>
						</tr>
					</table>
<%						
		}else{
%>
<%-- 
		  			<iframe frameborder="0" scrolling="no" src="../extprofile/facebook.jsp?appID=345817736440&extTokenID=<%=ub.getUserID() %>&callback=http://<%=request.getServerName() + request.getContextPath() + "/utils/postExternalProfile.jsp"%>" style="height: 30px;width: 400px;"></iframe>
--%>
		  			<iframe frameborder="0" scrolling="no" src="../extprofile/facebook.jsp?appID=1389944597930969&extjs=getExtFBProfile&extTokenID=<%=ub.getUserID() %>&callback=http://<%=request.getServerName() + request.getContextPath() + "/utils/postExternalProfile.jsp"%>" style="height: 30px;width: 400px;"></iframe>
<%
		}
	}
%>
