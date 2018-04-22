<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.util.LinkedHashMap"%><logic:notPresent name="UserSession">
	<script type="text/javascript">
		window.location = "login.do";
	</script>
</logic:notPresent>
<logic:present name="createNewSeries">
	<div style="font-size: 0.8em;font-weight: bold;color: green;">Post Colloquium Series Successful!</div>
	<div style="font-size: 0.8em;">
		Questions can be directed to CoMeT via email at 
		<a href="mailto:comet.paws@gmail.com">comet.paws@gmail.com</a>.
	</div>
<%-- 
	<html:link forward="aaa.pre.create.series"><span style="font-size: 0.9em;">Create New Series</span></html:link>
--%>
</logic:present>

<logic:notPresent name="createNewSeries">
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
<% 
	session=request.getSession(false);
	connectDB conn = new connectDB();
	String sql = "SELECT series_id,name,description,url FROM series s WHERE series_id = " + request.getParameter("series_id");
	ResultSet rs = conn.getResultSet(sql);
	String series_id = "0";
	String name = "";
	String url = "";
	String description = "";
	HashSet<String> sponsorSet = new HashSet<String>();
	HashSet<String> pathSet = new HashSet<String>();
	if(rs.next()){
		series_id = rs.getString("series_id");
		name = rs.getString("name");
		description = rs.getString("description");
		url = rs.getString("url");
		
		sql = "SELECT r.path,a.affiliate_id FROM affiliate_series a JOIN relation r ON a.affiliate_id = r.child_id WHERE a.series_id = " + series_id;
		rs = conn.getResultSet(sql);
		while(rs.next()){
			sponsorSet.add(rs.getString("affiliate_id"));
			String p = rs.getString("path");
			String[] path = p.split(",");
			if(path != null){
				for(int i=0;i<path.length;i++){
					if(!rs.getString("affiliate_id").equalsIgnoreCase(path[i])){
						pathSet.add(path[i]);
					}
				}
			}
		}
	}
	
	sql = "SELECT area_id FROM area_series WHERE series_id=" + request.getParameter("series_id") + " GROUP BY area_id";
	rs = conn.getResultSet(sql);
	HashSet<Integer> areaSet = new HashSet<Integer>();
	while(rs.next()){
		int area_id = rs.getInt("area_id");
		areaSet.add(area_id);
	}
	
	sql = "SELECT area_id,area FROM area ORDER BY area";
	rs = conn.getResultSet(sql);
	LinkedHashMap<String, Integer> areaMap = new LinkedHashMap<String, Integer>();
	while(rs.next()){
		int area_id = rs.getInt("area_id");
		String area = rs.getString("area");
		
		areaMap.put(area, area_id);
	}
%>
	<html:form action="/PostNewSeries" method="POST">
		<table cellspacing="0" cellpadding="0" width="100%" align="center">
			<tr>
				<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
			</tr>
			<tr>
				<td colspan="2" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
<% 
		if(request.getParameter("series_id") == null){
%>
					Create New
<%		
		}else{
%>
					Edit
<%		
		}
%>					 Colloquium Series
				</td>
			</tr>
			<tr>
				<td width="25%" align="left" style="font-size: 0.7em;font-weight: bold;">
						Series Name
				</td>
				<td align="left" style="font-size: 0.7em;">
					<html:text maxlength="400" property="name" size="50" value="<%=name%>" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="name" /></td>
			</tr>
			<tr>
				<td width="25%" align="left" valign="top" style="font-size: 0.7em;font-weight: bold;">
					Semester
				</td>
				<td align="left" style="font-size: 0.7em;">
<% 
	sql = "SELECT currsemester FROM sys_config";
	rs = conn.getResultSet(sql);
	String currsemester = "200903";
	if(rs.next()){
		currsemester = rs.getString("currsemester");
	}
	String year = currsemester.substring(0,4);
	String term = currsemester.substring(4,6);
	String semester[] = {"Spring","Summer","Fall"};
	int nextyear = Integer.parseInt(year) + 1;
	int termno = Integer.parseInt(term) -1;
%>
					<input type="radio" name="semester" value="<%=currsemester%>" checked="checked" />&nbsp;<%=semester[termno]%>&nbsp;<%=year%><br/>
<% 
	if(termno + 1 > 2){
%>
					<input type="radio" name="semester" value="<%=(nextyear + "01")%>" />&nbsp;<%=semester[0]%>&nbsp;<%=nextyear%><br/>
<%	
	}else{
%>
					<input type="radio" name="semester" value="<%=(year + "0" + (termno + 2))%>" />&nbsp;<%=semester[termno + 1]%>&nbsp;<%=year%><br/>
<%	
	}
	if(termno + 2 > 2){
%>
					<input type="radio" name="semester" value="<%=(nextyear + "0" + ((termno + 2)%3+1))%>" />&nbsp;<%=semester[(termno + 2)%3]%>&nbsp;<%=nextyear%><br/>
<%	
	}else{
%>
					<input type="radio" name="semester" value="<%=(year + "03")%>" />&nbsp;<%=semester[2]%>&nbsp;<%=year%><br/>
<%	
	}
%>
				</td>
			</tr>
			<tr>
				<td width="25%" align="left" valign="top" style="font-size: 0.7em;font-weight: bold;">
					URL
				</td>
				<td align="left" style="font-size: 0.7em;">
					<html:text maxlength="400" property="url" size="50" value="<%=url%>" />
				</td>
			</tr>
			<tr>
				<td width="25%" align="left" valign="top" style="font-size: 0.7em;font-weight: bold;">
					Description
				</td>
				<td align="left" style="font-size: 0.7em;">
					<html:textarea property="description" rows="5" cols="65" value="<%=description%>"></html:textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="color: red;font-weight: bold;"><html:errors property="description" /></td>
			</tr>
			<tr>
				<td align="left" valign="top" style="font-size: 0.7em;font-weight: bold;">Sponsor(s)</td>
				<td style="font-size: 0.7em;">
				
						<ul>
<% 
	sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id IS NULL ";
	ResultSet rs0 = conn.getResultSet(sql);
	while(rs0.next()){
		String aid = rs0.getString("affiliate_id");
		String aff = rs0.getString("affiliate");
		String checked = "";
		if(sponsorSet.contains(aid)){
			checked = "checked='checked'";		
		}
		//If the affiliation in the path, show children
		boolean show0 = false;
		if(pathSet.contains(aid)){
			show0 = true;			
		}
%>
							<li>
								<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
		sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + 
		" ORDER BY a.affiliate";
		ResultSet rs1 = conn.getResultSet(sql);
		boolean lvl1Hidden = false;
		while(rs1.next()){
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
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
			if(sponsorSet.contains(aid)){
				checked = "checked='checked'";		
			}
			//If the affiliation in the path, show children
			boolean show1 = false;
			if(pathSet.contains(aid)){
				show1 = true;			
			}
%>
									<li>
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
			sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			boolean lvl2Hidden = false;
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
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
				if(sponsorSet.contains(aid)){
					checked = "checked='checked'";		
				}
				//If the affiliation in the path, show children
				boolean show2 = false;
				if(pathSet.contains(aid)){
					show2 = true;			
				}
%>
											<li>
												<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
												&nbsp;&nbsp;<%=aff%>
<%
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
						aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
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
					if(sponsorSet.contains(aid)){
						checked = "checked='checked'";		
					}
%>
													<li>
														<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
														&nbsp;&nbsp;<%=aff%>
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
	conn.conn.close();
	conn = null;
%>			
						</ul>
				</td>				
			</tr>
			<tr>
				<td width="25%" valign="top" align="left" style="font-size: 0.7em;font-weight: bold;">
					Research Area(s)
				</td>
				<td>
					<table cellspacing="0" cellpadding="0" width="100%" align="center">
						<tr>
							<td style="font-size: 0.7em;">
								<ul>
<% 
	for(String area : areaMap.keySet()){
		Integer area_id = areaMap.get(area);
%>
									<li>
										<input type="checkbox" name="area_id" value="<%=area_id.intValue() %>" <%=(areaSet.contains(area_id)?"checked=\"checked\"":"") %> /><%=area %>
									</li>
<%			
	}
%>								
								</ul>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<input type="submit" name="btnSubmit" class="btn" value="Submit" />
				</td>
				<td>&nbsp;<input type="hidden" name="series_id" value="<%=series_id%>" /></td>
			</tr>
		</table>
	</html:form> 
</logic:notPresent>
	