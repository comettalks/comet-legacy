<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%@page import="edu.pitt.sis.beans.UserBean"%>

<style>
img.speakerImg {
    	display:block;
    	margin-left:auto;
    	margin-right:auto;
    }
</style>
<%
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int speaker_id = 0;
	int totaltalks =0;
	String picurl = null;
	boolean haveprofileID = false;
	if(request.getParameter("speaker_id") != null){
		speaker_id = Integer.parseInt((String)request.getParameter("speaker_id"));
	}
	
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql0 = "SELECT count(DISTINCT col_id) " +"FROM col_speaker " + "WHERE speaker_id = " +speaker_id+ " GROUP BY speaker_id";
	rs = conn.getResultSet(sql0);
	if(rs.next()){
		totaltalks = rs.getInt(1);
	}
	
	String sql1= "SELECT COUNT(*) FROM speaker_academic_profile sap JOIN scholar.g_scholar_profile gsp ON sap.profileID = gsp.profileID "+
				 " WHERE sap.speaker_id= " +speaker_id;
	rs = conn.getResultSet(sql1);
	if(rs.next()){
		int checkexist = rs.getInt(1);
		if(checkexist>0)
		haveprofileID = true;
	}
	String microsofturl = null;
	if(haveprofileID){
		ResultSet microsoftrs = null;
					String microsoftsql = "SELECT url FROM speaker_academic_profile "+
									   " WHERE profileSource = 2 "+
									   " AND status = 1 "+
									   " AND speaker_id = " + speaker_id;
					microsoftrs = conn.getResultSet(microsoftsql);
					if(microsoftrs.next()){
					microsofturl = microsoftrs.getString("url");
					}
	}
	String sql = "SELECT name, publications, citations, gslink, affiliation, picurl " +
					"FROM speaker " + "WHERE speaker_id = " + speaker_id;
	rs = conn.getResultSet(sql);
	if(rs.next()){
		String name = rs.getString("name");
		picurl = rs.getString("picurl");
		if(picurl == null){
    	    ResultSet picrs = null;
    	    String picsql = "SELECT imageUrl FROM speaker_academic_profile WHERE (profileSource = 1 OR status = 1) AND speaker_id= "+speaker_id;
    	    picrs = conn.getResultSet(picsql); 
    	    if(picrs.next()){
    	    picurl = picrs.getString("imageUrl");
    	    }
    	    }
		if(picurl == null){ 
			picurl = "./images/speaker/avartar.gif";
		}	
		String publications = rs.getString("publications");
		if(haveprofileID){
			ResultSet pubrs = null;
			String pubsql = "SELECT COUNT(gspub.gspubID) totalpub FROM scholar.g_scholar_publication gspub "+
				   " JOIN scholar.g_scholar_publication_author gspuba ON gspub.gspubID=gspuba.gspubID "+
				   " JOIN scholar.g_scholar_author gsa ON gspuba.gsaID = gsa.gsaID "+
				   " JOIN speaker_academic_profile sap ON gsa.profileID = sap.profileID "+
				   " WHERE gsa.profileID is not NULL "+
				   " AND sap.speaker_id = "+ speaker_id+ 
				   " GROUP BY sap.speaker_id ";
			pubrs = conn.getResultSet(pubsql);
			if(pubrs.next()){
			publications = pubrs.getString("totalpub");
			}
		}
	    String citations = rs.getString("citations");
	    if(haveprofileID){
			ResultSet citers = null;
			String citesql = "SELECT sum(gspub.citedBy) totalcite FROM scholar.g_scholar_publication gspub "+
				   " JOIN scholar.g_scholar_publication_author gspuba ON gspub.gspubID=gspuba.gspubID "+
				   " JOIN scholar.g_scholar_author gsa ON gspuba.gsaID = gsa.gsaID "+
				   " JOIN speaker_academic_profile sap ON gsa.profileID = sap.profileID "+
				   " WHERE gsa.profileID is not NULL "+
				   " AND sap.speaker_id = "+ speaker_id;
			citers = conn.getResultSet(citesql);
			if(citers.next()){
			citations = citers.getString("totalcite");
			}
		}
		String gslink = "";
		if(haveprofileID){
		String sql3 = "SELECT gsp.url url FROM scholar.g_scholar_profile gsp "+
					  " JOIN speaker_academic_profile sap ON gsp.profileID = sap.profileID "+
					  " WHERE sap.speaker_id = " + speaker_id;
		ResultSet rstemp = null;
		rstemp = conn.getResultSet(sql3);
		if(rstemp.next()){
		gslink = rstemp.getString("url");
		}
		}else{
		gslink = rs.getString("gslink");
		}	
		String affiliation= rs.getString("affiliation");
		
		int subno = 0;
			if(ub != null){
				sql = "SELECT COUNT(*) _no FROM final_subscribe_speaker WHERE speaker_id=" + speaker_id + " AND user_id=" + ub.getUserID();
				ResultSet rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					subno = rsExt.getInt("_no");
				}
			}
	%>
<div><table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
		<td width="80%" valign="top">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="info">
		<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
		<td width="50%" align="left" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
		<%=name %>'s Info
		</td>
		<td width="50%" align="right" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
		<logic:present name="UserSession">
		<input class="btn" id="btnspid<%=speaker_id %>" type="button" value="<%=subno>0?"Unsubscribe":"Subscribe" %>"
					onclick="subscribeSpeaker(<%=ub.getUserID() %>,<%=speaker_id %>,this,'spansubrspid<%=speaker_id %>');" />
		</logic:present>
		</td>
		</tr>
		<tr><td><div style="height: 10px; overflow:hidden;">&nbsp;</div></td></tr>
		</table>
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" >
		<tr>
		<td width="15%" valign="top">
		<img class="speakerImg" alt="avartar" src="<%=picurl%>" onload="javascript:DrawImage(this,100,100)" />
		</td>
		<td width="50%" valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td width="20%" valign="top"  align="left"><font size="2">Name:</font></td>
		<td width="70%" valign="top" ><font size="2"><%=name %>
				<span class="spansubspid<%=speaker_id %>" id="spansubrspid<%=speaker_id %>" 
					style="display: <%=subno==0?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
					onclick="window.location='speakerprofile.do?speaker_id=<%=speaker_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
				</span>&nbsp;
				</font>
		</td>
		</tr>
		<tr><td><div style="height: 10px; overflow:hidden;">&nbsp;</div></td></tr>
		<tr>
		<td valign="top"  align="left"><font size="2">Affiliation:</font></td>
		<td valign="top"><font size="2"><%=affiliation %></font></td>
		</tr>
		<tr><td><div style="height: 10px; overflow:hidden;">&nbsp;</div></td></tr>
<%
		if(publications != null && citations != null){
%>
		<tr>
		<td valign="top"  align="left"><font size="2">Publications:</font><a href="<%=gslink %>" ><font size="2"><%=publications %></font></a></td>
		<td valign="top" ><font size="2">Citations:</font><a href="<%=gslink %>" ><font size="2"><%=citations %></font></td>
		</tr>
		<tr><td><div style="height: 10px; overflow:hidden;">&nbsp;</div></td></tr>
<%
		}else if(gslink != null){
%>
		<tr>
		<td valign="top"  align="left"><img src="http://www.google.com/images/icons/favicon_colors-35.gif" height="10" width="10"/><font size="2">Google Scholar:</font></td>
		<td valign="top" ><font size="2"><a href="<%=gslink %>" target="_blank" >Link</a></font></td>
		</tr>
<%
		}
		if(microsofturl != null){
%>
		<tr>
		<td valign="top"  align="left"><img src="http://i.s-microsoft.com/global/ImageStore/PublishingImages/logos/hp/logo-lg-1x.png" height="10" width="10"/><font size="2">Microsoft Academic:</font></td>
		<td valign="top" ><font size="2"><a href="<%=microsofturl %>" target="_blank" >Link</a></font></td>
		</tr>
<%
		}
		if(haveprofileID){
		ResultSet temp_rs = null;
		String sql2 = "SELECT gsi.interest interest, gsi.url url " + " FROM scholar.g_scholar_interest gsi "+
					  " JOIN scholar.g_scholar_profile_interest gspi ON gsi.gsiID = gspi.gsiID "+ 
					  " JOIN scholar.g_scholar_profile gsp ON gspi.profileID = gsp.profileID "+
					  " JOIN speaker_academic_profile sap ON gsp.profileID = sap.profileID " +
					  " WHERE sap.speaker_id = " + speaker_id;
		temp_rs = conn.getResultSet(sql2);
		String interest="";	
		String url ="";	  
%>
		<tr>
		<td valign="top"  align="left"><font size="2"><img src="http://www.google.com/images/icons/favicon_colors-35.gif" height="10" width="10"/>Interest:</font></td>
		<td valign="top" ><font size="2">
<%
		while(temp_rs.next()){
			interest = temp_rs.getString("interest");
			url = temp_rs.getString("url");
%>
		<a href="<%=url %>" ><%=interest %></a>
<%
		}
%>
		</font></td>
		</tr>
		<tr><td><div style="height: 10px; overflow:hidden;">&nbsp;</div></td></tr>
<%
		}
%>		
		<tr>
		<td valign="top"  align="left"><font size="2">Talk<% if(totaltalks <=2){out.print("s:");}else{out.print(":");} %></font></td>
		<td valign="top" ><font size="2"><%=totaltalks %></font></td>
		</tr>
		</table>
		</td>
		</tr>
	</table>
</div>
<br/>
<%
	}
	ResultSet temprs = null;
	String sql4 = "SELECT gspub.title title, gspub.gUrl gurl FROM scholar.g_scholar_publication gspub "+
				  " JOIN scholar.g_scholar_publication_author gspuba ON gspub.gspubID=gspuba.gspubID "+
				  " JOIN scholar.g_scholar_author gsa ON gspuba.gsaID = gsa.gsaID "+
				  " JOIN speaker_academic_profile sap ON gsa.profileID = sap.profileID "+
				  " WHERE gsa.profileID is not NULL "+
				  " AND sap.speaker_id = " + speaker_id +
				  " ORDER BY gspub.citedBy DESC " +
				  " LIMIT 1 ";
	temprs = conn.getResultSet(sql4);
%>
<div>

<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<%
	if(temprs.next()){
	ResultSet rs_temp = null;
	String sql5 = "SELECT gspub.title title, gspub.gUrl gurl FROM scholar.g_scholar_publication gspub "+
				  " JOIN scholar.g_scholar_publication_author gspuba ON gspub.gspubID=gspuba.gspubID "+
				  " JOIN scholar.g_scholar_author gsa ON gspuba.gsaID = gsa.gsaID "+
				  " JOIN speaker_academic_profile sap ON gsa.profileID = sap.profileID "+
				  " WHERE gsa.profileID is not NULL "+
				  " AND sap.speaker_id = " + speaker_id +
				  " ORDER BY gspub.citedBy+0 DESC " +
				  " LIMIT 3 ";
	rs_temp = conn.getResultSet(sql5);
%>
		<tr>
		<td align="left" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
		Top Cited Paper
		</td>
		</tr>
		
<%
	while(rs_temp.next()){
	String papertitle = rs_temp.getString("title");
	String citeurl = rs_temp.getString("gurl");
%>
		<tr>
		<td align="left" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;">
		<img src="http://www.google.com/images/icons/favicon_colors-35.gif" height="10" width="10"/><a href="http://scholar.google.com<%=citeurl %>" ><%=papertitle %></a>
		</td>
		</tr>
<%
	  }
	}
	
/* 	String sqlcoa = "SELECT sa.firstname, sa.lastname, sa.authorID FROM scholar.scopus_author sa "+
" JOIN scholar.scopus_paper_author spa1 ON sa.saID=spa1.saID "+
" JOIN scholar.scopus_paper_author spa2 ON spa1.spID=spa2.spID "+
" JOIN tmp_scopus_speaker_mapping ssm ON spa2.saID=ssm.saID "+
" WHERE speaker_id="+ speaker_id +
" LIMIT 10 ";


ResultSet rscoa = null;
rscoa = conn.getResultSet(sqlcoa);
String cofirstname = "";
String colastname = "";
String authorid = ""; */
%>
		<tr>
		<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
		<td align="left" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
		Schedule
		</td>
		</tr>
		<tr>
		<td colspan="3"  valign="top" width="80%">
			<div id="divMain">
				<tiles:insert template="/utils/loadTalks.jsp" />			
			</div>
        </td>
        </tr>
        <tr><td><div style="height: 10px; overflow:hidden;">&nbsp;</div></td></tr>
        </table>
	
	<table width="100%" align="left" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
		<td width="15%" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
		Recent Activities
		</td>
	</tr>
	<tr>
		<td colspan="3"  valign="top" width="80%">
			<div id="divMain">
				<tiles:insert template="/profile/recentActivity.jsp" />			
			</div>
     	</td>
    </tr>
</table>

</td>
<td width="20%" valign="top">
<table width="20%" align="right" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
		<td width="15%" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
		Co-Authors
		</td>
	</tr>
	<tr>
		<td id="tdCoAuthor">
			<script type="text/javascript">
				$(document).ready(function(){
				var clicktime = 0 ;
				if(clicktime == 0){
					$('#authorprev').hide();
				}
				
				if(clicktime < 0){
					clicktime = 0;
				}
				
				$('#authornext').click(function(){
					clicktime++;
					$.get('loadCoAuthor.jsp',{speakerid: <%=speaker_id%>, index: clicktime},
						function(data){
							$('#tdCoAuthor').html(data);
							$('#tdCoAuthor').show('fast');
					});
									
				});
				
				$('#authorprev').click(function(){
					clicktime--;
					$.get('loadCoAuthor.jsp',{speakerid: <%=speaker_id%>, index: clicktime},
						function(data){
							$('#tdCoAuthor').html(data);
							$('#tdCoAuthor').show('fast');
					});
									
				});
				

					$.get('loadCoAuthor.jsp',{speakerid: <%=speaker_id%>, index: clicktime},
						function(data){
							$('#tdCoAuthor').html(data);
							$('#tdCoAuthor').show('fast');
						});
				});
			</script>
		</td>
	</tr>
	<tr>
		<td>
			<button id="authorprev">Previous Page</button>
			<button id="authornext">Next Page</button>
		</td>
	</tr>
<%
		/* while(rscoa.next()){
		cofirstname = rscoa.getString("firstname");
		colastname = rscoa.getString("lastname");
		authorid = rscoa.getString("authorID"); */
%>
<%-- 		<tr>
		<td>
			<a href="http://www.scopus.com/authid/detail.url?authorId=<%= authorid %>" ><%= cofirstname %> &nbsp; <%= colastname %></a>
		</td>
		</tr> --%>
<%
	/* } */
%>
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
				</logic:present>
			</table>
			</td>
</tr>
</table>
