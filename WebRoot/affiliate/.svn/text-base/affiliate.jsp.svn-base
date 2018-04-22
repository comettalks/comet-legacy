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


<style type='text/css' media='all'>
ul li{
     list-style-type:none;
     margin:0;
     padding:0;
     margin-left:8px;
 }
</style>
<script type="text/javascript">
function showChildren(obj,btn){
	if(obj){
		obj.style.display = "block";
		btn.style.width="0px";
		btn.style.display="none";
	}
}
</script>
<logic:notPresent name="UserSession">
<% 
	String pagePath = "affiliate.do";
	
	if(request.getQueryString()!=null){
		pagePath += "?" + request.getQueryString();
	} 
	session.setAttribute("before-login-redirect", pagePath);
%>
</logic:notPresent>
<% 
	String affiliate_id = (String)request.getParameter("affiliate_id");
	if(affiliate_id == null){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td style="color: #003399;font-weight: bold;font-size: 0.95em;">Affiliation Tree</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
						<ul style="color: #003399;font-size: 0.8em;">
<% 
	connectDB conn = new connectDB();
	String sql = "SELECT SQL_CACHE a.affiliate_id,a.affiliate,r.fullPath FROM relation r JOIN affiliate a ON r.child_id = a.affiliate_id WHERE r.parent_id IS NULL ";
	ResultSet rs0 = conn.getResultSet(sql);
	while(rs0.next()){
		String aid = rs0.getString("affiliate_id");
		String aff = rs0.getString("affiliate");
		String fullpath = rs0.getString("fullPath");
		String checked = "";
		//If the affiliation in the path, show children
		boolean show0 = false;
%>
							<li>
								&nbsp;&nbsp;<a href="affiliate.do?affiliate_id=<%=aid %>"><%=aff %></a>
<%
		sql = "SELECT SQL_CACHE a.affiliate_id,a.affiliate,r.fullPath FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + 
		" ORDER BY a.affiliate";
		ResultSet rs1 = conn.getResultSet(sql);
		boolean lvl1Hidden = false;
		while(rs1.next()){
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
			fullpath = rs1.getString("fullPath");
			if(!lvl1Hidden){
				if(show0){
%>
							<ul id="ulSponsor<%=aid %>">
<%		
				}else{
%>
							<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
							onclick="showChildren(ulSponsor<%=aid%>,this);"  />
							<ul id="ulSponsor<%=aid %>" style="display: none;">
<%		
				}
				lvl1Hidden = true;
			}
			checked = "";
			//If the affiliation in the path, show children
			boolean show1 = false;
%>
									<li>
										&nbsp;&nbsp;<a href="affiliate.do?affiliate_id=<%=aid %>"><%=aff %></a>
<%
			sql = "SELECT SQL_CACHE a.affiliate_id,a.affiliate,r.fullPath FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			boolean lvl2Hidden = false;
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				fullpath = rs2.getString("fullPath");
				if(!lvl2Hidden){
					if(show1){
%>
										<ul id="ulSponsor<%=aid%>">
<%
					}else{
%>
										<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
										onclick="showChildren(ulSponsor<%=aid%>,this);"  />
										<ul id="ulSponsor<%=aid%>" style="display: none;">
<%
					}
					lvl2Hidden = true;
				}
				checked = "";
				//If the affiliation in the path, show children
				boolean show2 = false;
%>
											<li>
												&nbsp;&nbsp;<a href="affiliate.do?affiliate_id=<%=aid %>"><%=aff %></a>
<%
				sql = "SELECT SQL_CACHE a.affiliate_id,a.affiliate,r.fullPath FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
						aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					fullpath = rs3.getString("fullPath");
					if(!lvl3Hidden){
						if(show2){
%>
												<ul id="ulSponsor<%=aid%>">
<%
						}else{
%>
												<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
												onclick="showChildren(ulSponsor<%=aid%>,this);"  />
												<ul id="ulSponsor<%=aid%>" style="display: none;">
<%
						}
						lvl3Hidden = true;
					}
					checked = "";
%>
													<li>
														&nbsp;&nbsp;<a href="affiliate.do?affiliate_id=<%=aid %>"><%=aff %></a>
													</li>
<%
				}
				rs3.close();
				if(lvl3Hidden){
%>
												</ul>
<%
				}
%>
											</li>
<%						
				
			}
			rs2.close();
			if(lvl2Hidden){
%>
										</ul>
<%
			}
%>
									</li>
<%						
		}
		rs1.close();
		if(lvl1Hidden){
%>
								</ul>
<%
		}
%>
							</li>
<%						
	}
	rs0.close();
%>			
						</ul>
		</td>
	</tr>
</table>
<% 
	}else{
		connectDB conn = new connectDB();
		String sql = "SELECT SQL_CACHE a.affiliate,r.fullpath FROM affiliate a JOIN relation r ON a.affiliate_id = r.child_id WHERE a.affiliate_id = " + affiliate_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String affiliate = rs.getString("affiliate");
			String fullpath = rs.getString("fullpath");
%>
<script type="text/javascript">
<!--
	var aTitle = "CoMeT | Affiliation: ";
	aTitle = aTitle.concat('<%=fullpath %>');
	window.setTimeout(function(){document.title=aTitle;},50);	
//-->
</script>
 <table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="5" width="100%" align="left" style="color: #003399;font-weight: bold;font-size: 0.95em;">
			Affiliation: <%=fullpath%>&nbsp;
			<logic:present name="UserSession">
<% 
			UserBean ub = (UserBean)session.getAttribute("UserSession");
			boolean subscribed = false;
			sql = "SELECT user_id FROM final_subscribe_affiliate WHERE user_id=" + ub.getUserID() +
					" AND affiliate_id=" + affiliate_id;
			rs = conn.getResultSet(sql);
			if(rs.next()){
				subscribed = true;
			}
%>	
				<span class="spansubaid<%=affiliate_id %>" id="spansubraid<%=affiliate_id %>" 
					style="display: <%=subscribed?"inline":"none" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
					onclick="window.location='affiliate.do?affiliate_id=<%=affiliate_id %>'"><%=subscribed?"&nbsp;Subscribed&nbsp;":"" %>
				</span>&nbsp;			
				<input class="btn" type="button" value="<%=subscribed?"Unsubscribe":"Subscribe" %>"
					onclick="subscribeAffiliation(<%=ub.getUserID() %>,<%=affiliate_id %>,this,'spansubraid<%=affiliate_id %>');" />
			</logic:present>	
		</td>
	</tr>
<%-- 
	<tr>
		<td colspan="5" style='color: black;font-weight: normal;font-size: 0.75em;'>
			&nbsp;
		</td>
	</tr>
--%>
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
<%-- 
				<br/>
				<div id="divFacet">
					<tiles:insert template="/utils/namedEntity.jsp" />
				</div>
--%>				
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
<span style="font-size: 0.75em;font-weight: bold;">Affiliation Not Found</span>
<%		
		}
	}
%>
