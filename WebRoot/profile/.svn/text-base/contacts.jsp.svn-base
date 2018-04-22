<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%>

<% 
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	if(ub==null){
%>
	<script type="text/javascript">
		redirect("login.do");
		//window.setTimeout(function(){window.location="login.do";},50);
	</script>
<%		
	}else{
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td width="75%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					External Email Contacts <span style="color: red;font-style: italic;">(only you can see this)</span>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="1" style="font-size: 0.7em;">
<% 
			connectDB conn = new connectDB();
			ResultSet rs;
			String sql;
			sql = "SELECT emails FROM emailfriends WHERE user_id=" + ub.getUserID() + " GROUP BY emails";
			rs = conn.getResultSet(sql);
			if(rs!=null){
				HashSet<String> emailSet = new HashSet<String>();
				while(rs.next()){				
					String[] email = rs.getString("emails").trim().split(",");
					if(email!=null){
						for(int i=0;i<email.length;i++){
							emailSet.add(email[i].trim().toLowerCase());
						}
					}
				}
				if(emailSet.size() > 0){
					int i=0;
					for(Iterator<String> it=emailSet.iterator();it.hasNext();){
						if(i%3==0){
							out.println("<tr>");
						}
						out.print("<td>" + it.next() + "</td>");
						if(i%3==2){
							out.println("</tr>");
						}
						i++;
					}
					if(i%3==1){
						out.println("<td colspan=\"2\">&nbsp;</td></tr>");	
					}
					if(i%3==2){
						out.println("<td>&nbsp;</td></tr>");	
					}
				}else{
					%>
							<tr>
								<td colspan="3">No contact</td>
							</tr>
<%				
				}
			}else{
%>
							<tr>
								<td colspan="3">No contact</td>
							</tr>
<%				
			}
%>
						</table>					
					</td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="25%" valign="top">
			&nbsp;
		</td>
	</tr>
</table>	
<%			
	}
%>
