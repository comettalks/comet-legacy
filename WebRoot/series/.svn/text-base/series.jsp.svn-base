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
	session.setAttribute("before-login-redirect", 
		"series.do" + (request.getQueryString()==null?"":"?" + request.getQueryString()));
%>
</logic:notPresent>
<% 
	String series_id = (String)request.getParameter("series_id");
	if(series_id == null){
%>
<style type='text/css' media='all'>
 ul li{
     list-style-type:none;
     margin:0;
     padding:0;
     margin-left:8px;
 }
</style>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="2">
			<table>
				<tr>
					<td width="10%">
						<input class="btn" type="button" onclick="window.location='PreCreateSeries.do'" value="Create New Series" />
					</td>
					<td style="color: green;font-weight: bold;text-align: center;font-size: 0.8em;">
<% 
	String DeleteSeries = (String)session.getAttribute("DeleteSeries");
	out.print(DeleteSeries==null?"&nbsp;":"The Series: " + DeleteSeries + " was deleted successfully.");
	session.removeAttribute("DeleteSeries");
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
			<tiles:insert template="/utils/recentSeries.jsp" />
		</td>
		<td width="50%" valign="top" style="padding-left: 1px;">
			<tiles:insert template="/utils/popSeries.jsp" />
		</td>
	</tr>
</table>
<% 
	}else{
		session=request.getSession(false);
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		connectDB conn = new connectDB();
		String sql = "SELECT s.name,s.description,s.owner_id,u.name owner,s.url " +
						"FROM series s,userinfo u WHERE s.owner_id = u.user_id AND s.series_id = " + series_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String name = rs.getString("name");
			String description = rs.getString("description");
			String owner_id = rs.getString("owner_id");
			String owner = rs.getString("owner");
			String url = rs.getString("url");

			int subno = 0;
			if(ub != null){
				sql = "SELECT COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
				ResultSet rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					subno = rsExt.getInt("_no");
				}
			}
			
			LinkedHashMap<String, Integer> areaMap = new LinkedHashMap<String, Integer>();
			sql = "SELECT a.area_id,a.area FROM area a JOIN area_series aa ON a.area_id = aa.area_id " +
					"WHERE aa.series_id=" + series_id +
					" ORDER BY a.area";
			rs = conn.getResultSet(sql);
			while(rs.next()){
				String area = rs.getString("area");
				int area_id = rs.getInt("area_id");
				areaMap.put(area, area_id);
			}
%>
<script type="text/javascript">
<!--
	var aTitle = "CoMeT | Series: ";
	aTitle = aTitle.concat('<%=name%>');
	window.setTimeout(function(){document.title = aTitle;},50);	
//-->
</script>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="4" align="left">
			<span style="color: #003399;font-weight: bold;font-size: 0.9em;">
				Series: <%=name%> 
				<span class="spansubsid<%=series_id %>" id="spansubrsid<%=series_id %>" 
					style="display: <%=subno==0?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
					onclick="window.location='series.do?series_id=<%=series_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
				</span>&nbsp;			
			</span>

			<logic:present name="UserSession">
<% 
			/*sql = "SELECT user_id FROM final_subscribe_series WHERE user_id=" + ub.getUserID() +
					" AND series_id=" + series_id;
			ResultSet rsExt = conn.getResultSet(sql);
			boolean subscribed = false;
			if(rsExt.next()){
				subscribed = true;
			}
			
			sql = "SELECT user_id FROM final_like_series WHERE user_id=" + ub.getUserID() +
					" AND series_id=" + series_id;
			rsExt = conn.getResultSet(sql);
			boolean liked = false;
			if(rsExt.next()){
				liked = true;
			}*/
%>	
				<input class="btn" type="button" value="<%=subno>0?"Unsubscribe":"Subscribe" %>"
					onclick="subscribeSeries(<%=ub.getUserID() %>,<%=series_id %>,this,'spansubrsid<%=series_id %>');" />
			</logic:present>	

		</td>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="right">
						<input class="btn" type="button" 
							onclick="document.location='PreCreateSeries.do?series_id=<%=series_id%>'" value="Edit" />
					</td>
<% 
			if(ub != null){
				if(ub.getUserID() == Long.parseLong(owner_id)){
%>
					<td width="1%" align="right">
<%-- 
						<a href="javascript:return false;" 
							onclick="showAddFriendDialog(divDeleteSeries);return false;"
							><img src="images/x.gif" border="0" /></a>
--%>						
						<input class="btn" type="button" 
							onclick="showAddFriendDialog(divDeleteSeries);return false;"
							value="Delete" />
												
						<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
							id="divDeleteSeries">
							<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;">
								<tr>
									<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
										&nbsp;Delete Series: <%=name %>
									</td>
								</tr>
								<tr>
									<td style="border: 1px solid #efefef;">
										<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
											<tr>
												<td colspan="2" style="font-size: 0.75em;padding: 4px;">
													Are you sure to delete the series: <%=name %>?
												</td>
											</tr>
											<tr style="background-color: #efefef;">
												<td align="right" width="85%"><input class="btn" type="button" value="Confirm Delete" onclick="deleteSeries(<%=series_id %>);hideAddFriendDialog(divDeleteSeries);return false;"></input></td>
												<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(divDeleteSeries);return false;"></input></td>
											</tr>
										</table>		
									</td>
								</tr>
							</table>
						</div>
					</td>
<%					
				}
			}
%>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" style="font-size: 0.8em;" width="730">
			Post by <a href="calendar.do?user_id=<%=owner_id %>"><%=owner%></a><br/>
			URL: <a href="<%=url%>"><%=url%></a><br/>
<% 
			if(areaMap.size() > 0){
%>
			Research area<%=areaMap.size() > 1?"s":"" %>:
			<ul>
<% 
				for(String area : areaMap.keySet()){
%>
				<li><%=area %></li>
<%					
				}
%>			
			</ul>
<%				
			}
%>			
			<%=description%>
		</td>
		<td valign="top" width="50">
<%-- 
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<logic:present name="UserSession">
<% 
			sql = "SELECT user_id FROM final_subscribe_series WHERE user_id=" + ub.getUserID() +
					" AND series_id=" + series_id;
			ResultSet rsExt = conn.getResultSet(sql);
			boolean subscribed = false;
			if(rsExt.next()){
				subscribed = true;
			}
			
			sql = "SELECT user_id FROM final_like_series WHERE user_id=" + ub.getUserID() +
					" AND series_id=" + series_id;
			rsExt = conn.getResultSet(sql);
			boolean liked = false;
			if(rsExt.next()){
				liked = true;
			}
%>	
				<tr>
					<td  align="right">
				<input class="btn" type="button" value="<%=liked?"Unlike":"Like" %>"
					onclick="likeSeries(<%=ub.getUserID() %>,<%=series_id %>,this,null);" />
					</td>
				</tr>
				<tr>
					<td  align="right">
						<input class="btn" type="button" value="<%=subscribed?"Unsubscribe":"Subscribe" %>"
							onclick="subscribeSeries(<%=ub.getUserID() %>,<%=series_id %>,this,'spansubrsid<%=series_id %>');" />
					</td>
				</tr>
				</logic:present>	
			</table>
--%>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="left" valign="top" width="650">
			<div id="divMain">
				<tiles:insert template="/includes/bookmarks.jsp" />			
			</div>
        </td>
		<td colspan="2" align="right" valign="top" width="130">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<div id="divFeed">
							<tiles:insert template="/utils/feed.jsp" />
						</div>
					</td>
				</tr>
			<logic:present name="UserSession">
				<tr>
					<td>
						<div id="divTag">
							<tiles:insert template="/utils/tagCloud.jsp" />
						</div>
					</td>
				</tr>
<%-- 
				<tr>
					<td>
						<div id="divExtension">
							<tiles:insert template="/utils/namedEntity.jsp" />
						</div>
					</td>
				</tr>
--%>
			</logic:present>
			</table> 
        </td>
	</tr>
</table>
<%		
		}else{
%>
<span style="color: #003399;font-size: 0.9em;font-weight: bold;">Series Not Found</span>
<%		
		}
		rs.close();
		conn.conn.close();
		conn = null;
	}
%>
