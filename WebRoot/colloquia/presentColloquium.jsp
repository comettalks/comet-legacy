<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.LinkedHashMap"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<html>
 	<head>
		<link rel="CoMeT Icon" href="images/favicon.ico" />
<script type="text/javascript">
/*
function   DrawImage(ImgD, iwidth, iheight){ 
    var image = new Image();     
    image.src = ImgD.src; 
    if(image.width > 0  &&  image.height> 0){ 
      if(image.width/image.height >= iwidth/iheight){    
        	 ImgD.width=iwidth; 
        	 ImgD.height=image.height*iwidth/image.width;  
        	 ImgD.alt=image.width+ "× "+image.height; 
      } 
     else{ 
        	ImgD.height=iheight; 
        	ImgD.width=image.width*iheight/image.height;           
        	ImgD.alt=image.width+ "× "+image.height; 
     } 
   }
}
*/
	var oAJAXIFrame = null;
	function setDocumentTitle(aTitle){
		document.title = aTitle;
	}
	function insert(tag){
		var el = document.getElementById('myTags');
		el.innerHTML += '<div><div class="tags">' + tag + '&nbsp;&nbsp;</div><input style="float:left" height="15" width="15" type="image" src="images/delete.jpg" onclick="deleteTag(this, \'' + tag + '\')"/></div>';
		
		document.AddBookmarkColloquiumForm.tags.value += tag + ",,";
		document.getElementById(tag).removeAttribute("onclick");
		document.getElementById(tag).removeAttribute("href");
		document.getElementById(tag).style.color = "black";			
		
	}
	function deleteTag(element, tag){
		 var parentElement = element.parentNode;
		 var parentElement2 = parentElement.parentNode;
         if(parentElement2){
                parentElement2.removeChild(parentElement);  
         }
         var tagContent = document.AddBookmarkColloquiumForm.tags.value;
         document.AddBookmarkColloquiumForm.tags.value = tagContent.replace(tag+",,", "");
         
         document.getElementById(tag).onclick = function() {insert(tag);};
         document.getElementById(tag).href = "javascript: return false;";
         document.getElementById(tag).style.color = "#00A";	
         
	}
	function editNote(){
		if(btnEditNote.value == "Cancel"){
			cancelEditNote();
			return;
		}
		btnEditNote.value = "Cancel";
		if(divNote){
			divNote.style.display = "none";
		}
		if(divBookmark){
			divBookmark.style.display = "block";
		}
		/*if(btnCancelEditNote){
			btnCancelEditNote.style.width = "auto";
			btnCancelEditNote.style.display = "block";
		}
		if(btnEditNote){
			btnEditNote.style.width = "0px";
			btnEditNote.style.display = "none";
		}*/
	}
	function cancelEditNote(){
		btnEditNote.value = "Edit";
		if(divNote){
			divNote.style.display = "block";
		}
		if(divBookmark){
			divBookmark.style.display = "none";
		}
		/*if(btnCancelEditNote){
			btnCancelEditNote.style.width = "0px";
			btnCancelEditNote.style.display = "none";
		}
		if(btnEditNote){
			btnEditNote.style.width = "auto";
			btnEditNote.style.display = "block";
		}*/
	}
	function createAJAXIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenAJAXFrame";
			iframe.id = "hiddenAJAXFrame";
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oAJAXIFrame = frames["hiddenAJAXFrame"];
		}else{
			window.setTimeout(function(){createAJAXIFrame();},50);
		}
	}

<%--	
	function sendEmailFriends(col_id){
		if(txtEmail.value.length < 1){
			alert("Please enter your friends emails");
			return;
		}

		if(col_id){
			if(!oAJAXIFrame){
				createAJAXIFrame();
				window.setTimeout(function(){ sendEmailFriends(col_id);},50); 
			}else{
				txtEmail.disabled = true;
				btnSendEmail.value = "Sending...";
				btnSendEmail.disabled = true;
				var action = "utils/sendEmails.jsp?col_id=".concat(col_id,"&emails=",txtEmail.value);
				//alert(action);
				oAJAXIFrame.location = action;
			}
		}
	}
	
	function enableEmailFriends(){
		btnSendEmail.value = "Sent";
		window.setTimeout(
			function(){
				txtEmail.value = "";
				txtEmail.disabled = false;
				btnSendEmail.value = "Send";
				btnSendEmail.disabled = false;
			},500
		);
	}
--%>

	function deleteCol(col_id,isPost){
		if(col_id){
			if(!oAJAXIFrame){
				createAJAXIFrame();
				window.setTimeout(function(){ deleteCol(col_id,isPost);},50); 
			}else{
				var action = "utils/deleteTalks.jsp?col_id=".concat(col_id);
				//alert(action);
				oAJAXIFrame.location = action;
				window.setTimeout(function(){clearNote();},50);
			}
		}
	}
	function redirect(html){
		window.location = html;
	}
	function clearNote(){
		if(divNote){
			divNote.style.height = "0px";
			divNote.style.overflow = "hidden";
		}
		if(divBookmark){
			divBookmark.style.height = "auto";
			divBookmark.style.overflow = "visible";
		}
		if(btnDeleteNote){
			btnDeleteNote.style.width = "0px";
			btnDeleteNote.style.display = "none";
		}
		/*if(btnCancelEditNote){
			btnCancelEditNote.style.width = "0px";
			btnCancelEditNote.style.display = "none";
		}*/
		if(btnEditNote){
			btnEditNote.style.width = "0px";
			btnEditNote.style.display = "none";
		}
		if(document.forms[1]){
			for(var i=0;document.forms[1].elements.length;i++){
				var element = document.forms[1].elements[i];
				var elName = element.name;
				switch(element.type){
					case "text":
					case "textarea":
						element.value = "";break;
					case "checkbox":
						element.checked = 0;break; 
					default:
						break;
				}
			}
		}
	}

</script>
<style>
	div.tags {float: left; background-color: #0080ff; margin-left:6px;  margin-bottom: 4px; font-size: 11px}
	tr.trBookmarkAlike, tr.trViewAlike, tr.trBookmarkAlikeConcise{
		display: none;
	}

</style>

<%
	response.setHeader("Access-Control-Allow-Origin","*");
	session=request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String col_id = (String)request.getParameter("col_id");
	String sql = "SELECT s.speaker_id,s.name,s.picURL,s.affiliation FROM col_speaker cs JOIN speaker s ON cs.speaker_id=s.speaker_id WHERE cs.col_id = " + col_id;
	ArrayList<String> speaker_id = new ArrayList<String>();
	ArrayList<String> speakers = new ArrayList<String>();
	ArrayList<String> pics = new ArrayList<String>();
	ArrayList<String> affiliations = new ArrayList<String>();
	
	connectDB conn = new connectDB();
	boolean multiSpeakers = false;
	try{
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			speaker_id.add(rs.getString("speaker_id"));
			speakers.add(rs.getString("name"));
			String imageSrc = rs.getString("picURL");
			if (imageSrc == null){
				imageSrc = "images/speaker/avartar.gif";
			}
			pics.add(imageSrc);
			affiliations.add(rs.getString("affiliation"));
		}
		if(speakers.size() > 1)	multiSpeakers = true;			
		
		rs.close();
	}catch(SQLException e){
		
	}
	sql = "SELECT c.title,date_format(c._date,_utf8'%b %d, %Y') _date," +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin," +
					"date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"c.detail,h.host_id,h.host,s.speaker_id,s.name,s.picURL,c.location," +
					"c.user_id,c.url,u.name owner,c.owner_id,lc.abbr,c.video_url,s.affiliation,c.slide_url,c.s_bio,c.paper_url " +
					"FROM colloquium c JOIN userinfo u ON c.owner_id = u.user_id " +
					"LEFT OUTER JOIN speaker s ON c.speaker_id=s.speaker_id " +
					"LEFT OUTER JOIN host h ON c.host_id = h.host_id " +
					"LEFT OUTER JOIN loc_col lc ON c.col_id = lc.col_id " +
					"WHERE c.col_id = " + col_id;
	
	try{
		ResultSet rs = conn.getResultSet(sql);
		if(!rs.next()){
%>
    	<title>
    		CoMeT | Colloquium Detail
	    </title>
	</head>
<body leftmargin="0" topmargin="0">
	<div align="center">
		<table width="1000" border="0" cellpadding="0" cellspacing="0" bordercolor="#0080ff">
			<tr>
				<td>
					<tiles:insert template="/includes/header.jsp" >
						<tiles:put name="title" value="CoMeT | Colloquium Detail"/>
					</tiles:insert>
				</td>
			</tr>
			<tr>
				<td>
					<span style="color: #003399;font-size: 0.9em;font-weight: bold;">Talk Not Found</span>

<%
		}else{
			String url = rs.getString("url");
			String title = rs.getString("title");
			String host = rs.getString("host");
			if(speakers.size() == 0){// (!multiSpeakers){
				speaker_id.add(rs.getString("speaker_id"));
				speakers.add(rs.getString("name"));
				String imageSrc = rs.getString("picURL");
				if (imageSrc == null){
					imageSrc = "images/speaker/avartar.gif";
				}
				pics.add(imageSrc);
				affiliations.add(rs.getString("affiliation"));
			}
			
			
			/* if(affiliation != null){
				if(!affiliation.equalsIgnoreCase("N/A")){
					speaker += ", " + affiliation;
				}
			} */
%>

<logic:notPresent name="UserSession">
<% 
	session.setAttribute("before-login-redirect", "presentColloquium.do?col_id=" + col_id);
%>
</logic:notPresent>
		<title>
    		CoMeT | <%=title %>
	    </title>
	</head>
<body topmargin="0">
	<div align="center">
		<table width="1000" border="0" cellpadding="0" cellspacing="0" bordercolor="#0080ff">
			<tr>
				<td>
					<tiles:insert template="/includes/header.jsp" >
						<tiles:put name="title" value="CoMeT | <%=title %>"/>
					</tiles:insert>
				</td>
			</tr>
			<tr>
				<td>
			<tr>
				<td>


<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td width="770" valign="top">
			<table width="100%" cellspacing="0" cellpadding="0" align="left" style="padding-right: 1px;">
				<tr>
					<td width="100%" colspan="3">

<% 
			String path = request.getContextPath();
			String basePath = request.getScheme()+"://"+request.getServerName()+path+"/";
			String paperPath = basePath + "presentColloquium.do?col_id=" + col_id;
%>
						<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
							<tr>
								<td align="center" width="25%">
									<script src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script>
									<fb:like href="<%=paperPath %>" layout="button_count" action="recommend"></fb:like>		
								</td>
								<td align="center" width="25%">
									<a href="http://twitter.com/share" class="twitter-share-button" data-text="<%=title %>" 
										data-url="<%=paperPath %>" data-count="horizontal">Tweet</a>
									<script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
								</td>
								<td align="center" width="25%">
									<!-- Place this tag where you want the +1 button to render -->
									<g:plusone size="medium"></g:plusone>
									
									<!-- Place this render call where appropriate -->
									<script type="text/javascript">
									  (function() {
									    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
									    po.src = 'https://apis.google.com/js/plusone.js';
									    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
									  })();
									</script>
<%-- 
									<!-- AddThis Button BEGIN -->
									<div class="addthis_toolbox addthis_default_style">
										<a class="addthis_counter addthis_pill_style" href="http://www.addthis.com/bookmark.php" 
											addthis:url="<%=paperPath %>" addthis:title="<%=title %>" ></a>
									</div>
									<script type="text/javascript">var addthis_config = {"data_track_clickback":true};</script>
									<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=chirayukong"></script>
									<!-- AddThis Button END -->
--%>								
								</td>
								<td align="center" width="25%">
									&nbsp;
								</td>
							</tr>	
						</table>

					</td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
<% 
			ResultSet rsExt;
			long userprofile_id = -1;			
			boolean usertagged = false;
			boolean userposted = false;
			String tags = "";
			String usertags = "";
			String notes = "";
			String _date = "";
			HashMap<String,Long> mapComm = new HashMap<String,Long>();
			if(ub != null){
				sql = "SELECT SQL_CACHE userprofile_id,usertags,comment,DATE_FORMAT(lastupdate,_utf8'%b %e, %Y %r') _date FROM userprofile u WHERE user_id = " + ub.getUserID() + " AND col_id = " + col_id;
				ResultSet rsBookmark = conn.getResultSet(sql);
				//Bookmarked or not?
				if(rsBookmark.next()){
					userprofile_id = rsBookmark.getLong("userprofile_id");
					usertags = rsBookmark.getString("usertags");
					notes = rsBookmark.getString("comment");
					_date = rsBookmark.getString("_date");
				}
				//Tagged or not?
				sql = "SELECT SQL_CACHE t.tag_id,t.tag FROM tags tt JOIN tag t ON tt.tag_id = t.tag_id WHERE LENGTH(t.tag) >0 AND tt.col_id = " + col_id;
				rsBookmark = conn.getResultSet(sql);
				while(rsBookmark.next()){
					tags += "<a href='tag.do?tag_id=" + rsBookmark.getString("tag_id") + "'>" + rsBookmark.getString("tag") + "</a>&nbsp;";
				}
				//Shared to groups or not?
				sql = "SELECT SQL_CACHE c.comm_id,c.comm_name FROM community c,contribute cc WHERE c.comm_id = cc.comm_id AND cc.userprofile_id = " + userprofile_id;
				rsBookmark = conn.getResultSet(sql);
				while(rsBookmark.next()){
					mapComm.put(rsBookmark.getString("comm_name"),Long.valueOf(rsBookmark.getString("comm_id")));
				}
				
				sql = "SELECT SQL_CACHE COUNT(*) _no FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
						"WHERE  tt.col_id = " + col_id + " AND tt.user_id=" + ub.getUserID() +
						" AND LENGTH(t.tag) > 0 GROUP BY t.tag_id ";
				rsExt = conn.getResultSet(sql);
				if(rsExt != null){
					while(rsExt.next()){
						long _no = rsExt.getLong("_no");
						if(_no > 0)usertagged = true;
					}
				}
				
				sql = "SELECT COUNT(*) _no FROM contribute WHERE (user_id=" + ub.getUserID() +
						" AND col_id=" + col_id + ") OR "+
						"userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE user_id=" + ub.getUserID() + 
						" AND col_id=" + col_id + ")";
				rsExt = conn.getResultSet(sql);
				if(rsExt != null){
					while(rsExt.next()){
						long _no = rsExt.getLong("_no");
						if(_no>0)userposted = true;
					}
				}
			}
%>
				<tr>
					<td colspan="3">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="140" colspan="2" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
									Colloquium Detail
								</td>
								<td width="630" align="right" style="background-color: #efefef;">
									<logic:present name="UserSession">
										<table border="0" cellspacing="0" cellpadding="0" width="100%" align="right" style="font-size: 0.85em;font-weight: bold;">
											<tr>
												<td align="right">
													<input id="btnbookcolid<%=col_id %>" type="button" class="btn" value="<%=userprofile_id > 0?"Unbookmark":"Bookmark" %>" 
														onclick="$('#spanBookmarkHeader').show();bookmarkTalk(<%=ub.getUserID() %>, <%=col_id %>, this, 'spanbookcolid<%=col_id %>')" />
												</td>
												<td align="right">
													<input id="btntagcolid<%=col_id %>" type="button" class="btn" value="<%=usertagged?"Edit Keywords":"Add Keywords" %>" 
														onclick="$('#spanBookmarkHeader').hide();$('#btnTagClose').val('Cancel');showPopupTag(<%=ub.getUserID() %>,<%=col_id %>,this,'.tdTagColID<%=col_id %>');addMoreTagInputRow();" />
												</td>
												<td align="right">
													<input id="btnpostcolid<%=col_id %>" type="button" class="btn" value="<%=userposted?"Edit Groups Posted":"Post to Groups" %>" 
														onclick="showPopupPost2Group(<%=ub.getUserID() %>,<%=col_id %>,this,'.tdGroupContributedColID<%=col_id %>');" />
												</td>
												<%-- Email Button Here --%>
												<td align="right">
													<input id="btnemailcolid<%=col_id %>" type="button" class="btn" value="Email" 
														onclick="showPopupEmailTalk(<%=ub.getUserID() %>,<%=col_id %>,this);" />
												</td>
<% 
			if(ub.isWritable()){
%>
												<td align="right">
													<input type="button" class="btn" name="btnEditTalk" value="Edit" onclick="redirect('PreColloquiumEntry.do?col_id=<%=col_id%>');">
												</td>
<% 
			}
%>
											</tr>
										</table>
									</logic:present>
								</td>
							</tr>
						</table>
					</td>
				</tr>
					<tr>
						<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Posted:</td>
						<td colspan="1" style="font-size: 0.75em;"><a href="profile.do?user_id=<%=rs.getString("owner_id")%>"><%=rs.getString("owner")%></a> <b>on</b>&nbsp;
<% 
			sql = "SELECT date_format(MIN(lastupdate),_utf8'%b %d %r') posttime " +
					"FROM (SELECT lastupdate FROM colloquium WHERE col_id = "+col_id+" " +
					"UNION " +
					"SELECT MIN(lastupdate) lastupdate FROM col_bk WHERE col_id = "+col_id+") ptime";
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String posttime = rsExt.getString("posttime");
%>
						<%=posttime%>
<%							
			}
%>
						</td>
						<td rowspan="6" valign="top">
							<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<% 
						
							for (int i = 0 ; i < speakers.size(); i++){
								
						%>
								<tr>
									<td style="align: right;<%=pics.get(i).equalsIgnoreCase("images/speaker/avartar.gif")||pics.get(i).equalsIgnoreCase("http://halley.exp.sis.pitt.edu/comet/images/speaker/avartar.gif")?"display: none;":"" %>"><img onload="DrawImage(this, 100, 100)"  src='<%= pics.get(i) %>' height="100" width="100" /> </td>
								</tr>
						<%
							}
						%>
							</table>
						</td>
					</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Title:</td>
					<td colspan="1" style="font-size: 0.9em;font-weight: bold;">
						<span id="aTitleColID<%=col_id %>"><%=title%></span>
						&nbsp;
						<span id="spanbookcolid<%=col_id %>" class="spanbookcolid<%=col_id %>" 
						style="display:<%=userprofile_id > 0?"inline":"none" %>;cursor: pointer;font-size: 1em;background-color: green;font-weight: bold;color: white;"
						onclick="window.location='myaccount.do'">&nbsp;Bookmarked&nbsp;</span>
					</td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Speaker:</td>
					<td valign="top">
						<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<% 
					
						for (int i = 0 ; i < speakers.size(); i++){
							
					%>
							<tr>
								<td style="vertical-align: top;font-size: 0.75em;"><a href="speakerprofile.do?speaker_id=<%=speaker_id.get(i) %>"><b><%=speakers.get(i)==null?"N/A":speakers.get(i) %></b></a></td>
							</tr>
							<tr>
								<td style="vertical-align: top;font-size: 0.75em;"><%=affiliations.get(i)==null?"N/A":affiliations.get(i) %></td>
							</tr>
					<%
						}
					%>
						</table>
					</td>
<%-- 
					<td rowspan="6" valign="top">
						<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<% 
					
						for (int i = 0 ; i < speakers.size(); i++){
							
					%>
							<tr>
								<td style="align: right;<%=pics.get(i).equalsIgnoreCase("images/speaker/avartar.gif")||pics.get(i).equalsIgnoreCase("http://halley.exp.sis.pitt.edu/comet/images/speaker/avartar.gif")?"display: none;":"" %>"><img onload="DrawImage(this, 100, 100)"  src='<%= pics.get(i) %>' height="100" width="100" /> </td>
							</tr>
					<%
						}
					%>
						</table>
					</td>
--%>
				</tr>
<% 
			if(host!=null){
				if(host.trim().length() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Host:</td>
					<td style="font-size: 0.75em;"><%=host%></td>
				</tr>
<%			
				}
			}
%>
<% 
		sql = "SELECT r.path FROM affiliate_col ac INNER JOIN relation r ON ac.affiliate_id = r.child_id WHERE ac.col_id = " + col_id;
		ResultSet rsSponsor = conn.getResultSet(sql);
		ArrayList<String> relationList = new ArrayList<String>();
		HashMap<String,String> aList = new HashMap<String,String>();
		while(rsSponsor.next()){
			String relation = rsSponsor.getString("path");
			relationList.add(relation);
			String[] _path = relation.split(",");
			for(int i=0;i<_path.length;i++){
				aList.put(_path[i],null);
			}
			
		}
		String affList = null;
		for(Iterator<String> i=aList.keySet().iterator();i.hasNext();){
			if(affList ==null){
				affList = "";
			}else{
				affList +=",";
			}
			affList +=i.next();
		}
		sql = "SELECT affiliate_id,affiliate FROM affiliate WHERE affiliate_id IN ("+affList+")";
		rsSponsor = conn.getResultSet(sql);
		while(rsSponsor.next()){
			aList.put(rsSponsor.getString("affiliate_id"),rsSponsor.getString("affiliate"));
		}
		rsSponsor.close();
		if(relationList.size()>0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Sponsor:</td>
					<td style="font-size: 0.75em;">
<% 
			for(int i=0;i<relationList.size();i++){
				String[] _path = relationList.get(i).split(",");
				for(int j=0;j<_path.length;j++){
%>
								<a href="affiliate.do?affiliate_id=<%=_path[j]%>"><%=(String)aList.get(_path[j])%>
									</a>
<%					
						if(j!=_path.length-1){
%>
								&nbsp;>&nbsp;
<%
						}
						if(j==_path.length-1){
%>
						<logic:present name="UserSession">
							&nbsp;
<% 
				int affno = 0;
				sql = "SELECT COUNT(*) _no FROM final_subscribe_affiliate WHERE affiliate_id=" + _path[j] + " AND user_id=" + ub.getUserID();
				rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					affno = rsExt.getInt("_no");
				}
%>
							<span class="spansubaid<%=_path[j] %>" id="spansubaid<%=_path[j] %>" 
								style="display: <%=affno==0?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
								onclick="window.location='affiliate.do?affiliate_id=<%=_path[j] %>'"><%=affno>0?"&nbsp;Subscribed&nbsp;":"" %>
							</span>&nbsp;
							<a class="asubsid<%=_path[j] %>" href="javascript:return false;" 					
								style="text-decoration: none;"
								onmouseover="this.style.textDecoration='underline'" 
								onmouseout="this.style.textDecoration='none'"
								onclick="subscribeAffiliation(<%=ub.getUserID() %>, <%=_path[j] %>, this, 'spansubaid<%=_path[j] %>')"
							><%=affno>0?"Unsubscribe":"Subscribe" %></a>
						</logic:present>					
<%							
						}
				}			
				if(i!=relationList.size()-1){
%>
								<br/>
<%
				}
			}
%>									
					</td>
				</tr>
<%		
		}
%>
<% 
		String _sql = "SELECT DISTINCT s.series_id,s.name FROM series s JOIN seriescol sc " +
						"ON s.series_id = sc.series_id WHERE sc.col_id=" + col_id;
		
		ResultSet rsSeries = conn.getResultSet(_sql);
		if(rsSeries.next()){
			String series_id = rsSeries.getString("series_id");
			String series_name = rsSeries.getString("name");
				
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left">Series:</td>
					<td style="font-size: 0.75em;">
						<a href="series.do?series_id=<%=series_id%>"><%=series_name%></a>
						<logic:present name="UserSession">
							&nbsp;
<% 
			int subno = 0;
			sql = "SELECT COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				subno = rsExt.getInt("_no");
			}
%>
							<span class="spansubsid<%=series_id %>" id="spansubsid<%=series_id %>" 
								style="display: <%=subno==0?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
								onclick="window.location='series.do?series_id=<%=series_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
							</span>&nbsp;
							<a class="asubsid<%=series_id %>" href="javascript:return false;" 					
								style="text-decoration: none;"
								onmouseover="this.style.textDecoration='underline'" 
								onmouseout="this.style.textDecoration='none'"
								onclick="subscribeSeries(<%=ub.getUserID() %>, <%=series_id %>, this, 'spansubsid<%=series_id %>')"
							><%=subno>0?"Unsubscribe":"Subscribe" %></a>
						</logic:present>					
					</td>
				</tr>
<%				
		}
		while(rsSeries.next()){
			String series_id = rsSeries.getString("series_id");
			String series_name = rsSeries.getString("name");
			
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left">&nbsp;</td>
					<td style="font-size: 0.75em;">
						<a href="series.do?series_id=<%=series_id%>"><%=series_name%></a>
						<logic:present name="UserSession">
							&nbsp;
<% 
			int subno = 0;
			sql = "SELECT COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				subno = rsExt.getInt("_no");
			}
%>
							<span class="spansubsid<%=series_id %>" id="spansubsid<%=series_id %>" 
								style="display: <%=subno==0?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
								onclick="window.location='series.do?series_id=<%=series_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
							</span>&nbsp;
							<a class="asubsid<%=series_id %>" href="javascript:return false;" 					
								style="text-decoration: none;"
								onmouseover="this.style.textDecoration='underline'" 
								onmouseout="this.style.textDecoration='none'"
								onclick="subscribeSeries(<%=ub.getUserID() %>, <%=series_id %>, this, 'spansubsid<%=series_id %>')"
							><%=subno>0?"Unsubscribe":"Subscribe" %></a>
						</logic:present>					
					</td>
				</tr>
<%				
		}
		rsSeries.close();
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left">Date:</td>
					<td style="font-size: 0.75em;"><%=rs.getString("_date")%> <%=rs.getString("_begin")%> - <%=rs.getString("_end")%></td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">URL:</td>
					<td style="font-size: 0.75em;"><a href="<%=url%>"><%=url%></a></td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Location:</td>
					<td style="font-size: 0.75em;"><%=rs.getString("location")%>
<% 
		String abbr = rs.getString("abbr");
		if(abbr != null){
%>
					&nbsp;(<a href="http://gis.sis.pitt.edu/CampusLocator/searchBuilding?abbr=<%=abbr%>">map</a>)
<%			
		}
%>					
					</td>
				</tr>
<% 
		String video = rs.getString("video_url");
		if(video!=null){
			if(video.length() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Video:</td>
					<td style="font-size: 0.75em;">
<%
				if(video.length() > 7){
%>
						<a href="<%=video%>"><%=video%></a>
<%					
				}else{
%>
						<%=video%>
<%					
				}
%>
					</td>
				</tr>
<%
			}
		}

		String slide = rs.getString("slide_url");
		if(slide!=null){
			if(slide.length() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Slide:</td>
					<td style="font-size: 0.75em;">
<%
				if(slide.length() > 7){
%>
						<a href="<%=slide%>"><%=slide%></a>
<%					
				}else{
%>
						<%=slide%>
<%					
				}
%>
					</td>
				</tr>
<%
			}
		}

		String paper = rs.getString("paper_url");
		if(paper!=null){
			if(paper.length() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Paper:</td>
					<td style="font-size: 0.75em;">
<%
				if(paper.length() > 7){
%>
						<a href="<%=paper%>"><%=paper%></a>
<%					
				}else{
%>
						<%=paper%>
<%					
				}
%>
					</td>
				</tr>
<%
			}
		}
			
%>
				<tr class="trTagColID<%=col_id %>" style="<%=tags.length()>0?"":"display: none;" %>">
					<td style="vertical-align: top;font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Keywords:</td>
					<td class="tdTagColID<%=col_id %>" colspan="2" style="vertical-align: top;font-size: 0.75em;"><%=tags %></td>
				</tr>
<%			
		//Posted Groups
		String communities = "";		
		sql = "SELECT c.comm_id,c.comm_name FROM community c JOIN contribute ct ON c.comm_id = ct.comm_id " +
				"WHERE  ct.col_id = " + col_id +
				" OR ct.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id=" + col_id + ")" +
				" GROUP BY c.comm_name,c.comm_id";
		rsExt = conn.getResultSet(sql);
		if(rsExt != null){
			while(rsExt.next()){
				String comm_name = rsExt.getString("comm_name");
				long comm_id = rsExt.getLong("comm_id");
				if(comm_name.length() > 0){
					communities += "<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>&nbsp;"; 
				}
			}
		}
%>
				<tr class="trGroupContributedColID<%=col_id %>" style="<%=communities.length()>0?"":"display: none;" %>">
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Groups Posted:</td>
					<td class="tdGroupContributedColID<%=col_id %>" colspan="2" style="vertical-align: top;font-size: 0.75em;"><%=communities %></td>
				</tr>
<% 
		//Bookmark by
		String bookmarks = "";
		sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u JOIN userprofile up " +
				"ON u.user_id = up.user_id WHERE up.col_id = " + col_id;
		sql +=	" GROUP BY u.user_id,u.name ORDER BY up.lastupdate DESC,u.name";
		rsExt.close();
		rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				String user_name = rsExt.getString("name");
				long user_id = rsExt.getLong("user_id");
				long _no = rsExt.getLong("_no");
				if(user_name.length() > 0){
					bookmarks += "&nbsp;<a href=\"profile.do?user_id=" + user_id + "\">" + user_name + "</a>";				
				}
			}
		}
%>
				<tr class="trWhomBookmarkColID<%=col_id %>" style="<%=bookmarks.length()>0?"":"display: none;" %>">
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Bookmarked by:</td>
					<td class="tdWhomBookmarkColID<%=col_id %>" colspan="2" style="vertical-align: bottom;font-size: 0.75em;"><%=bookmarks %></td>
				</tr>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Detail:</td>
					<td colspan="2" style="font-size: 0.75em;"><%=rs.getString("detail")%></td>
				</tr>
<% 
		String s_bio = rs.getString("s_bio");
		if(s_bio!=null){
			if(s_bio.length() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Bio:</td>
					<td colspan="2" style="font-size: 0.75em;"><%=s_bio%></td>
				</tr>
<%
			}
		}

		sql = "SELECT a.area_id,a.area FROM area a JOIN area_col ac ON a.area_id=ac.area_id WHERE ac.col_id=" + col_id + 
				" GROUP BY a.area_id,a.area ORDER BY a.area";
		rs = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> areaMap = new LinkedHashMap<Integer,String>();
		while(rs.next()){
			int area_id = rs.getInt("area_id");
			String area = rs.getString("area");
			areaMap.put(area_id,area);
		}
		
		if(areaMap.size() > 0){
%>
				<tr>
					<td style="font-size: 0.75em;font-weight: bold;" width="10%" align="left" valign="top">Interest Area:</td>
<%
			String talk_areas = "";
			for(String area : areaMap.values()){
				if(!talk_areas.equalsIgnoreCase("")){
					talk_areas += ", ";
				}
				talk_areas += area;
			}
%>
					<td colspan="2" style="font-size: 0.75em;vertical-align: top;"><%=talk_areas %></td>
				</tr>
<%
		}
		
		if(bookmarks.trim().length() > 0){
%>
				<tr class="trBookmarkAlike">
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr class="trBookmarkAlike">
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr class="trBookmarkAlike">
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						People Who Bookmarked This Colloquium, Also Bookmarked
					</td>
				</tr>
				<tr class="trBookmarkAlike">
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr class="trBookmarkAlike">
					<td colspan="3" id="tdBookmarkAlike">
						<script type="text/javascript">
							$(document).ready(function(){
								$.get('utils/loadTalks.jsp',{bookmarked_alike_col_id: <%=col_id %>, rows: 3},
									function(data){
										var str = $.trim($("td#lblNoTalk",data).text());
										if(str !== "No Talks"){
											$("#tdBookmarkAlike").html(data);
											$(".trBookmarkAlike").show();
										}
									}
								);
							});
						</script>
					</td>
				</tr>				
<%			
		}else{
%>
				<tr class="trViewAlike">
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr class="trViewAlike">
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr class="trViewAlike">
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						People Who Viewed This Colloquium, Also Viewed
					</td>
				</tr>
				<tr class="trViewAlike">
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr class="trViewAlike">
					<td colspan="3" id="tdViewAlike">
						<script type="text/javascript">
							$(document).ready(function(){
								$.get('utils/loadTalks.jsp',{viewed_alike_col_id: <%=col_id %>, rows: 3},
									function(data){
										var str = $.trim($("td#lblNoTalk",data).text());
										if(str !== "No Talks"){
											$("#tdViewAlike").html(data);
											$(".trViewAlike").show();
										}
									}
								);
							});
						</script>
					</td>
				</tr>				
<%		
		}
		//Insert time log
		long uid = 0;
		if(ub != null){
			uid = ub.getUserID();
		} 
		String sessionID = session.getId();
		Cookie cookies[] = request.getCookies();
		//Find session id
		boolean foundSessionID = false;
		if(cookies != null){
			for(int i=0;i<cookies.length;i++){
				Cookie c = cookies[i];
			    if (c.getName().equalsIgnoreCase("sessionid")) {
			        sessionID = c.getValue();
			    	foundSessionID = true;
			    }			
			}
		}
		String ipaddress = request.getRemoteAddr();
		sql = "INSERT INTO talkview (user_id,viewTime,col_id,ipaddress,sessionid) VALUES (" + uid + ",NOW()," + col_id + ",'" + ipaddress + "','" + sessionID + "')";
		conn.executeUpdate(sql);

		if(ub != null){
			sql = "SELECT usernote FROM usernote WHERE user_id=" + ub.getUserID() + " AND col_id=" + col_id;
			String usernote = "";
			rs = conn.getResultSet(sql);
			if(rs.next()){
				usernote = rs.getString("usernote");
			}
%>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						Your private note
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									<textarea id="txtUserNote" name="txtUserNote" rows="15" cols="100"><%=usernote %></textarea>
<%-- 
									<script type="text/javascript"> 
									//<![CDATA[
					 
										// This call can be placed at any point after the
										// <textarea>, or inside a <head><script> in a
										// window.onload event handler.
					 
										// Replace the <textarea id="editor"> with an CKEditor
										// instance, using default configurations.
										//CKEDITOR.replace( 'txtUserNote'
											/*,{ toolbar:[
													['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink']
												]
											}*/
										//);
					 
									//]]>
									</script> 
--%>
								</td>
							</tr>
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="3">
									<input id="btnSaveNote" type="button" class="btn" value="Save Note"
										onclick="saveNote(<%=col_id %>,$('#txtUserNote'),$('#spanSavingNoteProgress'));return false;"
										/>
									<span id="spanSavingNoteProgress">&nbsp;</span>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td colspan="3" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						Rate relevance of this talk (0 CoMeT: not at all - 5 CoMeTs: totally relevant)
					</td>
				</tr>
				<tr>
					<td colspan="3"><tiles:insert template="/SliderBarFeedback.html" /></td>
				</tr>
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td width="110" valign="top">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
				<tr>
					<td>
						<tiles:insert template="/utils/feed.jsp?header=Export&onecol=1&norss=1&noatom=1&nogcal=1" />
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<tiles:insert template="/utils/impact.jsp" />
					</td>
				</tr>
				<logic:present name="UserSession">
				<tr>
					<td>
						<tiles:insert template="/utils/tagCloud.jsp" />
					</td>
				</tr>
				</logic:present>
<%-- 
				<tr>
					<td>
						<tiles:insert template="/utils/scholarCitationStat.jsp" />
					</td>
				</tr>
--%>
<% 
			if(bookmarks.trim().length() > 0){
%>
<%-- 
				<tr class="trBookmarkAlikeConcise">
					<td>&nbsp;</td>
				</tr>
				<tr class="trBookmarkAlikeConcise">
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr class="trBookmarkAlikeConcise">
					<td bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
						People Who Bookmarked This Colloquium, Also Bookmarked
					</td>
				</tr>
				<tr class="trBookmarkAlikeConcise">
					<td>&nbsp;</td>
				</tr>
				<tr class="trBookmarkAlikeConcise">
					<td id="tdBookmarkAlikeConcise">
						<script type="text/javascript">
							$(document).ready(function(){
								$.get('utils/loadTalks.jsp',{bookmarked_alike_col_id: <%=col_id %>, rows: 2},
									function(data){
										$("#tdBookmarkAlike").html(data);
										$(".trBookmarkAlike").show();
									}
								);
						
								$.get('utils/loadTalks.jsp',{bookmarked_alike_col_id: <%=col_id %>, rows: 2, concise: 1},
									function(data){
										$("#tdBookmarkAlikeConcise").html(data);
										$(".trBookmarkAlikeConcise").show();
									}
								);
						
							});
						</script>
					</td>
				</tr>				
--%>
<%			
			}
%>
				<logic:present name="UserSession">
<%-- 
					<tr>
						<td valign="top">
							<tiles:insert template="/utils/postTalk2Group.jsp" />
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td valign="top">
							<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
								<tr>
									<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
										Named Entities
									</td>
								</tr>
								<tr>
									<td align="left" id="tdNamedEntity">
										<a href="javascript: return false;" onclick="$('#tdNamedEntity').html('<img border=\'0\' src=\'images/loading-small.gif\' />');$('#tdNamedEntity').load('utils/namedEntity.jsp?col_id=<%=col_id %>');">Show Named Entities</a>
									</td>
								</tr>
							</table>
							<tiles:insert template="/utils/namedEntity.jsp" />
						</td>
					</tr>
--%>
					<tr>
						<td>
							<tiles:insert template="/utils/loadComments.jsp" />
						</td>
					</tr>
				</logic:present>
			</table>
		</td>
	</tr>
</table>
<%
		}
		rs.close();	
		conn.conn.close();
		conn = null;																					
	}catch(SQLException e){
		
	}
%>		
				</td>
			</tr>
			<tr>
				<td>
					<tiles:insert template="/includes/footer.jsp"/>			
				</td>
			</tr>
		</table>
	</div>				

</body>
</html>
