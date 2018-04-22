<%@page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.form.ColloquiumForm"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.*"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.ArrayList"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	session=request.getSession(false);
	connectDB conn = new connectDB();
%>


<logic:present name="UserSession">
<% 
	session.removeAttribute("redirect");
%>
<!-- calendar stylesheet -->
<link rel="stylesheet" type="text/css" media="all" href="css/calendar-win2k-cold-1.css" title="win2k-cold-1" />

<!-- main calendar program -->
<script type="text/javascript" src="scripts/calendar.js"></script>

<!-- language for the calendar -->
<script type="text/javascript" src="scripts/calendar-en.js"></script>

<!-- the following script defines the Calendar.setup helper function, which makes
     adding a calendar a matter of 1 or 2 lines of code. -->
<script type="text/javascript" src="scripts/calendar-setup.js"></script>

<%-- 
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>	

<script src="ckeditor/_samples/sample.js" type="text/javascript"></script> 
<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css"/>
--%>

<script src="https://www.google.com/jsapi?key=ABQIAAAAJV4VSZegWFWQprtTfauynxQNhFvRy9-gdGqZBHpj1luIRJ1nLBS2fCJx1UmWsKM7FHDCz6YzvKqUWg"></script>

<script type="text/javascript">
    var counter = 0;

      google.load('search', '1');

      var imageSearch;
	  
	  //show more pages
	  function addPaginationLinks() {
        // To paginate search results, use the cursor function.
        var cursor = imageSearch.cursor;
        var curPage = cursor.currentPageIndex; // check what page the app is on
        var pagesDiv = document.createElement('div');
        
        pagesDiv.id = "pageDiv";
        for (var i = 0; i < cursor.pages.length; i++) {
          var page = cursor.pages[i];
          if (curPage == i) { 

          // If we are on the current page, then don't make a link.
            var label = document.createTextNode('  ' + page.label + '  ');
            
            pagesDiv.appendChild(label);
          } else {

            // Create links to other pages using gotoPage() on the searcher.
            var link = document.createElement('a');
            link.href = 'javascript:imageSearch.gotoPage('+i+');';
            link.innerHTML = page.label;
            link.style.marginRight = '4px';
            link.style.marginLeft = '4px';
            pagesDiv.appendChild(link);
          }
        }

        //var contentDiv = document.getElementById('content_' + counter);
        var contentDiv = document.getElementById('content');
        contentDiv.appendChild(pagesDiv);
      }

     

      function searchComplete() {
    	
        // Check that we got results
        if (imageSearch.results && imageSearch.results.length > 0) {

          // Grab our content div, clear it.
          //var contentDiv = document.getElementById('content_'+counter);
          var contentDiv = document.getElementById('content');
          contentDiv.innerHTML = '';

          // Loop through our results, printing them to the page.
          var results = imageSearch.results;
          for (var i = 0; i < results.length; i++) {
            // For each result write it's title and image to the screen
            var result = results[i];
            
            var imgContainer = document.createElement('div');
            imgContainer.id = "picDiv";
            //$(imgContainer).addClass('picDiv');
            
            var imgContainerInside = document.createElement('div');
            imgContainerInside.id = "imgDiv";
            //$(imgContainerInside).addClass('imgDiv');
            
            var rdoContainer = document.createElement('div');
            //$(rdoContainer).addClass('rdoDiv');
            rdoContainer.id = "rdoDiv";
            
            var newImg = document.createElement('img');
            //newImg.id ='img_id_'.concat(i);
            
            // There is also a result.url property which has the escaped version
            newImg.src = result.tbUrl;
            var $pic_src = result.tbUrl;
            imgContainerInside.appendChild(newImg);
            var rdo = document.createElement('input');
            rdo.type = 'button';
            rdo.id = 'radio_' + i;

			//$(rdo).attr('name','btnSelectImg');
			$(rdo).attr('class','btn');
            $(rdo).val('Select');
            /*$(rdo).name = result.tbUrl;
            $(rdo).unbind();
            $(rdo).click(function(){
                alert($(this).parent().children('img').attr('src'));
            	showImg(this.name);
            });*///showImg($(rdo).parent().children('.imgDiv.img').attr('src'));
            rdo.name = result.tbUrl;//'Select';
            rdo.onclick= function() {showImg(this.name);};
            rdoContainer.appendChild(rdo);
            
            imgContainer.appendChild(imgContainerInside);
            imgContainer.appendChild(rdoContainer);
            // Put our image in the content
            contentDiv.appendChild(imgContainer);
            //alert("haha");
          }
			

          // Now add links to additional pages of search results.
          addPaginationLinks(imageSearch);
        }
      }
	  
      function showImg(src){
    	  //var image = document.getElementById('imgDisplay_'+counter);
    	  var image = document.getElementById('imgDisplay');
    	  image.src = src;
      }
      
	function searchImage(imagekeyword){
    	 
		// Create an Image Search instance.
		imageSearch = new google.search.ImageSearch(); 		
		imageSearch.setRestriction(google.search.ImageSearch.RESTRICT_IMAGETYPE, google.search.ImageSearch.IMAGETYPE_FACES);		         
		// Set searchComplete as the callback function when a search is          
		// complete.  The imageSearch object will have results in it.          
		imageSearch.setSearchCompleteCallback(this, searchComplete, null);         
		// execute search
		imageSearch.execute(imagekeyword);               
		// Include the required Google branding         
		//google.search.Search.getBranding('branding');

		$("#content").show();
			         
     }

	var nameArray = new Array();
	var affiliationArray = new Array();
	var pictureArray = new Array();
	var currentSponsor;
	var currentSeries;

	function addSpeakerElement() {
		
		var name = document.getElementById('nameInput');
		var affiliation = document.getElementById('affiliationInput');
		var image = document.getElementById('imgDisplay');
		
		if (affiliation.value == ''){
			alert("Please enter the affiliation of speaker.");
			return;
		}

		var container = document.getElementById('speaker_container');		
		var trObj = document.createElement('tr');
		trObj.setAttribute('id','speaker_tr_' + counter);	
				
		var tdLabelObj = document.createElement('td');
		tdLabelObj.innerHTML = '&nbsp;';
		trObj.appendChild(tdLabelObj);
			
		var tdSpeakerObj = document.createElement('td');
		
		var tab = document.createElement('table');
		tab.setAttribute('class', 'showSpeakers');
		tab.setAttribute('width', '100%');
		
		var tr1 = document.createElement('tr');
		var tr2 = document.createElement('tr');
		
		var tdImage = document.createElement('td');
		tdImage.setAttribute('rowspan', 2);
		tdImage.setAttribute('align','right');
		var imageObj = document.createElement('img');
		imageObj.setAttribute('src', image.src);
		tdImage.appendChild(imageObj);
		$(tdImage).attr("width","10%");
		
		var tdName = document.createElement('td');
		var nameObj = document.createElement('label');
		nameObj.innerHTML = "<b>Name:</b> " + name.value;
		tdName.appendChild(nameObj);
		$(tdName).attr("width","90%");
		
		tr1.appendChild(tdName);
		tr1.appendChild(tdImage);
		
		
		var tdAffiliation = document.createElement('td');
		var affiliationLabelObj = document.createElement('label');
		affiliationLabelObj.innerHTML ="<b>Affiliation:</b> " + affiliation.value;	
		tdAffiliation.setAttribute('valign','top');
		tdAffiliation.appendChild(affiliationLabelObj);	
		tr2.appendChild(tdAffiliation);
	
		tab.appendChild(tr1);
		tab.appendChild(tr2);
		tdSpeakerObj.appendChild(tab);
		
		var tdRemoveObj = document.createElement('td');
		tdRemoveObj.setAttribute('valign','top');
		
		var buttonObj = document.createElement('input');
		buttonObj.setAttribute('class','btn');
		buttonObj.setAttribute('type','button');
		buttonObj.setAttribute('name', counter);
		buttonObj.setAttribute('value','Remove Speaker');
		buttonObj.style.float = "right";
		
		buttonObj.onclick = function(){
			trObj.parentNode.removeChild(trObj);
			nameArray[this.name] = '';
			affiliationArray[this.name] = '';
		}; 	
		
		tdRemoveObj.appendChild(buttonObj); 
	
		trObj.appendChild(tdSpeakerObj);
		trObj.appendChild(tdRemoveObj);
		container.appendChild(trObj);
		nameArray[counter] = name.value;
		affiliationArray[counter] = affiliation.value;
		pictureArray[counter] = image.src;
		
		
		name.value = '';
		affiliation.value = '';
		document.getElementById('trShowImage').style.display = "none";	
		var cell = document.getElementById("content");
		if ( cell.hasChildNodes() )
		{
		    while ( cell.childNodes.length >= 1 )
		    {
		        cell.removeChild( cell.firstChild );       
		    } 
		}
		counter++;

		$("#image").html("&nbsp;");
	}

	$(document).ready(function() {
		
	  $("input#series").autocomplete("series.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {			
				return  value.split(";")[0];
					
			},
	  		formatResult: function(data, value) {
				return value.split(";")[0];
			}
	  }).result(function(event, data, formatted) {
		  
		  if (data){
			  currentSeries = formatted.split(";")[1];
			  $("input#sponsor").val(formatted.split(";")[3]);
			  currentSponsor = formatted.split(";")[2];
		  }	else if ($("input#series").val().length > 0){
			  //confirm();  
		  } 
		  		  		 
	  }).blur(function(){
		    $(this).search();
	  }); 
	
	 
	  $("input#sponsor").autocomplete("utils/sponsor.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {			
				return  value.split(";")[0];
					
			},
			formatResult: function(data, value) {
				return value.split(";")[0];
			}
	  }).result(function(event, data, formatted) {
		  currentSponsor = formatted.split(";")[1];
		  
	  }); 
	  
	  $("input#nameInput").autocomplete("speakers.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {
				var imageSrc = value.split(";")[2];
				if (imageSrc != "null"){
					if (imageSrc.indexOf("http") != 0){
						imageSrc = "images/speaker/" + imageSrc;
					}
					return "<table><tr><td rowspan=\"2\">" + "<img src='" + imageSrc + "' height=\"50\" width=\"50\" /> </td>" 
					+ "<td style=\"font-size:12px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				
				}
				else {
					return "<table><tr><td rowspan=\"2\">" + "<img src='images/speaker/avartar.gif' height=\"50\" width=\"50\" /> </td>" 
					+ "<td style=\"font-size:12px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				}
				
			},
	  		formatResult: function(data, value) {
				return value.split(";")[0];
			}
	  }).result(function(event, data, formatted) {
		  
		  if (data){
			  $("input#affiliationInput").val(formatted.split(";")[1]);
			  //$("#trShowImage").css("visibility", "visible");
			 
			  var imageSrc = formatted.split(";")[2];
			  if (imageSrc != "null"){
				  if (imageSrc.indexOf("http") != 0){
						imageSrc = "images/speaker/" + imageSrc;			
				  }
				  $("#trShowImage").css("display", "table-row");
				  $("input#selectImg").val("Not this Person?");
				  $("input#selectImg").show();
				  $("div#image").html("<img id='imgDisplay' src='" + imageSrc + "' />");
				  $("#content").hide();
				  
			  }else{
				  imageSrc = "images/speaker/avartar.gif";
				  $("#trShowImage").css("display", "table-row");
				  //$("input#selectImg").val("Select a picture");
				  $("input#selectImg").hide();
				  searchImage($("input#nameInput").val() + ' ' + $("input#affiliationInput").val());
				  $("div#image").html("<img id='imgDisplay' src='" + imageSrc + "' />");
				 
				  
			  }
		  }	else if ($("input#nameInput").val().length > 0){
			  imageSrc = "images/speaker/avartar.gif";
			  $("#trShowImage").css("display", "table-row");
			  //$("input#selectImg").val("Select a picture");
			  $("input#selectImg").hide();
			  searchImage($("input#nameInput").val() + ' ' + $("input#affiliationInput").val());
			  $("div#image").html("<img id='imgDisplay' src='" + imageSrc + "' />");
			  
		  } 
		  		  		  
	  }).blur(function(){
		    $(this).search();
	  });	  
	 
	});

	var num_sponsor = 0;
	var sponsorArray = new Array();
	var num_series = 0;
	var seriesArray = new Array();
	
	/****insert tags ****/
	function insert(tag, divName){
		var el = document.getElementById(divName);	
		if (divName == "seriesTags"){
			el.innerHTML += '<div style="clear: both; "><div class="tags">' + tag + '&nbsp;&nbsp;</div><input id=\'' + 
							num_series + '\' style="float:left" height="15" width="15" type="image" src="images/delete.jpg" ' +
							'onclick="deleteTag(this, \'' + tag + '\',\'' + divName + '\' )"/></div>';
			document.ColloquiumForm.series.value = "";  
			seriesArray[num_series] = currentSeries;
			num_series++;
		}else{
			el.innerHTML += '<div style="clear: both; "><div class="tags">' + tag + '&nbsp;&nbsp;</div><input id=\'' + num_sponsor + 
							'\' style="float:left" height="15" width="15" type="image" src="images/delete.jpg" onclick="deleteTag(this, \'' + tag + '\',\'' + divName + '\' )"/></div>';
			document.ColloquiumForm.sponsor.value = "";  
			sponsorArray[num_sponsor] = currentSponsor;
			num_sponsor++;
		}
		
	}
	
	/** delete tags **/
	function deleteTag(element, tag, divName){
		 var parentElement = element.parentNode;
		 var parentElement2 = parentElement.parentNode;
	     if(parentElement2){
	            parentElement2.removeChild(parentElement);  
	     }
	     var index = element.id;
	     if (divName == "seriesTags"){	 
	     	 seriesArray[index] = "";
	     }else{
	     	 sponsorArray[index] = "";
	     }
	        
	}

	function submitform(){
		var ready = true;
		var speakerAffiliation = document.getElementById('affiliation');
		var speakerName = document.getElementById('speaker');
		var speakerPic =  document.getElementById('picURL');
		var sponsor = document.getElementById('sponsor_id');
		var series = document.getElementById('series_id');
		if (num_sponsor == 0){
			if (document.getElementById("sponsor").value != ''){
				sponsor.value = currentSponsor + ";;";	
			}
		}
		if (num_series == 0){
			if (document.getElementById("series").value != ''){
				series.value = currentSeries + ";;";	
			}
		}

		speakerName.value = '';
		speakerAffiliation.value = '';
		speakerPic.value = '';
		
		for(var i = 0; i < nameArray.length; i++){
			speakerName.value += nameArray[i] + ";;";

			if (affiliationArray[i] == '')
				affiliationArray[i] = 'null';
			speakerAffiliation.value += affiliationArray[i] + ";;";

			speakerPic.value += pictureArray[i] + ";;";
		}

		if (counter == 0){ //did not click "Add"
			if (document.getElementById("nameInput").value != ''){
				speakerName.value = document.getElementById("nameInput").value + ";;";
				var affiliation = document.getElementById("affiliationInput");
				if (affiliation.value == '')
					affiliation.value = 'null';
				speakerAffiliation.value = affiliation.value + ";;";
				speakerPic.value = document.getElementById("imgDisplay").src + ";;";
			}else{
				if(nameArray.length == 0){
					ready = false;
					alert("No speaker added");
					return;
				}
			}
			
		}

		for (var i = 0; i < sponsorArray.length; ++i){
			if (sponsorArray[i] != '')
				sponsor.value += sponsorArray[i] + ";;";
		}
		for (var i = 0; i < seriesArray.length; ++i){
			if (seriesArray[i] != '')
				series.value += seriesArray[i] + ";;";
		}
		//check whether all required fields have been filled
		if (document.getElementById("title").value == '' || document.getElementById("location").value == ''
			|| document.getElementById("f_date_c").value == ''){
			ready = false;
		}
		if (ready)
	  		document.forms[1].submit();
		else
			alert("Please fill all required fields!");
	}

function showAll(ele, id){
	if (ele.value == 'Show All'){
		document.getElementById(id).style.display = "table-row";
		ele.value = "Hide All";
	}else{
		document.getElementById(id).style.display = "none";
		ele.value = "Show All";
	}
}

function showChildren(obj,btn){
	if(obj){
		obj.style.display = "block";
		btn.style.width="0px";
		btn.style.display="none";
	}
}

</script>
 

		<!-- preload the images -->


<logic:present name="Colloquium">
<% 
	ColloquiumForm cqf = (ColloquiumForm)session.getAttribute("Colloquium");
	String title = cqf.getTitle();
	long col_id = cqf.getCol_id();
	boolean writable = false;
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	if(ub != null){
		//out.print("ub.getUserID(): " + ub.getUserID());
		if(ub.isWritable()){
			writable = true;
		}
	}
	
	if(writable){
%>
<span style="font-size: 0.8em;font-weight: bold;color: green;text-decoration: none;">
	<a style="text-decoration: none;" href="presentColloquium.do?col_id=<%=col_id %>"><%=title %></a> was Submitted Successfully!
</span>
<br/><br/>
<span style="font-size: 0.8em;">It will automatically redirect to the talk page in 3 seconds.</span><br/>
<% 
	}else{
%>
<span style="font-size: 0.8em;font-weight: bold;color: green;text-decoration: none;">
	Thank you for posting a talk!<br/>
	The <%=title %> will be reviewed shortly.
</span>
<br/><br/>
<% 
	}
	if(writable){
%>
<script type="text/javascript">
	var talkpage = "presentColloquium.do?col_id=<%=col_id %>";
	window.setTimeout(function(){window.location = talkpage;},3000);
</script>
<% 
	}
%>
<span style="font-size: 0.8em;">
Questions can be directed to CoMeT via email at 
<a href="mailto:comet.paws@gmail.com">comet.paws@gmail.com</a>.</span>
</logic:present>

<logic:notPresent name="Colloquium">

<style type='text/css' media='all'>
.showSpeakers{
	font-size: 1em;
}

.requiredField{
	font-weight: bold;
	margin: 0 3px;
	color: red;
} 
 ul li{
     list-style-type:none;
     margin:0;
     padding:0;
     margin-left:8px;
 }
#content{
 	margin:5px 0px;
	margin-bottom: 20px;
 	float: left;
 }
#picDiv{
 	margin:5px 20px;
 	margin-left: 0;
 	text-align: center;
 	float: left;
 }
#pageDiv{
  	clear:both;
  	margin: 15px 0;
 	text-align: center;
 	padding:0 3px;
 }
#imgDiv{
 	text-align: center;
}
#rdoDiv{
 	margin: 5px 40px;
 	text-align: center;
}
</style>

<html:form action="/PostColloquiumEntry" method="post">


<table width="100%" border="0" cellspacing="0" cellpadding="0" >
<% 
	//UserBean ub = (UserBean)session.getAttribute("UserSession");
	String col_id = "0";
	String title = "";
	String speaker = "";
	String affiliation = "";
	String picURL = null;
	String host = "";
	HashSet<String> seriesSet = new HashSet<String>();
	String _date = "";
	String begintime = "";
	String endtime = "";
	String location = "";
	String detail = "";
	String url = "";
	String paper_url = "";
	String video_url = "";
	String slide_url = "";
	String s_bio = "";
	HashSet<String> sponsorSet = new HashSet<String>();
	HashSet<String> pathSet = new HashSet<String>();

	class sp{
		private String name = null;
		private String affiliation = null;
		private String picURL = null;
		public sp(String name,String affiliation,String picURL){
			this.name = name;
			this.affiliation = affiliation;
			this.picURL = picURL;
		}
		public String getName(){
			return name;
		}
		public String getAffiliation(){
			return affiliation;
		}
		public String getPicURL(){
			if(picURL==null){
				return "images/speaker/avartar.gif";
			}else{
				return picURL;
			}
		}
	}
	
	ArrayList<sp> speakerList = new ArrayList<sp>();
	HashSet<Integer> areaSet = new HashSet<Integer>();
	
	String sql = "SELECT c.col_id,c.title,s.name,s.affiliation,h.host,date_format(c._date,_utf8'%m/%d/%Y') _date," +
					"date_format(c.begintime,_utf8'%l %i %p') _begin,s.picURL," +
					"date_format(c.endtime,_utf8'%l %i %p') _end,c.location,c.detail,c.url,c.video_url,c.slide_url,c.s_bio,c.paper_url " +
					"FROM colloquium c LEFT OUTER JOIN speaker s ON c.speaker_id = s.speaker_id " +
					"LEFT OUTER JOIN host h ON c.host_id = h.host_id " + 
					"WHERE " +
					//"c.user_id = " + ub.getUserID() + " AND " +
					"c.col_id = " + request.getParameter("col_id");
	ResultSet rs = conn.getResultSet(sql);
	if(rs.next()){
		col_id = rs.getString("col_id");
		title = rs.getString("title");
		speaker = rs.getString("name");
		affiliation = rs.getString("affiliation");
		picURL = rs.getString("picURL");
		host = rs.getString("host");
		if(host == null){
			host = "";
		}
		_date = rs.getString("_date");
		begintime = rs.getString("_begin");
		endtime = rs.getString("_end");
		location = rs.getString("location");
		detail = rs.getString("detail");
		url = rs.getString("url");
		video_url = rs.getString("video_url");
		if(video_url==null){
			video_url = "";
		}
		slide_url = rs.getString("slide_url");
		if(slide_url==null){
			slide_url = "";
		}
		s_bio = rs.getString("s_bio");
		if(s_bio==null){
			s_bio = "";
		}
		paper_url = rs.getString("paper_url")==null?"":rs.getString("paper_url");
		
		sql = "SELECT r.path,a.affiliate_id FROM affiliate_col a JOIN relation r ON a.affiliate_id = r.child_id WHERE a.col_id = " + request.getParameter("col_id");
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
		
		sql = "SELECT s.name,s.affiliation,s.picURL FROM speaker s JOIN col_speaker cs ON s.speaker_id = cs.speaker_id " +
				"WHERE cs.col_id=" + request.getParameter("col_id");
		rs = conn.getResultSet(sql);
		while(rs.next()){
			speakerList.add(new sp(rs.getString("name"),rs.getString("affiliation"),rs.getString("picURL")));
		}
		if(speakerList.size() == 0 && speaker!=null){
			speakerList.add(new sp(speaker,affiliation,picURL));
		}
		
		sql = "SELECT area_id FROM area_col WHERE col_id=" + col_id;
		rs = conn.getResultSet(sql);
		while(rs.next()){
			areaSet.add(rs.getInt(1));
		}
	}
	
%>
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td width="85%" colspan="2" bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
<%
	if(col_id.equalsIgnoreCase("0")){
%>
				Post Talk
<%	
	}else{
%>
				Edit Talk
<%	
	}
%>
		</td>
	</tr>
	<logic:present name="SubmitTalkError">
<% 
	String error = (String)session.getAttribute("SubmitTalkError");
%>
	<tr>
		<td colspan="2">
			<font color="red"><b><%=error%></b></font>
		</td>
	</tr>
	</logic:present>

	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size: 0.7em;">
				<tr> 
						<td width="20%" valign="top" style="font-weight: bold;">Title<span class="requiredField">*</span>:</td>
			  		<td><input style="font-size: 1em;" id ="title" name="title" size="160" value="<%=title.replaceAll("\"","&quot;") %>"/></td>
			  		
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><b><html:errors property="title"/></b></font></td>
				</tr>
				<tr>
							<td width="20%" valign="top" style="font-weight: bold;">
								Speaker<span class="requiredField">*</span>:					
							</td>
							
							<td>
								<table width="100%" class="showSpeakers">
									<tbody id = "speaker_container">
<% 
	int ii=0;
	for(sp s : speakerList){
%>
										<tr id="speaker_tr_<%=ii %>">
											<td>&nbsp;</td>
											<td>
												<table class="showSpeakers" width="100%" cellpadding="0" cellspacing="0">
													<tr>
														<td width="90%">
															<label>
																<b>Name:</b> <%=s.getName() %>
															</label>
														</td>
														<td width="10%" rowspan="2" align="right">
															<img src="<%=s.getPicURL() %>" />
														</td>
													</tr>
													<tr>
														<td valign="top">
															<label>
																<b>Affiliation:</b> <%=s.getAffiliation() %>
															</label>
														</td>
													</tr>
												</table>
											</td>
											<td valign="top">
												<input class="btn" type="button" name="<%=ii %>" value="Remove Speaker" style="float: right;"
													onclick="nameArray[this.name] = '';affiliationArray[this.name] = '';this.parentNode.parentNode.parentNode.removeChild(this.parentNode.parentNode);">
											</td>
										</tr>
<%
		ii++;
	}
%>					
									</tbody>
								</table>
							</td>
						</tr>
<% 
	if(ii>0){
%>
<script type="text/javascript">
//$(document).ready(function() {
	counter=<%=ii %>;
<% 
	ii=0;
	for(sp s : speakerList){
%>
	nameArray[<%=ii %>] = '<%=s.getName().replaceAll("'","\\\\'") %>';
	affiliationArray[<%=ii %>] = '<%=s.getAffiliation().replaceAll("'","\\\\'") %>';
	pictureArray[<%=ii %>] = '<%=s.getPicURL().replaceAll("'","\\\\'") %>';
<%		
		ii++;
	}
%>	
//});
</script>
<%		
	}
%>
				<tr>
					<td id="tdImage">
						<div id="image"></div>
					</td>
					<td valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" style="font-size: 1em;">
							<tr>
								<td valign="top"><b>Name<span class="requiredField">*</span>: </b><input style="font-size: 1em;" id="nameInput" name="nameInput"  size="40" value=""/> </td>
								<td valign="top"><b>Affiliation<span class="requiredField">*</span>:</b><input style="font-size: 1em;" id="affiliationInput" name="affiliationInput"  size="70" value=""/> </td>
								<td valign="top"><input type="button" class="btn" onclick="addSpeakerElement();return false;" value="Add" /></td>
							</tr>
						</table>
					</td>	
				</tr>
				<tr id="trShowImage" style="display:none;">
					<td style="vertical-align: top">
						<input class="btn" style="margin:5px 0;" type="button" id="selectImg" value="Not this Picture?" onclick='searchImage(nameInput.value.concat(" ",affiliationInput.value))'/>
					</td>
					<td>
						<div id="content"></div>
					</td>
				</tr>
				
				
				<tr>
					<td><input type="hidden" id="speaker" name="speaker" size="20" /> </td>
					<td><input type="hidden" id="affiliation" name="affiliation" size="20" /></td>
					<td><input type="hidden" id="picURL" name="picURL" /> </td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><b><html:errors property="speaker"/></b></font></td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><b><html:errors property="affiliation"/></b></font></td>
				</tr>
				<tr> 
					<td width="20%" style="font-weight: bold;">Person hosting a talk: </td>
				  	<td><html:text style="font-size: 1em;" property="host" size="80" value="<%=host%>"/></td>
				</tr>
				<tr> 
					<td colspan="2"><font style="color: red;"><html:errors property="host"/></font></td>
				</tr>
				<tr>
					<td width="20%" valign="top" style="font-weight: bold;">Series: </td>
					<td>
							<div id="seriesTags">
<% 
	int seriesno=0;
	String strSeriesArray = "";
	if(!col_id.equalsIgnoreCase("0")){
		sql = "SELECT s.series_id,s.name FROM series s JOIN seriescol sc ON s.series_id = sc.series_id WHERE sc.col_id=" + col_id;
		rs = conn.getResultSet(sql);
		while(rs.next()){
			String series_id = rs.getString("series_id");
			String name = rs.getString("name");
			seriesSet.add(rs.getString("series_id"));
%>
								<div style="clear: both; ">
									<div class="tags"><%=name %>&nbsp;&nbsp;</div><input id='<%=seriesno %>' style="float:left" height="15" width="15" type="image" src="images/delete.jpg" onclick="deleteTag(this, '<%=name %>','seriesTags' )"/></div>
<%		
			strSeriesArray += "seriesArray[" + seriesno + "]='" + series_id + "';";
			seriesno++;
		}
	}
%>
							</div>
<% 
	if(seriesno>0){
%>
<script type="text/javascript">
//$(document).ready(function() {
	num_series=<%=seriesno %>;
	<%=strSeriesArray %>
//});
</script>
<%		
	}
%>
							<div style="clear:both">
                				<input id="series" name="series" size="80"  /> 
								<input type="hidden" id="series_id" name="series_id" size="80"  />
								<input type="button" class="btn" value="Add" onClick="insert(document.ColloquiumForm.series.value, 'seriesTags')" />
								<input type="button" id="showAllSeriesBtn" class="btn" value="Show All" onClick="showAll(this,'showAllSeries')" />
							</div>
					</td>
					
				</tr>
				<tr>
					<td></td>
					<td id ="showAllSeries" style="display: none" >
<%	
	sql = "SELECT series_id,name FROM series " +
			//"WHERE semester = (SELECT currsemester FROM sys_config) " + 
			"ORDER BY name";
	rs = conn.getResultSet(sql);
%>
						<ul id="ulSeries">
<%
	while(rs.next()){
		String checked = "";
		String _series_id = rs.getString("series_id");
		String _name = rs.getString("name");
		if(seriesSet.contains(_series_id)){
			checked = "checked='checked'";
		}
%>
						<li>
							<input type="checkbox" onclick="insert('<%=_name%>', 'seriesTags')" name="series_list_id" value="<%=_series_id%>" <%=checked%>/>&nbsp;<%=_name%><br/>
						</li>
<%	
	}
%>
						</ul>	
					</td>
				</tr>
				
				<tr>
					<td width="20%" valign="top" style="font-weight: bold;">Sponsor: </td>
					<td>
							<div id="sponsorTags">
<% 
	sql = "SELECT r.child_id,r.fullPath FROM relation r JOIN affiliate_col ac ON r.child_id = ac.affiliate_id WHERE ac.col_id=" + col_id;
	rs = conn.getResultSet(sql);
	int sponsorno = 0;
	String strSponsorArray = "";
	while(rs.next()){
		String sponsor_id = rs.getString("child_id");
		String fullpath = rs.getString("fullPath");
%>
								<div style="clear: both; "><div class="tags"><%=fullpath %>&nbsp;&nbsp;</div><input id="<%=sponsorno %>" style="float:left" height="15" width="15" type="image" src="images/delete.jpg" onclick="deleteTag(this, '<%=fullpath %>','sponsorTags')"/></div>
<%
		strSponsorArray += "sponsorArray[" + sponsorno + "]='" + sponsor_id + "';";
		sponsorno++;
	}
%>							
							</div>
<% 
	if(sponsorno>0){
%>
<script type="text/javascript">
//$(document).ready(function() {
	num_sponsor=<%=sponsorno %>;
	<%=strSponsorArray %>
//});
</script>
<%		
	}
%>
							<div style="clear:both">
	                			<input id="sponsor" name="sponsor" size="80"  /> 
	 							<input type="hidden" id="sponsor_id" name="sponsor_id" size="80"  /> 
	 							<input type="button" class="btn" value="Add" onClick="insert(document.ColloquiumForm.sponsor.value, 'sponsorTags')" />
	 							<input type="button" id="showAllSponsorsBtn" class="btn" value="Show All" onClick="showAll(this,'showAllSponsors')" />
 							</div>
					</td>
					
				</tr>
				<tr>
					<td></td>
					<td id="showAllSponsors" style="display:none">
						<ul>
<% 
	sql = "SELECT a.affiliate_id,a.affiliate,r.fullPath FROM relation r JOIN affiliate a ON r.child_id = a.affiliate_id WHERE r.parent_id IS NULL ";
	ResultSet rs0 = conn.getResultSet(sql);
	while(rs0.next()){
		String aid = rs0.getString("affiliate_id");
		String aff = rs0.getString("affiliate");
		String fullpath = rs0.getString("fullPath");
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
								<input type="checkbox" onclick="insert('<%=fullpath%>', 'sponsorTags')" name="sponsor_list_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
		sql = "SELECT a.affiliate_id,a.affiliate,r.fullPath FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + 
		" ORDER BY a.affiliate";
		ResultSet rs1 = conn.getResultSet(sql);
		boolean lvl1Hidden = false;
		while(rs1.next()){
			aid = rs1.getString("affiliate_id");
			aff = rs1.getString("affiliate");
			fullpath = rs1.getString("fullPath");
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
										<input type="checkbox" onclick="insert('<%=fullpath%>', 'sponsorTags')" name="sponsor_list_id" value="<%=aid%>" <%=checked%> />&nbsp;&nbsp;<%=aff%>
<%
			sql = "SELECT a.affiliate_id,a.affiliate,r.fullPath FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + aid + " ORDER BY a.affiliate";
			ResultSet rs2 = conn.getResultSet(sql);
			boolean lvl2Hidden = false;
			while(rs2.next()){
				aid = rs2.getString("affiliate_id");
				aff = rs2.getString("affiliate");
				fullpath = rs2.getString("fullPath");
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
												<input type="checkbox" onclick="insert('<%=fullpath%>', 'sponsorTags')" name="sponsor_list_id"  value="<%=aid%>" <%=checked%> />
												&nbsp;&nbsp;<%=aff%>
<%
				sql = "SELECT a.affiliate_id,a.affiliate,r.fullPath FROM relation r,affiliate a WHERE r.child_id = a.affiliate_id AND r.parent_id = " + 
						aid + " ORDER BY a.affiliate";
				ResultSet rs3 = conn.getResultSet(sql);
				boolean lvl3Hidden = false;
				while(rs3.next()){
					aid = rs3.getString("affiliate_id");
					aff = rs3.getString("affiliate");
					fullpath = rs3.getString("fullPath");
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
														<input type="checkbox" onclick="insert('<%=fullpath%>', 'sponsorTags')" name="sponsor_list_id" value="<%=aid%>" <%=checked%> />
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
%>			
						</ul>
					</td>
				</tr>
				
				<tr> 
				  <td width="20%" style="font-weight: bold;">Date(month/date/year)<span class="requiredField">*</span>:</td>
				  <td>
					  <html:text style="font-size: 1em;" property="talkDate" size="10" styleId="f_date_c" value="<%=_date%>" />
					  <html:img page="/images/calendar.gif" styleId="f_trigger_c" 
					    style="cursor: pointer; border: 0px solid red;" 
					    imageName="Date selector"
						onmouseover="this.style.background='cyan';" 
						onmouseout="this.style.background=''" />  
					  <script type="text/javascript">
							      Calendar.setup({
							        inputField     :    "f_date_c",     // id of the input field
							        ifFormat       :    "%m/%d/%Y",     // format of the input field
							        button         :    "f_trigger_c",  // trigger for the calendar (button ID)
							        align          :    "Tl",           // alignment (defaults to "Bl")
							        singleClick    :    true
							    });
					  </script>
				   </td>			
				</tr>
				<tr> 
				  <td colspan="2"><font style="color: red;"><html:errors property="talkDate"/></font></td>
				</tr>
			<tr> 
			  <td width="20%" style="font-weight: bold;">Begin Time<span class="requiredField">*</span>:</td>
			  <td>
			  	<select name="beginHour" style="font-size: 1em;" >
<% 
	String beginhour = "";
	String beginmin = "";
	String beginampm = "";
	if(!begintime.equalsIgnoreCase("")){
		String[] btime = begintime.split(" ");
		beginhour = btime[0];
		beginmin = btime[1];
		beginampm = btime[2];
	}
	for(int i=0;i<12;i++){
		String selected = "";
		if(beginhour.equalsIgnoreCase(String.valueOf(i+1))){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=i+1%>" <%=selected%>><%=i+1%></option>
<%	
	}
%>
			  	</select> : 
			  	<select name="beginMin" style="font-size: 1em;" >
<% 
	for(int i=0;i<12;i++){
		String value = String.valueOf(i*5);
		if(value.length()==1){
			value = "0" + value;
		}
		String selected = "";
		if(beginmin.equalsIgnoreCase(value)){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=value%>" <%=selected%>><%=value%></option>
<%	
	}
%>
			  	</select>  
			  	<select name="beginAMPM" style="font-size: 1em;" >
			  		<option value="PM">PM</option>
<% 
	String selected = "";
	if(beginampm.equalsIgnoreCase("am")){
		selected = "selected='selected'";
	}	
%>
			  		<option value="AM" <%=selected%>>AM</option>
			  	</select>
			  </td>
			</tr>
			<tr> 
			  <td width="20%" style="font-weight: bold;">End Time<span class="requiredField">*</span>:</td>
			  <td>
			  	<select name="endHour" style="font-size: 1em;">
<% 
	String endhour = "";
	String endmin = "";
	String endampm = "";
	if(!endtime.equalsIgnoreCase("")){
		String[] etime = endtime.split(" ");
		endhour = etime[0];
		endmin = etime[1];
		endampm = etime[2];
	}
	for(int i=0;i<12;i++){
		selected = "";
		if(endhour.equalsIgnoreCase(String.valueOf(i+1))){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=i+1%>" <%=selected%>><%=i+1%></option>
<%	
	}
%>
			  	</select> : 
			  	<select name="endMin" style="font-size: 1em;" >
<% 
	for(int i=0;i<12;i++){
		String value = String.valueOf(i*5);
		if(value.length()==1){
			value = "0" + value;
		}
		selected = "";
		if(endmin.equalsIgnoreCase(value)){
			selected = "selected='selected'";	
		}
%>
					<option value="<%=value%>" <%=selected%>><%=value%></option>
<%	
	}
%>
			  	</select>  
			  	<select name="endAMPM" style="font-size: 1em;" >
			  		<option value="PM">PM</option>
<% 
	selected = "";
	if(endampm.equalsIgnoreCase("am")){
		selected = "selected='selected'";
	}	
%>
			  		<option value="AM" <%=selected%>>AM</option>
			  	</select>
			</tr>
			<tr>
				<td width="20%" style="font-weight: bold;">URL:</td>
				<td><html:text style="font-size: 1em;" property="url" size="160" value="<%=url%>" /></td>
			</tr>
			<tr> 
			  <td width="20%" style="font-weight: bold;">Location<span class="requiredField">*</span>:</td>
			  <td><input style="font-size: 1em;" id="location" name="location" size="160" value="<%=location%>"/></td>
			</tr>
			<tr> 
			  <td colspan="2"><font style="color: red;"><html:errors property="location"/></font></td>
			</tr>
			<tr>
				<td width="20%" style="font-weight: bold;">Video URL: </td>
				<td><html:text style="font-size: 1em;" property="video_url" size="160" value="<%=video_url%>" /></td>
			</tr>
			<tr>
				<td width="20%" style="font-weight: bold;">Slide URL: </td>
				<td><html:text style="font-size: 1em;" property="slide_url" size="160" value="<%=slide_url%>" /></td>
			</tr>
			<tr>
				<td width="20%" style="font-weight: bold;">Paper URL: </td>
				<td><html:text style="font-size: 1em;" property="paper_url" size="160" value="<%=paper_url%>" /></td>
			</tr>
			<tr>
				<td valign="top" style="font-weight: bold;">Detail<span class="requiredField">*</span>:</td>
				<td>
					<textarea style="font-size: 1em;" name="detail" rows="20" cols="80"><%=detail%></textarea>
					<script type="text/javascript"> 
					//<![CDATA[
	 
						// This call can be placed at any point after the
						// <textarea>, or inside a <head><script> in a
						// window.onload event handler.
	 
						// Replace the <textarea id="editor"> with an CKEditor
						// instance, using default configurations.
						CKEDITOR.replace( 'detail' );
	 
					//]]>
					</script> 
				</td>
			</tr>
			<tr>
				<td colspan="2"><font style="color: red;"><html:errors property="detail" /></font></td>
			</tr>
<%-- 
			<tr>
				<td valign="top" style="font-weight: bold;">Bio: (optional)</td>
				<td>
					<textarea style="font-size: 1em;" name="s_bio" rows="20" cols="80"><%=s_bio%></textarea>
				<script type="text/javascript"> 
				//<![CDATA[
 
					// This call can be placed at any point after the
					// <textarea>, or inside a <head><script> in a
					// window.onload event handler.
 
					// Replace the <textarea id="editor"> with an CKEditor
					// instance, using default configurations.
					CKEDITOR.replace( 's_bio' );
 
				//]]>
				</script> 
				</td>
			</tr>
--%>
			<tr>
				<td width="20%" valign="top" style="font-weight: bold;">Research Areas:</td>
				<td>
					<ul>
<% 
	sql = "SELECT area_id,area FROM area ORDER BY area";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		int area_id = rs.getInt("area_id");
		String area = rs.getString("area");
%>
						<li><input name="area_id" type="checkbox" value="<%=area_id %>" <%=areaSet.contains(area_id)?"checked=\"checked\"":"" %>><%=area %></input></li>
<%					
	}
	conn.conn.close();
	conn = null;
%>
					</ul>				
				</td>
			</tr>
      </table></td>
      </tr>
</table>
<input type="hidden" name="s_bio" value="" />
<input type="hidden" name="col_id" value="<%=col_id %>" />
<input type="button" class="btn" value="Post Talk" onclick="submitform()" />

</html:form>
</logic:notPresent>

</logic:present>

