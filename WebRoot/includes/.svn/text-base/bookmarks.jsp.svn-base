<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<!-- calendar stylesheet -->

<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%><link rel="stylesheet" type="text/css" media="all" href="css/calendar-win2k-cold-1.css" title="win2k-cold-1" />

<!-- main calendar program -->
<script type="text/javascript" src="scripts/calendar.js"></script>

<!-- language for the calendar -->
<script type="text/javascript" src="scripts/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
     adding a calendar a matter of 1 or 2 lines of code. -->
<script type="text/javascript" src="scripts/calendar-setup.js"></script>

<script type="text/javascript" src="ckeditor/ckeditor.js"></script>	
<script src="ckeditor/_samples/sample.js" type="text/javascript"></script> 
<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css"/>		
<script src="http://connect.facebook.net/en_US/all.js"></script>
<script type="text/javascript" src="http://platform.linkedin.com/in.js">
  api_key: O9aW2MKcw2Uwv42xuFnfBywwYQ4oSdAkBL7NtNyCYUktF7v0Jcs8uKwmqSDOnxl8
  authorize: true
</script>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link media="all" type="text/css" href="http://developer.linkedinlabs.com/tutorials/css/jqueryui.css" rel="stylesheet"/>
  <script type="text/javascript" src="http://code.jquery.com/jquery-1.5b1.js"></script>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/jquery-ui.min.js"></script> 
<%-- 
<link type="text/css" href="css/jquery-ui-1.8.5.custom.css" rel=
  "stylesheet" /> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"> 
</script> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"> 
</script> 
--%>
<% 
	connectDB conn = new connectDB();
	session=request.getSession(false);
	String menu = (String)session.getAttribute("menu");
	String _v = (String)session.getAttribute("v");
	String t = (String)request.getParameter("t");
	String v = (String)request.getParameter("v");
	String user_id = (String)request.getParameter("user_id");
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	//Find friendship btw u and other
	if(ub!=null&&user_id!=null){
		String user0_id = user_id;
		String user1_id = "" + ub.getUserID();
		if(Integer.parseInt(user0_id) > ub.getUserID()){
			user0_id = "" + ub.getUserID();
			user1_id = user_id;
		}
		
	}

    String sql;// = "SELECT MIN(_date) mindate FROM colloquium WHERE _date >= CURDATE()";
    ResultSet rs;// = conn.getResultSet(sql);
    Calendar calendar = new GregorianCalendar();
    int req_day = -1;
    int req_week = -1;
    int req_month = calendar.get(Calendar.MONTH)+1;
    int req_year = calendar.get(Calendar.YEAR);
    if(request.getParameter("day")!=null){
        req_day = Integer.parseInt(request.getParameter("day"));
        //out.print("day: " + req_day);
    }
    
    if(request.getParameter("week")!=null){
        req_week = Integer.parseInt(request.getParameter("week"));
        //out.print("week: " + req_week);
    }
    
    if(request.getParameter("month")!=null){
        req_month = Integer.parseInt(request.getParameter("month"));
        //out.print("month: " + req_month);
    }
    
    if(request.getParameter("year")!=null){
        req_year = Integer.parseInt(request.getParameter("year"));
        //out.print("year: " + req_year);
    }else{
    	req_week = calendar.get(Calendar.WEEK_OF_MONTH);
    }

	if(t!=null&&menu!=null){
		if(t.equalsIgnoreCase("profile")&&menu.equalsIgnoreCase("myaccount")&&v==null){
			v="activity";
		}
	}
	
	if(_v!=null){
		v = _v;
		session.removeAttribute("v");
	}
	
	if(user_id!=null&&v==null){
		//This is ad-hoc page because we should choose v=activity if its user_id is friend of the user unless choosing v=info
		v="info";
		if(ub!=null){
			String user0_id = user_id;
			String user1_id = "" + ub.getUserID();
			
			if(Integer.parseInt(user_id) > ub.getUserID()){
				user0_id = "" + ub.getUserID();
				user1_id = user_id;
			}
			
			sql = "SELECT SQL_CACHE friend_id FROM friend WHERE user0_id=" + user0_id + " AND user1_id=" + user1_id + 
						" AND breaktime IS NULL";
			
			rs = conn.getResultSet(sql);
			if(rs.next()){
				v="activity";
			}
		}
	}
	if(t==null&&v==null){
		v="bookmark";
	}
%>
<style type="text/css"> 
    .auto-hint { color: #AAAAAA; }
    .icon-show { display: block; width: 50px;}
    .icon-hide { display: none; }
</style> 
<script type="text/javascript"><!--
	var isBookmark = 1;//0: Post;1: Bookmark;2: Impact;3: Impact Summary;4: Activity;5: Info;6:connection
<% 
	if(v!=null){
		if(v.equalsIgnoreCase("post")){
%>
	isBookmark = 0;
<%			
		}
		if(v.equalsIgnoreCase("bookmark")){
%>
	isBookmark = 1;
<%			
		}
		if(v.equalsIgnoreCase("impact")){
%>
	isBookmark = 2;
<%			
		}
		if(v.equalsIgnoreCase("summary")){
%>
	isBookmark = 3;
<%			
		}
		if(v.equalsIgnoreCase("activity")){
%>
	isBookmark = 4;
<%			
		}
		if(v.equalsIgnoreCase("info")){
%>
	isBookmark = 5;
<%			
		}
		
		if(v.equalsIgnoreCase("connection")){
%>
	isBookmark = 6;
<%			
		}
		
	}
%>
	var period = 1;//0: day; 1: week; 2: month
	var queryString = window.location.search;
	if(queryString!=null){
		queryString = queryString.substr(1,queryString.length-1);
	}
	var oIFrame = null;
	var oTalkIFrame = null;
	var oDeleteTalkIFrame = null;
	var oCalExtIFrame = null;
	var oSelfTalkIFrame = null;
	var now = new Date();
	var _day = <%=req_day<=0?"now.getDate()":req_day %>;
	//var _dayWeek = now.getDay();
	var _month = <%=req_month<=0?"now.getMonth() + 1":req_month %>;
	var _year = <%=req_year<=0?"now.getYear()":req_year %>;
	if(_year < 1900){
		_year += 1900;
	}
	/***********************************************/
	/* Initialization                              */
	/***********************************************/
	window.onload = function() {
	}
	/***********************************************/
	/* Ajax Script                                 */	
	/***********************************************/
	function createIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenFrame";
			iframe.id = "hiddenFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oIFrame = frames["hiddenFrame"];
		}else{
			window.setTimeout(function(){createIFrame();},50);
		}
	}
	function createTalkIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenTalkFrame";
			iframe.id = "hiddenTalkFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oTalkIFrame = frames["hiddenTalkFrame"];
		}else{
			window.setTimeout(function(){createTalkIFrame();},50);
		}
	}
	function createDeleteTalkIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenDeleteTalkFrame";
			iframe.id = "hiddenDeleteTalkFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oDeleteTalkIFrame = frames["hiddenDeleteTalkFrame"];
		}else{
			window.setTimeout(function(){createDeleteTalkIFrame();},50);
		}
	}
	function createCalExtIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenCalExtFrame";
			iframe.id = "hiddenCalExtFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oCalExtIFrame = frames["hiddenCalExtFrame"];
		}else{
			window.setTimeout(function(){createCalExtIFrame();},50);
		}
	}

	function getExtFBProfile(profileID){
		if(document.getElementById("tdFacebook")){
			var tdFacebook = document.getElementById("tdFacebook");
			$.get("profile/facebookProfile.jsp", {fAutoID: profileID},
					function(data){
						tdFacebook.innerHTML = data;
					}
				);
		}
		//alert(profileID);
	}

	function getExtInProfile(profileID){
		if(document.getElementById("tdLinkedIn")){
			var tdLinkedIn = document.getElementById("tdLinkedIn");
			$.get("profile/linkedinProfile.jsp", {lAutoID: profileID},
					function(data){
						tdLinkedIn.innerHTML = data;
					}
				);
		}
	}

	function getExtMDProfile(profileID){
		if(document.getElementById("tdMendeley")){
			var tdMendeley = document.getElementById("tdMendeley");
			$.get("profile/mendeleyProfile.jsp", {profile_id: profileID},
					function(data){
						tdMendeley.innerHTML = data;
					}
				);
		}
		//alert(profileID);
	}

	function showOlderPosts(uid,divPost,timeStamp){
		var divOlderPosts = document.getElementById(divPost);
		if(divOlderPosts){
			divOlderPosts.innerHTML = "<div align='center'><img border='0' src='images/loading.gif' /></div>";
			$.get("profile/recentActivity.jsp",{user_id: uid,appendlast: 1,timestamp: timeStamp},
				function(data){
					//divOlderPosts.style.display = "none";
					//var tdRecentActivity = document.getElementById("tdRecentActivity");
					//tdRecentActivity.innerHTML = tdRecentActivity.innerHTML.concat(data);
					divOlderPosts.innerHTML = data;
				}
			);
		}	

	}			

	function showOlderFeedPosts(uid,divPost,timeStamp){
		var divOlderPosts = document.getElementById(divPost);
		if(divOlderPosts){
			divOlderPosts.innerHTML = "<div align='center'><img border='0' src='images/loading.gif' /></div>";
			$.get("profile/recentActivity.jsp",{user_id: uid,appendlast: 1,timestamp: timeStamp, showstream: 1},
				function(data){
					//divOlderPosts.style.display = "none";
					//var tdRecentActivity = document.getElementById("tdRecentActivity");
					//tdRecentActivity.innerHTML = tdRecentActivity.innerHTML.concat(data);
					divOlderPosts.innerHTML = data;
				}
			);
		}	

	}			

	function showOlderTalks(strPara){
		if(!oSelfTalkIFrame){
			createSelfTalkIFrame();
			window.setTimeout(function(){showOlderTalks(strPara);},40);
			return;
		}else{
			var divOlderTalks = document.getElementById("divOlderTalks");
			if(divOlderTalks){
				divOlderTalks.innerHTML = "<div align='center'><img border='0' src='images/loading.gif' /></div>";
			}	
			var action = "utils/loadTalks.jsp?insertfirst=1";
			/*var queryString = window.location.search;
			if(queryString!=null){
				queryString = queryString.substr(1,queryString.length-1);
				action = action.concat('&',queryString);
			}*/
			if(strPara!=null){
				action = action.concat('&',strPara);
			}
			oSelfTalkIFrame.location = action;

			//action = "utils/namedEntity.jsp?insertfirst=1";
			/*if(queryString!=null){
				action = action.concat('&',queryString);
			}*/
			//loadExtension(action);		
				
		}			
	}

	function createSelfTalkIFrame(){
		if(document.body){
			var iframe = document.createElement("iframe");
			iframe.name = "hiddenSelfTalkFrame";
			iframe.id = "hiddenSelfTalkFrame";
			iframe.style.position = 'absolute';
			iframe.style.border = '0px';
			iframe.style.width = '0px';
			iframe.style.height = '0px';
			if(document.body.firstChild){
				document.body.insertBefore(iframe, document.body.firstChild);
			}else{
				document.body.appendChild(iframe);
			}
			oSelfTalkIFrame = frames["hiddenSelfTalkFrame"];
		}else{
			window.setTimeout(function(){createSelfTalkIFrame();},40);
		}
	}

	function insertTalks(htmlTalks){
		var divMain = document.getElementById("divMain");
		divMain.innerHTML = htmlTalks.concat(divMain.innerHTML); 
		var divOlderTalks = document.getElementById("divOlderTalks");
		if(divOlderTalks){
			divOlderTalks.innerHTML = "&nbsp;";
			divOlderTalks.style.display = "none";
			divOlderTalks.style.height = "0px";
			divOlderTalks.style.overflow = "hidden";
		}
		var lblNoTalk = document.getElementById("lblNoTalk");
		if(lblNoTalk){
			lblNoTalk.style.display = "none";
		}		
	}

	function appendTalks(htmlTalks){
		var divMain = document.getElementById("divMain");
		divMain.innerHTML = divMain.innerHTML.concat(htmlTalks); 
	}

	function loadTalks(action){
		/*displayTalks("<div align='center'><img border='0' src='images/loading.gif' /></div>");
		if(!oTalkIFrame){
			createTalkIFrame();
			window.setTimeout(function(){loadTalks(action);},40);
			return;
		}else{
			oTalkIFrame.location = action;
		}*/
		if($('#divTalks').length){
			$("#divTalks").html("<div align='center'><img border='0' src='images/loading.gif' /></div>");
			$.get(action,function(data){
				$("#divTalks").html(data);
			});		
		}
	}
	function displayTalks(htmlTalks){
		divTalks.innerHTML = htmlTalks;
	}
	function loadCalendar(action){
		/*if(!oIFrame){
			createIFrame();
			window.setTimeout(function(){loadCalendar(action);},40);
			return;
		}else{
			oIFrame.location = action;
		}*/
		if($('#divCal').length){
			$("#divCal").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");
			$.get(action, function(data){
				$("#divCal").html(data);
			});
		}		
	}	
	function displayCalendar(htmlCalendar){
		divCal.innerHTML = htmlCalendar;
	}
	function loadExtension(action){
		//alert(action);
		/*if(typeof divExtension != 'undefined'){
			displayExtension("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");
			if(!oCalExtIFrame){
				//alert("No oCalExtIFrame");
				createCalExtIFrame();
				window.setTimeout(function(){loadExtension(action);},40);
				return;
			}else{
				//alert("Loading extension");
				oCalExtIFrame.location = action;			
			}
			$("#divExtension").html("<div align='center'><img border='0' src='images/loading.gif' /></div>");
			$.get(action,function(data){
				$("#divExtension").html(data);
			});		
		}*/
		if($('#divExtension').length){
			$("#divExtension").html("<div align='center'><img border='0' src='images/loading.gif' /></div>");
			$.get(action,function(data){
				$("#divExtension").html(data);
			});		
		}	
	}	
	function displayExtension(htmlExtension){
		//var divExtension = document.getElementById("divExtension");
		if($('#divExtension') != null){
			$('#divExtension').html(htmlExtension);
		}else{
			//alert("No divExtension");
		}
	}
	function loadResearchArea(action){
		//alert(action);
		if($('#divResearchArea').length){
			$("#divResearchArea").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");
			$.get(action,function(data){
				$("#divResearchArea").html(data);
			});
		}else{
			//alert("No #divResearchArea Found!!!");
		}
	}
	/***********************************************/
	/* Utility Function                            */
	/***********************************************/
	function daysInMonth(year,month){
		return 32 - (new Date(year,month-1,32)).getDate();	
	}
	function getWeekNoInMonth(year,month,day){
		var first = new Date(year,month-1,1);
		var startday = first.getDay();
		return Math.ceil((startday + day)/7);
		
	}
	/***********************************************/
	/* Account Navigation Script                   */
	/***********************************************/
	function flip2Activity(){
		if($('#divBtnActivity').length){
			$('#divBtnActivity').css('background','#003399');
			$('#divBtnActivity').css('color','#ffffff');
			$('#divBtnActivity').css('font-weight','bold');
			$('#divBtnActivity').hover(
				function(){
					this.style.background='#003399';this.style.color='#ffffff';
				},
				function(){
					this.style.background='#ffffff';this.style.color='#003399';
				}
			);
			//$('#divBtnActivity').onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			//$('#divBtnActivity').onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}
		
		if($('#divBtnInfo').length){
			divBtnInfo.style.background = "#ffffff";
			divBtnInfo.style.color = "#003399";
			divBtnInfo.style.fontWeight = "normal";
			divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnBookmark').length){
			divBtnBookmark.style.background = "#ffffff";
			divBtnBookmark.style.color = "#003399";
			divBtnBookmark.style.fontWeight = "normal";
			divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnPost').length){
			divBtnPost.style.background = "#ffffff";
			divBtnPost.style.color = "#003399";
			divBtnPost.style.fontWeight = "normal";
			divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnImport').length){
			divBtnImpact.style.background = "#ffffff";
			divBtnImpact.style.color = "#003399";
			divBtnImpact.style.fontWeight = "normal";
			divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnImpactSummary').length){
			divBtnImpactSummary.style.background = "#ffffff";
			divBtnImpactSummary.style.color = "#003399";
			divBtnImpactSummary.style.fontWeight = "normal";
			divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}

		if($('#divBtnConnection').length){
			divBtnConnection.style.background = "#ffffff";
			divBtnConnection.style.color = "#003399";
			divBtnConnection.style.fontWeight = "normal";
			divBtnConnection.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnConnection.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}
	
		isBookmark = 4;
		
		loadActivity();
	}
	function flip2Info(){
		if($('divBtnActivity').length){
			divBtnActivity.style.background = "#ffffff";
			divBtnActivity.style.color = "#003399";
			divBtnActivity.style.fontWeight = "normal";
			divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnInfo').length){
			divBtnInfo.style.background = "#003399";
			divBtnInfo.style.color = "#ffffff";
			divBtnInfo.style.fontWeight = "bold";
			divBtnInfo.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnInfo.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}
		
		if($('#divBtnBookmark').length){
			divBtnBookmark.style.background = "#ffffff";
			divBtnBookmark.style.color = "#003399";
			divBtnBookmark.style.fontWeight = "normal";
			divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnPost').length){
			divBtnPost.style.background = "#ffffff";
			divBtnPost.style.color = "#003399";
			divBtnPost.style.fontWeight = "normal";
			divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnImport').length){
			divBtnImpact.style.background = "#ffffff";
			divBtnImpact.style.color = "#003399";
			divBtnImpact.style.fontWeight = "normal";
			divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnImpactSummary').length){
			divBtnImpactSummary.style.background = "#ffffff";
			divBtnImpactSummary.style.color = "#003399";
			divBtnImpactSummary.style.fontWeight = "normal";
			divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}

		if($('#divBtnConnection').length){
			divBtnConnection.style.background = "#ffffff";
			divBtnConnection.style.color = "#003399";
			divBtnConnection.style.fontWeight = "normal";
			divBtnConnection.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnConnection.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}
		
		isBookmark = 5;

		loadInfo();
	}

	function flip2Impact(){
		if($('#divBtnActivity').length){
			divBtnActivity.style.background = "#ffffff";
			divBtnActivity.style.color = "#003399";
			divBtnActivity.style.fontWeight = "normal";
			divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
		}
		
		if($('#divBtnInfo').length){
			divBtnInfo.style.background = "#ffffff";
			divBtnInfo.style.color = "#003399";
			divBtnInfo.style.fontWeight = "normal";
			divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}


		if($('#divBtnBookmark').length){
			divBtnBookmark.style.background = "#ffffff";
			divBtnBookmark.style.color = "#003399";
			divBtnBookmark.style.fontWeight = "normal";
			divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnPost').length){
			divBtnPost.style.background = "#ffffff";
			divBtnPost.style.color = "#003399";
			divBtnPost.style.fontWeight = "normal";
			divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnImpact').length){
			divBtnImpact.style.background = "#003399";
			divBtnImpact.style.color = "#ffffff";
			divBtnImpact.style.fontWeight = "bold";
			divBtnImpact.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnImpact.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}
		
		if($('#divBtnImpactSummary').length){
			divBtnImpactSummary.style.background = "#ffffff";
			divBtnImpactSummary.style.color = "#003399";
			divBtnImpactSummary.style.fontWeight = "normal";
			divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}

		if($('#divBtnConnection').length){
			divBtnConnection.style.background = "#ffffff";
			divBtnConnection.style.color = "#003399";
			divBtnConnection.style.fontWeight = "normal";
			divBtnConnection.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnConnection.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}
		
	
		isBookmark = 2;
		
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	
	function flip2ImpactSummary(){
		if($('#divBtnActivity').length){
			divBtnActivity.style.background = "#ffffff";
			divBtnActivity.style.color = "#003399";
			divBtnActivity.style.fontWeight = "normal";
			divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
		}
		
		if($('#divBtnInfo').length){
			divBtnInfo.style.background = "#ffffff";
			divBtnInfo.style.color = "#003399";
			divBtnInfo.style.fontWeight = "normal";
			divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}


		if($('#divBtnBookmark').length){
			divBtnBookmark.style.background = "#ffffff";
			divBtnBookmark.style.color = "#003399";
			divBtnBookmark.style.fontWeight = "normal";
			divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnPost').length){
			divBtnPost.style.background = "#ffffff";
			divBtnPost.style.color = "#003399";
			divBtnPost.style.fontWeight = "normal";
			divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnImport').length){
			divBtnImpact.style.background = "#ffffff";
			divBtnImpact.style.color = "#003399";
			divBtnImpact.style.fontWeight = "normal";
			divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnImpactSummary').length){
			divBtnImpactSummary.style.background = "#003399";
			divBtnImpactSummary.style.color = "#ffffff";
			divBtnImpactSummary.style.fontWeight = "bold";
			divBtnImpactSummary.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnImpactSummary.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";	
		}

		if($('#divBtnConnection').length){
			divBtnConnection.style.background = "#ffffff";
			divBtnConnection.style.color = "#003399";
			divBtnConnection.style.fontWeight = "normal";
			divBtnConnection.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnConnection.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}
	
		isBookmark = 3;
		
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	
	function flip2Post(){
		if($('#divBtnActivity').length){
			divBtnActivity.style.background = "#ffffff";
			divBtnActivity.style.color = "#003399";
			divBtnActivity.style.fontWeight = "normal";
			divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
		}
		
		if($('#divBtnInfo').length){
			divBtnInfo.style.background = "#ffffff";
			divBtnInfo.style.color = "#003399";
			divBtnInfo.style.fontWeight = "normal";
			divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnBookmark').length){
			divBtnBookmark.style.background = "#ffffff";
			divBtnBookmark.style.color = "#003399";
			divBtnBookmark.style.fontWeight = "normal";
			divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnPost').length){
			divBtnPost.style.background = "#003399";
			divBtnPost.style.color = "#ffffff";
			divBtnPost.style.fontWeight = "bold";
			divBtnPost.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnPost.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}
		
		if($('#divBtnImport').length){
			divBtnImpact.style.background = "#ffffff";
			divBtnImpact.style.color = "#003399";
			divBtnImpact.style.fontWeight = "normal";
			divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnImpactSummary').length){
			divBtnImpactSummary.style.background = "#ffffff";
			divBtnImpactSummary.style.color = "#003399";
			divBtnImpactSummary.style.fontWeight = "normal";
			divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}
		
		if($('#divBtnConnection').length){
			divBtnConnection.style.background = "#ffffff";
			divBtnConnection.style.color = "#003399";
			divBtnConnection.style.fontWeight = "normal";
			divBtnConnection.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnConnection.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}	
	
		isBookmark = 0;
		
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	function flip2Bookmark(){
		if($('#divBtnActivity').length){
			divBtnActivity.style.background = "#ffffff";
			divBtnActivity.style.color = "#003399";
			divBtnActivity.style.fontWeight = "normal";
			divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
		}
		
		if($('#divBtnInfo').length){
			divBtnInfo.style.background = "#ffffff";
			divBtnInfo.style.color = "#003399";
			divBtnInfo.style.fontWeight = "normal";
			divBtnInfo.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnInfo.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnBookmark').length){
			divBtnBookmark.style.background = "#003399";
			divBtnBookmark.style.color = "#ffffff";
			divBtnBookmark.style.fontWeight = "bold";
			divBtnBookmark.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnBookmark.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}

		if($('#divBtnPost').length){
			divBtnPost.style.background = "#ffffff";
			divBtnPost.style.color = "#003399";
			divBtnPost.style.fontWeight = "normal";
			divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}
		
		if($('#divBtnImport').length){
			divBtnImpact.style.background = "#ffffff";
			divBtnImpact.style.color = "#003399";
			divBtnImpact.style.fontWeight = "normal";
			divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnImpactSummary').length){
			divBtnImpactSummary.style.background = "#ffffff";
			divBtnImpactSummary.style.color = "#003399";
			divBtnImpactSummary.style.fontWeight = "normal";
			divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}
		
		if($('#divBtnConnection').length){
			divBtnConnection.style.background = "#ffffff";
			divBtnConnection.style.color = "#003399";
			divBtnConnection.style.fontWeight = "normal";
			divBtnConnection.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnConnection.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}
	
		isBookmark = 1;

		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	
	function flip2Connection(){
		if($('#divBtnActivity').length){
			$('#divBtnActivity').css('background','#ffffff');
			$('#divBtnActivity').css('color','#003399');
			$('#divBtnActivity').css('font-weight','normal');
			divBtnActivity.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnActivity.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";				
		}
		
		if($('#divBtnInfo').length){
			$('#divBtnInfo').css('background','#ffffff');
			$('#divBtnInfo').css('color','#003399');
			$('#divBtnInfo').css('font-weight','normal');
			$('#divBtnInfo').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			$('#divBtnInfo').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnBookmark').length){
			divBtnBookmark.style.background = "#ffffff";
			divBtnBookmark.style.color = "#003399";
			divBtnBookmark.style.fontWeight = "normal";
			divBtnBookmark.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnBookmark.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnPost').length){
			divBtnPost.style.background = "#ffffff";
			divBtnPost.style.color = "#003399";
			divBtnPost.style.fontWeight = "normal";
			divBtnPost.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnPost.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnImport').length){
			divBtnImpact.style.background = "#ffffff";
			divBtnImpact.style.color = "#003399";
			divBtnImpact.style.fontWeight = "normal";
			divBtnImpact.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpact.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";		
		}

		if($('#divBtnImpactSummary').length){
			divBtnImpactSummary.style.background = "#ffffff";
			divBtnImpactSummary.style.color = "#003399";
			divBtnImpactSummary.style.fontWeight = "normal";
			divBtnImpactSummary.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			divBtnImpactSummary.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
		}

		if($('#divBtnConnection').length){
			divBtnConnection.style.background = "#003399";
			divBtnConnection.style.color = "#ffffff";
			divBtnConnection.style.fontWeight = "bold";
			divBtnConnection.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnConnection.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}
		
		isBookmark = 6;

		loadConnections();
	
	}
	/*************************************************/
	/* Research Area Navigation Script               */
	/*************************************************/
	var area_array = [];
	function addArea(area_id,area){
		area_array.push({
			'area_id':area_id,
			'area':area
		});
		area_array = $.unique(area_array);
	}
	function removeArea(area_id){
		//area_array = $.grep(area_id, function(value){
		//		return value != area_id;
		//	});
		//var position = $.inArray(area_id,area_array);
		//if(~position)area_array.splice(position, 1);
		$.each(area_array,function(i,v){
			if(v.area_id == area_id){
				area_array.splice(i,1);
				return;
			}
		});
	}
	
	//Wenyuan, for bookmark vaapad
	var bk_array = [];
	
	function addbk(bk_rs_id){
		
		bk_array.push({

			'bk_rs_id' : bk_rs_id
		});
		
		bk_array+ $.unique(bk_array);
	
	}
	
	
	
	function removebk(bk_rs_id){
		
		bk_array=[];
	
	}
	//modified on 11.12.2014 
	
	
	/*************************************************/
	/* User Profile Navigation Script                */
	/*************************************************/
	function loadAnActivity(act,actid){
		$.get("profile/recentActivity.jsp",{activity: act,activity_id: actid},function(data){
				displayTalks(data);
			}
		);

	}	
	function loadActivity(){
		var action = "profile/activity.jsp";
		if(queryString){
			action = action.concat('?',queryString);
		}
		//loadTalks(action);
		$.get(action,function(data){
			displayTalks(data);
		});
	}
	function loadInfo(){
		var action = "profile/info.jsp";
		if(queryString){
			action = action.concat('?',queryString);
		}
		//loadTalks(action);
		$.get(action,function(data){
			displayTalks(data);
		});
	}
	function loadFriends(){
		var action = "profile/people.jsp";
		/*if(queryString){
			action = action.concat('?',queryString);
		}*/
		$.get(action,function(data){
			$('#tdUserSubInfo').html(data); 
		});
	}
	
	function loadConnections()
	{
		displayTalks("<div align='center'><img border='0' src='images/loading.gif' /></div>");
		$.get("profile/socialConnectionContent.jsp",{},function(data){
				displayTalks(data);
				initialization('facebook');
		});
	}
	
	function loadFriendsTalks()
	{
		displayTalks("<div align='center'><img border='0' src='images/loading.gif' /></div>");
		$.get("profile/friendsTalk.jsp",{},function(data){
				displayTalks(data);
				
		});
	}	
	
	/*************************************************/
	/* Calendar Navigation Script                    */
	/*************************************************/
	function flip2Day(){
		period = 0;

		if($('#divBtnDay').length){
			divBtnDay.style.background = "#003399";
			divBtnDay.style.color = "#ffffff";
			divBtnDay.style.fontWeight = "bold";
			divBtnDay.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnDay.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}

		if($('#divBtnWeek').length){
			divBtnWeek.style.background = "#ffffff";
			divBtnWeek.style.color = "#003399";
			divBtnWeek.style.fontWeight = "normal";
			divBtnWeek.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
			divBtnWeek.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

		if($('#divBtnMonth').length){
			divBtnMonth.style.background = "#ffffff";
			divBtnMonth.style.color = "#003399";
			divBtnMonth.style.fontWeight = "normal";
			divBtnMonth.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
			divBtnMonth.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}

<%
	if(menu.equalsIgnoreCase("home")){
%>
		/* This is a GET method
		var action = "calendar.do";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(queryString){
			action = action.concat('&',queryString);
		}
		window.location = action;*/
		// This is a POST jQuery
		$('#inDay').val(_day);
		$('#inMonth').val(_month);
		$('#inYear').val(_year);
		if(queryString){
			$('#frmPostCalDate').attr('action','calendar.do?' + queryString);
		}
		$('#frmPostCalDate').submit();
<%		
	}else{
%>
		var area_para = "";
		$.each(area_array,function(i,v){
			area_para = area_para.concat("&area_id=",v.area_id);
		});
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		var bk_para ="";
		
		$.each(bk_array, function(i,v){
			
			bk_para = bk_para.concat("&bk_rs_id=", v.bk_rs_id);
		
		});
		//modified on 11.12.2014 
		
		
		
		var action = "includes/calendar.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2 || isBookmark == 3){
			action = action.concat('&impact=1');
		}
		if(area_para != ""){
			action = action.concat(area_para);
		}
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadCalendar(action);
		
		action = "utils/loadTalks.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		}	
		if(area_para != ""){
			action = action.concat(area_para);
		}
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadTalks(action);
		
		/*action = "utils/namedEntity.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(isBookmark == 0 || isBookmark == 1){
			if(queryString){
				action = action.concat('&',queryString);
			}
			loadExtension(action);		
		}else{
			displayExtension("&nbsp;");
		}*/	

		action = "researcharea/researcharea.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(area_para != ""){
			action = action.concat(area_para);
		}
		
		//researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		loadResearchArea(action);			
<%		
	}
%>
	}
	
	function flip2Week(){
		period = 1;

		if($('#divBtnDay').length){
			divBtnDay.style.background = "#ffffff";
			divBtnDay.style.color = "#003399";
			divBtnDay.style.fontWeight = "normal";
			divBtnDay.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
			divBtnDay.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}
		
		if($('#divBtnWeek').length){
			divBtnWeek.style.background = "#003399";
			divBtnWeek.style.color = "#ffffff";
			divBtnWeek.style.fontWeight = "bold";
			divBtnWeek.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnWeek.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}
		
		if($('#divBtnMonth').length){
			divBtnMonth.style.background = "#ffffff";
			divBtnMonth.style.color = "#003399";
			divBtnMonth.style.fontWeight = "normal";
			divBtnMonth.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
			divBtnMonth.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}
				
		var thisweek = getWeekNoInMonth(_year,_month,_day);
<%
	if(menu.equalsIgnoreCase("home")){
%>
		/* This is a GET method
		var action = "calendar.do";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(queryString){
			action = action.concat('&',queryString);
		}
		window.location = action;*/
		// This is a POST jQuery
		$('#inWeek').val(thisweek);
		$('#inMonth').val(_month);
		$('#inYear').val(_year);
		if(queryString){
			$('#frmPostCalDate').attr('action','calendar.do?' + queryString);
		}
		$('#frmPostCalDate').submit();
<%		
	}else{
%>
		var area_para = "";
		$.each(area_array,function(i,v){
			area_para = area_para.concat("&area_id=",v.area_id);
		});
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		var bk_para ="";
		$.each(bk_array, function(i,v){
			bk_para = bk_para.concat("&bk_rs_id=", v.bk_rs_id);
		});
		//modified on 11.12.2014 
		
		var action = "includes/calendar.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2 || isBookmark == 3){
			action = action.concat('&impact=1');
		}	
		if(area_para != ""){
			action = action.concat(area_para);
		}
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadCalendar(action);	

		action = "utils/loadTalks.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		}	
		if(area_para != ""){
			action = action.concat(area_para);
		}
				
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadTalks(action);

		/*action = "utils/namedEntity.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(isBookmark == 0 || isBookmark == 1){
			if(queryString){
				action = action.concat('&',queryString);
			}
			//alert(action);
			loadExtension(action);		
		}else{
			displayExtension("&nbsp;");
		}*/
		action = "researcharea/researcharea.jsp";
		action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
		if(area_para != ""){
			action = action.concat(area_para);
		}	
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		loadResearchArea(action);			
<%
	}
%>						
	}

	function flip2MonthNoAction(){
		period = 2;

		if($('#divBtnDay').length){
			divBtnDay.style.background = "#ffffff";
			divBtnDay.style.color = "#003399";
			divBtnDay.style.fontWeight = "normal";
			divBtnDay.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
			divBtnDay.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}
		
		if($('#divBtnWeek').length){
			divBtnWeek.style.background = "#ffffff";
			divBtnWeek.style.color = "#003399";
			divBtnWeek.style.fontWeight = "normal";
			divBtnWeek.onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";		
			divBtnWeek.onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		}
				
		if($('#divBtnMonth').length){
			divBtnMonth.style.background = "#003399";
			divBtnMonth.style.color = "#ffffff";
			divBtnMonth.style.fontWeight = "bold";
			divBtnMonth.onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			divBtnMonth.onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";		
		}
	}
	
	function flip2Month(){
		flip2MonthNoAction();

<%
	if(menu.equalsIgnoreCase("home")){
%>
		/* This is a GET method
		var action = "calendar.do";
		action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		if(queryString){
			action = action.concat('&',queryString);
		}
		window.location = action;*/
		// This is a POST jQuery
		$('#inMonth').val(_month);
		$('#inYear').val(_year);
		if(queryString){
			$('#frmPostCalDate').attr('action','calendar.do?' + queryString);
		}
		$('#frmPostCalDate').submit();
<%		
	}else{
%>
		var area_para = "";
		$.each(area_array,function(i,v){
			area_para = area_para.concat("&area_id=",v.area_id);
		});
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		var bk_para ="";
		$.each(bk_array, function(i,v){
			bk_para = bk_para.concat("&bk_rs_id=", v.bk_rs_id);
		});
		//modified on 11.12.2014 
		
		var action = "includes/calendar.jsp";
		action = action.concat('?month=',_month,'&year=',_year);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2 || isBookmark == 3){
			action = action.concat('&impact=1');
		}	
		if(area_para != ""){
			action = action.concat(area_para);
		}	
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
		action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		if(queryString){
			action = action.concat('&',queryString);
		}
		loadCalendar(action);	
		
		action = "utils/loadTalks.jsp";
		action = action.concat('?month=',_month,'&year=',_year);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = "utils/loadImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year);
			action = action.concat('&impact=1');
		}else if(isBookmark == 3){
			action = "utils/popImpact.jsp";
			action = action.concat('?month=',_month,'&year=',_year);
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		if(area_para != ""){
			action = action.concat(area_para);
		}
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		loadTalks(action);

		/*action = "utils/namedEntity.jsp";
		action = action.concat('?month=',_month,'&year=',_year);
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}
		if(isBookmark == 0 || isBookmark == 1){
			if(queryString){
				action = action.concat('&',queryString);
			}
			loadExtension(action);		
		}else{
			displayExtension("&nbsp;");
		}*/
		action = "researcharea/researcharea.jsp";
		action = action.concat('?month=',_month,'&year=',_year);
		if(area_para != ""){
			action = action.concat(area_para);
		}
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		loadResearchArea(action);			
<%
	}
%>						
	}

	function backNoTalkList(noFeed,period){
		var action = "";
		if(period == 0){
			_day--;
			if(_day <= 0){
				_month--;
				if(_month == 0){
					_month = 12;
					_year--;
				}
				_day = daysInMonth(_year,_month) + _day;
			}
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		}
		if(period == 1){
			_day -= 7;
			if(_day <= 0){
				_month--;
				if(_month == 0){
					_month = 12;
					_year--;
				}
				_day = daysInMonth(_year,_month) + _day;
			}
			var prevweek = getWeekNoInMonth(_year,_month,_day);
			action = action.concat('?month=',_month,'&year=',_year,'&week=',prevweek);
		}
		if(period == 2){
			_month--;
			if(_month == 0){
				_month = 12;
				_year--;
			}
			action = action.concat('?month=',_month,'&year=',_year);
		}
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = action.concat('&impact=1');
		}	
		//alert(action);
		if(queryString){
			action = action.concat('&',queryString);
		}
		if(noFeed){
			action = action.concat('&nofeed=1');
		}	
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		var bk_para ="";
		$.each(bk_array, function(i,v){
			bk_para = bk_para.concat("&bk_rs_id=", v.bk_rs_id);
		});
		//modified on 11.12.2014 
		
		var area_para = "";
		$.each(area_array,function(i,v){
			area_para = area_para.concat("&area_id=",v.area_id);
		});
		if(area_para != ""){
			action = action.concat(area_para);
		}
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 
		
		loadCalendar("includes/calendar.jsp".concat(action));

		return action;
	}
		
	function back(){
		var action = backNoTalkList(false,period);
		//alert(action);
		if(isBookmark == 2){
			loadTalks("utils/loadImpact.jsp".concat(action));
		}else if(isBookmark == 3){
			loadTalks("utils/popImpact.jsp".concat(action));	
		}else{
			loadTalks("utils/loadTalks.jsp".concat(action));
			//loadExtension("utils/namedEntity.jsp".concat(action));
			loadResearchArea("researcharea/researcharea.jsp".concat(action));		
		}
	}
	
	function nextNoTalkList(noFeed,period){
		var action = "";
		
		if(period == 0){
			_day++;
			var days = daysInMonth(_year,_month);
			if(_day > days){
				_month++;
				if(_month == 13){
					_month = 1;
					_year++;
				}
				_day -= days;
			}
			action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
		}
		if(period == 1){
			_day += 7;
			var days = daysInMonth(_year,_month);
			if(_day > daysInMonth(_year,_month)){
				_month++;
				if(_month == 13){
					_month = 1;
					_year++;
				}
				_day -= days;
			}
			var nextweek = getWeekNoInMonth(_year,_month,_day);
			action = action.concat('?month=',_month,'&year=',_year,'&week=',nextweek);
		}
		if(period == 2){
			_month++;
			if(_month == 13){
				_month = 1;
				_year++;
			}
			action = action.concat('?month=',_month,'&year=',_year);
		}
		if(isBookmark == 0){
			action = action.concat('&post=1');
		}else if(isBookmark == 2){
			action = action.concat('&impact=1');
		}	
		if(queryString){
			action = action.concat('&',queryString);
		}
		if(noFeed){
			action = action.concat('&nofeed=1');
		}	
		var area_para = "";
		$.each(area_array,function(i,v){
			area_para = area_para.concat("&area_id=",v.area_id);
		});
		
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		var bk_para ="";
		$.each(bk_array, function(i,v){
			bk_para = bk_para.concat("&bk_rs_id=", v.bk_rs_id);
		});
		//modified on 11.12.2014 
		
		if(area_para != ""){
			action = action.concat(area_para);
		}
				
		//Wenyuan, researcharea modification, for BOOKMARK vaapad
		if(bk_para !=""){
			action = action.concat(bk_para);
		}
		//modified on 11.12.2014 

		loadCalendar("includes/calendar.jsp".concat(action));

		return action;
	}
	
	function next(){
		var action = nextNoTalkList(false,period);
		if(isBookmark == 2){
			loadTalks("utils/loadImpact.jsp".concat(action));			
		}else if(isBookmark == 3){
			loadTalks("utils/popImpact.jsp".concat(action));	
		}else{
			loadTalks("utils/loadTalks.jsp".concat(action));		
			//loadExtension("utils/namedEntity.jsp".concat(action));		
			loadResearchArea("researcharea/researcharea.jsp".concat(action));		
		}
	}
	
	function deleteCols(){
		/*if(document.talkForm && document.talkForm.length > 2){
				if(!oDeleteTalkIFrame){
					createDeleteTalkIFrame();
					window.setTimeout(function(){deleteCols();},50); 
				}else{
					var cols = "";
					if(document.talkForm.length == 3){
						cols = document.talkForm.deleted.value;			
					}else{//deleted as array
						for(var i=0;i<document.talkForm.deleted.length;i++){
							if(document.talkForm.deleted[i].checked){
								cols = cols.concat(document.talkForm.deleted[i].value,',');
							}
						}
						if(cols.length > 1){
							cols = cols.substr(0,cols.length-1);
						}
					}		
					if(cols.length > 0){
						var action = "utils/deleteTalks.jsp?col_id=".concat(cols);
						if(isBookmark == 0){
							action = action.concat('&post=1');
						}else if(isBookmark == 2){
							action = action.concat('&impact=1');
						}	
						oDeleteTalkIFrame.location = action;
						window.setTimeout(
							function(){
								alert("Delete Talk(s) Successful!");
								refreshTalks();
							},100);
					}
				}
		}else if(document.getElementById("deleted0")){
			if(!oDeleteTalkIFrame){
				createDeleteTalkIFrame();
				window.setTimeout(function(){deleteCols();},50); 
			}else{
				var cols = "";
				for(var i=0;true;i++){
					var deleted = document.getElementById("deleted" + i);
					if(deleted){
						if(deleted.checked){
							cols = cols.concat(deleted.value,',');
						}
					}else{
						break;
					}	
				}	
				if(cols.length > 1){
					cols = cols.substr(0,cols.length-1);
				}
				if(cols.length > 0){
					var action = "utils/deleteTalks.jsp?col_id=".concat(cols);
					if(isBookmark == 0){
						action = action.concat('&post=1');
					}else if(isBookmark == 2){
						action = action.concat('&impact=1');
					}	
					oDeleteTalkIFrame.location = action;
					window.setTimeout(
						function(){
							alert("Delete Talk(s) Successful!");
							refreshTalks();
						},100);
				}
			}
		}*/
			var cols = "";
			$.each($('input.chkDelCol:checked'), function(index){
				cols = cols.concat($(this).val(), ',');
			});		
			if(cols.length > 1){
				cols = cols.substr(0,cols.length-1);

				//alert(cols + " isBookmark: " + isBookmark);

				if(isBookmark == 0){
					$.post("utils/deleteTalks.jsp", {col_id: cols, post: 1, outputMode: "json"}, function(data){
						if(data){
							if(data.status == "OK"){
								refreshTalks();
							}else{
								alert(data.message);
							}		
						}	
					});
				}else if(isBookmark == 2){
					$.post("utils/deleteTalks.jsp", {col_id: cols, impact: 1, outputMode: "json"}, function(data){
						if(data){
							if(data.status == "OK"){
								refreshTalks();
							}else{
								alert(data.message);
							}		
						}	
					});
				}else{
					$.post("utils/deleteTalks.jsp", {col_id: cols, outputMode: "json"}, function(data){
						if(data){
							if(data.status == "OK"){
								refreshTalks();
							}else{
								alert(data.message);
							}		
						}	
					});
				}	
			}

			
	}

	function redirect(html){
		window.location = html;
	}
	function refreshTalks(){
		switch(period){
			case 0: flip2Day();break;
			case 1: flip2Week();break;
			case 2: flip2Month();break;
		}
	}
	function fillInfo(){
		var infoFrame = top.infoFrame;
		if(infoFrame){
			infoFrame.document.forms[0].elements["user_id"].value = document.getElementById("user_id").value;	
			infoFrame.document.forms[0].elements["name"].value = document.getElementById("name").value;	
			infoFrame.document.forms[0].elements["email"].value = document.getElementById("email").value;	
			infoFrame.document.forms[0].elements["location"].value = document.getElementById("location").value;
			infoFrame.document.forms[0].elements["job"].value = document.getElementById("job").value;
			infoFrame.document.forms[0].elements["affiliation"].value = document.getElementById("affiliation").value;
			infoFrame.document.forms[0].elements["website"].value = document.getElementById("website").value;
			infoFrame.document.forms[0].elements["aboutme"].value = document.getElementById("aboutme").value;
			infoFrame.document.forms[0].elements["interests"].value = document.getElementById("interests").value;
			infoFrame.document.forms[0].submit();
		}
	}
	function cancelEditInfo(){
		if(btnCancelEditInfo.value == "Edit"){
			btnCancelEditInfo.value = "Cancel";
			if(divInfo){
				divInfo.style.display = "none";
			}
			if(divEditInfo){
				divEditInfo.style.display = "block";
			}
			btnEditInfo.style.width = "auto";
			btnEditInfo.style.visibility = "visible";
			btnEditInfo.style.display = "inline";
			btnEditInfo.style.overflow = "visible";

			var infoFrame = top.infoFrame;
			if(!infoFrame.document.forms[0]){
				infoFrame.location = "profile/infoEntry.jsp";
			}

			displayUpdatingInfo();
			
			updateError.innerHTML = "";
			nameError.innerHTML = "";
			emailError.innerHTML = "";
		}else{
			btnCancelEditInfo.value = "Edit";
			btnEditInfo.disabled = false;
			btnCancelEditInfo.disabled = false;
			if(divEditInfo){
				divEditInfo.style.display = "none";
			}
			if(divInfo){
				divInfo.style.display = "block";
			}
			btnEditInfo.style.width = "0px";
			btnEditInfo.style.visibility = "hidden";
			btnEditInfo.style.display = "none";
			btnEditInfo.style.overflow = "hidden";

			infoDesc.innerHTML = "";	
		}	
	}	
	function updateInfo(){
		var infoFrame = top.infoFrame;
		if(!infoFrame.document.forms[0]){
			infoFrame.location = "profile/infoEntry.jsp";
			window.setTimeout(function(){updateInfo();},100);
		}
		btnEditInfo.disabled = true;
		btnCancelEditInfo.disabled = true;
		fillInfo();
	}
	function displayUpdateInfoError(error){
		updateError.innerHTML = error;
		btnEditInfo.disabled = false;
		btnCancelEditInfo.disabled = false;
	}
	function displayNameInfoError(error){
		nameError.innerHTML = error;
		btnEditInfo.disabled = false;
		btnCancelEditInfo.disabled = false;
	}
	function displayEmailInfoError(error){
		emailError.innerHTML = error;
		btnEditInfo.disabled = false;
		btnCancelEditInfo.disabled = false;
	}
	function displayUpdatedInfo(){
		document.getElementById("infoName").innerHTML = document.getElementById("name").value;	
		document.getElementById("infoEmail").innerHTML = document.getElementById("email").value;	
		document.getElementById("infoLocation").innerHTML = document.getElementById("location").value;	
		document.getElementById("infoJob").innerHTML = document.getElementById("job").value;	
		document.getElementById("infoAffiliation").innerHTML = document.getElementById("affiliation").value;	
		document.getElementById("infoWebsite").innerHTML = document.getElementById("website").value;	
		document.getElementById("infoAboutme").innerHTML = document.getElementById("aboutme").value;	
		document.getElementById("infoInterests").innerHTML = document.getElementById("interests").value;
		cancelEditInfo();
		infoDesc.innerHTML = "Update information successful";	
	}
	function displayUpdatingInfo(){
		document.getElementById("name").value = document.getElementById("infoName").innerHTML;	
		document.getElementById("email").value = document.getElementById("infoEmail").innerHTML;	
		document.getElementById("location").value = document.getElementById("infoLocation").innerHTML;	
		document.getElementById("job").value = document.getElementById("infoJob").innerHTML;	
		document.getElementById("affiliation").value = document.getElementById("infoAffiliation").innerHTML;	
		document.getElementById("website").value = document.getElementById("infoWebsite").innerHTML;	
		document.getElementById("aboutme").value = document.getElementById("infoAboutme").innerHTML;	
		document.getElementById("interests").value = document.getElementById("infoInterests").innerHTML;
	}

	/*************************************************/
	/* Request Add Friend Script                     */
	/*************************************************/

	function addFriend(divDialog,objParent,uid,reqtype){
		var data = sendFriendRequest(objParent,uid,reqtype);
		hideAddFriendDialog(divDialog);		
	}	
	
	/*function showAddFriendDialog(){
		var divAddFriend = document.getElementById("divAddFriend");
		divAddFriend.style.display = "block";
	}
	
	function hideAddFriendDialog(){
		var divAddFriend = document.getElementById("divAddFriend");
		divAddFriend.style.display = "none";
	}

	function sendFriendRequest(uid,reqtype){
		$.post("profile/friendRequest.jsp",{user_id: uid,request_type: reqtype},function(data){
				if(data){
					if(data.status == "OK"){
						
					}else{

					}		
				}	
			});
	}	
	
	function autohintGotFocus(txtShare){
        if(txtShare.value == txtShare.getAttribute('title')){ 
            txtShare.value = '';
            var rows = txtShare.getAttribute('rows');
            if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r+1));
            }   
            txtShare.removeAttribute('class');
        }
	}	

	function autohintGotFocus(txtShare,objButton){
        if(txtShare.value == txtShare.getAttribute('title')){ 
            txtShare.value = '';
            var rows = txtShare.getAttribute('rows');
            if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r+1));
            }   
            txtShare.removeAttribute('class');
            objButton.style.display = "block";
        }
	}	

	function autohintGotBlur(txtShare){
        if(txtShare.value == '' && txtShare.getAttribute('title') != ''){ 
        	txtShare.value = txtShare.getAttribute('title');
            var rows = txtShare.getAttribute('rows');
            if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r-1));
            }   
        	txtShare.setAttribute('class','auto-hint'); 
        }
	}
		
	function autohintGotBlur(txtShare,objButton){
        if(txtShare.value == '' && txtShare.getAttribute('title') != ''){ 
        	txtShare.value = txtShare.getAttribute('title');
            var rows = txtShare.getAttribute('rows');
            if(rows){
				var r = parseInt(rows);
	        	txtShare.setAttribute('rows',(r-1));
            }   
        	txtShare.setAttribute('class','auto-hint');
        	objButton.style.display = "none"; 
        }
	}

	function postComment(u_id,txtShare,objButton){
		if(txtShare.getAttribute('class') != 'auto-hint'){
			txtShare.style.disabled = true;
			$.post("utils/postComment.jsp",{user_id: u_id,comment: txtShare.value},
				function(data){
					if(data.status == "OK"){
						txtShare.value = "";
						autohintGotBlur(txtShare,objButton);
						var latestTime = document.getElementById("latestTime");
						if(latestTime){
							$.get("profile/recentActivity.jsp",{user_id: u_id,insertfirst: 1,timestamp: latestTime.value},
								function(data){
									var now = new Date();
									latestTime.value = now.getFullYear() + "-" + (now.getMonth()+1) + "-" + now.getDate() + " " +
											now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
									var tdRecentActivity = document.getElementById("tdRecentActivity");
									tdRecentActivity.innerHTML = data.concat(tdRecentActivity.innerHTML);
								}
							);
						}	
					}else{
   						alert("<b><red>" + data.status + ":</red></b> " + data.message);
					}		
					txtShare.style.disabled = false;
				}
			);
		}	
	}

	function replyComment(cid,_txtComment,_objButton){
		var txtComment = document.getElementById(_txtComment);
		var objButton = document.getElementById(_objButton); 
		if(txtComment.getAttribute('class') != 'auto-hint'){
			txtComment.style.disabled = true;
			$.post("utils/postComment.jsp",{comment_id: cid,comment: txtComment.value},
				function(data){
					if(data.status == "OK"){
						txtComment.value = "";
						autohintGotBlur(txtComment,objButton);
						var latestTime = document.getElementById("commenttimeccid".concat(cid));
						if(latestTime){
							$.get("utils/replyComment.jsp",{user_id: u_id,comment_id: cid,timestamp: latestTime.value},
								function(data){
									var now = new Date();
									latestTime.value = now.getFullYear() + "-" + (now.getMonth()+1) + "-" + now.getDate() + " " +
											now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds();
									var tdReplyComment = document.getElementById("tdcommentcid".concat(cid));
									if(tdReplyComment){
										tdReplyComment.innerHTML = tdReplyComment.innerHTML.concat(data);
										tdReplyComment.style.display = "block";
									}else{
										//alert("No found " + "tdcommentcid".concat(cid));
									}	
								}
							);
						}
					}else{
   						alert("<b><red>" + data.status + ":</red></b> " + data.message);
					}		
					txtComment.style.disabled = false;
				}
			);
		}	
	}	

	function likeComment(uid,cid,anchorlike,tdlike){
		var txtLike = anchorlike.innerHTML;
		if(txtLike){
			$.post("utils/postLike.jsp",{user_id: uid,comment_id: cid,like: txtLike},
				function(data){
					if(data.status == "OK"){
						var like_tag = document.getElementById(tdlike);
						if(data.like_tag == "&nbsp;"){
							like_tag.style.display = "none";
						}else{
							like_tag.style.display = "block";
						}
						like_tag.innerHTML = data.like_tag;		
					}	
				}
			);
			if(txtLike == "Like"){
				anchorlike.innerHTML = "Unlike";
			}else{
				anchorlike.innerHTML = "Like";
			}		
		}	
	}*/

	$(document).ready(function(){
		//345817736440 123050457758183
		 FB.init({appId: '345817736440', xfbml: true, cookie: true});
	});	
	
	//For social Connection
	
	/*************************************************/
	/* Request Add Friend Script                     */
	/*************************************************/
	function s_confirm(){
		if(document.s_search.search_text.value == "" || document.s_search.search_text.value == " "){
	        alert("Enter keywords");
	    }else{
	        document.s_search.submit();
	    }
	}
	
	function showAddFriendDialog(divAddFriend){
		//var divAddFriend = document.getElementById("divAddFriend");
		
		divAddFriend.style.display = "block";
	}
	
	function hideAddFriendDialog(divAddFriend){
		//var divAddFriend = document.getElementById("divAddFriend");
		divAddFriend.style.display = "none";
	}
	
	function sendFriendRequest(objParent,divDialog,uid,reqtype){
		$.post("profile/friendRequest.jsp",{user_id: uid,request_type: reqtype},function(data){
				if(data){
					if(data.status=="OK"){
						if(objParent != null){
							if(divDialog == null){//This section is for a feed line, change things for the whole class not just one id
								var classname = $(objParent).attr('class');
								if(reqtype=="add"){
									$('.'.concat(classname)).html("<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\"".concat(
											" onclick=\"addFriend(",null,",spanClassAddFriend",uid,",",uid,",'drop');return false;\">",
												"<img border='0' src='images/x.gif' /></a>"));
								}
								if(reqtype=="drop"){
									$('.'.concat(classname)).html("&nbsp;");
								}
								if(reqtype=="accept"){
									$('.'.concat(classname)).html("<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">You both are connected.</span>");
								}
								if(reqtype=="notnow"){
									$('.'.concat(classname)).html("&nbsp;");
								}				
								if(reqtype=="reject"){
									$('.'.concat(classname)).html("&nbsp;");
								}				
							}else{
								if(reqtype=="add"){
									objParent.innerHTML = "<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\"".concat(
											" onclick=\"addFriend(",divDialog.id,",",objParent.id,",",uid,",'drop');return false;\">",
												"<img border='0' src='images/x.gif' /></a>");
								}
								if(reqtype=="drop"){
									objParent.innerHTML = "<input class =\"btn\" type=\"button\" id=\"btnAddAsFriend\"".concat(
											" value=\"Connect in CoMeT\" onclick=\"showAddFriendDialog(",divDialog.id,");return false;\" />");
								}
								if(reqtype=="accept"){
									objParent.innerHTML = "<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">You both are connected.</span>";
									window.setTimeout(function(){location.reload();},500);
								}
								if(reqtype=="notnow"){
									objParent.innerHTML = "&nbsp;";
								}				
								if(reqtype=="reject"){
									objParent.innerHTML = "<input class =\"btn\" type=\"button\" id=\"btnAddAsFriend\"".concat(
										" value=\"Connect in CoMeT\" onclick=\"showAddFriendDialog(",divDialog.id,");return false;\" />");
								}				
							}	
						}else{//objParent is null

						}		
					}else{
						alert(data.status + " : " + data.message);
					}		
				}	
			});
	}	

	function toggleRequestList(aList,divTopList){
		var _class = divTopList.getAttribute("class");
		if(_class == "hiddenlist"){
			$(".shownlist").removeClass("shownlist").addClass("hiddenlist");
			divTopList.setAttribute("class","shownlist");
			aList.setAttribute("class","shownlist");
		}else{
			divTopList.setAttribute("class","hiddenlist");
			aList.setAttribute("class","hiddenlist");
		}		
	}
	function addFriend(divDialog,objParent,uid,reqtype){
			var data = sendFriendRequest(objParent,divDialog,uid,reqtype);
			hideAddFriendDialog(divDialog);		
		}	
		
	function invitation(facebookId)
	{

      	FB.ui({
      	  to:facebookId,
          method: 'send',
          name: 'CoMeT Invitation',
          link: 'http://halley.exp.sis.pitt.edu/comet/index.do'
         });
	}
function initialization(type)
{
	
	$('#PagesDIV').empty();
	$('#PageSizeDIV').empty();
	//showPageSize('#pageSizeDIV',10);
	
	if(type == 'facebook')
	{
		showOrderBy('#orderByDIV','friends');
		showPageSize('#pageSizeDIV',10,'f');
		show_fb_friend_funtion(1,10,'ALL');
	}else if(type == 'linkedIn')
	{
		showOrderBy('#orderByDIV','friends');
		showPageSize('#pageSizeDIV',10,'f');
		show_linkedIn_friend_funtion(1,10,'ALL');
	}else if(type == 'friendsTalks')
	{
	//	showOrderBy('#orderByDIV','ft');
	//	showPageSize('#pageSizeDIV',5,'t');
		loadSingleFriendTalks('ShowALL','ShowALL',1,5,'none');
		
		
		
	/*	
		*/
	}
}

function changePageSize(me)
{
	var size = me.options[me.selectedIndex].value;
	var type  = $('#fbDiv').attr("class");
	
	$('#PagesDIV').empty();
	var x=document.getElementById("OrderBy").selectedIndex;
	var y=document.getElementById("OrderBy").options;
	var location = y[x].value;
	
	if(type == 'fb')
		show_fb_friend_funtion(1,size,location);
	else if(type == 'linkin')
		show_linkedIn_friend_funtion(1,size,location);
	else if(type == 'friendTalks')
		ShowFriendsTalks(1,size,'');
	
}

function showPageSize(target,size,type)
{
	$(target).empty();
	var tag1="",tag2="",tag3="",tag4="",tag5="";
	if(parseInt(size) == 5)
	{
		 tag1 = "selected";
	}else if(parseInt(size) == 10)
	{
		 tag2 = "selected";
	}else if(parseInt(size) == 20)
	{
		 tag3 = "selected";
	}else if(parseInt(size) == 30)
	{
		 tag4 = "selected";
	}else if(parseInt(size) == 50)
	{
		 tag5 = "selected";
	}
	var tag = "friends";
	var navigation;
	if(type == 't')
	{
		tag = "talks";
		
	}
	 navigation='&nbsp&nbspNumber of '+tag+' per page:<select name="size" onChange="changePageSize(this)">'+
		'<option value="5" '+ tag1+'>5</option>'+
		'<option value="10" '+ tag2+'>10</option>'+
		'<option value="20" '+ tag3+'>20</option>'+
		'<option value="30" '+ tag4+'>30</option>'+
		'<option value="50" '+ tag5+'>50</option>'+
		'</select>';
	
	$(target).append(navigation);
}


function showPageDivision(target,totalSizeField,functionName,currentPage,pageSize)
{
	$(target).empty();

	
	var totalSize = $(totalSizeField).attr('value');
	
	var pages = totalSize / pageSize;
	if(totalSize % pageSize > 0)
	{
		pages++;
	}
	
	if(functionName == 'ShowFriendsTalks')
		var navigation="&nbsp&nbspPages:<select name=\"pages\" onChange=\""+functionName+"(this.options[this.selectedIndex].value,'"+pageSize+"')\">";
	else
	{
		if(document.getElementById("OrderBy") != null)
		{
		var x=document.getElementById("OrderBy").selectedIndex;
		var y=document.getElementById("OrderBy").options;
		var location = y[x].value;
		}else
		var location = 'ALL';
		var navigation="&nbsp&nbspPages:<select name=\"pages\" onChange=\""+functionName+"(this.options[this.selectedIndex].value,'"+pageSize+"','"+location+"')\">";
		
	}
	
	var selected="selected"; 
	for(var index = 1;index<=pages;index++)
	{
		var start = (index-1)*pageSize+1;
		var end = parseInt(start) + parseInt(pageSize) - 1;
		
		if(currentPage == index)
			selected="selected"; 
		else
			selected=""; 
		
		navigation = navigation + "<option value="+index+" "+ selected + ">"+index+"</option>";
	
		
	}
	navigation += "</select>";
	
	navigation += "&nbsp&nbspSearch name:<input id='friendSearch'/>";
	$(target).append(navigation);
	
}

function showOrderBy(target,type)
{
	$(target).empty();
	var orderBy ="";
	if(type == 'friends')
	{
		orderBy += "&nbsp&nbspLocation:<select id='OrderBy' name='OrderBy'   onChange='changeOrder(this.options[this.selectedIndex].value)'><option value='all'>ALL</option>";
		orderBy += "<option value='pittsburgh'>Pittsburgh</option>";
		orderBy += "<option value='others'>Others</option>";
		
	}else if(type == "ft")
	{
		orderBy += "&nbsp&nbspNew/Old:<select id='OrderBy' name='OrderBy' onChange='changeOrder(this.options[this.selectedIndex].value)'><option value='all'>ALL</option>";
		orderBy += "<option value='new'>New</option>";
		orderBy += "<option value='old'>Old</option>";
	}
	orderBy += "</select>";
	
	$(target).append(orderBy);
}

function changeOrder(value)
{
	var type  = $('#fbDiv').attr("class");
	
	
	
	if(type == 'fb')
	{
		
		show_fb_friend_funtion(1,10,value);
	}else if(type == 'linkin')
	{
		
		show_linkedIn_friend_funtion(1,10,value);
	}else if(type == 'friendTalks')
	{
		//loadSingleFriendTalks('ShowALL','ShowALL',1,5,value);
		ShowFriendsTalks(1,5,value);
	}
	
	
}

function show_more_fb_friends()
{
	$('#showmorefb').remove();
	
		$('#fbfriends').append("<div id=\"loadProcess\" align='center'><img border='0' src='images/loading.gif' /></div>");
		
			 $('#fbfriends').show();
			$('#friendsTalksDiv').hide();
			
			 
			$('#linkInfriends').hide();
			
			  $('#fbDiv').attr("class","fb");
			 var start;
		   if($(".fbfriend:last").attr("id") == null)
		   {
		    	start=1;
		   }else
		   {
            	start=parseInt($(".fbfriend:last").attr("id")) + 1;
           }
           var end = start + 10;
			var addr = "utils/getFacebookFriends.jsp";
			$.get(addr,{"start":start,"end":end},
         	 function(newitems){   
         	$('#loadProcess').remove();
         	
            $('#fbfriends').append(newitems);  
            $('#fbfriends').append('<div id="showmorefb"><b><a href="javascript:void(0);" onclick="show_more_fb_friends()">Show more</a></b></div>');
            
        	});   
			

}
//last_fb_friend_funtion
function show_fb_friend_funtion(page,pageSize,location) 
		{ 
			var start = (page-1)*pageSize+1;
			var end = parseInt(start) + parseInt(pageSize) - 1;
			
			var currentId = "#pageIndex".concat(page);
			var pre = page - 1;
			
			
			
			//$(currentId).removeAttr('href');
			//$(currentId).removeAttr('onClick');
			
			$('#fbfriends').empty();
			$('#fbfriends').append("<div id=\"loadProcess\" align='center'><img border='0' src='images/loading.gif' /></div>");
		
			document.getElementById('linkConnectionBtn').style.background = "#ffffff";
			document.getElementById('linkConnectionBtn').style.color = "#003399";
			document.getElementById('linkConnectionBtn').style.fontWeight = "normal";
			document.getElementById('linkConnectionBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('linkConnectionBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
			document.getElementById('faceConnectionBtn').style.background = "#003399";
			document.getElementById('faceConnectionBtn').style.color = "#ffffff";
			document.getElementById('faceConnectionBtn').style.fontWeight = "bold";
			document.getElementById('faceConnectionBtn').onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			document.getElementById('faceConnectionBtn').onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";	
			
			document.getElementById('friendTalksBtn').style.background = "#ffffff";
			document.getElementById('friendTalksBtn').style.color = "#003399";
			document.getElementById('friendTalksBtn').style.fontWeight = "normal";
			document.getElementById('friendTalksBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('friendTalksBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
			
			
			
			 $('#fbfriends').show();
			$('#friendsTalksDiv').hide();
			$('#friendsTalksDiv').empty();
			 
			$('#linkInfriends').hide();
			$('#linkInfriends').empty();
			
			  $('#fbDiv').attr("class","fb");
	/*		 var start;
		   if($(".fbfriend:last").attr("id") == null)
		   {
		    	start=1;
		   }else
		   {
            	start=parseInt($(".fbfriend:last").attr("id")) + 1;
           }
           var end = start + 10;
    */
    		
			var addr = "utils/getFacebookFriends.jsp";
			$.get(addr,{"start":start,"end":end,"location":location},
         	 function(newitems){   
         	$('#loadProcess').remove();
         	
            $('#fbfriends').append(newitems); 
         
         //   $('#fbfriends').append('<div id="showmorefb"><b><a href="javascript:void(0);" onclick="show_more_fb_friends()">Show more</a></b></div>');
            showPageDivision('#PagesDIV','#totalSizeFB','show_fb_friend_funtion',page,pageSize); 
				 
				  $(function() {
 
 
				$( "#friendSearch" ).autocomplete({
				source: "profile/facebookFriendSearch.jsp",
				minLength: 1,
				
					select: function( event, ui ) {
							showSingleFriend('facebook',ui.item.value);
						
					}
				});
				
				});
				 
        	});  
        	
        		
			
		}; 
		
		 
		
		function more_linkedIn_friend()
		{
			$('#showmoreli').remove();
			$('#linkInfriends').append("<div id='loadProcess' align='center'><img border='0' src='images/loading.gif' /></div>");
		
				 var start;
		   if($(".lifriend:last").attr("id") == null)
		   {
		    	start=1;
		   }else
		   {
            	start=parseInt($(".lifriend:last").attr("id")) + 1;
           }
           var end = start + 10;
			var addr = "utils/getLinkedInFriends.jsp";
			$.get(addr,{"start":start,"end":end},
         	 function(newitems){   
         		$('#loadProcess').remove();
         		
           		 $('#linkInfriends').append(newitems);
           		$('#linkInfriends').append('<div id="showmoreli"><b><a href="javascript:void(0);" onclick="more_linkedIn_friend()">Show more</a></b></div>');
           		 
           		
           		
        	});   
			
		}
 function show_linkedIn_friend_funtion(page,pageSize,location) 
		{ 
			var start = (page-1)*pageSize+1;
			var end = parseInt(start) + parseInt(pageSize) - 1;
			
			var currentId = "#pageIndex".concat(page);
			
			$('#linkInfriends').empty();
			$('#linkInfriends').append("<div id='loadProcess' align='center'><img border='0' src='images/loading.gif' /></div>");
		
		
			document.getElementById('faceConnectionBtn').style.background = "#ffffff";
			document.getElementById('faceConnectionBtn').style.color = "#003399";
			document.getElementById('faceConnectionBtn').style.fontWeight = "normal";
			document.getElementById('faceConnectionBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('faceConnectionBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
			document.getElementById('linkConnectionBtn').style.background = "#003399";
			document.getElementById('linkConnectionBtn').style.color = "#ffffff";
			document.getElementById('linkConnectionBtn').style.fontWeight = "bold";
			document.getElementById('linkConnectionBtn').onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			document.getElementById('linkConnectionBtn').onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";	
			
			document.getElementById('friendTalksBtn').style.background = "#ffffff";
			document.getElementById('friendTalksBtn').style.color = "#003399";
			document.getElementById('friendTalksBtn').style.fontWeight = "normal";
			document.getElementById('friendTalksBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('friendTalksBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
			
				
			 $('#fbfriends').hide();
			$('#fbfriends').empty();
			 $('#friendsTalksDiv').hide();
			 $('#friendsTalksDiv').empty();
			$('#linkInfriends').show();
			
		
		
			 
			 $('#fbDiv').attr("class","linkin");
/*			 
			 var start;
		   if($(".lifriend:last").attr("id") == null)
		   {
		    	start=1;
		   }else
		   {
            	start=parseInt($(".lifriend:last").attr("id")) + 1;
           }
           var end = start + 10;
  */
			var addr = "utils/getLinkedInFriends.jsp";
			$.get(addr,{"start":start,"end":end,"location":location},
         	 function(newitems){   
         		$('#loadProcess').remove();
         		
           		 $('#linkInfriends').append(newitems);
       			
       			showPageDivision('#PagesDIV','#totalSizeLI','show_linkedIn_friend_funtion',page,pageSize); 
			
           		 $(function() {
 
 
				$( "#friendSearch" ).autocomplete({
				source: "profile/linkedInFriendSearch.jsp",
				minLength: 1,
				
					select: function( event, ui ) {
							showSingleFriend('linkedIn',ui.item.value);
					}
				});
				
				});
        	});   
			
		};
		
		function ShowFriendsTalks(page,pageSize,oldNew) {
			var start = (page-1)*pageSize+1;
			var end = parseInt(start) + parseInt(pageSize) - 1;
			
			//showPageSize('#pageSizeDIV',pageSize);
			
			document.getElementById('faceConnectionBtn').style.background = "#ffffff";
			document.getElementById('faceConnectionBtn').style.color = "#003399";
			document.getElementById('faceConnectionBtn').style.fontWeight = "normal";
			document.getElementById('faceConnectionBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('faceConnectionBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
			document.getElementById('linkConnectionBtn').style.background = "#ffffff";
			document.getElementById('linkConnectionBtn').style.color = "#003399";
			document.getElementById('linkConnectionBtn').style.fontWeight = "normal";
			document.getElementById('linkConnectionBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('linkConnectionBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
			
			document.getElementById('friendTalksBtn').style.background = "#003399";
			document.getElementById('friendTalksBtn').style.color = "#ffffff";
			document.getElementById('friendTalksBtn').style.fontWeight = "bold";
			document.getElementById('friendTalksBtn').onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			document.getElementById('friendTalksBtn').onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";	
			
				
			 $('#fbfriends').hide();
			  $('#fbfriends').empty();
			
			$('#linkInfriends').hide();
			$('#linkInfriends').empty();
			
			$('#friendsTalksDiv').show();
			
			var speaker= $('.disable').attr("id");
		
			
			$('#friendsTalksDiv').empty();
			$('#friendsTalksDiv').append("<div id='loadProcess' align='center'><img border='0' src='images/loading.gif' /></div>");
		
			 
			  $('#fbDiv').attr("class","friendTalks");
			
		 
			var addr = "profile/friendsTalk.jsp";
			$.get(addr,{"start":start,"end":end,"oldNew":oldNew,"speaker":speaker},
         	 function(newitems){   
         		$('#loadProcess').remove();
         		$('#friendsTalksDiv').empty();
           		 $('#friendsTalksDiv').append(newitems);
           	//	$('#linkInfriends').append('<div id="showmoreli"><b><a href="javascript:void(0);" onclick="last_linkedIn_friend_funtion()">Show more</a></b></div>');
           		 
				  if(newitems.indexOf('No Talks') != -1)
				 {
					 showPageDivision('#PagesDIV',0,'ShowFriendsTalks',page,pageSize); 
					
				 }else
				 {
           		  showPageDivision('#PagesDIV','#totalSizeFT','ShowFriendsTalks',page,pageSize); 
				 }
           		
				if(speaker)
				{
					document.getElementById(speaker).removeAttribute('href');
           			document.getElementById(speaker).setAttribute('class','disable');
           		}
           		
           		
           		$(function() {
 
 
				$( "#friendSearch" ).autocomplete({
				source: "profile/friendsTalksSearch.jsp",
				minLength: 1,
				
					select: function( event, ui ) {
						 loadSingleFriendTalks(ui.item.value,ui.item.value,1,pageSize,'none');
					}
				});
				
				});
           		
        	});   
			
		
	
	}  
	
	function loadSingleFriendTalks(id,speaker,page,pageSize,oldNew)
	{
			var start = (page-1)*pageSize+1;
			var end = parseInt(start) + parseInt(pageSize) - 1;
			
			$('#orderByDIV').empty();
			$('#PagesDIV').empty();
			$('#PageSizeDIV').empty();
			showPageSize('#pageSizeDIV',pageSize,'t');
			showOrderBy('#orderByDIV','ft');
			
			//alert(pageSize);
		  $('#fbDiv').attr("class","friendTalks");
		  
		$('.disable').attr("href","javascript:void(0);");
		$('.disable').attr("class","enable");
		
		document.getElementById('faceConnectionBtn').style.background = "#ffffff";
			document.getElementById('faceConnectionBtn').style.color = "#003399";
			document.getElementById('faceConnectionBtn').style.fontWeight = "normal";
			document.getElementById('faceConnectionBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('faceConnectionBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";
		
			document.getElementById('linkConnectionBtn').style.background = "#ffffff";
			document.getElementById('linkConnectionBtn').style.color = "#003399";
			document.getElementById('linkConnectionBtn').style.fontWeight = "normal";
			document.getElementById('linkConnectionBtn').onmouseover = "this.style.background='#ffffff';this.style.color='#003399';";
			document.getElementById('linkConnectionBtn').onmouseout = "this.style.background='#003399';this.style.color='#ffffff';";	
			
			document.getElementById('friendTalksBtn').style.background = "#003399";
			document.getElementById('friendTalksBtn').style.color = "#ffffff";
			document.getElementById('friendTalksBtn').style.fontWeight = "bold";
			document.getElementById('friendTalksBtn').onmouseover = "this.style.background='#003399';this.style.color='#ffffff';";
			document.getElementById('friendTalksBtn').onmouseout = "this.style.background='#ffffff';this.style.color='#003399';";	
			
				 $('#fbfriends').hide();
				 $('#fbfriends').empty();
			
			$('#linkInfriends').hide();
			$('#linkInfriends').empty();
			
			$('#friendsTalksDiv').show();
			
		//	var speakerDiv = "'#".concat(me.id).concat("'");
			if(document.getElementById(speaker) == null)
			{
				$('#friendsTalksDiv').append("<div id='loadProcess' align='center'><img border='0' src='images/loading.gif' /></div>");
			}
			else
			{
				
				$('#talkListsTd').html("<br/><br/><div id='loadProcess' align='center'><img border='0' src='images/loading.gif' /></div>")
			//	$(speakerDiv).removeAttr('href');
			//	$(speakerDiv).removeAttr('onClick');
				document.getElementById(id).removeAttribute('href');
           		document.getElementById(id).setAttribute('class','disable');
          		
       /*    		if(document.getElementById(speaker.concat('Old')) != null)
           		{
           			document.getElementById(speaker.concat('Old')).removeAttribute('href');
           			document.getElementById(speaker.concat('Old')).setAttribute('class','disable');
				}
				if(document.getElementById(speaker.concat('New')) != null)
           		{
					document.getElementById(speaker.concat('New')).removeAttribute('href');
           			document.getElementById(speaker.concat('New')).setAttribute('class','disable');
				}*/
				//me.removeAttribute('onClick');
			}
			
	  			//document.getElementById(me.id).removeAttribute('href');
           		//document.getElementById(me.id).setAttribute('class','disable');
	   
		$.get("profile/friendsTalk.jsp",{"speaker":speaker,"start":start,"end":end,"oldNew":oldNew},function(data){
				$('#loadProcess').remove();
				//var id = me.id;
         		$('#friendsTalksDiv').empty();
           		 $('#friendsTalksDiv').append(data);
           		 if(data.indexOf('No Talks') != -1)
				 {
					 showPageDivision('#PagesDIV',0,'ShowFriendsTalks',page,pageSize); 
					
				 }else
				 {
           		  showPageDivision('#PagesDIV','#totalSizeFT','ShowFriendsTalks',page,pageSize); 
				 }
			
           		 
           		// $(id).removeAttr("href");
           		//  $(id).attr("class","disable");
           		
           		document.getElementById(id).removeAttribute('href');
           		document.getElementById(id).setAttribute('class','disable');
          /* 		
           		if(document.getElementById(speaker.concat('Old')) != null)
           		{
           			document.getElementById(speaker.concat('Old')).removeAttribute('href');
           			document.getElementById(speaker.concat('Old')).setAttribute('class','disable');
				}
				if(document.getElementById(speaker.concat('New')) != null)
           		{
					document.getElementById(speaker.concat('New')).removeAttribute('href');
           			document.getElementById(speaker.concat('New')).setAttribute('class','disable');
				}
				//document.getElementById(me.id).removeAttribute('onClick');
		*/		
			$(function() {
 
 
				$( "#friendSearch" ).autocomplete({
				source: "profile/friendsTalksSearch.jsp",
				minLength: 1,
				
					select: function( event, ui ) {
						 loadSingleFriendTalks(ui.item.value,ui.item.value,1,pageSize,'none');
					}
				});
				
			});
					
	
});
	}
	 

	function showSingleFriend(type,name)
	{
		if(type == 'facebook')
		{
			$('#fbfriends').empty();
			$('#fbfriends').append("<div id='loadProcess' align='center'><img border='0' src='images/loading.gif' /></div>");
		
			
			
			var addr = "utils/getFacebookFriends.jsp";
			$.get(addr,{"target":name},
         	 function(newitems){   
         		$('#loadProcess').remove();
         		
           		 $('#fbfriends').append(newitems);
       			
       		});
		}else if(type == 'linkedIn')
		{
			$('#linkInfriends').empty();
			$('#linkInfriends').append("<div id='loadProcess' align='center'><img border='0' src='images/loading.gif' /></div>");
		
			
			var addr = "utils/getLinkedInFriends.jsp";
			$.get(addr,{"target":name},
         	 function(newitems){   
         		$('#loadProcess').remove();
         		
           		 $('#linkInfriends').append(newitems);
       			
       		});
		}
		
			
			
		
	}
 function showLinkedInPopup(uid,object)
 {
	$('#btnDoneINInviting').unbind();
	$('#btnDoneINInviting').click(function(){SendLinkedInInvitation(uid,$('#txtINMessage').val(),object);});
 	//document.getElementById('linkedInInvitation').setAttribute("onClick","SendMessage('"+uid+"',"+object+")");
 	$(object).show();
 }	
	
 function SendLinkedInInvitation(uid,message,object) {
     var BODY = {
        "recipients": {
           "values": [{
             "person": {
                "_path": "/people/".concat(uid)
             }
           }]
         },
       "subject": "CoMeT Invitation",
       "body": message.concat('\n\nCoMeT website: http://pittcomet.info/')
     }
     IN.API.Raw("/people/~/mailbox")
           .method("POST")
           .body(JSON.stringify(BODY)) 
           .result(function(result) {/*alert ("Message sent")*/ })
           .error(function error(e) { /*alert ("No dice")*/ });
     $(object).hide();  
 }

 function showFacebookCrawler(crawlerPath){
	if($('#tdFacebook').length){
		$('#tdFacebook')
		.html('<iframe frameborder="0" scrolling="no" src="' + crawlerPath + '" style="height: 30px;width: 400px;"></iframe>');
	}
 }

 function showLinkedInCrawler(crawlerPath){
		if($('#tdLinkedIn').length){
			$('#tdLinkedIn')
			.html('<iframe frameborder="0" scrolling="no" src="' + crawlerPath + '" style="height: 30px;width: 400px;"></iframe>');
		}
 }
	
function showMendeleyCrawler(crawlerPath){
	if($('#tdMendeley').length){
		$('#tdMendeley')
		.html('<iframe frameborder="0" scrolling="no" src="' + crawlerPath + '" style="height: 400px;width: 600px;"></iframe>');
	}
 }

</script>

<logic:notPresent name="UserSession">
<% 
	String pagePath = "";
	if(menu.equalsIgnoreCase("calendar")){
		pagePath = "calendar.do";
	} 
	if(menu.equalsIgnoreCase("myaccount")){
		pagePath = "myaccount.do";
	}
	if(menu.equalsIgnoreCase("community")){
		pagePath = "community.do";
	}
	if(menu.equalsIgnoreCase("series")){
		pagePath = "series.do";
	}
	if(menu.equalsIgnoreCase("affiliate")){
		pagePath = "affiliate.do";
	}
	if(menu.equalsIgnoreCase("connection")){
		pagePath = "connection.do";
	}
	
	if(request.getQueryString()!=null){
		pagePath += "?" + request.getQueryString();
	} 
	session.setAttribute("before-login-redirect", pagePath);
%>
</logic:notPresent>

<%	
	String redirect = (String)session.getAttribute("redirect");
	if(redirect != null){
		session.removeAttribute("redirect");
%>
	<script>
		window.location="<%=redirect%>";
	</script>
<%
	}		
%>
<div align="center">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
<% 
	if(user_id != null){// && menu.equalsIgnoreCase("profile")){
%>
		<tr>
			<td align="left">
<% 
		sql = "SELECT name FROM userinfo WHERE user_id = " + user_id;
		rs = conn.getResultSet(sql);
		if(rs.next()){
			String _username = rs.getString("name");
%>
		&nbsp;<span style="color: #003399;font-size: 0.9em;font-weight: bold;"><%=_username %></span>&nbsp;
<% 
			if(ub!=null){
				String user0_id = user_id;
				String user1_id = "" + ub.getUserID();
				if(!user0_id.equalsIgnoreCase(user1_id)){
					
					if(Integer.parseInt(user_id) > ub.getUserID()){
						user0_id = "" + ub.getUserID();
						user1_id = user_id;
					}
					
					sql = "SELECT friend_id FROM friend WHERE user0_id=" + user0_id + " AND user1_id=" + user1_id + 
						" AND breaktime IS NULL";
					
					rs = conn.getResultSet(sql);
					if(rs.next()){
						String friend_id = rs.getString("friend_id");
					}else{//They are not friends. So is there any befriending request?
						
						sql = "SELECT request_id FROM request WHERE requester_id=" + ub.getUserID() + " AND target_id=" + user_id + 
							" AND droprequesttime IS NULL ORDER BY request_id DESC LIMIT 1";
						
						rs = conn.getResultSet(sql);
%>
		<span id="spanAddAsFriend">
<%
						boolean isNotNow = false;
						if(rs.next()){
							String request_id = rs.getString("request_id");
							//Something ...
%>
			<span style="font-size: 0.8em;font-style: italic;color: #aaaaaa;">Friend Request Sent</span> <a href="javascript:return false;" 
			onclick="addFriend(divAddFriend,spanAddAsFriend,<%=user_id%>,'drop');return false;"><img border='0' src='images/x.gif' /></a>
<%
						}else{
							sql = "SELECT request_id,notnowtime FROM request WHERE requester_id=" + user_id + " AND target_id=" + ub.getUserID() + 
								" AND accepttime IS NULL AND rejecttime IS NULL AND droprequesttime IS NULL ORDER BY requesttime DESC LIMIT 1";
							rs = conn.getResultSet(sql);
							if(rs.next()){
								String request_id = rs.getString("request_id");
								if(rs.getString("notnowtime")!=null){
									isNotNow = true;
								}
%>
			<input class ="btn" type="button" id="btnRespondRequest" value="Respond to Friend Request" onclick="showAddFriendDialog(divRespondRequest);return false;" />
<%		
							}else{
%>
			<input class ="btn" type="button" id="btnAddAsFriend" value="Add as Friend" onclick="showAddFriendDialog(divAddFriend);return false;" />
<%		
							}
						}
%>
		</span>
		<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="divAddFriend">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
						&nbsp;Send <%=_username %> a friend request?
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td colspan="2" style="font-size: 0.75em;padding: 4px;">
									<b><%=_username %></b> will have to confirm your request.
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="85%"><input class="btn" type="button" value="Send Request" onclick="addFriend(divAddFriend,spanAddAsFriend,<%=user_id%>,'add');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(divAddFriend);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
		<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="divRespondRequest">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
						&nbsp;Confirm <%=_username %> as a friend?
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td colspan="3" style="font-size: 0.75em;padding: 4px;">
									<b><%=_username %></b> would like to be your friend. If you know <%=_username %>, click Confirm.
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="85%"><input class="btn" type="button" value="Confirm" onclick="addFriend(divRespondRequest,spanAddAsFriend,<%=user_id%>,'accept');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="<%=isNotNow?"Delete Request":"Not Now" %>" onclick="addFriend(divRespondRequest,spanAddAsFriend,<%=user_id%>,<%=isNotNow?"'reject'":"'notnow'" %>);return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(divRespondRequest);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
<%-- 
		<input class ="btn" type="button" id="btnAddAsFriend" value="Add as Friend" />
		<div id="divAddFriend" title="Send <%=_username %> a friend request?">
			<p style="font-size: 0.75em;">
				<b><%=_username %></b> will have to confirm your request.
			</p>
		</div>
--%>
<%
					}
				}
			}
		}else{
%>
		User Not Found
<%		
		}
		conn.conn.close();
		conn = null;
%>
			</td>
		</tr>
<%
	}
	if(menu.equalsIgnoreCase("myaccount") || menu.equalsIgnoreCase("profile")){
%>
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="90">
<% 
		if(t!=null){
%>
							<div id="divBtnActivity" 
<% 
			if(v.equalsIgnoreCase("activity")){
%>
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
			}else{
%>
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
			}
%>
								align="center"
								onclick="window.location='profile.do?v=activity<%if(user_id!=null)out.print("&user_id="+user_id);%>'"
<%-- 
								onclick="flip2Activity();"
--%>								
								>
								Activity
							</div>
<%			
		}else{
%>
							<div id="divBtnActivity" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='profile.do?v=activity<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Activity
							</div>
<%			
		}
%>
						</td>
						<td width="90">
<% 
		if(t!=null){
%>
							<div id="divBtnInfo" 
<% 
			if(v.equalsIgnoreCase("info")){
%>
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
			}else{
%>
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
			}
%>
								align="center"
								onclick="window.location='profile.do?v=info<%if(user_id!=null)out.print("&user_id="+user_id);%>'"
<%-- 
								onclick="flip2Info();"
--%>
								>
								Info
							</div>
<%		
		}else{
%>
							<div id="divBtnInfo" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='profile.do?v=info<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Info
							</div>
<%		
		}
%>
						</td>
						<td width="90">
<% 
		if(t==null&&v.equalsIgnoreCase("bookmark")){
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2Bookmark();">
								Bookmark
							</div>
<%
		}else if(t==null){
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Bookmark();">
								Bookmark
							</div>
<%
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=bookmark'">
								Bookmark
							</div>
<%		
		}else{
%>
							<div id="divBtnBookmark" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=bookmark<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Bookmark
							</div>
<%		
		}
%>
						</td>
						<td width="90">
<% 
		if(t==null&&v.equalsIgnoreCase("post")){
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2Post();">
								Post
							</div>
<% 
		}else if(t==null){
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Post();">
								Post
							</div>
<% 
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=post'">
								Post
							</div>
<%		
		}else{
%>
							<div id="divBtnPost" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=post<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Post
							</div>
<%		
		}
%>
						</td>
						<td width="90">
<% 
		if(t==null&&v.equalsIgnoreCase("impact")){
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2Impact();">
								Impact
							</div>
<% 
		}else if(t==null){
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2Impact();">
								Impact
							</div>
<% 
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=impact'">
								Impact
							</div>
<% 
		}else{
%>
							<div id="divBtnImpact" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=impact<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Impact
							</div>
<% 
		}
%>
						</td>
						<td width="140">
<% 
		if(t==null&&v.equalsIgnoreCase("summary")){
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
								align="center"
								onclick="flip2ImpactSummary();">
								Impact Summary
							</div>
<% 
		}else if(t==null){
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="flip2ImpactSummary();">
								Impact Summary
							</div>
<% 
		}else if(menu.equalsIgnoreCase("myaccount")){
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='myaccount.do?v=summary'">
								Impact Summary
							</div>
<% 
		}else{
%>
							<div id="divBtnImpactSummary" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='calendar.do?v=summary<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Impact Summary
							</div>
<% 
		}
%>
						</td>
<%
		//This tab is being shown only for the login user
%>						
							<td width="100">
<% 
		if(ub!=null){
			if(user_id==null||user_id==String.valueOf(ub.getUserID())){
				if(t!=null){
%>
							<div id="divBtnConnection" 
<% 
					if(v.equalsIgnoreCase("connection")){
%>
								style="font-size: 0.9em;font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
					}else{
%>
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
					}
%>
								align="center"
								onclick="flip2Connection();">
								Connection
							</div>
<%		
				}else{
%>
							<div id="divBtnConnection" 
								style="font-size: 0.9em;color: #003399;border: 1px #003399 solid;margin: 3px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="window.location='profile.do?v=connection<%if(user_id!=null)out.print("&user_id="+user_id);%>'">
								Connection
							</div>
<%		
				}
			}
		}	
%>
						</td>
						
							
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
<%	
	}

	if((menu.equalsIgnoreCase("profile") || menu.equalsIgnoreCase("calendar") || menu.equalsIgnoreCase("myaccount"))&&t==null){	
%>
		<tr>
			<td align="center">
				<table width="350" border="0" cellpadding="0" cellspacing="0" style="font-size:0.9em;">
					<tr>
						<td width="40">
							<div id="divBtnBack" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="back();">
								&laquo;
							</div>
						</td>
						<td width="90">
							<div id="divBtnDay"
<% 
		if(req_day > 0){
%>
								style="font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
		}else{
%>
								style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
		}
%> 
								align="center"
								onclick="flip2Day();">
								Day
							</div>
						</td>
						<td width="90">
							<div id="divBtnWeek" 
<% 
		if(req_day <= 0 && req_week > 0){
%>
								style="font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
		}else{
%>
								style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
		}
%> 
								align="center"
								onclick="flip2Week();">
								Week
							</div>
						</td>
						<td width="90">
							<div id="divBtnMonth" 
<% 
		if(req_day <= 0 && req_week <= 0){
%>
								style="font-weight: bold;background: #003399;color: #ffffff;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#ffffff';this.style.color='#003399';"
								onmouseout="this.style.background='#003399';this.style.color='#ffffff';"
<%			
		}else{
%>
								style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
<%			
		}
%> 
								align="center"
								onclick="flip2Month();">
								Month
							</div>
						</td>
						<td width="40">
							<div id="divBtnNext" style="color: #003399;border: 1px #003399 solid;margin: 1px;cursor: pointer;" 
								onmouseover="this.style.background='#003399';this.style.color='#ffffff';"
								onmouseout="this.style.background='#ffffff';this.style.color='#003399';"
								align="center"
								onclick="next();">
								&raquo;
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<% 
	}
	
%>

		<tr>
			<td>
				<div id="<%=menu.equalsIgnoreCase("home")?"divActivities":"divTalks" %>">
<% 
	if(menu.equalsIgnoreCase("calendar")){
%>
<%-- 
						//window.setTimeout(function(){flip2Week();},50);
						//flip2Day();
						flip2Week();
--%>
					<tiles:insert template="/utils/loadTalks.jsp" />
<%		
	}else if(v.equalsIgnoreCase("activity")){
%>
					<tiles:insert template="/profile/activity.jsp" />
<%		
	}else{
%>
					<script type="text/javascript">
<%
		if(v.equalsIgnoreCase("connection")){
%>
					//window.setTimeout(function(){flip2Connection();},50);
					//flip2Connection();
					loadConnections();
<%		
		}else if(menu.equalsIgnoreCase("affiliate")||menu.equalsIgnoreCase("community")||menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("tag")||menu.equalsIgnoreCase("entity")){
	
%>
						var action = "utils/loadTalks.jsp<%if(request.getQueryString()!=null)out.print("?"+request.getQueryString());%>";
						//window.setTimeout(function(){loadTalks(action);},50);
						loadTalks(action);
<%		
	}else if(v.equalsIgnoreCase("info")){
%>
						//window.setTimeout(function(){flip2Info();},50);
						flip2Info();
<%		
	}else if(v.equalsIgnoreCase("activity")){
%>
						//window.setTimeout(function(){flip2Activity();},50);
						flip2Activity();
<%		
	}else if(v.equalsIgnoreCase("bookmark")){
%>
						//window.setTimeout(function(){flip2Bookmark();},50);
						flip2Bookmark();
<%		
	}else if(v.equalsIgnoreCase("post")){
%>
						//window.setTimeout(function(){flip2Post();},50);
						flip2Post();
<%		
	}else if(v.equalsIgnoreCase("impact")){
%>
						//window.setTimeout(function(){flip2Impact();},50);
						flip2Impact();
<%		
	}else if(v.equalsIgnoreCase("summary")){
%>
						//window.setTimeout(function(){flip2ImpactSummary();},50);
						flip2ImpactSummary();
<%		
	}else{
%>
						var action = "utils/loadTalks.jsp<%=request.getQueryString()!=null?"?"+request.getQueryString():"" %>";
						//window.setTimeout(function(){loadTalks(action);},50);
						loadTalks(action);
<%		
		}
%>
					</script>
<%
	}
%>
				</div>
			</td>
		</tr>
	</table>
</div>

<div style="display:none;z-index: 999;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="linkedInvit">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 550px;border: 1px solid #aaaaaa;">
				<tr>
					<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td colspan="3">
						<table cellpadding="0" cellspacing="0" width="100%" border="0" bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
							<tr>
								<td id="tdPostTitle">
									&nbsp;CoMeT Invitation
								</td>
								<td style="width: 10px;">
									<a href="javascript: return false;" onclick="$('#btnINInviteClose').click();">
										<img alt="Close Window" src="images/x.gif">
									</a>
								</td>
							</tr>
						</table>
					</td>
				
				</tr>
				<tr>
					<td valign="top">Your Message: </td>
					<td colspan="2" style="border: 1px solid #efefef;">
						<textarea id="txtINMessage" rows="4" cols="60"></textarea>
					</td>
				</tr>
				<tr style="background-color: #efefef;">
					<td align="right" width="100">&nbsp;</td>
					<td align="right" width="410"><input id="btnDoneINInviting" class="btn" type="button" value="Send Invitation"></input> </td>
					<td align="center" width="40"><input id="btnINInviteClose" class="btn" type="button" value="Cancel" onclick="$('#linkedInvit textarea,input:text').val('');$('#linkedInvit').fadeOut();return false;"></input></td>
				</tr>
			</table>
		</div>
		
<div id="divPostCalDate" style="display: none;">
	<form id="frmPostCalDate" method="post" action="calendar.do">
		<input type="hidden" id="inDay" name="day" value="-1" />
		<input type="hidden" id="inWeek" name="week" value="-1" />
		<input type="hidden" id="inMonth" name="month" value="-1" />
		<input type="hidden" id="inYear" name="year" value="-1" />
	</form>
</div>