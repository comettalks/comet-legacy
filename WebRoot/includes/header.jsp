<%@page language="java"%>
<%@page import="edu.pitt.sis.beans.*" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jstl/xml_rt" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>
<%-- 
<html>
  	<head>  	
--%>
  		<link rel="CoMeT Icon" href="images/favicon.ico" />
    	<title>
    		<tiles:getAsString name="title"/>
	    </title>
	    <meta http-equiv="pragma" content="no-cache">
	    <meta http-equiv="cache-control" content="no-cache">
	    <meta http-equiv="expires" content="0">    

<%-- 
<link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel=
  "stylesheet" /> 
--%>
<link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"> 
</script> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"> 
</script> 
<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/jquery.cookie.js"%>"> 
</script> 

<link rel="stylesheet" href="css/jquery.autocomplete.css" type="text/css" />
<link type='text/css' href='css/confirm.css' rel='stylesheet' media='screen' />

<%--
<script src="http://code.jquery.com/jquery-latest.js"></script>
--%>
<script src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
<script type='text/javascript' src='scripts/jquery.bgiframe.min.js'></script>
<script type='text/javascript' src='scripts/jquery.autocomplete.js'></script>
<script type='text/javascript' src='scripts/jquery.simplemodal.js'></script>
<%-- 
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xtree.js"%>"></script>
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xmlextras.js"%>"></script>
		<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/xloadtree.js"%>"></script>	
--%>

<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en"></script>
		
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>	

<script src="ckeditor/_samples/sample.js" type="text/javascript"></script> 
<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css"/>
		
		
		
		
<!-- Edit by Wenbang -->
<script type="text/javascript" src="scripts/bootstrap.js"></script>
<script type="text/javascript" src="scripts/jquery-smooth-scroll.js"></script>
<!-- <script type="text/javascript" src="scripts/jquery-ui.js"></script> -->
<style>
	.navbar-fixed {
		position: fixed;
		top: 0;
		z-index: 9999;
	}	
</style>
<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="css/navbar.css">
<!-- <link rel="stylesheet" type="text/css" href="css/jquery-ui.css"> -->
<style>
	#toTop{
		width:40px;
		height:80px;
		text-align:center;
		padding-top:10px;
		position:fixed;
		bottom:100px;
		right:20px;
		cursor:pointer;
		display:none;
		color:##0FC;
		font-size:11px;
	}
</style>
<script>
	$("a[rel=tooltip]").tooltip({
	"placement": "bottom"
	});
	
	
	$(".navbar a, .subnav a").smoothScroll();
	
	
	(function ($) {
	
		$(function(){
	
			// fix sub nav on scroll
			var $win = $(window),
					$body = $("body"),
					$nav = $(".subnav"),
					navHeight = $(".navbar").first().height(),
					subnavHeight = $(".subnav").first().height(),
					subnavTop = $(".subnav").length && $(".subnav").offset().top - navHeight,
					marginTop = parseInt($body.css("margin-top"), 10);
					isFixed = 0;
	
			processScroll();
	
			$win.on("scroll", processScroll);
	
			function processScroll() {
				var i, scrollTop = $win.scrollTop();
	
				if (scrollTop >= subnavTop && !isFixed) {
					isFixed = 1;
					$nav.addClass("navbar-fixed");
					$body.css("margin-top", marginTop + subnavHeight + "px");
				} else if (scrollTop <= subnavTop && isFixed) {
					isFixed = 0;
					$nav.removeClass("navbar-fixed");
					$body.css("margin-top", marginTop + "px");
				}
			}
	
		});
	
	})(window.jQuery); 
	
	//realize the go to top function
	$(document).ready(function(){
		$(window).scroll(function(){
			if($(this).scrollTop()!=0){
				$('#toTop').fadeIn(1500);
			}
			else{
				$('#toTop').fadeOut(1500);
			} 
		});
		$('#toTop').click(function(){ 
			$('body,html').animate({scrollTop:0},800);
		});
	});
</script>
<!-- Edit by Wenbang -->

<%
	//Response.setHeader("Access-Control-Allow-Origin",
	response.setHeader("Access-Control-Allow-Origin","*");
	session=request.getSession(false);
	long userID = -1;
	String userName = "";
	boolean writable = false;
	String sessionID = session.getId();
	Cookie cookies[] = request.getCookies();
	//Find session id & user id
	//boolean foundSessionID = false;
	boolean foundUserID = false;
	if(cookies != null){
		for(int i=0;i<cookies.length;i++){
			Cookie c = cookies[i];
            /*if (c.getName().equals("comet_session_id")) {
                sessionID = c.getValue();
            	foundSessionID = true;
            }*/			
            if (c.getName().equals("comet_user_id")) {
            	if(c.getValue() != null){
                    userID = Integer.parseInt(c.getValue());
                	foundUserID = true;
            	}
            }			
            if (c.getName().equals("comet_user_name")) {
                userName = c.getValue();
            }
            if(c.getName().equals("comet_user_write")){
            	int writeInt = Integer.parseInt(c.getValue());
            	if(writeInt == 1){
            		writable = true;
            	}
            }
		}
	}
	/*if(!foundSessionID){
		Cookie c = new Cookie("comet_session_id", sessionID);
        c.setMaxAge(365*24*60*60);
        response.addCookie(c);
	}*/
%>
<script type="text/javascript">
<%
	connectDB conn = new connectDB();
	ResultSet rs;
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	if(ub != null){
		Cookie cid = new Cookie("comet_user_id", "" + ub.getUserID());
        cid.setMaxAge(365*24*60*60);
        cid.setPath("/");
        response.addCookie(cid);
		Cookie cname = new Cookie("comet_user_name", ub.getName());
        cname.setMaxAge(365*24*60*60);
        cname.setPath("/");
        response.addCookie(cname);
		Cookie cwrite = new Cookie("comet_user_write", ub.isWritable()==true?"1":"0");
        cname.setMaxAge(365*24*60*60);
        cname.setPath("/");
        response.addCookie(cwrite);
	}else if(foundUserID && userID > 0){
		if(session.getAttribute("logout")==null){
			ub = new UserBean();
			ub.setUserID(userID);
			ub.setName(userName);
			ub.setWritable(writable);
			session.setAttribute("UserSession",ub);
%>
	window.location.reload();
<%
		}
	}
%>
	/*************************************************/
	/* Request Add Friend Script                     */
	/*************************************************/
	var memberid = 0;
	
	function vote(membered, action, voteno, col_id, comm_id, user_id, voteStatus){
				
				if((memberid == 1 && membered=="false") || (membered == "true" && memberid != -1)){
					var voteAction = 0;
					if ((action == "up" && voteStatus != 1)|| (action == "down" && voteStatus == -1)){						
						voteno++;
						voteAction = 1;
						voteStatus++;
					}else if ((action == "up" && voteStatus == 1) || (action == "down" && voteStatus != -1)){						
						voteno--;	
						voteAction = -1;
						voteStatus--;
					}
					if (voteAction != 0){
						document.getElementById("vote_no_"+col_id).innerHTML= voteno.toString();
						document.getElementById("vote_up_"+col_id).className = (voteStatus!=1?"vote_up_off":"vote_up_on");
						document.getElementById("vote_up_"+col_id).onclick = function() {vote(membered, "up",voteno,col_id,comm_id,user_id,voteStatus);};
						
						document.getElementById("vote_down_"+col_id).className = (voteStatus!=-1?"vote_down_off":"vote_down_on");
						document.getElementById("vote_down_"+col_id).onclick = function() {vote(membered, "down",voteno,col_id,comm_id,user_id,voteStatus);};
						if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
						    xmlhttp=new XMLHttpRequest();
						}
						else{// code for IE6, IE5
						    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
						}
						
						xmlhttp.open("GET","utils/updateVoteAjax.jsp?col_id="+col_id+"&comm_id="+comm_id+"&user_id="+user_id+"&vote="+voteAction,true);
						xmlhttp.send();
					}
				}else{
					$('#confirm').modal({
						closeHTML: "<a href='#' title='Close' class='modal-close'>x</a>",
						position: ["20%",],
						overlayId: 'confirm-overlay',
						containerId: 'confirm-container', 
						onShow: function (dialog) {
							var modal = this;

							$('.message', dialog.data[0]).append("You must be a group member before voting. Please join in first.");

						}
					});
				}
				
	}
	function addQuickBookmark(col_id){
		
  				var src = "utils/bookmarkPage.jsp?col_id=" + col_id;
  				$.modal('<iframe src="' + src + '" height="450" width="830" style="border:0" >', {
  					
  					containerCss:{
  						backgroundColor:"#fff",
  						borderColor:"#000",
  						height:450,
  						padding:0,
  						width:830
  					},
  					overlayClose:true
  					
  				});
  				
	}
	
	
	function closeWindow(){
		if(typeof period != "undefined"){
			var action = "utils/loadTalks.jsp";
			if(period == 0){//Day
				action = action.concat('?month=',_month,'&year=',_year,'&day=',_day);
			}else if(period == 1){//Week
				var thisweek = getWeekNoInMonth(_year,_month,_day);
				action = action.concat('?month=',_month,'&year=',_year,'&week=',thisweek);
			}else{
				action = action.concat('?month=',_month,'&year=',_year);
			}
			if(queryString){
				action = action.concat('&',queryString);
			}
			//alert(action);
			loadTalks(action);
			
		}else{
			window.parent.location.reload();
		}
		$.modal.close();
	}
	function   DrawImage(ImgD, iwidth, iheight){ 
	      var image = new Image();     
	      image.src = ImgD.src; 
	      if(image.width > 0  &&  image.height> 0){ 
	        if(image.width/image.height >= iwidth/iheight){    
	          	 ImgD.width=iwidth; 
	          	 ImgD.height=image.height*iwidth/image.width;  
	          	 ImgD.alt=image.width+ "* "+image.height; 
	        } 
	       else{ 
	          	ImgD.height=iheight; 
	          	ImgD.width=image.width*iheight/image.height;           
	          	ImgD.alt=image.width+ "* "+image.height; 
	       } 
	     }
	} 

	function s_confirm(){
		if(document.s_search.search_text.value == "" || document.s_search.search_text.value == " "){
	        alert("Enter keywords");
	    }else{
	        document.s_search.submit();
	    }
	}
	
	function showAddFriendDialog(divAddFriend){
		//var divAddFriend = document.getElementById("divAddFriend");
		//divAddFriend.style.display = "block";
		$(divAddFriend).show();
	}
	
	function hideAddFriendDialog(divAddFriend){
		//var divAddFriend = document.getElementById("divAddFriend");
		//divAddFriend.style.display = "none";
		$(divAddFriend).hide();
	}

	function sendFriendRequest(objParent,uid,reqtype){
		$.post("profile/friendRequest.jsp",{user_id: uid,request_type: reqtype},function(data){
				if(data){
					if(data.status=="OK"){
						if(objParent != null){
							if(reqtype=="add"){
								objParent.innerHTML = "<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\"".concat(
										" onclick=\"addFriend(",objParent.id,",",uid,",'drop');return false;\">",
											"<img border='0' src='images/x.gif' /></a>");
							}
							if(reqtype=="drop"){
								objParent.innerHTML = "<input class =\"btn\" type=\"button\" id=\"btnAddAsFriend\"".concat(
										" value=\"Add as Friend\" onclick=\"showAddFriendDialog(divAddFriend);return false;\" />");
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
									" value=\"Add as Friend\" onclick=\"showAddFriendDialog(divAddFriend);return false;\" />");
							}				
						}	
					}else{
						alert(data.status + " : " + data.message);
					}		
				}	
			});
	}	

	function toggleRequestList(aList,divTopList){
		var _class = divTopList.getAttribute("class");
		var _id = divTopList.getAttribute("id");
		if(_class == "hiddenlist"){
			$(".shownlist").removeClass("shownlist").addClass("hiddenlist");
			$(divTopList).attr("class","shownlist");
			$(aList).attr("class","shownlist");
		}else{
			$(divTopList).attr("class","hiddenlist");
			$(aList).attr("class","hiddenlist");
		}		
		if(_id == 'divTopNotifyList'){
			$.post("utils/postUserNotified.jsp",{},function(data){
				if(data.status == 'OK'){

				}else{
					alert(data.message);
				}
			});
		}else{
			//alert($(divTopList).attr('id'));
		}	
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

	function postColComment(colid,txtComment,objButton,tdComments){
		if(jQuery.trim($(txtComment).val()).length==0){
			alert("Comment cannot be blank!");
			return;
		}
		$(txtComment).css("disabled",true);
		$.post("utils/postComment.jsp",{col_id:colid,comment:$(txtComment).val()},
			function(data){
				if(data.status=="OK"){
					$(txtComment).val("");
					$(tdComments).html("<img border='0' src='images/loading-small.gif' />");
					$(tdComments).load("utils/getComments.jsp?col_id=".concat(colid));
				}else{
					alert(data.status + ": " + data.message);
				}
				$(txtComment).css("disabled",false);
			}
		);
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
							alert(data.status + ": " + data.message);
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
							$.get("utils/replyComment.jsp",{comment_id: cid,timestamp: latestTime.value},
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
		var txtLike = $.trim(anchorlike.innerHTML);
		//alert(txtLike);
		//if(typeof txtLike != 'undefined'){
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
		//}	
	}	
	
	function likeComment1(uid,cid,anchorlike,tdlike){
		var txtLike = $.trim(anchorlike.innerHTML);
		//alert(txtLike);
		//if(typeof txtLike != 'undefined'){
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
		//}	
	}	
	
	function likeSeries(uid,sid,anchorlike,tdlike){
		var classname = $(anchorlike).attr('class');
		var txtLike;
		
		if(classname == 'btn'){
			txtLike = anchorlike.value;
		}else{
			txtLike = anchorlike.innerHTML;
		}		

		if(txtLike){
			$.post("utils/postLike.jsp",{user_id: uid,series_id: sid,like: txtLike},
				function(data){
					if(data.status == "OK"){
						if(tdlike!=null){
							var classname = $('#'.concat(tdlike)).attr('class');
							if(data.like_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.like_tag);
						}
					}	
				}
			);
			
			if(classname == 'btn'){
				if(txtLike == "Like"){
					anchorlike.value = "Unlike";
				}else{
					anchorlike.value = "Like";
				}		
			}else{
				if(txtLike == "Like"){
					$('.'.concat(classname)).text('Unlike');
				}else{
					$('.'.concat(classname)).text('Like');
				}		
			}		
		}	
	}	

	function insertTag(tag){
		/*var el = document.getElementById('myTags');
		el.innerHTML += '<div><div class="tags">' + tag + '&nbsp;&nbsp;</div><input style="float:left" height="15" width="15" type="image" src="./images/delete.jpg" onclick="deleteTag(this, \'' + tag + '\')"/></div>';
		
		//document.AddBookmarkColloquiumForm.tags.value += tag + ",,";
		document.getElementById(tag).removeAttribute("onclick");
		document.getElementById(tag).removeAttribute("href");
		document.getElementById(tag).style.color = "black";*/
		var inserted = false;

		$("input.tagInput").each(function(index){
			if(jQuery.trim($(this).val()) == '' && !inserted){
				$(this).val(tag);
				inserted = true;

				$("a.".concat(tag.split(" ").join("_"))).attr("color","black");
				$("a.".concat(tag.split(" ").join("_"))).removeAttr("onclick");
				$("a.".concat(tag.split(" ").join("_"))).removeAttr("href");
			}
		});

		if(!inserted){
			addMoreTagInputRow();
			insertTag(tag);
			
		}	
	}

	/*function deleteTag(element, tag){
		 var parentElement = element.parentNode;
		 var parentElement2 = parentElement.parentNode;
	     if(parentElement2){
	            parentElement2.removeChild(parentElement);  
	     }
	     //var tagContent = document.AddBookmarkColloquiumForm.tags.value;
	     //document.AddBookmarkColloquiumForm.tags.value = tagContent.replace(tag+",,", "");
	     
	     document.getElementById(tag).onclick = function() {insert(tag);};
	     document.getElementById(tag).href = "javascript: void(0)";
	     document.getElementById(tag).style.color = "#00A";	
	     
	}*/

	function getSuggestedTag(colid){
		if(colid != null){

			$("#spanSuggestedTag").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");
			
			var key = "0494dda81af7f0b4c28c93401dd0326845df8d91";
			var alchemyURL = "http://access.alchemyapi.com/calls/url/URLGetRankedConcepts";
			var talkurl = "http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=".concat(colid);

			$.getJSON(alchemyURL,{apikey: key, url: talkurl, outputMode: "json", callback : "?"},
				function(data){
					
					if(data.status == "OK"){
						var i;
						var suggestedtags = "";
						for(i=0;i<data.concepts.length;i++){
							suggestedtags = suggestedtags
								.concat("<a class='",data.concepts[i].text.toLowerCase().split(" ").join("_"),"' href='javascript:void(0)' onclick='insertTag(\"",
										data.concepts[i].text.toLowerCase(),"\")'>",data.concepts[i].text.toLowerCase(),"</a>&nbsp;");
						}
						if(suggestedtags.length > 0){
							suggestedtags = " <b>Suggested keywords (click to add): </b>".concat(suggestedtags);
							//alert(suggestedtags);
							$("#spanSuggestedTag").html(suggestedtags);
						}else{
							$("#spanSuggestedTag").html("&nbsp;");
						}
					}else{
						alert(data.statusInfo);
					}
				}
			);

		}
	}

	function addMoreTagInputRow(){
		var currowno = $("#tags_container tr").length;
		var col1 = "<td width=\"30%\" align=\"center\">Keyword".concat(currowno*3 + 1,":<br/><input style=\"font-size: 10px;\" class=\"tagInput\" type=\"text\" size=\"20\"  /></td>");
		var col2 = "<td width=\"30%\" align=\"center\">Keyword".concat(currowno*3 + 2,":<br/><input style=\"font-size: 10px;\" class=\"tagInput\" type=\"text\" size=\"20\"  /></td>");
		var col3 = "<td width=\"30%\" align=\"center\">Keyword".concat(currowno*3 + 3,":<br/><input style=\"font-size: 10px;\" class=\"tagInput\" type=\"text\" size=\"20\"  /></td>");
		var col4 = "<td width=\"10%\">&nbsp;</td>";
		
		$("#tags_container").append("<tr class='removable'>".concat(col1,col2,col3,col4,"</tr>"));
		
	}
	
	function getTalkUserTag(uid,colid){
		if(uid != null && colid != null){
			
			//$("#myTags").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");
			$("#tags_container").hide();
			$("#divUserTagLoading").show();
			
			$.post("utils/getTags.jsp",{user_id: uid, col_id: colid, outputMode: "json"},
				function(data){
					//alert(data.status);
					if(data.status == "OK"){
						$("#divUserTagLoading").hide();
						//Create tag cells more to fit user tags
						if(data.tags.length > 6){
							var remainder = data.tags.length % 6;
						    var quotient = ( data.tags.length - remainder ) / 6;

						    if ( quotient >= 0 ){
						        quotient = Math.floor( quotient );
						    }else{  // negative
						        quotient = Math.ceil( quotient );
						    }

						    if(remainder > 0){
								quotient++;
							}

							if(quotient > 2){// 2 is the fixed number of initial rows
								var newrowno = qutient - 2;
								for(var i=0;i<newrowno;i++){
									addMoreTagInputRow();
								}
							}
		
						}

						$("input.tagInput").each(function(index){
							//alert(index);
							if(index < data.tags.length){
								//alert(data.tags[index].tag.toLowerCase());
								$(this).val(data.tags[index].tag.toLowerCase());
							}
						});
						
						$("#tags_container").show();
					}else{
						alert(data.message);
					}
				}
			);

		}
	}
	
	function getPopUserTag(uid){
		if(uid != null){
			
			$("#spanPopUserTag").html("<div align='center'><img border='0' src='images/loading-small.gif' /></div>");

			$.post("utils/getTags.jsp",{user_id: uid, outputMode: "json"},
				function(data){
					//alert(data.status);
					if(data.status == "OK"){
						var i;
						var popUserTags = "";
						for(i=0;i<data.tags.length;i++){
							popUserTags = popUserTags
								.concat("<a class='",data.tags[i].tag.toLowerCase().split(" ").join("_"),
										"' href='javascript:void(0)' onclick='insertTag(\"",
										data.tags[i].tag.toLowerCase(),"\")'>",data.tags[i].tag.toLowerCase(),"</a>&nbsp;");
						}
						if(popUserTags.length > 0){
							popUserTags = " <b>Top 10 your keywords (click to add): </b>".concat(popUserTags);
							//alert(popUserTags);
							$("#spanPopUserTag").html(popUserTags);
						}else{
							$("#spanPopUserTag").html("&nbsp;");
						}
					}else{
						alert(data.message);
					}
				}
			);

		}
	}

	function insertEmail(email){
		if(email != null&&!$("#divEmailTalk").is(":hidden")){
			var txtEmail = $("#txtRecipientEmail").val();
			txtEmail = jQuery.trim(txtEmail);
			if(txtEmail.length==0){
				$("#txtRecipientEmail").val(email);				
			}else{
				$("#txtRecipientEmail").val($("#txtRecipientEmail").val() + "," + email);
			}

			$("a.".concat(email
					.split(" ").join("_")
					.split(".").join("_")
					.split("@").join("_")
							)).attr("color","black");
			$("a.".concat(email
					.split(" ").join("_")
					.split(".").join("_")
					.split("@").join("_")
							)).removeAttr("onclick");
			$("a.".concat(email
					.split(" ").join("_")
					.split(".").join("_")
					.split("@").join("_")
							)).removeAttr("href");
		
		}
	}
	
	function getUserEmail(uid){
		if(uid != null){
			$.post("utils/getEmails.jsp",{user_id: uid, outputMode: "json"},
					function(data){
						//alert(data.status);
						if(data.status == "OK"){
							var i;
							//Popular emails
							var popUserEmails = "";
							for(i=0;i<data.pop_emails.length;i++){
								if(i==5){
									popUserEmails = popUserEmails.concat("<br/>");
								}
								popUserEmails = popUserEmails
									.concat("<a class='",
											data.pop_emails[i].email.toLowerCase()
												.split(" ").join("_")
												.split(".").join("_")
												.split("@").join("_"),
											"' href='javascript:void(0)' onclick='insertEmail(\"",
											data.pop_emails[i].email.toLowerCase(),"\")'>",
											data.pop_emails[i].email.toLowerCase(),"</a>&nbsp;");
							}
							if(popUserEmails.length > 0){
								popUserEmails = " <b>Top ".concat(data.pop_emails.length," email",
										(data.pop_emails.length>0?"s":"") ," (click to add):</b> ",
										popUserEmails);
								$("#tdPopEmailContainer").html(popUserEmails);
							}else{
								$("#tdPopEmailContainer").html("&nbsp;");
							}

							//Latest emails
							var latestUserEmails = "";
							for(i=0;i<data.latest_emails.length;i++){
								if(i==5){
									latestUserEmails = latestUserEmails.concat("<br/>");
								}
								latestUserEmails = latestUserEmails
									.concat("<a class='",
											data.latest_emails[i].email.toLowerCase().split(" ").join("_")
											.split(".").join("_")
											.split("@").join("_"),
										"' href='javascript:void(0)' onclick='insertEmail(\"",
											data.latest_emails[i].email.toLowerCase(),"\")'>",
											data.latest_emails[i].email.toLowerCase(),"</a>&nbsp;");
							}
							if(latestUserEmails.length > 0){
								latestUserEmails = " <b>Latest ".concat(data.latest_emails.length," email",
										(data.latest_emails.length>0?"s":"") ," (click to add):</b> ",
										latestUserEmails);
								$("#tdLatestEmailContainer").html(latestUserEmails);
							}else{
								$("#tdLatestEmailContainer").html("&nbsp;");
							}
						}else{
							alert(data.message);
						}
					}
				);
		}
	}
	
	function showPopupEmailTalk(uid,colid,anchorEmail){
		//var talkDetail = '&nbsp;Title: '.concat($('#aTitleColID'.concat(colid)).text());
		//$("#tdEmailTitle").html(talkDetail);

		getUserEmail(uid);

		$("#btnDoneEmailing").unbind();
		$("#btnDoneEmailing").click(function(){
			if(jQuery.trim($("#txtRecipientEmail").val()).length==0){
				alert("Recipient email cannot be blank!");
				return;
			}

			$("#tdEmailTitle").html(" <b><i>Sending...</i></b>");
			$("#divEmailTalk textarea,:input").attr("disabled",true);
			$("#divEmailTalk ")
			$.post("utils/sendEmails.jsp",{col_id: colid,emails: $("#txtRecipientEmail").val(),
				usermessage: $("#txtEmailMessage").val(),outputMode: "json"},
				function(data){
					$("#divEmailTalk textarea,:input").attr("disabled",false);
					if(data.status == "OK"){
						$("#tdEmailTitle").html("Sent Successful!");
						$("#divEmailTalk textarea,input:text").val("");
						$("#btnEmailClose").delay(500).click();
					}else{
						alert(data.message);
					}
				}
			);
		});
		
		var position = $(anchorEmail).position();
		$(divEmailTalk).css("top",position.top + 250);
		//divEmailTalk.style.left = 400;
		$(divEmailTalk).show();//divEmailTalk.style.display = 'block';
	}

	function saveNote(colid,usernote,progress){
		//alert($(usernote).val());
		if(progress != null){
			$(progress).html("<i>Saving...</i>");
		}
		$.post('utils/postNote.jsp',{col_id:colid,note:$(usernote).val()},
			function(data){
				if(data.status=='OK'){
					if(progress != null){
						$(progress).html('<b>Your note is saved!</b>');
						window.setTimeout($(progress).html('&nbsp;'),5000);
					}
				}else{
					alert(data.message);
				}		
			}
		);
	}
	
	function showPopupPost2Group(uid,colid,anchorPost,tdPost){
		var talkDetail = '&nbsp;Title: '.concat($('#aTitleColID'.concat(colid)).text());
		$("#tdPostTitle").html(talkDetail);

		var position = $(anchorPost).position() + 250;
		divPostTalk2Group.style.top = position.top;
		divPostTalk2Group.style.display = 'block';
		
		$("#tdPostGroupContainer").load("utils/postTalk2Group.jsp?col_id=".concat(colid));
		
		$("#btnDonePosting").unbind();
		$("#btnDonePosting").click( function(){
			var groups = null;
			if($("input.chkPostGroup:checked").length > 0){
				groups = "";
				jQuery.each($("input.chkPostGroup:checked"), function(){
					groups = groups.concat($(this).val(),";;");
				});
			}
			
			$.post("utils/postGroups.jsp",{user_id: uid,col_id:colid,group: groups},
				function(data){
					if(data.status == "OK"){
						if($(anchorPost).attr('class') == 'btn'){
							$(anchorPost).val(data.group_tag);
						}else{
							$(anchorPost).text(data.group_tag);
						}

						var talkGroups = "";
						for(var i=0;i<data.groups.length;i++){
							talkGroups = talkGroups
							.concat("<a href=\"community.do?comm_id=",data.groups[i].comm_id,"\">",
									data.groups[i].comm_name,"</a>&nbsp;");
						}

						if($(anchorPost).attr('class') == 'btn'){
							if(talkGroups.length > 0){
								$(tdPost).html(talkGroups);
								$(tdPost).parent().show();
							}else{
								$(tdPost).html("&nbsp;");
								$(tdPost).parent().hide();
							}
						}else{
							if(talkGroups.length > 0){
								talkGroups = "<br/><b>Post to groups:</b> ".concat(talkGroups);
								$(tdPost).html(talkGroups);
								$(tdPost).show();
							}else{
								$(tdPost).html("&nbsp;");
								$(tdPost).hide();
							}
						}
						
						$("#btnPostClose").click();
					}else{
						alert(data.message);
					}
				}
			);
		});

	}
	
	function showPopupTag(uid,colid,anchorTag,tdTag){
		$("#tags_container tr.removable").remove();
		$('.tagInput').val('');
		
		var talkDetail = '&nbsp;Title: '.concat($('#aTitleColID'.concat(colid)).text());
		$("#tdTagTitle").html(talkDetail);
		//talkDetail = talkDetail.concat('&nbsp;Speaker: ',document.getElementById('spanSpeakerColID'.concat(colid)).innerHTML);
		//document.getElementById('spanTagTalkDetail').innerHTML = talkDetail;

		getTalkUserTag(uid,colid);
		getSuggestedTag(colid);
		getPopUserTag(uid);
		
		$("#aAddMoreTagRow").unbind();
		$("#aAddMoreTagRow").click(function(){addMoreTagInputRow();});	
		
		$("#btnDoneTagging").unbind();
		$("#btnDoneTagging").click( function(){
				var tags = null;
				if($("input.tagInput").length > 0){
					tags = "";
					jQuery.each($("input.tagInput"), function(){
						if(jQuery.trim($(this).val()) != ""){
							tags = tags.concat(jQuery.trim($(this).val()),";;");
						}
					});
				}
				
				$.post("utils/postTags.jsp",{user_id: uid,col_id: colid,tag: tags},
					function(data){
						if(data.status=="OK"){

							//Change anchor or button title
							if($(anchorTag).attr('class')=='btn'){
								$(anchorTag).val(data.tag_tag);
							}else{
								$(anchorTag).text(data.tag_tag);
							}
							
							var i;
							var talkTags = "";
							for(i=0;i<data.tags.length;i++){
								//"&nbsp;<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
								talkTags = talkTags
									.concat("&nbsp;<a href=\"tag.do?tag_id=",data.tags[i].tag_id,"\">",
											data.tags[i].tag.toLowerCase(),"</a>");
							}
							if($(anchorTag).attr('class') == 'btn'){
								if(talkTags.length > 0){
									$(tdTag).html(talkTags);
									$(tdTag).parent().show();
								}else{
									$(tdTag).html("&nbsp;");
									$(tdTag).parent().hide();
								}
							}else{
								if(talkTags.length > 0){
									talkTags = "<br/><b>Keywords:</b>".concat(talkTags);
									$(tdTag).html(talkTags);
									$(tdTag).show();
								}else{
									$(tdTag).html("&nbsp;");
									$(tdTag).hide();
								}
							}
						}else{
							alert(data.message);
						}
						//divTagTalk.style.display = 'none';
						$("#btnTagClose").click();
					}
				);
			}
		);

		//alert(anchorTag);
		var position = $(anchorTag).position();
		$("#divTagTalk").css("top",position.top + 250);
		$("#divTagTalk").show();//divTagTalk.style.display = 'block';
	
	}
	
	function bookmarkTalk(uid,colid,anchorBookmark,tdBookmark){
		var classname = $(anchorBookmark).attr('class');
		var txtBookmark;
		if(classname == 'btn'){
			txtBookmark = anchorBookmark.value;
		}else{
			txtBookmark = anchorBookmark.innerHTML;
		}
 
		if(typeof txtBookmark != "undefined"){
			$.post("utils/postBookmark.jsp",{user_id: uid,col_id: colid,bookmark: txtBookmark},
				function(data){
					if(data.status == "OK"){
						if(tdBookmark != null){
							var classname = $('#'.concat(tdBookmark)).attr('class');
							if(data.bookmark_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							//$('.'.concat(classname)).html(data.bookmark_tag);
						}

						if($('.tdCBookNoColID'.concat(colid)) != null){
							if(data.bookmarkno > 0){
								$('.tdCBookNoColID'.concat(colid)).css('display','block');
								$('.tdCBookNoColID'.concat(colid)).html('<b>'.concat(data.bookmarkno,'</b>'));
							}else{
								$('.tdCBookNoColID'.concat(colid)).css('display','none');
							}
						}

						if($('.tdBookNoColID'.concat(colid)) != null){
							if(data.bookmarkno > 0){
								$('.tdBookNoColID'.concat(colid)).css('display','block');
								$('.tdBookNoColID'.concat(colid)).html('<b>'
										.concat(data.bookmarkno,
											'</b><br/><span style=\'font-size: 0.55em;\'>bookmark',
											data.bookmarkno > 1?'s':''));
							}else{
								$('.tdBookNoColID'.concat(colid)).css('display','none');
							}
						}

						if($('.spanWhomBookmarkColID'.concat(colid)) != null){
							if(data.whombookmark.length > 0){
								$('.spanWhomBookmarkColID'.concat(colid)).show();//css('display','inline');
								$('.spanWhomBookmarkColID'.concat(colid)).html('<br/><b>Bookmarked by:</b>'
										.concat(data.whombookmark));
							}else{
								$('.spanWhomBookmarkColID'.concat(colid)).hide();//css('display','none');
							}
						}

						if($('.trWhomBookmarkColID'.concat(colid)) != null){
							if(data.whombookmark.length > 0){
								$('.trWhomBookmarkColID'.concat(colid)).show();//css('display','inline');
								$('.tdWhomBookmarkColID'.concat(colid)).html(data.whombookmark);
							}else{
								$('.trWhomBookmarkColID'.concat(colid)).hide();//css('display','none');
							}
						}

						if($('.tdCEmailNoColID'.concat(colid)) != null){
							if(data.emailno > 0){
								$('.tdCEmailNoColID'.concat(colid)).css('display','block');
								$('.tdCEmailNoColID'.concat(colid)).html('<b>'.concat(data.emailno,'</b>'));
							}else{
								$('.tdCEmailNoColID'.concat(colid)).css('display','none');
							}
						}							

						if($('.tdEmailNoColID'.concat(colid)) != null){
							if(data.emailno > 0){
								$('.tdEmailNoColID'.concat(colid)).css('display','block');
								$('.tdEmailNoColID'.concat(colid)).html('<b>'
										.concat(data.emailno,
											'</b><br/><span style=\'font-size: 0.55em;\'>email',
											data.emailno > 1?'s':''));
							}else{
								$('.tdEmailNoColID'.concat(colid)).css('display','none');
							}
						}							

						if($('.tdCViewNoColID'.concat(colid)) != null){
							if(data.viewno > 0){
								$('.tdCViewNoColID'.concat(colid)).css('display','block');
								$('.tdCViewNoColID'.concat(colid)).html('<b>'.concat(data.viewno,'</b>'));
							}else{
								$('.tdCViewNoColID'.concat(colid)).css('display','none');
							}
						}

						if($('.tdViewNoColID'.concat(colid)) != null){
							if(data.viewno > 0){
								$('.tdViewNoColID'.concat(colid)).css('display','block');
								$('.tdViewNoColID'.concat(colid)).html('<b>'
										.concat(data.viewno,
											'</b><br/><span style=\'font-size: 0.55em;\'>view',
											data.viewno > 1?'s':''));
							}else{
								$('.tdViewNoColID'.concat(colid)).css('display','none');
							}
						}

						if(data.bookmark_tag == "&nbsp;Bookmarked&nbsp;"){							
							//$("#btnNoAskAgain").show();
							$('#tdTagHeader').show();
							$("#btnTagClose").val("No, Thanks");
							$('.spanreccolid'.concat(colid)).hide();
							if($(anchorBookmark).attr('class') == 'btn'){
								showPopupTag(uid,colid,"#btntagcolid".concat(colid),".tdTagColID".concat(colid));
							}else{
								showPopupTag(uid,colid,".atagcolid".concat(colid),".spanTagColID".concat(colid));
							}
						}else{
							$('.spanreccolid'.concat(colid)).show();
						}
					}else{
						alert(data.message);
					}		
				}
			);

			if(classname == 'btn'){
				if(txtBookmark == "Bookmark"){
					anchorBookmark.value = 'Unbookmark';
				}else{
					anchorBookmark.value = 'Bookmark';
				}		
			}else{
				if(txtBookmark == "Bookmark"){
					$('.'.concat(classname)).text('Unbookmark');
				}else{
					$('.'.concat(classname)).text('Bookmark');
				}		
			}		
		}	
	}
	
	function bookmarkTalk1(uid,colid,anchorBookmark,tdBookmark){
		var classname = $(anchorBookmark).attr('id');
		var txtBookmark;
		if(classname == 'btn'){
			txtBookmark = anchorBookmark.value;
		}else{
			txtBookmark = anchorBookmark.innerHTML;
		}
 
		if(typeof txtBookmark != "undefined"){
			$.post("utils/postBookmark.jsp",{user_id: uid,col_id: colid,bookmark: txtBookmark},
				function(data){
					if(data.status == "OK"){
						if(tdBookmark != null){
							var classname = $('#'.concat(tdBookmark)).attr('a');
							if(data.bookmark_tag == "&nbsp;"){
								$('#'.concat(classname)).css('display','none');
							}else{
								$('#'.concat(classname)).css('display','');
							}
							//$('.'.concat(classname)).html(data.bookmark_tag);
						}

						if($('.tdCBookNoColID'.concat(colid)) != null){
							if(data.bookmarkno > 0){
								$('.tdCBookNoColID'.concat(colid)).css('display','block');
								$('.tdCBookNoColID'.concat(colid)).html('<b>'.concat(data.bookmarkno,'</b>'));
							}else{
								$('.tdCBookNoColID'.concat(colid)).css('display','none');
							}
						}

						if($('.tdBookNoColID'.concat(colid)) != null){
							if(data.bookmarkno > 0){
								$('.tdBookNoColID'.concat(colid)).css('display','block');
								$('.tdBookNoColID'.concat(colid)).html('<b>'
										.concat(data.bookmarkno,
											'</b><br/><span style=\'font-size: 0.55em;\'>bookmark',
											data.bookmarkno > 1?'s':''));
							}else{
								$('.tdBookNoColID'.concat(colid)).css('display','none');
							}
						}

						if($('.spanWhomBookmarkColID'.concat(colid)) != null){
							if(data.whombookmark.length > 0){
								$('.spanWhomBookmarkColID'.concat(colid)).show();//css('display','inline');
								$('.spanWhomBookmarkColID'.concat(colid)).html('<b>Bookmarked by:</b>'
										.concat(data.whombookmark));
							}else{
								$('.spanWhomBookmarkColID'.concat(colid)).hide();//css('display','none');
							}
						}

						if($('.trWhomBookmarkColID'.concat(colid)) != null){
							if(data.whombookmark.length > 0){
								$('.trWhomBookmarkColID'.concat(colid)).show();//css('display','inline');
								$('.tdWhomBookmarkColID'.concat(colid)).html(data.whombookmark);
							}else{
								$('.trWhomBookmarkColID'.concat(colid)).hide();//css('display','none');
							}
						}

						if($('.tdCEmailNoColID'.concat(colid)) != null){
							if(data.emailno > 0){
								$('.tdCEmailNoColID'.concat(colid)).css('display','block');
								$('.tdCEmailNoColID'.concat(colid)).html('<b>'.concat(data.emailno,'</b>'));
							}else{
								$('.tdCEmailNoColID'.concat(colid)).css('display','none');
							}
						}							

						if($('.tdEmailNoColID'.concat(colid)) != null){
							if(data.emailno > 0){
								$('.tdEmailNoColID'.concat(colid)).css('display','block');
								$('.tdEmailNoColID'.concat(colid)).html('<b>'
										.concat(data.emailno,
											'</b><br/><span style=\'font-size: 0.55em;\'>email',
											data.emailno > 1?'s':''));
							}else{
								$('.tdEmailNoColID'.concat(colid)).css('display','none');
							}
						}							

						if($('.tdCViewNoColID'.concat(colid)) != null){
							if(data.viewno > 0){
								$('.tdCViewNoColID'.concat(colid)).css('display','block');
								$('.tdCViewNoColID'.concat(colid)).html('<b>'.concat(data.viewno,'</b>'));
							}else{
								$('.tdCViewNoColID'.concat(colid)).css('display','none');
							}
						}

						if($('.tdViewNoColID'.concat(colid)) != null){
							if(data.viewno > 0){
								$('.tdViewNoColID'.concat(colid)).css('display','block');
								$('.tdViewNoColID'.concat(colid)).html('<b>'
										.concat(data.viewno,
											'</b><br/><span style=\'font-size: 0.55em;\'>view',
											data.viewno > 1?'s':''));
							}else{
								$('.tdViewNoColID'.concat(colid)).css('display','none');
							}
						}

						if(data.bookmark_tag == "&nbsp;Bookmarked&nbsp;"){							
							//$("#btnNoAskAgain").show();
							$('#tdTagHeader').show();
							$("#btnTagClose").val("No, Thanks");
							//$('.spanreccolid'.concat(colid)).hide();
							if($(anchorBookmark).attr('class') == 'btn'){
								showPopupTag(uid,colid,"#btntagcolid".concat(colid),".tdTagColID".concat(colid));
							}else{
								showPopupTag(uid,colid,".atagcolid".concat(colid),".spanTagColID".concat(colid));
							}
						}else{
							//$('.spanreccolid'.concat(colid)).show();
						}
					}else{
						alert(data.message);
					}		
				}
			);

			if(classname == 'btn'){
				if(txtBookmark == "Bookmark"){
					anchorBookmark.value = 'Unbookmark';
				}else{
					anchorBookmark.value = 'Bookmark';
				}		
			}else{
				if(txtBookmark == "Bookmark"){
					$('#'.concat(classname)).text('Unbookmark');
				}else{
					$('#'.concat(classname)).text('Bookmark');
				}		
			}		
		}	
	}
	
	function subscribeAffiliation(uid,aid,anchorSubscribe,tdSubscribe){
		var classname = $(anchorSubscribe).attr('class');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.innerHTML;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,affiliate_id: aid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(tdSubscribe != null){
							var classname = $('#'.concat(tdSubscribe)).attr('class');
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.subscribe_tag);
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
				}else{
					anchorSubscribe.value = 'Subscribe';
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classname)).text('Unsubscribe');
				}else{
					$('.'.concat(classname)).text('Subscribe');
				}		
			}		
		}	
	}	

	function subscribeSeries(uid,sid,anchorSubscribe,tdSubscribe){
		var classname = $(anchorSubscribe).attr('class');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.innerHTML;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,series_id: sid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(tdSubscribe != null){
							var classname = $('#'.concat(tdSubscribe)).attr('class');
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.subscribe_tag);
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
				}else{
					anchorSubscribe.value = 'Subscribe';
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classname)).text('Unsubscribe');
				}else{
					$('.'.concat(classname)).text('Subscribe');
				}		
			}		
		}	
	}	

	function subscribeSeries1(uid,sid,anchorSubscribe,tdSubscribe){
		var classname = $(anchorSubscribe).attr('id');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.text;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,series_id: sid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(tdSubscribe != null){
							var classname = $('#'.concat(tdSubscribe)).attr('a');
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classname)).each(function(){
									$(this).css('display','none');
								});
							}else{
								$('.'.concat(classname)).each(function(){
									$(this).css('display','inline');
								});
							}
							$('.'.concat(classname)).each(function(){
								$(this).html(data.subscribe_tag);
							});
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
				}else{
					anchorSubscribe.value = 'Subscribe';
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classname)).text('Unsubscribe');
				}else{
					$('.'.concat(classname)).text('Subscribe');
				}		
			}		
		}	
	}	

	function deleteSeries(sid){
		$.post("utils/postDelete.jsp",{series_id: sid},
			function(data){
				if(data.status == "OK"){
					window.location = 'series.do';
				}else{
					alert(data.message);
				}	
			}
		);
	}
	
	function subscribeCommunity(uid,cid,anchorSubscribe,classSubscribe){
		var classname = $(anchorSubscribe).attr('class');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.innerHTML;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,comm_id: cid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(classSubscribe != null){
							
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classSubscribe)).css('display','none');
							}else{
								$('.'.concat(classSubscribe)).css('display','inline');
							}
							$('.'.concat(classSubscribe)).html(data.subscribe_tag);
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
				}else{
					anchorSubscribe.value = 'Subscribe';
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classSubscribe)).text('Unsubscribe');
				}else{
					$('.'.concat(classSubscribe)).text('Subscribe');
				}		
			}		
		}	
	}	

	function subscribeCommunity1(uid,cid,anchorSubscribe,classSubscribe){
		var classname = $(anchorSubscribe).attr('id');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.text;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,comm_id: cid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(classSubscribe != null){
							
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classSubscribe)).css('display','none');
							}else{
								$('.'.concat(classSubscribe)).css('display','inline');
							}
							$('.'.concat(classSubscribe)).html(data.subscribe_tag);
						}	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
				}else{
					anchorSubscribe.value = 'Subscribe';
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classname)).text('Unsubscribe');
				}else{
					$('.'.concat(classname)).text('Subscribe');
				}		
			}		
		}	
	}	

	function joinCommunity(uid,cid,anchorJoin,tdJoin){
		var classname = $(anchorJoin).attr('class');
		var txtJoin;
		if(classname == 'btn'){
			txtJoin = anchorJoin.value;
		}else{
			txtJoin = anchorJoin.innerHTML;
		}
 
		if(txtJoin){
			$.post("utils/postMember.jsp",{user_id: uid,comm_id: cid,join: txtJoin},
				function(data){
					if(data.status == "OK"){
						if(tdJoin != null){
							var classname = $('#'.concat(tdJoin)).attr('class');
							if(data.member_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
								$('.sub'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
								$('.sub'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.member_tag);
						}
						location.reload();	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtJoin == "Join"){
					anchorJoin.value = 'Leave';
					memberid = 1;
					
				}else{				
					anchorJoin.value = 'Join';
					memberid = -1;
				}		
			}else{
				
				if(txtJoin == "Join"){
					$('.'.concat(classname)).text('Leave');
				}else{
					$('.'.concat(classname)).text('Join');
				}		
			}		
		}	
	}	
	
	function joinCommunity1(uid,cid,anchorJoin,tdJoin){
		var classname = $(anchorJoin).attr('id');
		var txtJoin;
		if(classname == 'btn'){
			txtJoin = anchorJoin.value;
		}else{
			txtJoin = anchorJoin.text;
		}
 
		if(txtJoin){
			$.post("utils/postMember.jsp",{user_id: uid,comm_id: cid,join: txtJoin},
				function(data){
					if(data.status == "OK"){
						if(tdJoin != null){
							var classname = $('#'.concat(tdJoin)).attr('a');
							if(data.member_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.member_tag);
						}
						location.reload();	
					}	
				}
			);

			if(classname == 'btn'){
				if(txtJoin == "Join"){
					anchorJoin.value = 'Leave';
					memberid = 1;
					
				}else{				
					anchorJoin.value = 'Join';
					memberid = -1;
				}		
			}else{
				
				if(txtJoin == "Join"){
					$('.'.concat(classname)).text('Leave');
				}else{
					$('.'.concat(classname)).text('Join');
				}		
			}		
		}	
	}	
	
	function subscribeSpeaker(uid,sid,anchorSubscribe,tdSubscribe){
		var classname = $(anchorSubscribe).attr('class');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.innerHTML;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,speaker_id: sid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(tdSubscribe != null){
							var classname = $('#'.concat(tdSubscribe)).attr('class');
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.subscribe_tag);
						}	
					}	
				}
			);
	
			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
					$('.asubspid'.concat(sid)).text('Unsubscribe');
				}else{
					anchorSubscribe.value = 'Subscribe';
					$('.asubspid'.concat(sid)).text('Subscribe');
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classname)).text('Unsubscribe');
					$('#btnspid'.concat(sid)).val('Unsubscribe');
				}else{
					$('.'.concat(classname)).text('Subscribe');
					$('#btnspid'.concat(sid)).val('Subscribe');
				}		
			}		
		}	
	}	

	function subscribeSpeaker1(uid,sid,anchorSubscribe,tdSubscribe){
		var classname = $(anchorSubscribe).attr('id');
		var txtSubscribe;
		if(classname == 'btn'){
			txtSubscribe = anchorSubscribe.value;
		}else{
			txtSubscribe = anchorSubscribe.innerHTML;
		}
 
		if(txtSubscribe){
			$.post("utils/postSubscribe.jsp",{user_id: uid,speaker_id: sid,subscribe: txtSubscribe},
				function(data){
					if(data.status == "OK"){
						if(tdSubscribe != null){
							var classname = $('#'.concat(tdSubscribe)).attr('a');
							if(data.subscribe_tag == "&nbsp;"){
								$('.'.concat(classname)).css('display','none');
							}else{
								$('.'.concat(classname)).css('display','inline');
							}
							$('.'.concat(classname)).html(data.subscribe_tag);
						}	
					}	
				}
			);
	
			if(classname == 'btn'){
				if(txtSubscribe == "Subscribe"){
					anchorSubscribe.value = 'Unsubscribe';
					$('.asubspid'.concat(sid)).text('Unsubscribe');
				}else{
					anchorSubscribe.value = 'Subscribe';
					$('.asubspid'.concat(sid)).text('Subscribe');
				}		
			}else{
				if(txtSubscribe == "Subscribe"){
					$('.'.concat(classname)).text('Unsubscribe');
					$('#btnspid'.concat(sid)).val('Unsubscribe');
				}else{
					$('.'.concat(classname)).text('Subscribe');
					$('#btnspid'.concat(sid)).val('Subscribe');
				}		
			}		
		}	
	}	

	$(document).ready(function(){
		$("input.tagInput").autocomplete("./utils/tags.jsp", {
			  	delay: 20,
				formatItem: function(data, i, n, value) {			
					return  value;
						
				},
				formatResult: function(data, value) {
					return value;
				}
		});

		$(document).keyup(function(e){
			if(!$("#divTagTalk").is(":hidden")){
				if(e.keyCode == 13){//Enter
					$("#btnDoneTagging").click();
				}
				if(e.keyCode == 27){//ESC
					$("#btnTagClose").click();
				}
			}
			if(!$("#divPostTalk2Group").is(":hidden")){
				if(e.keyCode == 13){//Enter
					$("#btnDonePosting").click();
				}
				if(e.keyCode == 27){//ESC
					$("#btnPostClose").click();
				}
			}
			if(!$("#divEmailTalk").is(":hidden")){
				/*if(e.keyCode == 13){//Enter
					$("#btnDoneEmailing").click();
				}*/
				if(e.keyCode == 27){//ESC
					$("#btnEmailClose").click();
				}
			}
		});
		
	});	

	function setDocumentTitle(aTitle){
		document.title = aTitle;
	}

	var clickShowRecentTalksMoreNo = 0;
	function showRecentTalksMore(){
		clickShowRecentTalksMoreNo++;
		if(clickShowRecentTalksMoreNo == 1){
			$('#trMostRecent').show('slow');
			$('#btnShowRecentMore').val('Show All Week Talks');
		}else{
			window.location='calendar.do<%if(request.getParameter("affiliate_id") != null)out.print("?affiliate_id="+request.getParameter("affiliate_id"));%>';
		}
	}

	function showMoreTalk(talkType,divPost,startPos){
		var divOlderPosts = document.getElementById(divPost);
		if(divOlderPosts){
			divOlderPosts.innerHTML = "<div align='center'><img border='0' src='images/loading.gif' /></div>";
			$.get("utils/loadTalks.jsp?".concat(talkType,"=1"),{start: startPos},
				function(data){
					//divOlderPosts.style.display = "none";
					//var tdRecentActivity = document.getElementById("tdRecentActivity");
					//tdRecentActivity.innerHTML = tdRecentActivity.innerHTML.concat(data);
					divOlderPosts.innerHTML = data;
				}
			);
		}	

	}	
	
	var isLoadingActivities = false;
	var divLoadActivities = null;
	
	function AutoLoadActivity(){
		if(!isLoadingActivities){
			if($('#btnLoadAct').length){//(typeof btnLoadAct != 'undefined'){
				if($('#btnLoadAct').attr('disabled') == true){
					//window.setTimeout(function(){AutoLoadActivity();},500);
					return;
				}else{
					$('#btnLoadAct').click();
				}
			}
		}

	}

	function isScrolledIntoView(elem){
	    var docViewTop = $(window).scrollTop();
	    var docViewBottom = docViewTop + $(window).height();

	    var elemTop = $(elem).offset().top;
	    var elemBottom = elemTop + $(elem).height();

	    return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
	}
	
	function notis(activity_id, user_id, ele)
	{
		$(ele).css("background", "");
		window.open("notifications.do?type=1&user_id="+user_id+"&activity_id="+activity_id);
	}
	
	function notisTalk(col_id, ele)
	{
		$(ele).css("background", "");
		window.open("presentColloquium.do?col_id="+col_id);
	}

	function getEXTLogin(fAutoID){
		//frmPostExtLogin
		$('#fAutoID').val(fAutoID);
		$('#frmPostExtLogin').submit();
	}
	
</script>

<style>

a.vote_up_on, a.vote_down_off, a.vote_down_on, a.vote_up_off{
	text-indent: -9999em;
	background-position: 0px -265px;
	text-decoration: none;
	display: block;
	
	cursor: pointer;
	background-repeat: no-repeat;
}
a.vote_up_off{	
	width:35px;
	height:20px;
	background: url('images/arrow_up.png');
}
a.vote_up_on{
	width:37px;
	height:25px;
	background: url('images/arrow_up_selected.png');
}
a.vote_down_off{
	width:35px;
	height:20px;
	background: url('images/arrow_down.png');
}
a.vote_down_on{
	width:37px;
	height:25px;
	background: url('images/arrow_down_selected.png');
}
span.vote_count{
	display: block;
	color: #808185;
	font-weight: bold;
	font-size:150%;
	vertical-align: baseline;
	text-align: center;
}
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
	/* text-decoration:none; */
	color: #003366;
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
	/* 	display: block;
	position:absolute;
	right: 0;
	border: 1px solid #003366;
	width: 200px;
	text-align: left;
	background-color: #efefef; */
	/*padding-left: 0;
	margin-left: 0;*/
	
	position: absolute;
	top: 100%;
	right: 0;
	z-index: 1000;
	display: block;
	float: left;
	min-width: 200px;
	min-height: 100px;
	padding: 5px 0;
	margin: 2px 0 0;
	list-style: none;
	background-color: #ffffff;
	border: 1px solid #ccc;
	border: 1px solid rgba(0, 0, 0, 0.2);
	-webkit-border-radius: 6px;
	-moz-border-radius: 6px;
	border-radius: 6px;
	-webkit-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
	-moz-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
	box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
	-webkit-background-clip: padding-box;
	-moz-background-clip: padding;
	background-clip: padding-box;
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
div.tags {float: left; background-color: #0080ff; margin-left:6px;  margin-bottom: 4px; font-size: 13px}
</style>

		<link href="<%=request.getContextPath() + "/css/stylesheet.css"%>" rel="stylesheet" media="grey" />  
	</head>
	<body leftmargin="0" topmargin="0" style="font-family: arial,Verdana,sans-serif,serif;font-size: 0.9em;">

	<logic:notPresent name="UserSession">
		<div id="divPostExtLogin" style="display: none;">
			<form id="frmPostExtLogin" method="post" action="extlogin.do">
				<input type="hidden" id="fAutoID" name="fAutoID" value="-1" />
			</form>
		</div>
	</logic:notPresent>

	<!-- Edit by Wenbang -->
	<div id="toTop"><img src="img/top.png"/><br/>Top</div>
	<!-- Edit by Wenbang -->

	<!-- modal content -->
<%--
	<div id='confirm'>
			<div class='header'><span>Confirm</span></div>
			<div class='message'></div>
			<div class='buttons'>
				<div class='no simplemodal-close'>OK</div>
			</div>
		</div>
		<!-- preload the images -->
		<div style='display:none'>
			<img src='images/confirm/header.gif' alt='' />
			
	</div>
--%>
	<!------------------------>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style = "margin-top:8px;margin-bottom:8px;"> 
			<tr>
				<td valign="top" align="left" style = "background-color: #fff;padding-right:4px" rowspan="3" width="18%">
                	<html:link forward="aaa.index" >
                		<img src="images/comet_logo.png" border="0">
                	</html:link>
				</td>			
				<td align="left" style = "background-color: #fff;padding-left:4px" width="52%">		
	                <span style="font-weight:bold; color:#003366;font-size:1.2em;">Collaborative Management of Talks</span>
				</td>    
              	<td align="right" width="30%" style="font-weight:bold; color:#003366;font-size:0.75em;">                        							
					<logic:notPresent name="HideBar">
						<logic:present name="UserSession">
							Welcome <bean:write name="UserSession" property="name" /> <html:link forward="aaa.authentication.logout" >Log out</html:link>
						</logic:present>
						<logic:notPresent name="UserSession">
							<b>Hello!</b> <html:link forward="aaa.authentication.login" >sign in</html:link>
							or <html:link forward="aaa.registration.register" >register</html:link>						
						</logic:notPresent>
					</logic:notPresent>
					<logic:present name="HideBar" />
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold; color: #0080ff; font-size:0.75em;">
					  Bookmark Talks, Share with Friends, and We Recommend More! 
				</td>
				<td align="right" style="color: #003366; font-size:0.75em;vertical-align: middle;">
					<logic:notPresent name="HideBar">
						<logic:notPresent name="UserSession">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td style="vertical-align: middle;">
										<span style="font-weight:bold; color:#003366;vertical-align: middle;font-size:0.75em;">Or, sign in using your Facebook</span>
									</td>
									<td style="vertical-align: middle;">
					  					 <iframe frameborder="0" scrolling="no" src="../extprofile/facebook.jsp?appID=1389944597930969&extjs=getEXTLogin&extopt=loginonly" style="height: 30px;width: 100px;"></iframe>
									</td>
								</tr>
							</table>
<%-- 
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="google" src="images/google.png" border="0"></a> 
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="facebook" src="images/facebook.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="yahoo" src="images/yahoo.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="twitter" src="images/twitter.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="twitter" src="images/linkedin.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="wordpress" src="images/wordpress.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="aol" src="images/aol.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="myspace" src="images/myspace.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="mslive" src="images/mslive.png" border="0"></a>
							<a class="rpxnow" onclick="return false;"
								href="https://washington.rpxnow.com/openid/v2/signin?token_url=http%3A%2F%2Fhalley.exp.sis.pitt.edu%2Fcomet%2Frpx.do">
								<img alt="openid" src="images/openid.png" border="0"></a>
--%>
						</logic:notPresent>
						<logic:present name="UserSession">
					  		<iframe frameborder="0" scrolling="no" src="../extprofile/facebook.jsp?appID=1389944597930969" 
					  			style="height: 0px;width: 0px;display: none;"></iframe>
<% 
	int noteno=0;
	Date today = new Date();
	Calendar calendar = new GregorianCalendar();
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
	Format formatter = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss"); 
	Format formatterDay = new SimpleDateFormat("MMMMM d"); 
	Format formatterDayYear = new SimpleDateFormat("MMMMM d, yyyy"); 
	final long MILLISECS_PER_DAY = 24*60*60*1000;
	final long MILLISECS_PER_HOUR = 60*60*1000;
	final long MILLISECS_PER_MIN = 60*1000;
	final long MILLISECS = 1000;
	String sql1 = "SELECT _no from qynewnotificationno where user_id=" + ub.getUserID() + ";";
	ResultSet rs1 = null;
	rs1 = conn.getResultSet(sql1);
	int noNum = 0;
	rs1.next();
	noNum = rs1.getInt("_no");
	sql1 = "SELECT _no FROM userlikednum WHERE user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	noNum += rs1.getInt("_no");
	sql1 = "SELECT _no FROM usercommentnum WHERE user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	noNum += rs1.getInt("_no");
	sql1 = "SELECT _no FROM grouptalksnum WHERE user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	noNum += rs1.getInt("_no");
	sql1 = "SELECT _no FROM seriestalksnum WHERE user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	noNum += rs1.getInt("_no");
	sql1 = "SELECT _no FROM friendtalksnum WHERE user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	noNum += rs1.getInt("_no");
	sql1 = "SELECT _no FROM subspeakernum WHERE user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	noNum += rs1.getInt("_no");	
	sql1 = "SELECT _date FROM lastusernotified WHERE user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	Timestamp lastNotified = rs1.getTimestamp("_date");
	if(noNum!=0)
	{
%>
		<script type="text/javascript">
			$(document).ready(function(){
				$("#noNum").css({"display":"inline"});
			});
			
		</script>
<%
	}
%>

							<div id="divNotifications" style="float: right;position: relative;">
								<span class="badge badge-important" id="noNum" style="display: none;"><%=noNum %></span>
								<a class="hiddenlist" title="Notifications" href="javascript: void(0);" 
									onclick="toggleRequestList(this,divTopNotifyList);"><b>Notification<%=noNum>1?"s":"" %></b></a>
								<div id="divTopNotifyList" class="hiddenlist">
									<table width="400px" border="0" cellpadding="0" cellspacing="0">
<%
	String sql = "SELECT SQL_CACHE ac.activity_id,abc.user_id,u.name,ac.activitytime,ac.day,ac._year,date_format(ac.activitytime,_utf8'%l:%i %p') _time " +
				 "FROM activitycommentuser ac " +
				 "JOIN activitybecommenteduser abc ON ac.activity_id = abc.activity_id AND ac.user_id <> abc.user_id " +
				 "JOIN userinfo u ON abc.user_id = u.user_id " +
				 "WHERE ac.user_id=" + ub.getUserID() +
				 //" AND ac.activitytime > (SELECT _date FROM lastusernotified WHERE user_id = " + ub.getUserID() +") " +
				 " ORDER BY ac.activitytime DESC limit 3";
	rs = conn.getResultSet(sql);
	if(rs.next()){
	%>
										<tr>
											<td style="background: #eeeeee; font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Comment on your wall</td>
										</tr>
	<%
		rs.previous();
	}
	%>
										<!-- <tr>
											<td style="font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Notifications</td>
										</tr> -->
<%
	int count = 0;
	while(rs.next()){
		String _day = null;
		String name = rs.getString("name");
		Timestamp _atime = rs.getTimestamp("activitytime");
		int _year = rs.getInt("_year");
		String _time = rs.getString("_time");
		int activity_id = rs.getInt("activity_id");
		long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
		long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
		long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
		long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
		if(_dateDiff >= 1){
			if(_dateDiff == 1){
				_day = "Yesterday";
			}else{
				_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
			}
		}else if(_hourDiff >= 1){
			_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
		}else if(_minDiff >= 1){
			_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
		}else if(_secDiff > 0){
			_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
		}else{
			_day = "a second ago";
		}
		noteno++;
		count++;
		if(count>3)
		{
%>
										<tr class="leftComment" style="display: none;">
											<td class="leftComment notis" onclick="notis(<%=activity_id %>, <%=ub.getUserID() %>, this)" style='<%=_atime.getTime()>lastNotified.getTime()?"background: rgb(206, 206, 206);":"" %> cursor: pointer; display: none; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>left a comment <b><%=_day %></b>
											</td>
										</tr>
<%
		}
		else
		{
%>
										<tr>
											<td class="notis" onclick="notis(<%=activity_id %>, <%=ub.getUserID() %>, this)" style='<%=_atime.getTime()>lastNotified.getTime()?"background: #0088cc;":"" %>cursor: pointer; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>left a comment <b><%=_day %></b>
											</td>
										</tr>
<%
		}
	}
	if(count>3)
	{
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<font style="cursor: pointer;" class="leftCommentShow">&nbsp;Show More&nbsp;</font>
												<script>
													$(".leftCommentShow").click(function(){
														if($(".leftComment").is(":visible"))
														{
															$(".leftCommentShow").html("Show More");
															$(".leftComment").fadeOut(0);
														}
														else
														{
															$(".leftCommentShow").html("Show Less");
															$(".leftComment").fadeIn(0);
														}
													});
												</script>
											</td>
										</tr>
<%
	}
	sql = "SELECT SQL_CACHE c.comment_id, ulw.user_id, u.name, ulw.liketime, ulw._year, date_format(ulw.liketime,_utf8'%l:%i %p') _time " + 
		  "FROM userlikeswhom ulw JOIN userinfo u ON u.user_id=ulw.user_id " +
		  "JOIN like_comment lc ON ulw.like_id=lc.like_id " + 
		  "JOIN comment c on c.comment_id=lc.comment_id " +
		  "WHERE ulw.user_who_comments_id=" + ub.getUserID() + " AND ulw.user_id<>" + ub.getUserID() + 
		  " ORDER BY liketime DESC limit 3;";
	rs = conn.getResultSet(sql);
	if(rs.next())
	{
	%>
										<tr>
											<td style="background: #eeeeee; font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Like your comment</td>
										</tr>
	<%
		rs.previous();
	}
	
	count = 0;
	while(rs.next()){
		String _day = null;
		String name = rs.getString("name");
		Timestamp _atime = rs.getTimestamp("liketime");
		int _year = rs.getInt("_year");
		String _time = rs.getString("_time");
		int activity_id = rs.getInt("comment_id");
		sql = "SELECT COUNT(commentee_id) AS _no, commentee_id FROM comment_comment WHERE comment_id=" + activity_id + " GROUP BY commentee_id;";
		rs1 = conn.getResultSet(sql);
		if(rs1.next())
		{
			if(rs1.getInt("_no")!=0)
			{
				activity_id = rs1.getInt("commentee_id");
			}
		}
		long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
		long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
		long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
		long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
		if(_dateDiff >= 1){
			if(_dateDiff == 1){
				_day = "Yesterday";
			}else{
				_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
			}
		}else if(_hourDiff >= 1){
			_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
		}else if(_minDiff >= 1){
			_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
		}else if(_secDiff > 0){
			_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
		}else{
			_day = "a second ago";
		}
		

		noteno++;
		count++;
		if(count>3)
		{
%>
										<tr class="likeComment" style="display: none;">
											<td class="likeComment notis" onclick="notis(<%=activity_id %>, <%=ub.getUserID() %>, this)" 
											    style='<%=_atime.getTime()>lastNotified.getTime()?"background: rgb(206, 206, 206);":"" %> 
											    cursor: pointer; display: none; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>liked a comment <b><%=_day %></b>
											</td>
										</tr>
<%
		}
		else
		{
%>
										<tr>
											<td class="notis"  onclick="notis(<%=activity_id %>, <%=ub.getUserID() %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: #0088cc;":"" %> 
												cursor: pointer; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>liked a comment <b><%=_day %></b>
											</td>
										</tr>
<%
		}
	}
	if(count>3)
	{
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<font style="cursor: pointer;" class="likeCommentShow">&nbsp;Show More&nbsp;</font>
												<script>
													$(".likeCommentShow").click(function(){
														if($(".likeComment").is(":visible"))
														{
															$(".likeCommentShow").html("Show More");
															$(".likeComment").fadeOut(0);
														}
														else
														{
															$(".likeCommentShow").html("Show Less");
															$(".likeComment").fadeIn(0);
														}
													});
												</script>
											</td>
										</tr>
<%
	}
	sql = "SELECT SQL_CACHE t.comment_id, u.name, t.comment_date, t._year, t._time " +
		  "FROM userinfo u, comment c, usercomment_comment t " +
		  "WHERE t.comment_id=c.comment_id AND c.user_id=u.user_id " +
		  "AND t.commentee_user_id=" + ub.getUserID() + " AND c.user_id<>" + ub.getUserID() + 
		  " ORDER BY comment_date DESC limit 3;";
	rs = conn.getResultSet(sql);
	if(rs.next())
	{
%>
										<tr>
											<td style="background: #eeeeee; font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Comment on your comment</td>
										</tr>
<%
		rs.previous();
	}
	
	count = 0;
	while(rs.next()){
		String _day = null;
		String name = rs.getString("name");
		Timestamp _atime = rs.getTimestamp("comment_date");
		int _year = rs.getInt("_year");
		int activity_id = rs.getInt("comment_id");
		sql = "SELECT SQL_CACHE c.comment_id FROM comment c JOIN comment_comment cc ON " +
			  "c.comment_id=cc.commentee_id WHERE cc.comment_id=" + activity_id + ";";
		rs1 = conn.getResultSet(sql);
		if(rs1.next())
		{
			activity_id = rs1.getInt("comment_id");
		}
		String _time = rs.getString("_time");
		long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
		long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
		long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
		long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
		if(_dateDiff >= 1){
			if(_dateDiff == 1){
				_day = "Yesterday";
			}else{
				_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
			}
		}else if(_hourDiff >= 1){
			_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
		}else if(_minDiff >= 1){
			_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
		}else if(_secDiff > 0){
			_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
		}else{
			_day = "a second ago";
		}
		
		noteno++;
		count++;
		if(count>3)
		{
%>
										<tr class="commentComment" style="display: none;">
											<td class="commentComment notis" onclick="notis(<%=activity_id %>, <%=ub.getUserID() %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: rgb(206, 206, 206);":"" %> 
												cursor: pointer; display: none; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>commented your comment <b><%=_day %></b>
											</td>
										</tr>
<%
		}
		else
		{
%>
										<tr>
											<td class="notis" onclick="notis(<%=activity_id %>, <%=ub.getUserID() %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: #0088cc;":"" %> 
												cursor: pointer; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>commented your comment <b><%=_day %></b>
											</td>
										</tr>
<%
		}
	}
	if(count>3)
	{
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<font style="cursor: pointer;" class="commentCommentShow">&nbsp;Show More&nbsp;</font>
												<script>
													$(".commentCommentShow").click(function(){
														if($(".commentComment").is(":visible"))
														{
															$(".commentCommentShow").html("Show More");
															$(".commentComment").fadeOut(0);
														}
														else
														{
															$(".commentCommentShow").html("Show Less");
															$(".commentComment").fadeIn(0);
														}
													});
												</script>
											</td>
										</tr>
<%
	}
	sql = "SELECT SQL_CACHE col.col_id, u.name, c.lastupdate, comm.comm_name, date_format(c.lastupdate, _utf8'%Y') as _year" +
		  ", date_format(c.lastupdate,_utf8'%l:%i %p') _time FROM contribute c JOIN colloquium col ON c.col_id=col.col_id " +
		  "JOIN community comm ON comm.comm_id=c.comm_id JOIN final_member_community fmc ON fmc.comm_id=comm.comm_id JOIN userinfo u " +
		  "ON u.user_id=c.user_id WHERE fmc.user_id=" + ub.getUserID() + 
		  " ORDER BY lastupdate DESC limit 3;";
	rs = conn.getResultSet(sql);
	if(rs.next())
	{
%>
										<tr>
											<td style="background: #eeeeee; font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Talks posted in your group(s)</td>
										</tr>
<%
		rs.previous();
	}
	
	count = 0;
	while(rs.next()){
		int col_id = rs.getInt("col_id");
		String _day = null;
		String name = rs.getString("name");
		String commName = rs.getString("comm_name");
		Timestamp _atime = rs.getTimestamp("lastupdate");
		int _year = rs.getInt("_year");
		String _time = rs.getString("_time");
		long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
		long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
		long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
		long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
		if(_dateDiff >= 1){
			if(_dateDiff == 1){
				_day = "Yesterday";
			}else{
				_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
			}
		}else if(_hourDiff >= 1){
			_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
		}else if(_minDiff >= 1){
			_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
		}else if(_secDiff > 0){
			_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
		}else{
			_day = "a second ago";
		}
		
		noteno++;
		count++;
		if(count>3)
		{
%>
										<tr class="groupPostTalk" style="display: none;">
											<td class="groupPostTalk notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: rgb(206, 206, 206);":"" %> 
												cursor: pointer; display: none; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>posted a new talk in <b><%=commName %></b> <b><%=_day %></b>
											</td>
										</tr>
<%
		}
		else
		{
%>
										<tr>
											<td class="notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: #0088cc;":"" %> 
												cursor: pointer; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>posted a new talk in <b><%=commName %></b> <b><%=_day %></b>
											</td>
										</tr>
<%
		}
	}
	if(count>3)
	{
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<font style="cursor: pointer;" class="groupPostTalkShow">&nbsp;Show More&nbsp;</font>
												<script>
													$(".groupPostTalkShow").click(function(){
														if($(".groupPostTalk").is(":visible"))
														{
															$(".groupPostTalkShow").html("Show More");
															$(".groupPostTalk").fadeOut(0);
														}
														else
														{
															$(".groupPostTalkShow").html("Show Less");
															$(".groupPostTalk").fadeIn(0);
														}
													});
												</script>
											</td>
										</tr>
<%
	}
	sql = "SELECT SQL_CACHE DISTINCT c.col_id, u.name, c.lastupdate, s.name AS series_name, date_format(c.lastupdate, _utf8'%Y') as _year, " +
		  "date_format(c.lastupdate,_utf8'%l:%i %p') _time FROM colloquium c JOIN seriescol sc ON c.col_id=sc.col_id " +
		  "JOIN series s ON sc.series_id=s.series_id JOIN final_subscribe_series sub ON sub.series_id=s.series_id " +
		  "JOIN userinfo u ON u.user_id=c.user_id " +
		  "JOIN lastusernotified l ON l.user_id=sub.user_id WHERE l.user_id=" + ub.getUserID() +" ORDER BY lastupdate DESC LIMIT 3;";
	rs = conn.getResultSet(sql);
	if(rs.next())
	{
%>
										<tr>
											<td style="background: #eeeeee; font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Talks posted in your series</td>
										</tr>
<%
		rs.previous();
	}
	
	count = 0;
	while(rs.next()){
		int col_id = rs.getInt("col_id");
		String _day = null;
		String name = rs.getString("name");
		String seriesName = rs.getString("series_name");
		Timestamp _atime = rs.getTimestamp("lastupdate");
		int _year = rs.getInt("_year");
		String _time = rs.getString("_time");
		long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
		long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
		long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
		long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
		if(_dateDiff >= 1){
			if(_dateDiff == 1){
				_day = "Yesterday";
			}else{
				_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
			}
		}else if(_hourDiff >= 1){
			_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
		}else if(_minDiff >= 1){
			_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
		}else if(_secDiff > 0){
			_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
		}else{
			_day = "a second ago";
		}
		

		noteno++;
		count++;
		if(count>3)
		{
%>
										<tr class="seriesPostTalk" style="display: none;">
											<td class="seriesPostTalk notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: rgb(206, 206, 206);":"" %> 
												cursor: pointer; display: none; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>posted a new talk in <b><%=seriesName %></b> <b><%=_day %></b>
											</td>
										</tr>
<%
		}
		else
		{
%>
										<tr>
											<td class="notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: #0088cc;":"" %> 
												cursor: pointer; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %>&nbsp;</b>posted a new talk in <b><%=seriesName %></b> <b><%=_day %></b>
											</td>
										</tr>
<%
		}
	}
	if(count>3)
	{
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<font style="cursor: pointer;" class="seriesPostTalkShow">&nbsp;Show More&nbsp;</font>
												<script>
													$(".seriesPostTalkShow").click(function(){
														if($(".seriesPostTalk").is(":visible"))
														{
															$(".seriesPostTalkShow").html("Show More");
															$(".seriesPostTalk").fadeOut(0);
														}
														else
														{
															$(".seriesPostTalkShow").html("Show Less");
															$(".seriesPostTalk").fadeIn(0);
														}
													});
												</script>
											</td>
										</tr>
<%
	}
	sql = "SELECT SQL_CACHE DISTINCT efc.col_id, efc.friend_name, c.begintime, date_format(c.begintime, _utf8'%Y') as _year, " +
		  "date_format(c.begintime,_utf8'%l:%i %p') _time FROM ext_friend_col efc JOIN colloquium c " +
		  "ON efc.col_id=c.col_id WHERE efc.user_id=" + ub.getUserID() + " ORDER BY begintime DESC limit 3;";
	rs = conn.getResultSet(sql);
	if(rs.next())
	{
%>
										<tr>
											<td style="background: #eeeeee; font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Friends give talks</td>
										</tr>
<%
		rs.previous();
	}
	
	count = 0;
	while(rs.next()){
		int col_id = rs.getInt("col_id");
		String _day = null;
		String name = rs.getString("friend_name");
		Timestamp _atime = rs.getTimestamp("begintime");
		int _year = rs.getInt("_year");
		String _time = rs.getString("_time");
		long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
		long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
		long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
		long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
		if(_dateDiff >= 1){
			if(_dateDiff == 1){
				_day = "Yesterday";
			}else{
				_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
			}
		}else if(_hourDiff >= 1){
			_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
		}else if(_minDiff >= 1){
			_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
		}else if(_secDiff > 0){
			_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
		}else if(_dateDiff <= 0){
			_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;
		}else{
			_day = "a second ago";
		}
		

		noteno++;
		count++;
		if(count>3)
		{
%>
										<tr class="friendsPostTalk" style="display: none;">
											<td class="friendsPostTalk notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: rgb(206, 206, 206);":"" %> 
												cursor: pointer; display: none; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %></b> <%=today.getTime() - _atime.getTime()<0?"will give":"gave" %> a talk <b><%=_day %></b>
											</td>
										</tr>
<%
		}
		else
		{
%>
										<tr>
											<td class="notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: #0088cc;":"" %> 
												cursor: pointer; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %></b> <%=today.getTime() - _atime.getTime()<0?"will give":"gave" %> a talk <b><%=_day %></b>
											</td>
										</tr>
<%
		}
	}
	if(count>3)
	{
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<font style="cursor: pointer;" class="friendsPostTalkShow">&nbsp;Show More&nbsp;</font>
												<script>
													$(".friendsPostTalkShow").click(function(){
														if($(".friendsPostTalk").is(":visible"))
														{
															$(".friendsPostTalkShow").html("Show More");
															$(".friendsPostTalk").fadeOut(0);
														}
														else
														{
															$(".friendsPostTalkShow").html("Show Less");
															$(".friendsPostTalk").fadeIn(0);
														}
													});
												</script>
											</td>
										</tr>
<%
	}
	
	sql = "SELECT SQL_CACHE s.name, c.col_id, c.begintime, date_format(c.begintime, _utf8'%Y') as _year, "+
		  "date_format(c.begintime,_utf8'%l:%i %p') _time FROM speaker s JOIN final_subscribe_speaker fss ON s.speaker_id=fss.speaker_id "+
		  "JOIN col_speaker cs ON cs.speaker_id=s.speaker_id JOIN colloquium c ON cs.col_id=c.col_id WHERE "+
		  "fss.user_id=" + ub.getUserID() + " ORDER BY begintime DESC limit 3;";
	rs = conn.getResultSet(sql);
	if(rs.next())
	{
%>
										<tr>
											<td style="background: #eeeeee; font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Subscribed Speaker</td>
										</tr>
<%
		rs.previous();
	}
	
	count = 0;
	while(rs.next()){
		int col_id = rs.getInt("col_id");
		String _day = null;
		String name = rs.getString("name");
		Timestamp _atime = rs.getTimestamp("begintime");
		int _year = rs.getInt("_year");
		String _time = rs.getString("_time");
		long _dateDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_DAY;
		long _hourDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_HOUR;
		long _minDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS_PER_MIN;
		long _secDiff = (long)(today.getTime() - _atime.getTime())/MILLISECS;
		if(_dateDiff >= 1){
			if(_dateDiff == 1){
				_day = "Yesterday";
			}else{
				_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;				
			}
		}else if(_hourDiff >= 1){
			_day = (_hourDiff==1&&_minDiff>0?"about ":"") + _hourDiff + " hour" + (_hourDiff>1?"s":"") + " ago";
		}else if(_minDiff >= 1){
			_day = _minDiff + " minute" + (_minDiff>1?"s":"") + " ago";
		}else if(_secDiff > 0){
			_day = (_secDiff<=1?"a":"" + _secDiff) + " second" + (_secDiff>1?"s":"") + " ago";
		}else if(_dateDiff <= 0){
			_day = 	((_year==year)?formatterDay.format(_atime):formatterDayYear.format(_atime)) + " at " + _time;
		}else{
			_day = "a second ago";
		}
		

		noteno++;
		count++;
		if(count>3)
		{
%>
										<tr class="speakerGiveTalk" style="display: none;">
											<td class="speakerGiveTalk notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: rgb(206, 206, 206);":"" %> 
												cursor: pointer; display: none; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %></b> <%=today.getTime() - _atime.getTime()<0?"will give":"gave" %> a talk <b><%=_day %></b>
											</td>
										</tr>
<%
		}
		else
		{
%>
										<tr>
											<td class="notis" onclick="notisTalk(<%=col_id %>, this)" 
												style='<%=_atime.getTime()>lastNotified.getTime()?"background: #0088cc;":"" %> 
												cursor: pointer; font-size: 0.6em;border-bottom: 1px solid #00468c; padding: 2px;'>
												<b><%=name %></b> <%=today.getTime() - _atime.getTime()<0?"will give":"gave" %> a talk <b><%=_day %></b>
											</td>
										</tr>
<%
		}
	}
	if(count>3)
	{
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<font style="cursor: pointer;" class="speakerGiveTalkShow">&nbsp;Show More&nbsp;</font>
												<script>
													$(".speakerGiveTalkShow").click(function(){
														if($(".speakerGiveTalk").is(":visible"))
														{
															$(".speakerGiveTalkShow").html("Show More");
															$(".speakerGiveTalk").fadeOut(0);
														}
														else
														{
															$(".speakerGiveTalkShow").html("Show Less");
															$(".speakerGiveTalk").fadeIn(0);
														}
													});
												</script>
											</td>
										</tr>
<%
	}
%>
										<tr>
											<td valign="middle" align="center" style="font-size: 0.7em; color: #0080ff; border-bottom: 1px solid #00468c;">
											&nbsp;
											</td>
										</tr>
<%
	if(rs1!=null)
	{
		rs1.close();
	}
	if(noteno==0){
%>
										<tr>
											<td  style="font-size: 0.8em;border-bottom: 1px solid #00468c;">No new notifications</td>
										</tr>
<%		
	}
	else
	{
%>	
										<tr>
											<td valign="middle" align="center" style="font-size: 0.8em; color: #0080ff; border-bottom: 1px solid #00468c;">
												<a href="notifications.do">Show All</a>
											</td>
										</tr>
<%
	}
%>									
										<!-- <tr>
											<td  style="font-size: 0.8em;font-weight: bold;">See All Notifications</td>
										</tr> -->
									</table>
										<!-- <ul>
											<li>Notifications</li>
											<li>No new notifications.</li>
											<li>See All Notifications</li>
										</ul> -->
								</div>
							</div>
							<div style="float: right;">&nbsp;</div>
			

<% 
	sql = "SELECT u.name,u.user_id FROM userinfo u JOIN request r ON u.user_id=r.requester_id " +
				"WHERE r.accepttime IS NULL AND r.rejecttime IS NULL AND r.droprequesttime IS NULL AND r.target_id=" + ub.getUserID() +
				" ORDER BY r.requesttime DESC LIMIT 5;";
	rs = conn.getResultSet(sql);
	LinkedHashMap<Integer,String> requestMap = new LinkedHashMap<Integer,String>();
	while(rs.next()){
		String uname = rs.getString("name");
		int uid = rs.getInt("user_id");
		requestMap.put(uid,uname);
		
	}
	sql1 = "SELECT f._no FROM friendrequestnum f where f.user_id=" + ub.getUserID() + ";";
	rs1 = conn.getResultSet(sql1);
	rs1.next();
	int frNum = rs1.getInt("_no");
	if(frNum!=0){
%>
		<script type="text/javascript">
			$(document).ready(function(){
				$("#frNum").css({"display":"inline"});
			});
			
		</script>
<%
		
	}
	%>											
	<div id="divFriendRequest" style="float: right;position: relative;" title="Friend Requests">
		<span class="badge badge-important" id="frNum" style="display: none;"><%=frNum %></span>
		<a class="hiddenlist" title="Friend Requests" href="javascript:void(0)" 
			onclick="toggleRequestList(this,divTopReqList);"><b>Friend Request<%=frNum>1?"s":"" %></b></a>
		<div id="divTopReqList" class="hiddenlist">
				<table width="200" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="font-size: 0.8em;font-weight: bold;border-bottom: 1px solid #00468c;">Friend Requests</td>
					</tr>
<%		
	if(requestMap.size()==0){
		%>
		<tr>
			<td style="font-size: 0.8em;border-bottom: 1px solid #00468c;">No new requests.</td>
		</tr>
<%		
	}else{
		for(int uid : requestMap.keySet()){
			String uname = requestMap.get(uid);
%>
											<tr>
												<td bgcolor="#efefef" style="font-size: 0.8em;font-weight: bold;"><a style="text-decoration: none" href="profile.do?user_id=<%=uid %>"><%=uname %></a></td>
											</tr>
<%		
		}
	}
%>											
<%-- 
											<tr>
												<td bgcolor="#efefef" style="font-size: 0.8em;font-weight: bold;">See All Friend Requests</td>
											</tr>
--%>
										</table>
								</div>
							</div>
						</logic:present>

					</logic:notPresent>
				</td>
			</tr>
<%--			<tr>
				<td align="left" style = "background-color: #fff;padding-right:4px;width: 60%;">
					<logic:notPresent name="HideBar">
						<form name="s_search" action="searchResult.do" style="border:0px;margin:0px;padding:0px">
<% 
	String s_opt = request.getParameter("s_opt");
%>
	                  		<select   name= "s_opt" id="s_opt">  	
	                  					 
    							<option   value= "1" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("1")?"selected":"") %>> Title </option> 
    							<option   value= "2" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("2")?"selected":"") %>> Detail </option>
    							<option   value= "3" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("3")?"selected":"") %>> Speaker </option>
    							<option   value= "4" <%=s_opt==null?"selected":(s_opt.trim().equalsIgnoreCase("4")?"selected":"") %>> ALL </option>
							</select> 
							<%
								String query = new String();
								if ((query = request.getParameter("search_text")) != null){
									int index;
									if ((index = query.indexOf("AND")) != -1){
										query = query.substring(0, index).trim();
									}
									if ((query.startsWith("(") && query.endsWith(")") )){
										query = query.substring(1, query.length()-1);
									}
										
								}
								else{
									query = "";
								}
							%>
						    <input name="search_text" size="38" type="text" value = "<%= query %>">
						    <input name="sa" class ="btn" value="Search" type="button" onclick="s_confirm()">
						    <input name="sortBy" value="1" type="hidden" />
							<input name="firstSearch" value="true" type="hidden" />
						    <a href="advancedSearch.do" style="font-size:11px; text-decoration: none; cursor: pointer; color: #36C">Advanced Search</a>
					    </form>
                	</logic:notPresent>
              	</td>    
              	<td align="right">
					<logic:notPresent name="HideBar">
                		<input class ="btn" id="btnPostNewTalk" onclick="window.location='PreColloquiumEntry.do'" value="Post New Talk" type="button">
                	</logic:notPresent>
				</td>													
			</tr> --%>

<% 
	String affiliate_id = null;
	String affiliate = "";
	LinkedHashMap<String,Integer> relationList = new LinkedHashMap<String,Integer>();
	HashMap<String,String> aList = new HashMap<String,String>();
	//String childrenList = null;
	LinkedHashMap<Integer, Integer> childrenList = null;
	Object hideBar = session.getAttribute("HideBar");
	if(request.getParameter("affiliate_id") != null && hideBar == null){
		affiliate_id = request.getParameter("affiliate_id");
		String sql = "SELECT SQL_CACHE affiliate FROM affiliate WHERE affiliate_id = " + affiliate_id;
		rs = conn.getResultSet(sql);
		if(rs.next()){
			affiliate = rs.getString("affiliate");
%>
<%-- 
			<tr>
				<td align="left" colspan="3">
					<span style="color:#0080ff;cursor:pointer;font-size: 1.5em;" 
						onclick="window.location='index.do?affiliate_id=<%=affiliate_id%>'"><%=affiliate%>
					</span>
				</td>
			</tr>
--%>
<%	
			int talkno = 0;
			sql = "SELECT SQL_CACHE COUNT(*) _no FROM colloquium c WHERE c.col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac JOIN " +
					"(SELECT child_id FROM relation WHERE " +
					"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id + "),',%')) cc " +
					"ON ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id + ") " + 
					" AND c._date >= CURDATE() ";
			ResultSet rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				talkno = rsSponsor.getInt("_no");
			}
			
			sql = "SELECT SQL_CACHE r.path FROM relation r WHERE r.child_id = " + affiliate_id;
			rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				String relation = rsSponsor.getString("path");
				relationList.put(relation, talkno);
				String[] path = relation.split(",");
				for(int i=0;i<path.length;i++){
					aList.put(path[i],null);
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
			
			sql = "SELECT SQL_CACHE r.child_id " +
					"FROM relation r JOIN affiliate a ON r.child_id = a.affiliate_id " +
					"JOIN affiliate_col ac ON a.affiliate_id = ac.affiliate_id " +
					"JOIN colloquium c ON ac.col_id = c.col_id " +
					"WHERE r.parent_id=" + affiliate_id + " AND c._date >= CURDATE() " +
					"GROUP BY r.child_id ORDER BY a.affiliate";
			rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				int child_id = rsSponsor.getInt("child_id");
				if(childrenList == null){
					childrenList = new LinkedHashMap<Integer, Integer>();
				}
				int _no = 0;
				sql = "SELECT SQL_CACHE COUNT(*) _no FROM colloquium c WHERE c.col_id IN " +
						"(SELECT ac.col_id FROM affiliate_col ac JOIN " +
						"(SELECT child_id FROM relation WHERE " +
						"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ child_id + "),',%')) cc " +
						"ON ac.affiliate_id = cc.child_id " +
						"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + child_id + ") " + 
						" AND c._date >= CURDATE() ";
				ResultSet rsNo = conn.getResultSet(sql);
				while(rsNo.next()){
					_no = rsNo.getInt("_no");
				}
				if(childrenList.containsKey(child_id)){
					_no += childrenList.get(child_id);
				}
				if(_no > 0){
					childrenList.put(child_id, _no);
					if(affList ==null){
						affList = "";
					}else{
						affList +=",";
					}
					affList += "" + child_id;
				}
				
			}
			sql = "SELECT SQL_CACHE affiliate_id,affiliate FROM affiliate WHERE affiliate_id IN ("+affList+")";
			rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				aList.put(rsSponsor.getString("affiliate_id"),rsSponsor.getString("affiliate"));
			}
			rsSponsor.close();
			
			/*if(relationList.size()>0){

				for(int ii=0;ii<relationList.size();ii++){
					String[] parents = relationList.get(ii).split(",");
%>
				<tr>
					<td align="left" colspan="3">
<% 
					String aParent = "";
					if(parents.length > 1){
						for(int j=parents.length-2;j>-1;j--){
%>				
							<span onclick="window.location='affiliate.do?affiliate_id=<%=parents[j]%>'" 
							style="color:#0080ff;cursor:pointer;font-size: 0.9em;">
								<%=aList.get(parents[j])%>
							</span>
<% 
							if(j>0)out.print(" , ");
						}
					}
					if(ii!=relationList.size()-1)out.print("<br/> and ");
%>				
					</td>
				</tr>
<%	
				}
			}*/
		}
		rs.close();
	}
%>
		</table>
<logic:notPresent name="HideBar">
<%
	CommunityBean cb = new CommunityBean();
	cb.setCommID(0);
	cb.setName("default");
	session.setAttribute("CommunitySession", cb);

	String menu = "home";	
	if(session.getAttribute("menu") != null){
		menu = (String)session.getAttribute("menu");
	}
%>
<!-- Edit by Wenbang -->
	<div class="row-fluid">
		<div class="span12">
			<div class="subnav" style="width: 1000px;">
				<ul class="nav nav-pills">
				<%
					String colsize = "14.28%";
					if(menu.equalsIgnoreCase("home")){
				%>
					<li class="active" ><a style="cursor: default;">Home</a></li>
				<%		
					}else{
				%>
					<li ><a href=".">Home</a></li>	
				<%
					}
					if(menu.equalsIgnoreCase("calendar")){
				%>		
					<li class="active" ><a style="cursor: default;">Calendar</a></li>
				<%		
					}else{
				%>
					<li ><a href="calendar.do">Calendar</a></li>
				<%
					}
					if(menu.equalsIgnoreCase("series")){
				%>
					<li class="active" ><a style="cursor: default;">Series</a></li>
				<%
					}else{
				%>
					<li ><a href="series.do">Series</a></li>
				<%
					}
					if(menu.equalsIgnoreCase("speaker")){
				%>
					<li class="active" ><a style="cursor: default;">Speakers</a></li>
				<%
					}else{
				%>
					<li ><a href="speakerlist.do">Speakers</a></li>
				<%
					}
					if(menu.equalsIgnoreCase("community")){
				%>
					<li class="active" ><a style="cursor: default;">Groups</a></li>
				<%
					}else{
				%>
					<li ><a href="community.do">Groups</a></li>
				<%
					}
					if(menu.equalsIgnoreCase("connection")){
				%>
					<li class="active" ><a style="cursor: default;">Connections</a></li>
				<%
					}else{
				%>
					<li ><a href="connection.do">Connections</a></li>
				<%
					}
					if(menu.equalsIgnoreCase("myaccount")){
				%>
					<li class="active" ><a style="cursor: default;">My Account</a></li>
				<%
					}else{
				%>
					<li ><a href="profile.do">My Account</a></li>
				<%	
					}
				%>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="row-fluid">
		<div class="span8">
		<logic:notPresent name="HideBar">
			<div class="row-fluid">
				<div class="span7">
					<form name="s_search" action="searchResult.do">
					
						<% 
							String s_opt = request.getParameter("s_opt");
						%>
			               		<select   name= "s_opt" id="s_opt" style="width: 90px;">  	
			               					 
										<option   value= "1" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("1")?"selected":"") %>> Title </option> 
										<option   value= "2" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("2")?"selected":"") %>> Detail </option>
										<option   value= "3" <%=s_opt==null?"":(s_opt.trim().equalsIgnoreCase("3")?"selected":"") %>> Speaker </option>
										<option   value= "4" <%=s_opt==null?"selected":(s_opt.trim().equalsIgnoreCase("4")?"selected":"") %>> ALL </option>
						</select> 
						<%
							String query = new String();
							if ((query = request.getParameter("search_text")) != null){
								int index;
								if ((index = query.indexOf("AND")) != -1){
									query = query.substring(0, index).trim();
								}
								if ((query.startsWith("(") && query.endsWith(")") )){
									query = query.substring(1, query.length()-1);
								}
									
							}
							else{
								query = "";
							}
						%>
						<div class="input-append">
					    <input name="search_text" size="38" type="text" value = "<%= query %>" />
					    <input name="sa" class ="bttn" value="Search" type="button" onclick="s_confirm()" />
					    <input name="sortBy" value="1" type="hidden" />
						<input name="firstSearch" value="true" type="hidden" />
					    </div>
				    </form>
			    </div>
			    <button class="bttn bttn-primary" onclick="window.location='advancedSearch.do'">Advanced Search</button>
		    </div>
         </logic:notPresent>	
         </div>
         <div class="span2 offset2">
			<logic:notPresent name="HideBar">
          		<input class ="bttn bttn-success" id="btnPostNewTalk" onclick="window.location='PreColloquiumEntry.do'" value="Post New Talk" type="button">
          	</logic:notPresent>
         </div>
    </div>
<!-- Edit by Wenbang -->

	<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
<% 
	if(affiliate_id!=null){
%>
		<tr>
			<td colspan="3">
<% 
		int i=0;
		for(String relation : relationList.keySet()){
			String[] aff_id  = relation.split(",");
			for(int j=0;j<aff_id.length;j++){
				String id = aff_id[j];
				String aff = (String)aList.get(id);
%>
				<%=j==0?"<a style=\"font-size: 0.9em;font-weight: bold;\" href=\"affiliate.do\">Affiliation Tree</a> > ":"" %>
				<a style="font-size: 0.9em;font-weight: bold;" href="affiliate.do?affiliate_id=<%=id%>"><%=aff%></a>
<%				
				if(j!=aff_id.length-1)out.print(" > ");	
			}
			int no = relationList.get(relation);
			if(no > 0){
%>
				<span style="color:#0080ff;font-size: 0.85em;">&nbsp;(<%=no %> talk<%=no>1?"s":"" %>)</span>
<%
			}
			if(i!=relationList.size()-1){
				out.print("<br/>");
			}
		}
%>			
			</td>
		</tr>
<% 
		if(childrenList!=null){
%>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td colspan="3" bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				Affiliations
			</td>
		</tr>
		<tr>
			<td colspan="3" style="font-size: 0.9em;font-weight: bold;">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
<% 
		int column = -1;
		i = 0;
		for(int child_id : childrenList.keySet()){
			String id = "" + child_id;
			int no = childrenList.get(child_id);
			String aff = (String)aList.get(id);
			column = i%3;
			i++;
			if(column == 0){
%>
					<tr>
<%			
			}
%>
						<td>
<%-- 
							<span style="cursor:pointer;font-size: 0.9em;font-weight: bold;" 
								onclick="window.location='affiliate.do?affiliate_id=<%=id%>'"><%=aff%></span>
--%>						
							<a style="font-size: 0.9em;font-weight: bold;" href="affiliate.do?affiliate_id=<%=id%>"><%=aff %></a>
<% 
			/*Calendar calendar = new GregorianCalendar();
			int month = calendar.get(Calendar.MONTH);
			int year = calendar.get(Calendar.YEAR);
			int req_day = -1;
			int req_week = -1;
			int req_month = month+1;
			int req_year = year;
			boolean req_posted = false;//True means user posts' talks
			boolean req_impact = false;//True means user impact
			boolean req_most_recent = false;

			String[] user_id_value = request.getParameterValues("user_id");
			String[] tag_id_value = request.getParameterValues("tag_id");
			String[] entity_id_value = request.getParameterValues("entity_id");
			String[] type_value = request.getParameterValues("_type");
			String[] series_id_value = request.getParameterValues("series_id");
			String[] comm_id_value = request.getParameterValues("comm_id");
			String[] affiliate_id_value = request.getParameterValues("affiliate_id");
		    if(request.getParameter("day")!=null){
		        req_day = Integer.parseInt(request.getParameter("day"));
		        //out.println("d:" + req_day);
		    }
		    
		    if(request.getParameter("week")!=null){
		        req_week = Integer.parseInt(request.getParameter("week"));
		        //out.println("w:" + req_week);
		    }
		    
		    if(request.getParameter("month")!=null){
		        req_month = Integer.parseInt(request.getParameter("month"));
		        //out.println("m:" + req_month);
		    }
		    
		    if(request.getParameter("year")!=null){
		        req_year = Integer.parseInt(request.getParameter("year"));
		    }else{
		    	req_week = calendar.get(Calendar.WEEK_OF_MONTH);
		    }
		    if(request.getParameter("post")!=null){
		    	req_posted = true;
		    }
		    if(request.getParameter("impact")!=null){
		    	req_impact = true;
		    }
		    if(request.getParameter("mostrecent")!=null){
		    	req_most_recent = true;
			    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
		    }

		    if(menu != null){
				if(menu.equalsIgnoreCase("home")){
					req_most_recent = true;
				    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
				}
			}
			
		    Calendar setcal = new GregorianCalendar();
		    setcal.set(req_year, req_month-1, 1);
		    int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
		    int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);

		    String strBeginDate = "";
			String strEndDate = "";*/
			
			/*****************************************************************/
			/* Day View                                                      */
			/*****************************************************************/
			/*if(req_day > 0){
				strBeginDate = req_year + "-" + req_month + "-" + req_day;
				strEndDate = req_year + "-" + req_month + "-" + req_day;
			}else{
			    if(req_month == 1){
			    	setcal.set(req_year-1, 11, 1);
			    }else{
			    	setcal.set(req_year, req_month-2, 1);
			    }  
			    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);*/
			/*****************************************************************/
			/* Week View                                                     */
			/*****************************************************************/
				/*if(req_week > 0){
					if(startday == 0){
						strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week-1) + 1);
					}else{
						if(req_week == 1){
							strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
							String tmpBeginDate = "";
							if(req_month==1){
								strBeginDate = (req_year-1) + "-12-" + (daysPrevMonth - startday + 1);
							}else{

							}
						}else{
							strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week - 1) - startday + 1);
						}
					}
					if(7*req_week - startday <= stopday ){
						strEndDate = req_year + "-" + req_month + "-" + (7*req_week - startday);
						if(req_week == 1){
						}else{
						}
					}else{
						if(req_month == 12){
							strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
						}else{
							strEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
						}
					}
					if(req_most_recent){
					    int today = calendar.get(Calendar.DAY_OF_MONTH);
						strBeginDate = req_year + "-" + req_month + "-" + today;	
					}
				}else{*/
			/*****************************************************************/
			/* Month View                                                    */
			/*****************************************************************/
					/*if(startday == 0){
						strBeginDate = req_year + "-" + req_month + "-1";
					}else{
						if(req_month == 1){
							strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
						}else{
							strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
							if(req_month == 12){
							}else{
							}
						}
					}
					if((startday + stopday)%7 == 0){
						strEndDate = req_year + "-" + req_month + "-" + (stopday);
					}else{
						if(req_month == 12){
							strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
						}else{
							strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
						}
					}
				}
			}*/

%>
						<span style="color:#0080ff;font-size: 0.85em;">&nbsp;(<%=no %> talk<%=no>1?"s":"" %>)</span></td> 
<%			
			if(column == 2){
%>
					</tr>
<%			
			}
		}
		if(column > -1){
			if(column < 2){
%>
					<tr>
						<td>&nbsp;</td>
					</tr>
<%			
			}else if(column < 1){
%>
					<tr>
						<td>&nbsp;</td>
					</tr>
<%			
			}
		}
%>			
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
<%	
		}
%>			
<%	
	}
	conn.conn.close();
	conn = null;
	
%>
	</table>

</logic:notPresent>		
 <script type="text/javascript">
  var rpxJsHost = (("https:" == document.location.protocol) ? "https://" : "http://static.");
  document.write(unescape("%3Cscript src='" + rpxJsHost +
"rpxnow.com/js/lib/rpx.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  RPXNOW.overlay = true;
  RPXNOW.language_preference = 'en';
</script>
<logic:present name="UserSession">
<!--  ******************************************************************** -->
		<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="divTagTalk">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 550px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" width="100%" border="0" bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
							<tr>
								<td id="tdTagTitle">
									&nbsp;Tag a talk
								</td>
								<td style="width: 10px;">
									<a href="javascript: return false;" onclick="$('#btnTagClose').click();">
										<img alt="Close Window" src="images/x.gif">
									</a>
								</td>
							</tr>
						</table>
					</td>
				
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td colspan="3" style="font-size: 0.85em;padding: 4px;">
									<table id="spanBookmarkHeader" cellpadding="1" cellspacing="0" border="0" width="100%">
										<tr>
											<td>
												<img width='75' alt='Information icon' 
													src='http://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Information_icon.svg/75px-Information_icon.svg.png'/>
											</td>
											<td valign="middle">
												<b style="color: #228b22;">Congratulations! Your bookmark has been saved.</b><br/>
												Could you please help us provide some keywords to organize this talk?
											</td>
										</tr>
									</table>
<%-- 
									<span id="spanTagHeader">
										Help the community to find content faster and add one or more keywords to the talk. Thanks :)
									</span>
--%>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<div id="divUserTagLoading" align='center'><img border='0' src='images/loading-small.gif' /></div>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size: 0.7em;padding: 4px;">
										<tbody id="tags_container" >
											<tr>
												<td width="30%" align="center">Keyword1:<br/><input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword2:<br/><input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword3:<br/><input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="10%" valign="middle">&nbsp;
<%-- 
												<input id="btnAddMoreTagRow" class="btn" type="button" value="Add More Keywords"/></td>
--%>												
											</tr>
<%-- 
											<tr>
												<td width="30%" align="center">Keyword4: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword5: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="30%" align="center">Keyword6: <input style="font-size: 10px;" class="tagInput" type="text" size="20"  /></td>
												<td width="10%">&nbsp;</td>
											</tr>
--%>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3" style="font-size: 0.7em;padding: 4px;">
									<a id="aAddMoreTagRow" href="javascript:return false;">[+]Add More Keywords</a>
								</td>
							<tr/>
<%-- 
							<tr>
								<td colspan="3" style="font-size: 0.7em;padding: 4px;">
									<span id="spanSuggestedTag">&nbsp;</span>
								</td>
							</tr>
--%>
							<tr>
								<td colspan="3" style="font-size: 0.7em;padding: 4px;">
									<span id="spanPopUserTag">&nbsp;</span>
								</td>
							</tr>
							<tr>
								<td colspan="3" style="font-size: 0.7em;padding: 4px;">
									&nbsp;
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="470">&nbsp;&nbsp;<input id="btnNoAskAgain" class="btn" type="button" style="display: none;" value="Never Ask Again"></input></td>
								<td align="center" width="40"><input id="btnDoneTagging" class="btn" type="button" value="Save" ></input></td>
								<td align="center" width="40"><input id="btnTagClose" class="btn" type="button" value="Cancel" onclick="$('#divTagTalk').fadeOut();return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
<!--  ******************************************************************** -->
		<div style="z-index: 999;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="divPostTalk2Group">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 550px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" width="100%" border="0" bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
							<tr>
								<td id="tdPostTitle">
									&nbsp;Post a talk to Your Groups
								</td>
								<td style="width: 10px;">
									<a href="javascript: return false;" onclick="$('#btnPostClose').click();">
										<img alt="Close Window" src="images/x.gif">
									</a>
								</td>
							</tr>
						</table>
					</td>
				
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td id="tdPostGroupContainer" align="center" colspan="3"><img border='0' src='images/loading-small.gif' /></td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="470">&nbsp;</td>
								<td align="center" width="40"><input id="btnDonePosting" class="btn" type="button" value="Save"></input></td>
								<td align="center" width="40"><input id="btnPostClose" class="btn" type="button" value="Cancel" onclick="$('#divPostTalk2Group').fadeOut();return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
<!--  ******************************************************************** -->
		<div style="z-index: 998;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="divEmailTalk">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 550px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" width="100%" border="0" bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
							<tr>
								<td id="tdEmailTitle">
									&nbsp;E-mail this talk to your friends
								</td>
								<td style="width: 10px;">
									<a href="javascript: return false;" onclick="$('#btnEmailClose').click();">
										<img alt="Close Window" src="images/x.gif">
									</a>
								</td>
							</tr>
						</table>
					</td>
				
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td>To: </td>
								<td colspan="2" style="font-size: 0.7em;padding: 4px;"><input id="txtRecipientEmail" type="text" size="80"/></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td colspan="2" style="font-size: 0.7em;padding: 4px;font-style: italic;">Note: separate emails with comma (,)</td>
							</tr>
							<tr>
								<td id="tdLatestEmailContainer" style="font-size: 0.7em;padding: 4px;" colspan="3"><img border='0' src='images/loading-small.gif' /></td>
							</tr>
							<tr>
								<td id="tdPopEmailContainer" style="font-size: 0.7em;padding: 4px;" colspan="3"><img border='0' src='images/loading-small.gif' /></td>
							</tr>
							<tr>
								<td valign="top">Subject: </td>
								<td colspan="2" style="font-size: 0.7em;font-weight: bold;padding: 4px;">CoMeT: <%=ub.getName() %> sugguested colloquium to you</td>
							</tr>
							<tr>
								<td valign="top">Your message: </td>
								<td colspan="2" style="font-size: 0.7em;padding: 4px;">
									<textarea style="font-size: 1em;" id="txtEmailMessage" rows="10" cols="60"></textarea>
<%-- 
									<script type="text/javascript"> 
									//<![CDATA[
					 
										// This call can be placed at any point after the
										// <textarea>, or inside a <head><script> in a
										// window.onload event handler.
					 
										// Replace the <textarea id="editor"> with an CKEditor
										// instance, using default configurations.
										CKEDITOR.replace( 'txtEmailMessage' );
					 
									//]]>
									</script> 
--%>									
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="100">&nbsp;</td>
								<td align="right" width="410"><input id="btnDoneEmailing" class="btn" type="button" value="Send"></input> </td>
								<td align="center" width="40"><input id="btnEmailClose" class="btn" type="button" value="Cancel" onclick="$('#divEmailTalk textarea,input:text').val('');$('#divEmailTalk').fadeOut();return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
<!--  ******************************************************************** -->
</logic:present>		
