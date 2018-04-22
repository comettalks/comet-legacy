<%@ page language="java"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%
connectDB conn = new connectDB();
String sql = "update colloquia.extmapping set ext_id =? where ext_id= ? and exttable ='extprofile.linkedin'";

 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">

<head>
<link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css"/>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"> 
</script> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"> 
</script> 


<script type="text/javascript" src="scripts/jquery.cookie.js">
</script> 
<link rel="stylesheet" href="css/jquery.autocomplete.css" type="text/css" />
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script type='text/javascript' src='scripts/jquery.bgiframe.min.js'></script>
<script type='text/javascript' src='scripts/jquery.autocomplete.js'></script>

<link href="css/stylesheet.css" rel="stylesheet" media="grey" />  


<script src="http://connect.facebook.net/en_US/all.js"></script>

<style>
input.btn { 
	color:#003399; 
	font: bold 0.7em verdana,helvetica,sans-serif; 
	background-color: #99CCFF; 
	border: 2px solid; 
	border-color: #0066CC #003366 #003366 #0066CC; 
	filter:progid:DXImageTransform.Microsoft.Gradient (GradientType=0,StartColorStr='#ffffffff',EndColorStr='#ffeeddaa'); 
}
a.hiddenlist,a.hiddenlist:visited{
	background-color: white;
	border-left: 1px solid white;
	border-right: 1px solid white;
	text-decoration:none;
	color: black;
}
a.shownlist,a.shownlist:visited{
	background-color: #003366;
	border: 1px solid #003366;
	text-decoration:none;
	color: white;
}
div.hiddenlist{
	display: none;	
}
div.shownlist{
	display: block;
	position:absolute;
	right: 0;
	border: 1px solid #003366;
	width: 200px;
	text-align: left;
	background-color: #efefef;
	/*padding-left: 0;
	margin-left: 0;*/
} 
div.showlist ul{
	list-style-type: none;
	margin: 0;
	padding: 0;
	border: 1px solid #003366;
	width: 100%;
}
div.shownlist ul li{
	float: left;
	margin: 0;
	border-top: 1px solid #003366;
	width: 100%;
}
div.shownlist table{
	width: 100%;
	padding: 0;
	border: 0;
	margin: 0;
}
</style>

	
<script type="text/javascript">

	/*	
 $(document).ready(function(){
		
		$(window).scroll(function(){
			
			if  ($(window).scrollTop() <= $(document).height() - $(window).height() -20){
				
				if($('#fbDiv').attr("class") == "fb")
				{
					last_fb_friend_funtion();
				}else
				{
			   		last_linkedIn_friend_funtion();
				}
			}
		}); 
		
	});
 
*/
	






</script>
</head>
<body>
<div id="fbDiv" class="type"></div>
<table width=35% border="0" cellpadding="0" cellspacing="0" style="font-size:0.9em;">
					<tr style="aline:center">
						<td width="90">
							<div id="faceConnectionBtn" style="background:#003399; color: #ffffff;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="initialization('facebook');">
								Facebook
							</div>
							
						</td>
						<td>
						&nbsp;&nbsp;
						</td>
						<td width="90">
							<div id="linkConnectionBtn" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="initialization('linkedIn');">
								LinkedIn
							</div>
							
						</td>
						<td>
						&nbsp;&nbsp;
						</td>
						<td width="120">
							<div id="friendTalksBtn" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="initialization('friendsTalks');">
								Friends' Talks
							</div>
						
						</td>
						
						
					</tr>
</table>
<br/>
<div style="display:inline;float:left;font-size:0.9em;" id="orderByDIV"></div>
<div style="display:inline;float:left;font-size:0.9em;" id="pageSizeDIV"></div>
<div style="display:inline;float:left;font-size:0.9em;" id="PagesDIV"></div>
<br/><br/>

<div id="fbfriends"></div>

<div id="linkInfriends"></div>

<div id="friendsTalksDiv">
</div>

</body>

</html>

