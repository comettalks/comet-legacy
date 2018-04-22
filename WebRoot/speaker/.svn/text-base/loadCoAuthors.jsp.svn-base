<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="org.apache.commons.lang.StringUtils"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<%@page import="edu.pitt.sis.beans.UserBean"%>

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"> 
</script> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"> 
</script> 
<style>

</style>

<script>
$(document).ready(function(){
// $(".disp.tr:odd").addClass("odd");
});
</script>
<%
String speaker_id = (String)request.getParameter("speaker_id");
int checktime = Integer.parseInt((String)request.getParameter("index"));

checktime = checktime*10;
connectDB conn = new connectDB();


String sqlcoa = "SELECT SQL_CACHE sa.firstname, sa.lastname, sa.authorID FROM scholar.scopus_author sa "+
"JOIN scholar.scopus_paper_author spa ON sa.saID=spa.saID "+
"WHERE spa.spID IN "+
"(SELECT sp.spID FROM scholar.scopus_paper sp JOIN scholar.scopus_paper_author spa ON sp.spID = spa.spaID "+
"JOIN tmp_scopus_speaker_mapping t ON spa.saID=t.saID " +
"WHERE t.speaker_id=" + speaker_id + 
") AND sa.firstname IS NOT NULL AND LENGTH(sa.firstname) > 0 " +
" AND sa.saID <> (SELECT saID FROM tmp_scopus_speaker_mapping WHERE speaker_id=" + speaker_id + ") " +
" GROUP BY sa.firstname, sa.lastname, sa.authorID " +
" ORDER BY sa.firstname,sa.lastname " +
" LIMIT " + checktime + ",10 ";


ResultSet rscoa = null;
rscoa = conn.getResultSet(sqlcoa);
String cofirstname = "";
String colastname = "";
String authorid = "";

HashMap<String, String> scopusmap = new HashMap<String, String>();
LinkedHashSet<String> authorlist = new LinkedHashSet<String>();

while(rscoa.next()){
		cofirstname = rscoa.getString("firstname");
		colastname = rscoa.getString("lastname");
		authorid = rscoa.getString("authorID");
		
		String name = cofirstname +" "+colastname;
		scopusmap.put(name, authorid);
		authorlist.add(name);
		
}

String sqlcogoogleauthor = "SELECT co_author_name, profileID, co_author_speaker_id  FROM speaker_co_author_g_scholar "+
" WHERE speaker_id = " + speaker_id+
" ORDER BY co_author_name " +
" LIMIT " + checktime + ",10";


ResultSet rscogoogleauthor = null;
rscogoogleauthor = conn.getResultSet(sqlcogoogleauthor);
String gname = "";
String profileid = "";
String co_author_speaker_id="";

HashMap<String, String> gauthormap1 = new HashMap<String, String>();
HashMap<String, String> gauthormap2 = new HashMap<String, String>();
while(rscogoogleauthor.next()){
		gname = rscogoogleauthor.getString("co_author_name");
		profileid = rscogoogleauthor.getString("profileID");
		co_author_speaker_id = rscogoogleauthor.getString("co_author_speaker_id");
		gauthormap1.put(gname, profileid);
		gauthormap2.put(gname,co_author_speaker_id);
		authorlist.add(gname);
}

String sname="";
String _authorid="";
String _gname = "";
String _profileid = "";
String _co_author_speaker_id = "";

%>
<table cellpadding="0" cellspacing="0" border="0" class="disp">

<%
for(String author:authorlist){

	if(scopusmap.containsKey(author)){
		sname = author;
		_authorid = scopusmap.get(author);
%>
	<tr>
	<td style="font-size:0.875em;">
	<%=sname %>
	</td>
	<td>
	<a href=" http://www.scopus.com/authid/detail.url?authorId=<%= _authorid %>"><img class="scopusicon" alt="scopusicon" src="./images/speaker/scopus.jpg" onload="javascript:DrawImage(this,10,10)" /></a>
	</td>
	</tr>
<% 
	}
	
	if(gauthormap1.containsKey(author) || gauthormap2.containsKey(author)){
		_gname = author;
		_profileid = gauthormap1.get(author);
		_co_author_speaker_id = gauthormap2.get(author);
%>
	<tr>
	<td style="font-size:0.875em;">
	<%=_gname %>
	</td>
	<td>
<% if(_profileid != null || _profileid !=""){
%>
	<a href="http://scholar.google.com/citations?user=<%= _profileid %>&hl=en&oi=ao"><img src="http://www.google.com/images/icons/favicon_colors-35.gif" height="10" width="10"/></a>
<%}else{
%>
		<a href="speakerprofile.do?speaker_id=<%=_co_author_speaker_id %>">CoMeT</a>
<%
}
%>
	</td>
	</tr>
<%
	}
}
%>
</table>