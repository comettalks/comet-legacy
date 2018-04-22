<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">Refine Your Search Result</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
			Time
		</td>
	</tr>
	<tr>
		<td align="center" style="border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="5" cellpadding="0" width="100%" align="center">
				<tr>
					<td style="font-size: 0.85em;">
<%
		if ((beginIndex = content.indexOf("<lst name=\"facet_queries\">", beginIndex)) != -1){
			beginIndex += "<lst name=\"facet_queries\">".length();
			endIndex = content.indexOf("</lst>", beginIndex);
			String dateStr = content.substring(beginIndex, endIndex);
			
			int dateBegin =0, dateEnd = 0;
			int i = 0;
			while((dateBegin = dateStr.indexOf("<int name=\"", dateBegin)) != -1){
				
				String dateLabel = new String();
				i++;
				switch (i){
					case 1:  dateLabel = "Past 3 months"; 	break;
					case 2:  dateLabel = "Past 1 month"; 	break;
					case 3:  dateLabel = "Past 1 week"; 	break;
					case 4:  dateLabel = "Future 1 week"; 	break;
					case 5:  dateLabel = "Future 1 month"; 	break;
					case 6:  dateLabel = "Future 3 months"; break;
					
				}
				
				dateBegin+= "<int name=\"".length();
				dateEnd = dateStr.indexOf("\">", dateBegin);
				String dateRange = dateStr.substring(dateBegin, dateEnd);
				
				dateBegin = dateEnd + 2;
				dateEnd = dateStr.indexOf("</int>", dateBegin);

				String dateNum = dateStr.substring(dateBegin, dateEnd);
				
				if (!dateNum.equals("0")){
					String dateURL = "searchResult.do?&s_opt=" + option + "&sortBy=" + sortBy + "&search_text=" + query + "+AND+" + URLEncoder.encode(dateRange,"UTF-8");
					
%>
					<a style ="color: #36C" href="<%=dateURL%>"><%= dateLabel %></a> &nbsp;(<%= dateNum %>)<br/>
<%
				}
				else{
%>
					<a><%= dateLabel %></a>&nbsp;(<%= dateNum %>)<br/>
<% 
				}
					
			}
		}
		beginIndex = temp;
%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
			Video
		</td>
	</tr>
	<tr>
		<td align="center" style="border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="5" cellpadding="0" width="100%" align="center">
				<tr>
					<td style="font-size: 0.85em;">
<%
		if ((beginIndex = content.indexOf("<lst name=\"video\">", beginIndex)) != -1){
			
			beginIndex += "<lst name=\"video\">".length();
			endIndex = content.indexOf("</lst>", beginIndex);
			String videoStr = content.substring(beginIndex, endIndex);
			int videoBegin =0, videoEnd = 0, numVideo = 0;
			String videoURL = new String();
			while((videoBegin = videoStr.indexOf("<int name=\"", videoBegin)) != -1){
				videoBegin+= "<int name=\"".length();
				videoEnd = videoStr.indexOf("\">", videoBegin);
				String curVideo = videoStr.substring(videoBegin, videoEnd);
				if (!curVideo.equals("")){
					videoURL +=  URLEncoder.encode("\"" + curVideo + "\"","UTF-8") + "+";
					numVideo++;

				}
			}
			videoURL = "searchResult.do?&s_opt=" + option + "&sortBy=" + sortBy + "&search_text=" + query + "+AND+video:(" + videoURL + ")";
			if(numVideo > 0){
%>
						<a style ="color: #36C" href="<%=videoURL%>"><%= numVideo %> video<%=numVideo>1?"s":"" %></a>
<% 
			}else{
%>
						<%= numVideo %> video<%=numVideo>1?"s":"" %>
<% 
			}
			
				
		}
		beginIndex = temp;
%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
			Slide
		</td>
	</tr>
	<tr>
		<td align="center" style="border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="5" cellpadding="0" width="100%" align="center">
				<tr>
					<td style="font-size: 0.85em;">
<%
		if ((beginIndex = content.indexOf("<lst name=\"slide\">", beginIndex)) != -1){
			
			beginIndex += "<lst name=\"slide\">".length();
			endIndex = content.indexOf("</lst>", beginIndex);
			String slideStr = content.substring(beginIndex, endIndex);
			int slideBegin =0, slideEnd = 0, numSlide = 0;
			String slideURL = new String();
			while((slideBegin = slideStr.indexOf("<int name=\"", slideBegin)) != -1){
				slideBegin+= "<int name=\"".length();
				slideEnd = slideStr.indexOf("\">", slideBegin);
				String curSlide = slideStr.substring(slideBegin, slideEnd);
				if (!curSlide.equals("")){
					slideURL +=  URLEncoder.encode("\"" + curSlide + "\"","UTF-8") + "+";
					numSlide++;

				}
			
			}
			slideURL = "searchResult.do?&s_opt=" + option +  "&sortBy=" + sortBy +"&search_text=" + query + "+AND+slide:(" + slideURL + ")";	
			if(numSlide > 0){
%>
						<a style ="color: #36C" href="<%=slideURL%>"><%= numSlide %> slide<%=numSlide>0?"s":"" %></a>
<% 
			}else{
%>
						<%= numSlide %> slide<%=numSlide>0?"s":"" %>
<% 
			}
		}
		beginIndex = temp;
%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
			Sponsor
		</td>
	</tr>
	<tr>
		<td align="center" style="border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="5" cellpadding="0" width="100%" align="center">
				<tr>
					<td style="font-size: 0.85em;">
<%
		if ((beginIndex = content.indexOf("<lst name=\"sponsor_str\">", beginIndex)) != -1){
			
			beginIndex += "<lst name=\"sponsor_str\">".length();
			endIndex = content.indexOf("</lst>", beginIndex);
			String sponsorStr = content.substring(beginIndex, endIndex);
			int sponBegin =0, sponEnd = 0;
			while((sponBegin = sponsorStr.indexOf("<int name=\"", sponBegin)) != -1){
				sponBegin+= "<int name=\"".length();
				sponEnd = sponsorStr.indexOf("\">", sponBegin);
				String curSponsor = sponsorStr.substring(sponBegin, sponEnd);
				String sponsorURL = "searchResult.do?&s_opt=" + option +  "&sortBy=" + sortBy + "&search_text=" + query + "+AND+sponsor_str:" + URLEncoder.encode("\"" + curSponsor + "\"","UTF-8");
%>
	
				<a style ="color: #36C" href="<%=sponsorURL%>"><%= curSponsor %></a>
<% 
				sponBegin = sponEnd+2;
				sponEnd = sponsorStr.indexOf("</int>", sponBegin);
%>
	(<%= sponsorStr.substring(sponBegin, sponEnd) %>)<br/>

<% 
			}
				
		}
		beginIndex = temp;

%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>