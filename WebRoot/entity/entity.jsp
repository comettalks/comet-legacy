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

<table cellspacing="0" cellpadding="0" width="100%" align="center">
<% 
	String queryString = request.getQueryString();
	String[] param_value = queryString.split("&");
	String[] entity_id_value = request.getParameterValues("entity_id");
	String[] type_value = request.getParameterValues("_type");
	if(entity_id_value == null && type_value == null){
%>
	<tr>
		<td valign="top">
			<tiles:insert template="/utils/namedEntity.jsp" />
		</td>
	</tr>
<% 
	}else{
		connectDB conn = new connectDB();
		String aTitle = "CoMeT | Entity Browsing |";
		int tag_id = 0;
		int col_id = 0;
		int user_id = 0;
		int comm_id = 0;
		int series_id = 0;
		int affiliate_id = -1;
		if(request.getParameter("tag_id")!=null){
			tag_id = Integer.parseInt((String)request.getParameter("tag_id"));
			String sql = "SELECT tag FROM tag WHERE tag_id =" + tag_id;
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String tag = rs.getString("tag");
				aTitle += " Tag: "  + tag;
				String newQueryString = "";
				if(param_value != null){
					for(int i=0;i<param_value.length;i++){
						if(!param_value[i].equalsIgnoreCase("tag_id=" + tag_id)){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param_value[i];
						}
					}
				}
%>
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Tag: <%=tag%>
<%
				if(newQueryString.length() > 0){
					if(newQueryString.indexOf("entity_id") >= 0 || newQueryString.indexOf("_type") >= 0){
%>
			<a href="entity.do?<%=newQueryString%>"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
<%
					}
				}
%>
		</td>
	</tr>
<% 
			}
		}	
		if(request.getParameter("col_id") != null){
			col_id = Integer.parseInt((String)request.getParameter("col_id"));
		}
		if(request.getParameter("user_id") != null){
			user_id = Integer.parseInt((String)request.getParameter("user_id"));
			String sql = "SELECT name FROM userinfo WHERE user_id =" + user_id;
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String name = rs.getString("name");
				aTitle += " User: "  + name;
				String newQueryString = "";
				if(param_value != null){
					for(int i=0;i<param_value.length;i++){
						if(!param_value[i].equalsIgnoreCase("user_id=" + user_id)){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param_value[i];
						}
					}
				}
%>
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			User: <%=name%>
<%
				if(newQueryString.length() > 0){
					if(newQueryString.indexOf("entity_id") >= 0 || newQueryString.indexOf("_type") >= 0){
%>
			<a href="entity.do?<%=newQueryString%>"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
<%
					}
				}
%>
		</td>
	</tr>
<% 
			}
		}
		if(request.getParameter("comm_id") != null){
			comm_id = Integer.parseInt((String)request.getParameter("comm_id"));
			String sql = "SELECT comm_name FROM community WHERE comm_id =" + comm_id;
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String comm_name = rs.getString("comm_name");
				aTitle += " Community: "  + comm_name;
				String newQueryString = "";
				if(param_value != null){
					for(int i=0;i<param_value.length;i++){
						if(!param_value[i].equalsIgnoreCase("comm_id=" + comm_id)){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param_value[i];
						}
					}
				}
%>
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Community: <%=comm_name%>
<%
				if(newQueryString.length() > 0){
					if(newQueryString.indexOf("entity_id") >= 0 || newQueryString.indexOf("_type") >= 0){
%>
			<a href="entity.do?<%=newQueryString%>"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
<%
					}
				}
%>
		</td>
	</tr>
<% 
			}
		}
		if(request.getParameter("series_id") != null){
			series_id = Integer.parseInt((String)request.getParameter("series_id"));
			String sql = "SELECT name FROM series WHERE series_id =" + series_id;
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String name = rs.getString("name");
				aTitle += " Series: "  + name;
				String newQueryString = "";
				if(param_value != null){
					for(int i=0;i<param_value.length;i++){
						if(!param_value[i].equalsIgnoreCase("series_id=" + series_id)){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param_value[i];
						}
					}
				}
%>
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Series: <%=name%>
<%
				if(newQueryString.length() > 0){
					if(newQueryString.indexOf("entity_id") >= 0 || newQueryString.indexOf("_type") >= 0){
%>
			<a href="entity.do?<%=newQueryString%>"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
<%
					}
				}
%>
		</td>
	</tr>
<% 
			}
		}
		if(request.getParameter("affiliate_id") != null){
			affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
			String sql = "SELECT affiliate FROM affiliate WHERE affiliate_id =" + affiliate_id;
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				String affiliate = rs.getString("affiliate");
				aTitle += " Sponsor: "  + affiliate;
				String newQueryString = "";
				if(param_value != null){
					for(int i=0;i<param_value.length;i++){
						if(!param_value[i].equalsIgnoreCase("affiliate_id=" + affiliate_id)){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param_value[i];
						}
					}
				}
%>
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Sponsor: <%=affiliate%>
<%
				if(newQueryString.length() > 0){
					if(newQueryString.indexOf("entity_id") >= 0 || newQueryString.indexOf("_type") >= 0){
%>
			<a href="entity.do?<%=newQueryString%>"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
<%
					}
				}
%>
		</td>
	</tr>
<% 
			}
		}

		String entity_id_list = "";
		if(entity_id_value!=null){
			for(int i=0;i<entity_id_value.length;i++){
				if(i!=0)entity_id_list+=",";
				entity_id_list+=entity_id_value[i];
			}
			String sql = "SELECT entity_id,entity,normalized FROM entity WHERE entity_id IN (" + entity_id_list + ")";
			ResultSet rs = conn.getResultSet(sql);
			while(rs.next()){
				String entity_id = rs.getString("entity_id");
				String entity = rs.getString("entity");
				String normalized = rs.getString("normalized");
				if(normalized != null){
					if(normalized.length() > 0){
						entity = normalized;
					}
				}
				aTitle += " Entity: "  + entity;
				String newQueryString = "";
				if(param_value != null){
					for(int i=0;i<param_value.length;i++){
						if(!param_value[i].equalsIgnoreCase("entity_id=" + entity_id)){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param_value[i];
						}
					}
				}
%>
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Entity: <%=entity%>
<%
				if(newQueryString.length() > 0){
					if(newQueryString.indexOf("entity_id") >= 0 || newQueryString.indexOf("_type") >= 0){
%>
			<a href="entity.do?<%=newQueryString%>"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
<%
					}
				}
%>
		</td>
	</tr>
<% 
			}
			conn.conn.close();
			conn = null;
		}
		if(type_value!=null){
			for(int i=0;i<type_value.length;i++){
				aTitle += " Entity Type: "  + type_value[i];
				String newQueryString = "";
				if(param_value != null){
					for(int j=0;j<param_value.length;j++){
						if(!param_value[j].equalsIgnoreCase("_type=" + type_value[i])){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param_value[j];
						}
					}
				}
%>
	<tr>
		<td colspan="2" align="left" style="color: #003399;font-weight: bold;font-size: 0.9em;">
			Entity Type: <%=type_value[i]%>
<%
				if(newQueryString.length() > 0){
					if(newQueryString.indexOf("entity_id") >= 0 || newQueryString.indexOf("_type") >= 0){
%>
			<a href="entity.do?<%=newQueryString%>"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
<%
					}
				}
%>
		</td>
	</tr>
<%				
			}
		}
%>
<script type="text/javascript">
<!--
	var aTitle = "<%=aTitle%>";
	window.setTimeout(function(){document.title=aTitle;},50);	
//-->
</script>
	<tr>
		<td align="left" valign="top" width="650">
			<div id="divMain">
				<tiles:insert template="/includes/bookmarks.jsp" />			
			</div>
        </td>
		<td align="right" valign="top" width="130">
			<br/>
			<div id="divFeed">
				<tiles:insert template="/utils/feed.jsp" />
			</div> 
			<div id="divTag">
				<tiles:insert template="/utils/tagCloud.jsp" />
			</div> 
			<div id="divEntity">
				<tiles:insert template="/utils/namedEntity.jsp" />
			</div>
        </td>
	</tr>
<%
	}		
%>
</table>
