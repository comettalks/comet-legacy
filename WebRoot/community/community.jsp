<%@ page language="java"%>
<%@ page import="edu.pitt.sis.beans.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


<logic:notPresent name="UserSession">
<% 
	String pagePath = "community.do";
	
	if(request.getQueryString()!=null){
		pagePath += "?" + request.getQueryString();
	} 
	session.setAttribute("before-login-redirect", pagePath);
%>
</logic:notPresent>
<% 
	String comm_id = (String)request.getParameter("comm_id");
	if(comm_id == null){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="2">
			<table>
				<tr>
					<td width="10%">
						<input type="button" class="btn" onclick="window.location='PreMakeCommunity.do'" value="Create New Group"></input>
					</td>
					<td style="color: green;font-weight: bold;text-align: center;font-size: 0.8em;">
<% 
	String DeleteGroup = (String)session.getAttribute("DeleteGroup");
	out.print(DeleteGroup==null?"&nbsp;":"The Group: " + DeleteGroup + " was deleted successfully.");
	session.removeAttribute("DeleteGroup");
%>							
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td width="50%" valign="top" style="padding-right: 1px;">
			<tiles:insert template="/utils/recentCommunity.jsp" />
		</td>
		<td width="50%" valign="top" style="padding-left: 1px;">
			<tiles:insert template="/utils/popCommunity.jsp" />
		</td>
	</tr>
</table>
<% 
	}else{
		connectDB conn = new connectDB();
		String sql = "SELECT comm_name,comm_desc FROM community WHERE comm_id = " + comm_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String comm_name = rs.getString("comm_name");
			String comm_desc = rs.getString("comm_desc");
%>
<script type="text/javascript">
<!--
	var aTitle = "CoMeT | Group: ";
	aTitle = aTitle.concat('<%=comm_name%>');
	window.setTimeout(function(){document.title=aTitle;},50);	
//-->
</script>
 <table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="4" width="100%" align="left" style="color: #003399;font-weight: bold;font-size: 0.95em;">
			Group: <%=comm_name%>&nbsp;
			<logic:present name="UserSession">
<% 
			UserBean ub = (UserBean)session.getAttribute("UserSession");
			sql = "SELECT user_id FROM final_member_community WHERE user_id=" + ub.getUserID() +
					" AND comm_id=" + comm_id;
			ResultSet rsExt = conn.getResultSet(sql);
			boolean membered = false;
			if(rsExt.next()){
				membered = true;
			}
			boolean subscribed = false;
			if(membered){
				sql = "SELECT user_id FROM final_subscribe_community WHERE user_id=" + ub.getUserID() +
						" AND comm_id=" + comm_id;
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					subscribed = true;
				}
			}
%>	
				<span class="spanmemcid<%=comm_id %>" id="spanmemrcid<%=comm_id %>" 
					style="display: <%=!membered?"none":"inline" %>;cursor: pointer;background-color: Khaki;font-weight: bold;color: white;"
					onclick="window.location='community.do?comm_id=<%=comm_id %>'"
					><%=membered?"&nbsp;Joined&nbsp;":"" %></span>
				&nbsp;
				<span class="subspanmemcid<%=comm_id %> spansubcid<%=comm_id %>" 
					style="display: <%=!subscribed?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
					onclick="window.location='community.do?comm_id=<%=comm_id %>'"
					><%=subscribed?"&nbsp;Subscribed&nbsp;":"" %></span>
				&nbsp;
				<input class="btn" type="button" value="<%=membered?"Leave":"Join" %>"
					onclick="joinCommunity(<%=ub.getUserID() %>,<%=comm_id %>,this,'spanmemrcid<%=comm_id %>');" />
				<span class="subspanmemcid<%=comm_id %>"
					style="display: <%=!membered?"none":"inline" %>;"
					>
					&nbsp;
					<input class="btn" type="button" value="<%=subscribed?"Unsubscribe":"Subscribe" %>"
						onclick="subscribeCommunity(<%=ub.getUserID() %>,<%=comm_id %>,this,'spansubcid<%=comm_id %>');" />
				</span>
			</logic:present>	
		</td>
		<td  align="right">
			<input class="btn" type="button" 
				onclick="document.location='PreMakeCommunity.do?comm_id=<%=comm_id%>'" value="Edit" />
		</td>
	</tr>
	<tr>
		<td colspan="5" style='color: black;font-weight: normal;font-size: 0.75em;'>
			<%=comm_desc %>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="left" valign="top" width="690">
			<div id="divMain">
				<tiles:insert template="/includes/bookmarks.jsp" />			
			</div>
        </td>
		<td colspan="2" align="right" valign="top" width="90"> 		
			<br/>
			<div id="divFeed">
				<tiles:insert template="/utils/feed.jsp" />
			</div>
			<logic:present name="UserSession">
				<br/>
				<div id="divTag">
					<tiles:insert template="/utils/tagCloud.jsp" />
				</div>
				<br/>
				<div id="divFacet">
					<tiles:insert template="/utils/namedEntity.jsp" />
				</div>
			</logic:present>
        </td>
	</tr>
</table>
<%		
			rs.close();
			rs = null;
			conn.conn.close();
			conn = null;
		}else{
%>
<span style="font-size: 0.75em;font-weight: bold;">Community Not Found</span>
<%		
		}
	}
%>
