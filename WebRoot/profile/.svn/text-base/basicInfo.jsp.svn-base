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
	final String[] months = {"January","Febuary","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String user_id = (String)request.getParameter("user_id");
	if(user_id==null&&ub==null){
%>
	
<script type="text/javascript">
		window.setTimeout(function(){window.location="login.do";},50);
</script>
<%		
	}else{
		connectDB conn = new connectDB();
		ResultSet rs;
		String sql;
%>

			<table width="100%" border="0" cellspacing="0" cellpadding="0" >
				<tr>
					<td>
						<tiles:insert template="/profile/people.jsp?listtype=snapshot" />
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
<%
		if(user_id==null){
%>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
<% 
			sql = "SELECT emails FROM emailfriends WHERE user_id=" + ub.getUserID() + " GROUP BY emails";
			rs = conn.getResultSet(sql);
			HashSet<String> emailSet = new HashSet<String>();
			if(rs!=null){
				while(rs.next()){				
					String[] email = rs.getString("emails").trim().split(",");
					if(email!=null){
						for(int i=0;i<email.length;i++){
							emailSet.add(email[i].trim().toLowerCase());
						}
					}
				}
			}			
%>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					External Email Contacts
<%
			if(emailSet.size() > 0){
%>
					(<%=emailSet.size() %>)
<%				
			}
%>
					<br/><span style="color: red;font-style: italic;">(only you can see these)</span>
					</td>
				</tr>
				<tr>
					<td style="border: 1px #EFEFEF solid;">
						<table width="100%" border="0" cellspacing="0" cellpadding="1" style="font-size: 0.7em;padding: 5px;">
<% 
			if(emailSet.size() > 0){
				int i=0;
				for(Iterator<String> it=emailSet.iterator();it.hasNext();){
					if(i%2==0){
						out.println("<tr>");
					}
					out.print("<td>" + it.next() + "</td>");
					if(i%2==1){
						out.println("</tr>");
					}
					i++;
					if(i==4)break;
				}
				if(i%2==1){
					out.println("<td>&nbsp;</td></tr>");	
				}
				if(emailSet.size() > 4){
%>
							<tr>
								<td colspan="2"><a href="contacts.do">View All</a></td>
							</tr>
<%				
				}
			}else{
%>
							<tr>
								<td>No contact</td>
							</tr>
<%				
			}
%>
						</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
<%			
		}
		sql = "SELECT COUNT(*) _no FROM final_subscribe_community_id " +
				" WHERE user_id=" + (user_id==null?ub.getUserID():user_id);
		rs = conn.getResultSet(sql);
		int groupno = 0;
		if(rs.next()){
			groupno = rs.getInt(1);	
		}
%>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
					Group<%=groupno>1?"s":"" %> <%=groupno>0?"(" + groupno + ")":"" %>
					</td>
				</tr>
				<tr>
					<td style="border: 1px #EFEFEF solid;">
					<table width="100%" border="0" cellspacing="0" cellpadding="1" style="font-size: 0.7em;padding: 5px;">
<% 
		sql = "SELECT c.comm_name,c.comm_id " +
				"FROM final_subscribe_community_id fsc JOIN community c ON fsc.comm_id = c.comm_id " +
				" WHERE fsc.user_id=" + (user_id==null?ub.getUserID():user_id) +
				" GROUP BY c.comm_name,c.comm_id " +
				"ORDER BY COUNT(*) DESC";
		rs = conn.getResultSet(sql);
		if(rs!=null){
			int i=0;
			while(rs.next()){
				String comm_name = rs.getString("comm_name");
				String comm_id = rs.getString("comm_id");
				if(i%2==0){
					out.println("<tr>");
				}
				out.print("<td><a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a></td>");
				if(i%2==1){
					out.println("</tr>");
				}
				i++;
			}
			if(i%2==1){
				out.println("<td>&nbsp</td></tr>");
			}
			if(i==0){
%>
						<tr>
							<td>No group</td>
						</tr>
<%			
			}
%>

<%		
		}else{
%>
						<tr>
							<td>No group</td>
						</tr>
<%			
		}
%>
					</table>
					</td>
				</tr>
			</table>
<%			
	}
%>
