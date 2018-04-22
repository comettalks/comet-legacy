<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
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
	function showSponsor(obj,btn){
		if(obj){
			obj.style.display = "block";
			btn.style.width="0px";
			btn.style.display="none";
		}
	}
</script>
 
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top" width="25%" style="font-size: 0.75em;font-weight: bold;">Network Affiliates:</td>
			<td colspan="2" style="font-size: 0.75em;">
				<ul>
<%
	session=request.getSession(false);
	connectDB conn = new connectDB();
	String sql = "SELECT a.affiliate_id,a.affiliate FROM relation r JOIN affiliate a ON r.child_id = a.affiliate_id WHERE r.parent_id IS NULL ";
	ResultSet rs0 = conn.getResultSet(sql);
	while(rs0.next()){
		String aid = rs0.getString("affiliate_id");
		String aff = rs0.getString("affiliate");
%>
					<li>
						<input type="checkbox" name="sponsor_id" value="<%=aid%>" />&nbsp;&nbsp;<%=aff%>
<%
		sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + 
		" ORDER BY a.affiliate";
		ResultSet rs1 = conn.getResultSet(sql);
		int i1=0;
		while(rs1.next()){
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
			if(i1==0){
%>
						<input class="btn" type="button" value="Show children" 
						onclick='showSponsor(aid<%=aid%>,this);'  />
						<ul id="aid<%=aid %>" style="display: none;">
<%
			}
			i1++;
%>
							<li>
								<input type="checkbox" name="sponsor_id" value="<%=aid%>" />&nbsp;&nbsp;<%=aff%>
<% 
			sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			int i2=0;
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				if(i2==0){
%>
								<input class="btn" type="button" value="Show children" 
								onclick='showSponsor(aid<%=aid %>,this);'  />
								<ul id="aid<%=aid %>" style="display: none;">
<% 
				}
				i2++;
%>
									<li>
										<input type="checkbox" name="sponsor_id" value="<%=aid%>" />&nbsp;&nbsp;<%=aff%>
<% 
				sql = "SELECT a.affiliate_id,a.affiliate FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
				aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				int i3=0;
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					if(i3==0){
%>
										<input class="btn" type="button" value="Show children" 
										onclick='showSponsor(aid<%=aid %>,this);'  />
										<ul id="aid<%=aid %>" style="display: none;">
<% 
					}
					i3++;
%>
											<li>
												<input type="checkbox" name="sponsor_id" value="<%=aid%>" />&nbsp;&nbsp;<%=aff%>
											</li>
<%							
				}
				if(i3>0){
%>
										</ul>
<%							
				}	
				rs3.close();
%>
									</li>
<%						
			}
			if(i2>0){
%>								
								</ul>
<%					
			}	
			rs2.close();
%>
							</li>	
<%			
		}
		if(i1>0){
%>
						</ul>
<%			
		}
		rs1.close();
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
			<td>&nbsp;</td>
			<td colspan="2"><font class="error"><html:errors property="affiliate"/></font></td>
		</tr>
	</table>
