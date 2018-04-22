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


<% 
	String tag_id = (String)request.getParameter("tag_id");
	int affiliate_id = -1;
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(tag_id == null){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td>
			<tiles:insert template="/utils/tagCloud.jsp" />
		</td>
	</tr>
</table>
<% 
	}else{
		connectDB conn = new connectDB();
		String sql = "SELECT tag FROM tag WHERE tag_id = " + tag_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String tag = rs.getString("tag");
%>
<script type="text/javascript">
<!--
	var aTitle = "CoMeT | Tag: ";
	aTitle = aTitle.concat('<%=tag%>');
	window.setTimeout(function(){document.title=aTitle;},50);	
//-->
</script>
 <table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Tag: <%=tag%>
		</td>
	</tr>
	<tr>
		<td align="left" valign="top" width="690">
			<div id="divMain">
				<tiles:insert template="/includes/bookmarks.jsp" />			
			</div>
        </td>
		<td align="right" valign="top" width="90"> 		
			<br/>
			<div id="divFeed">
				<tiles:insert template="/utils/feed.jsp" />
			</div>

			<div id="divTag">
				<tiles:insert template="/utils/tagCloud.jsp" />
			</div>
<%-- 
			<div id="divFacet">
				<tiles:insert template="/utils/namedEntity.jsp" />
			</div>
--%>
        </td>
	</tr>
</table>
<%		
		conn.conn.close();
		conn = null;
		}else{
%>
<span style="font-size: 0.95em;font-weight: bold;">Tag Not Found</span>
<%		
		}
	}
%>
