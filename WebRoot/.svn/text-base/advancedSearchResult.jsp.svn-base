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
<%@page import="java.net.*"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<%
	String titlePra, detailPra, speakerPra, frmYear, frmMonth, frmDay, toYear, toMonth, toDay;
	String query;
	
	if ((query = (String)request.getParameter("search_text")) == null){
		query = new String();
		if ((String)request.getParameter("title")!= null){
			if ((titlePra = (String)request.getParameter("title"))!= ""){
				titlePra = titlePra.replaceAll("\\<.*?>"," ").replaceAll("\\."," ").replaceAll(":"," ").trim();
				String[] term = titlePra.split("\\s+");
				if(term != null){
					query += "title%3A%28";
					for(int i=0;i<term.length;i++){
						if(i != 0){
							query += "+";
						}
						query += URLEncoder.encode(term[i],"UTF-8");
					}
					query += "%29+AND+";
				}
				//query += "title%3A%28" + titlePra + "%29+AND+";
			}
		}
		if ((String)request.getParameter("detail")!= null){
			if ((detailPra= (String)request.getParameter("detail"))!= ""){
				//System.out.println(detailPra);
				detailPra = detailPra.replaceAll("\\<.*?>"," ").replaceAll("\\."," ").replaceAll(":"," ").trim();
				String[] term = detailPra.split("\\s+");
				if(term != null){
					query += "detail%3A%28";
					for(int i=0;i<term.length;i++){
						if(i != 0){
							query += "+";
						}
						query += URLEncoder.encode(term[i],"UTF-8");
					}
					query += "%29+AND+";
				}
				//query += "detail%3A%28" + detailPra + "%29+AND+";
			}
		}
		if ((String)request.getParameter("speaker")!= null){
			if ((speakerPra= (String)request.getParameter("speaker"))!= ""){
				speakerPra = speakerPra.replaceAll("\\<.*?>"," ").replaceAll("\\."," ").replaceAll(":"," ").trim();
				String[] term = speakerPra.split("\\s+");
				if(term != null){
					query += "speaker_name%3A%28";
					for(int i=0;i<term.length;i++){
						if(i != 0){
							query += "+";
						}
						query += URLEncoder.encode(term[i],"UTF-8");
					}
					query += "%29+AND+";
				}
				//query += "speaker_name%3A%28" + speakerPra + "%29+AND+";
			}
		}
		if ((String)request.getParameter("frmYear") != null){
			if ((frmYear= (String)request.getParameter("frmYear").trim()) != ""){
				if ((frmMonth = (String)request.getParameter("frmMonth").trim()) == "")
					frmMonth = "01";	
				if ((frmDay= (String)request.getParameter("frmDay").trim()) == "")
					frmDay = "01";
				toYear= (String)request.getParameter("toYear");
				if ((toMonth = (String)request.getParameter("toMonth").trim()) == "")
					toMonth = "01";	
				if ((toDay= (String)request.getParameter("toDay").trim()) == "")
					toDay = "01";
				query += "date%3A+[" + frmYear + "-" + frmMonth + "-" + frmDay + "T00:00:00Z%20TO%20"  + toYear + "-" + toMonth + "-" + toDay + "T00:00:00Z]+AND+";
			}
		}
		query = query.substring(0, query.length() - 5);
		//query = URLEncoder.encode(query,"UTF-8");
	}
	else{
		query = URLEncoder.encode(query,"UTF-8");
		if (!(query.startsWith("%28") && query.endsWith("%29") )){
			query = "%28" + query + "%29";
		}
	}
	int sortBy = Integer.parseInt(request.getParameter("sortBy")) ;
	String sort = new String();
	switch (sortBy){
		case 1: sort = "score+desc"; break;
		case 2: sort = "date+desc"; break;
		case 3: sort = "date+asc"; break;
		case 4: sort = "comets+desc"; break;
		case 5: sort = "comets+asc"; break;
		case 6: sort = "bookmark_no+desc"; break;
		case 7: sort = "bookmark_no+asc"; break;
		case 8: sort = "email_no+desc"; break;
		case 9: sort = "email_no+asc"; break;
		case 10: sort = "view_no+desc"; break;
		case 11: sort = "view_no+asc"; break;
		
	}

	//out.println(query + "<br/>");
	query = query.replaceAll("\\s+", "+");
	String cur, start;
	int curPage = 1, startDoc = 0;
	
	if ((cur= (String)request.getParameter("pageNum"))!= null){
		curPage = Integer.parseInt(cur);
	}
	
	if ((start = (String)request.getParameter("start"))!= null){
		startDoc = Integer.parseInt(start);
	}
	

	String content = new String();
	try
	{
		String url = "http://halley.exp.sis.pitt.edu/solr/db/select/?q=" + query + 
				"&version=2.2&start=" + startDoc + "&rows=10&indent=on&sort=" + sort + 
				"&facet=true&facet.field=video&facet.field=slide&facet.field=sponsor_str&facet.field=date&facet.mincount=1" +
				"&facet.query=date:[NOW-3MONTHS%20TO%20NOW]&facet.query=date:[NOW-1MONTHS%20TO%20NOW]&facet.query=date:[NOW-30DAYS%20TO%20NOW]&facet.query=date:[NOW%20TO%20NOW%2B30DAYS]&facet.query=date:[NOW%20TO%20NOW%2B1MONTHS]&facet.query=date:[NOW%20TO%20NOW%2B3MONTHS]";
		//out.println(url + "<br/>");
		
		URL rootPage = new URL(url);			  
		BufferedReader reader = new BufferedReader(new InputStreamReader(rootPage.openStream()));
			
		String line = new String();
		while((line = reader.readLine()) != null)
			content += line;
		
	}		
	catch(IOException e){
		e.printStackTrace();
    }
	
%>

<table border="0" width="100%" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="70%" valign="top">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="font-family: arial, Verdana, sans-serif, serif;font-size: 12px;">
	<%
		
		int beginIndex = 0, endIndex = 0;
		beginIndex = content.indexOf("<result name=\"response\" numFound=\"", beginIndex);
		beginIndex += "<result name=\"response\" numFound=\"".length();
		endIndex = content.indexOf("\"", beginIndex);
		int num = Integer.parseInt( content.substring(beginIndex, endIndex));
		int temp = 0;
		ArrayList<Long> colList = new ArrayList<Long>();
		if (num <= 0){
	%>
		<tr>
			<td><b>Your search did not match any document.</b> </td>
		</tr>
	</table>
</td>
</tr>
</table>
	<% 
		}
		else{
			while ((beginIndex = content.indexOf("<doc>", beginIndex))!=-1){
				
				beginIndex = content.indexOf("<str name=\"col_id\">", beginIndex);
				beginIndex += "<str name=\"col_id\">".length();
				endIndex = content.indexOf("</str>", beginIndex);
				String col_id = content.substring(beginIndex, endIndex);
				String paperPath = "presentColloquium.do?col_id=" + col_id;
	
				colList.add(Long.parseLong(col_id));		
				temp = beginIndex;
		
			}
			session.setAttribute("searchResultList", colList);
			session.setAttribute("menu","nothing");
			beginIndex = temp;
%>
		<tr>
			<td>
			<form action="advancedSearchResult.do" >
				<input type="hidden" name="search_text" value='<%= URLDecoder.decode(query, "UTF-8")  %>' />
				<input type="hidden" name="start" value=<%= startDoc %> />
				<input type="hidden" name="pageNum" value=<%= curPage %> />
				&nbsp;&nbsp;&nbsp; Sort by
				<select name= "sortBy" onchange="this.form.submit();">  	
	            <%
	            	if (request.getParameter("sortBy").equals("1")){ 
	            	
	            %>      					 
    					<option   value= "1" selected > Relevance </option> 
    			<%
	            	}
	            	else{
    			%>
    					<option value= "1"  > Relevance </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("2")){ 
	            	
	            %>      					 
    					<option   value= "2" selected> Date: Descending </option> 
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "2"  > Date: Descending </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("3")){ 
	            	
	            %>      					 
    					<option   value= "3" selected> Date: Ascending </option> 
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "3"> Date: Ascending </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("4")){ 
	            	
	            %>      					 
    					<option   value= "4" selected > Comets Score: Descending </option> 
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "4"> Comets Score: Descending </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("5")){ 
	            	
	            %>      					 
    					<option   value= "5" selected > Comets Score: Ascending </option>
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "5"> Comets Score: Ascending </option>
    						
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("6")){ 
	            	
	            %>      					 
    					<option   value= "6" selected > Number of Bookmarks: Descending </option> 
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "6"> Number of Bookmarks: Descending </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("7")){ 
	            	
	            %>      					 
    					<option   value= "7" selected > Number of Bookmarks: Ascending </option>
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "7"> Number of Bookmarks: Ascending </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("8")){ 
	            	
	            %>      					 
    					<option   value= "8" selected > Number of emails: Descending </option>
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "8"> Number of emails: Descending </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("9")){ 
	            	
	            %>      					 
    					<option   value= "9" selected > Number of emails: Ascending </option>
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "9"> Number of emails: Ascending </option>
    					<%
	            	}
	            	if (request.getParameter("sortBy").equals("10")){ 
	            	
	            %>      					 
    					<option   value= "10" selected > Number of views: Descending </option>
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "10"> Number of views: Descending </option>
    			<%
	            	}
	            	if (request.getParameter("sortBy").equals("11")){ 
	            	
	            %>      					 
    					<option   value= "11" selected > Number of views: Ascending </option>
    			<%
	            	}
	            	else{
    			%>
    					<option   value= "11"> Number of views: Ascending </option>
    			<%  } %>	
				</select> 
				
			</form>
			</td>
		</tr>
		<tr>
						<td>
							<tiles:insert template="/utils/loadTalks.jsp?searchResult=1"/>
						</td>
		</tr>
	</table>
</td>
<td valign="top">
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
					String dateURL = "advancedSearchResult.do?sortBy=" + sortBy + "&search_text=" + query + "+AND+" + URLEncoder.encode(dateRange,"UTF-8");
					
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
			videoURL = "advancedSearchResult.do?sortBy=" + sortBy + "&search_text=" + query + "+AND+video:(" + videoURL + ")";
			
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
			slideURL = "advancedSearchResult.do?sortBy=" + sortBy + "&search_text=" + query + "+AND+slide:(" + slideURL + ")";	
			if(numSlide > 0){
%>
							<a style ="color: #36C" href="<%=slideURL%>"><%= numSlide %> slide<%=numSlide>1?"s":"" %></a>
<% 
			}else{
%>
							<%= numSlide %> slide<%=numSlide>1?"s":"" %>
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
				String sponsorURL = "advancedSearchResult.do?sortBy=" + sortBy + "&search_text=" + query + "+AND+sponsor_str:" + URLEncoder.encode("\"" + curSponsor + "\"","UTF-8");
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
	
</td>
</tr>
	
</table>
<%
	if (num > 10){
%>
<div   align=center > 		
<table style="text-align: center" cellpadding="4">
	<tr>
<%
		int startPage = 1, endPage = curPage+5;
		if (curPage - 4 >= 1)
			startPage = curPage - 4;
		if (endPage > num/10+1)
			endPage = num/10+1;
		if (curPage != 1){
			String url = "advancedSearchResult.do?sortBy=" + sortBy + "&pageNum=" + (curPage+1) + "&search_text=" + query + "&start=" + startDoc;

%>
			<td><a style ="color: #2200C1; margin-right:25px; font-weight: bold; " href="<%= url %>"> Previous </a> </td>
<% 
		}
		for(int i = startPage; i <= endPage && num%10!=0; i++){
			startDoc = (i-1)*10;		
			if (curPage == i){
%>
				<td><b><%= curPage %></b> </td>
<% 
			}
			else{
				String url = "advancedSearchResult.do?sortBy=" + sortBy + "&pageNum=" + i + "&search_text=" + query + "&start=" + startDoc;
				
%>	
				<td><a style ="text-decoration: none; color: #36C" href="<%= url %>"><%= i %> </a></td>
<%				
			}
		}
		if (curPage != num/10+1){
			String url = "advancedSearchResult.do?sortBy=" + sortBy + "&pageNum=" + (curPage-1) + "&search_text=" + query + "&start=" + startDoc;

%>
			<td><a style ="color: #2200C1; margin-left:25px; font-weight: bold" href="<%= url %>">Next </a> </td>

	<%	} %>
	</tr>
</table>

</div>
<%
	}
}
%>
	
	


	