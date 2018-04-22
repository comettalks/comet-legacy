<%@page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.form.ColloquiumForm"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.*"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>
<%-- 
<script type='text/javascript' src='../scripts/jquery.js'></script>
--%>
<link rel="stylesheet" href="../css/jquery.autocomplete.css" type="text/css" />
<link type='text/css' href='../css/basic.css' rel='stylesheet' media='screen' />

<script type='text/javascript' src='../scripts/jquery-ui-1.8.5.custom.min.js'></script>

<script src="http://code.jquery.com/jquery-latest.js"></script>
<script type='text/javascript' src='../scripts/jquery.bgiframe.min.js'></script>
<script type='text/javascript' src='../scripts/jquery.autocomplete.js'></script>

<script>
function insert(tag){
	var el = document.getElementById('myTags');
	el.innerHTML += '<div><div class="tags">' + tag + '&nbsp;&nbsp;</div><input style="float:left" height="15" width="15" type="image" src="../images/delete.jpg" onclick="deleteTag(this, \'' + tag + '\')"/></div>';
	
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
     document.getElementById(tag).href = "javascript: void(0)";
     document.getElementById(tag).style.color = "#00A";	
     
}
function submitForm(){
	document.AddBookmarkColloquiumForm.submit();
	//window.parent.closeWindow();
}

$(document).ready(function() {

	$("input#tagsInput").autocomplete("../utils/tags.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {			
				return  value;
					
			},
			formatResult: function(data, value) {
				return value;
			}
	});
});
</script>

<style>
	input.btn { 
	    color:#003399; 
	    font: bold 0.7em verdana,helvetica,sans-serif; 
	    background-color: #99CCFF; 
	    margin: 0 10px;
	    border: 2px solid; 
	    border-color: #0066CC #003366 #003366 #0066CC; 
	    filter:progid:DXImageTransform.Microsoft.Gradient (GradientType=0,StartColorStr='#ffffffff',EndColorStr='#ffeeddaa'); 
	}
	div.tags {float: left; background-color: #0080ff; margin-left:6px;  margin-bottom: 4px; font-size: 13px}
	.buttons {line-height:26px; float:right; margin: 15px 20px; } 
	
</style>
<%
	String col_id = (String)request.getParameter("col_id");

%>
<form name= "form1" method= "post" action= " " >
								
								<table cellspacing="0" cellpadding="10px" width="100%" align="center">
									<tr>
										<td width="20%" style="font-size: 13px;font-weight: bold;">Your Tags:</td>
										<td>
											
											<b id="myTags">								
											
											</b>
											<!--
											<input type="hidden" name="col_id" value="<%=col_id%>" /><span style="font-size: 13px;font-weight: bold;">(Separate by white space)</span>&nbsp;<input type="submit" class="btn" value="Bookmark" />--> 
										</td>
									</tr>
									<tr>
										<td width="20%" ></td>
										<td>
											
											<input style="font-size: 13px;" id="tagsInput" type="text" name="tagsInput" size="50"/> 
											<input id="addTag" class="btn" type= "button"  value="Add" onClick=insert(document.form1.tagsInput.value) /></td>
									</tr>
									<%
										String content = new String();
										try
										{
											String key = "0494dda81af7f0b4c28c93401dd0326845df8d91";
											String alchemyURL = "http://access.alchemyapi.com/calls/url/URLGetRankedConcepts?apikey=" + key +"&url=" + "http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=" + col_id;
																					
											URL rootPage = new URL(alchemyURL);			  
											BufferedReader reader = new BufferedReader(new InputStreamReader(rootPage.openStream()));
																		
											String line = new String();
											while((line = reader.readLine()) != null)
												content += line;
																							
										
										}
									 	catch(IOException e){
											e.printStackTrace();
									 	}
									 	
									 	

									%>
									<tr>
										<td width="20%" ></td>
										<td style="font-size: 13px">
											<b>Click to Add: </b>
										 <%
										 	int beginIndex = 0, endIndex = 0;
											
											while ((beginIndex = content.indexOf("<concept>", beginIndex))!=-1){
												beginIndex = content.indexOf("<text>", beginIndex);
												beginIndex += "<text>".length();
												endIndex = content.indexOf("</text>", beginIndex);
												String concept = content.substring(beginIndex, endIndex).trim();
												
												
										 %>
										 			<a id="<%= concept %>" href="javascript:void(0)" onclick="insert('<%= concept %>')"><%= concept %></a>&nbsp;   
										<% 
											}
										%>
									
										</td>
									</tr>
									</table>
									</form>
							<html:form action="/postQuickBookmark">	
														
									<table cellspacing="0" cellpadding="10px" width="100%" align="center">
									
									<tr>
										<td valign="top" style="font-size: 13px;font-weight: bold;">Notes:</td>
										<td style="font-size: 13px;"><textarea name="note" cols="45" rows="5"></textarea></td>
									</tr>
									<tr>
										<td width="20%" valign="top" style="font-size: 13px;font-weight: bold;">Post to:</td>
										<td>
											<table cellspacing="0" cellpadding="0" width="100%" align="center" >
<% 
			String sql = "SELECT comm_id,comm_name FROM community ORDER BY comm_name";
			connectDB conn = new connectDB();
			ResultSet rs = conn.getResultSet(sql);
			int row = 0;
			while(rs.next()){
				if(row%3==0){
%>
												<tr>
<%			
				}
				String checked = "";
				
%>
													<td style="font-size: 13px;" valign="top">
														<input type="checkbox" name="selectedCommunities" <%=checked%> value="<%=rs.getString("comm_id")%>" />
															&nbsp;<span style="font-size: 13px;"><%=rs.getString("comm_name")%></span>
													</td>
<%						
				if(row%3==2){
%>
												</tr>
<%			
				}
				row++;
			}
			if(row > 0 && row%3 != 2){
%>
													<td colspan="<%=(3-row%3)%>" style="font-size: 13px;">&nbsp;</td>
												</tr>

<%		
			}
%>										
											</table>
										</td>
									</tr>
<%-- 
									<tr>
										<td colspan="3"><input type="submit" class="btn" value="Bookmark" /></td>
									</tr>
--%>
								</table>
				<div class='buttons'>
					<input type="hidden" name="tags" >
											<input type="hidden" name="col_id" value="<%=col_id%>" />
											<input type="button" class="btn" id="bookmarkBtn" onclick="submitForm()" value="Bookmark" />
											<input type="button" class="btn" onclick="window.parent.closeWindow()" value = "Cancel" />
				</div>
				<table cellspacing="0" cellpadding="0" width="100%" align="center">
									<tr>
										<td width="20%"></td>
										<td>
											
										</td>
									</tr>
									</table>							
			</html:form>
			