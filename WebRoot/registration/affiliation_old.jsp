<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top" width="25%" style="font-size: 0.75em;font-weight: bold;">Network Affiliates:</td>
			<td colspan="2" style="font-size: 0.75em;">
<%
	session=request.getSession(false);
	connectDB conn = new connectDB();
	String sql = "SELECT a.affiliate_id,a.affiliate FROM relation r JOIN affiliate a ON r.child_id = a.affiliate_id WHERE r.parent_id IS NULL ";
	ResultSet rs0 = conn.getResultSet(sql);
	while(rs0.next()){
		String aid = rs0.getString("affiliate_id");
		String aff = rs0.getString("affiliate");
		String checked = "";
%>
						<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
		sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + 
		" ORDER BY a.affiliate";
		ResultSet rs1 = conn.getResultSet(sql);
		boolean lvl1Hidden = false;
		if(rs1.next()){
			lvl1Hidden = true;
%>
							<script type="text/javascript">
								function ShowSponsor<%=aid%>(){
									if(btnShowSponsor<%=aid%>){
										btnShowSponsor<%=aid%>.style.width = "0px";
										btnShowSponsor<%=aid%>.style.display = "none";
										divSponsor<%=aid%>.style.height = "auto";
										divSponsor<%=aid%>.style.overflow = "visible";
									}
								}
							</script>
						<input class="btn" type="button" id="btnShow childrenSponsor<%=aid%>" value="Show children" 
						onclick="ShowSponsor<%=aid%>();"  />
							<div id="divSponsor<%=aid%>" style="height: 0px;overflow: hidden;">
<%		
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
			checked = "";
%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
								&nbsp;&nbsp;<%=aff%>
<%
			sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			boolean lvl2Hidden = false;
			if(rs2.next()){
				lvl2Hidden = true;
%>
							<script type="text/javascript">
								function ShowSponsor<%=aid%>(){
									if(btnShowSponsor<%=aid%>){
										btnShowSponsor<%=aid%>.style.width = "0px";
										btnShowSponsor<%=aid%>.style.display = "none";
										divSponsor<%=aid%>.style.height = "auto";
										divSponsor<%=aid%>.style.overflow = "visible";
									}
								}
							</script>
						<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
						onclick="ShowSponsor<%=aid%>();"  />
							<div id="divSponsor<%=aid%>" style="height: 0px;overflow: hidden;">
<%
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				checked = "";
%>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
									&nbsp;&nbsp;<%=aff%>
<%
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
						aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				if(rs3.next()){
					lvl3Hidden = true;
%>
							<script type="text/javascript">
								function ShowSponsor<%=aid%>(){
									if(btnShowSponsor<%=aid%>){
										btnShowSponsor<%=aid%>.style.width = "0px";
										btnShowSponsor<%=aid%>.style.display = "none";
										divSponsor<%=aid%>.style.height = "auto";
										divSponsor<%=aid%>.style.overflow = "visible";
									}
								}
							</script>
						<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
						onclick="ShowSponsor<%=aid%>();"  />
							<div id="divSponsor<%=aid%>" style="height: 0px;overflow: hidden;">
<%
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				rs3.close();
				if(lvl3Hidden){
%>
									</div>
<%
				}else{
%>
									<br/>
<%
				}
			}
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				checked = "";
%>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
									&nbsp;&nbsp;<%=aff%>
<%
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
						aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				if(rs3.next()){
					lvl3Hidden = true;
%>
							<script type="text/javascript">
								function ShowSponsor<%=aid%>(){
									if(btnShowSponsor<%=aid%>){
										btnShowSponsor<%=aid%>.style.width = "0px";
										btnShowSponsor<%=aid%>.style.display = "none";
										divSponsor<%=aid%>.style.height = "auto";
										divSponsor<%=aid%>.style.overflow = "visible";
									}
								}
							</script>
						<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
						onclick="ShowSponsor<%=aid%>();"  />
							<div id="divSponsor<%=aid%>" style="height: 0px;overflow: hidden;">
<%
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				rs3.close();
				if(lvl3Hidden){
%>
									</div>
<%
				}else{
%>
									<br/>
<%
				}
			}
			rs2.close();
			if(lvl2Hidden){
%>
								</div>
<%
			}else{
%>
								<br/>
<%
			}
		}
		while(rs1.next()){
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
			checked = "";
%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
			sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + 
					" ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			boolean lvl2Hidden = false;
			if(rs2.next()){
				lvl2Hidden = true;
%>
							<script type="text/javascript">
								function ShowSponsor<%=aid%>(){
									if(btnShowSponsor<%=aid%>){
										btnShowSponsor<%=aid%>.style.width = "0px";
										btnShowSponsor<%=aid%>.style.display = "none";
										divSponsor<%=aid%>.style.height = "auto";
										divSponsor<%=aid%>.style.overflow = "visible";
									}
								}
							</script>
						<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
						onclick="ShowSponsor<%=aid%>();"  />
							<div id="divSponsor<%=aid%>" style="height: 0px;overflow: hidden;">
<%
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				checked = "";
%>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
									&nbsp;&nbsp;<%=aff%>
<%
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
						aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				if(rs3.next()){
					lvl3Hidden = true;
%>
							<script type="text/javascript">
								function ShowSponsor<%=aid%>(){
									if(btnShowSponsor<%=aid%>){
										btnShowSponsor<%=aid%>.style.width = "0px";
										btnShowSponsor<%=aid%>.style.display = "none";
										divSponsor<%=aid%>.style.height = "auto";
										divSponsor<%=aid%>.style.overflow = "visible";
									}
								}
							</script>
						<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
						onclick="ShowSponsor<%=aid%>();"  />
							<div id="divSponsor<%=aid%>" style="height: 0px;overflow: hidden;">
<%
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				rs3.close();
				if(lvl3Hidden){
%>
									</div>
<%
				}else{
%>
									<br/>
<%
				}
			}
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				checked = "";
%>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
									&nbsp;&nbsp;<%=aff%>
<%
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				if(rs3.next()){
					lvl3Hidden = true;
%>
							<script type="text/javascript">
								function ShowSponsor<%=aid%>(){
									if(btnShowSponsor<%=aid%>){
										btnShowSponsor<%=aid%>.style.width = "0px";
										btnShowSponsor<%=aid%>.style.display = "none";
										divSponsor<%=aid%>.style.height = "auto";
										divSponsor<%=aid%>.style.overflow = "visible";
									}
								}
							</script>
						<input class="btn" type="button" id="btnShowSponsor<%=aid%>" value="Show children" 
						onclick="ShowSponsor<%=aid%>();"  />
							<div id="divSponsor<%=aid%>" style="height: 0px;overflow: hidden;">
<%
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					checked = "";
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" <%=checked%> />
										&nbsp;&nbsp;<%=aff%>
<%
				}
				rs3.close();
				if(lvl3Hidden){
%>
									</div>
<%
				}else{
%>
									<br/>
<%
				}
			}
			rs2.close();
			if(lvl2Hidden){
%>
								</div>
<%
			}else{
%>
								<br/>
<%
			}
		}
		rs1.close();
		if(lvl1Hidden){
%>
							</div>
<%		
		}else{
%>
							<br/>
<%		
		}
	}
	rs0.close();
	conn.conn.close();
	conn = null;
%>			
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2"><font class="error"><html:errors property="affiliate"/></font></td>
		</tr>
	</table>
