<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.TreeMap"%>
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
<%@page import="edu.pitt.sis.ExternalProfile"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<%

	
%>

<table border="0" width="100%" align="center" cellpadding="0" cellspacing="0" style="font-size:0.9em;">
<tr>
<td width="70%" valign="top">
	<table border="0" width="100%" cellpadding="0" cellspacing="0" style="font-family: arial, Verdana, sans-serif, serif;font-size:0.9em;">
<% 
			ExternalProfile externalProfile = new ExternalProfile();
			externalProfile.connectDB();
			
			UserBean ub = (UserBean)session.getAttribute("UserSession");
			long my_id =  ub.getUserID();
			
			ArrayList<Long> colList = new ArrayList<Long>();
		
			String speakLink;
			String speakerName;
			ArrayList<Long> speakerTalks  = new ArrayList<Long>();
			TreeMap<String,ArrayList<Long>> friendTalks=  new TreeMap<String,ArrayList<Long>>();
			Hashtable<String,int[]> newOldTalks = new Hashtable<String,int[]>();
	
	
			int totalTalks=0,oldTalkSize=0,newTalkSize=0;
			if(session.getAttribute("allFriendsTalks") == null)
			{
				friendTalks = externalProfile.getFriendsWithTalk(my_id);
			//	newOldTalks = externalProfile.newOldTalks;
				session.setAttribute("allFriendsTalks",friendTalks);
			//	session.setAttribute("newOldTalksSize",newOldTalks);
				totalTalks = externalProfile.totalFriendsTalks;
			//	oldTalkSize = externalProfile.oldTalks;
			//	newTalkSize = externalProfile.newTalks;
			//	session.setAttribute("oldTalkSize",oldTalkSize);
			//	session.setAttribute("newTalkSize",newTalkSize);
				session.setAttribute("allFriendsTalksSize",totalTalks);
				
			}else
			{
				friendTalks = (TreeMap<String,ArrayList<Long>>)session.getAttribute("allFriendsTalks");
			//	newOldTalks = (Hashtable<String,int[]>)session.getAttribute("newOldTalksSize");
				totalTalks = (Integer)session.getAttribute("allFriendsTalksSize");
			//	oldTalkSize = (Integer)session.getAttribute("oldTalkSize");
			//	newTalkSize =(Integer)session.getAttribute("newTalkSize");
				
			}
			
			
			
			int start = Integer.parseInt(request.getParameter("start"));
			int end = Integer.parseInt(request.getParameter("end"));
			int length = end - start +1;
			
			String tempName;
			String talkTag = "talk";
			if(totalTalks == 1) 
					talkTag = totalTalks + " talk";
			else
					talkTag = totalTalks  + " talks";
			String target = request.getParameter("speaker") == null? "":(String)request.getParameter("speaker");
			
			int index = 0;
			String speakerListItem = "<a id='ShowALL' href=\"javascript:void(0);\" class=\"enable\" onClick=\"loadSingleFriendTalks('ShowALL','ShowALL',1,"+length+",'none')\">Show ALL ("+talkTag+")</a>";
			
			int oldSize=0,newSize=0;
			StringBuffer speakerList = new StringBuffer();
			speakerList.append(speakerListItem);
		/*	
			if(newTalkSize>0)
				speakerList.append("&nbsp<a id='ShowALLNew' href=\"javascript:void(0);\" class=\"enable\" onClick=\"loadSingleFriendTalks('ShowALLNew','ShowALL',1,"+length+",'new')\">new("+newTalkSize+")</a>");
			if(oldTalkSize>0)
			speakerList.append("&nbsp<a id='ShowALLOld' href=\"javascript:void(0);\" class=\"enable\" onClick=\"loadSingleFriendTalks('ShowALLOld','ShowALL',1,"+length+",'old')\">old("+oldTalkSize+")</a>");
		*/	
			speakerList.append("<br/>");
			
			
		//	String changePageSize = request.getParameter("changePageSize") == null? "":(String)request.getParameter("changePageSize");
			
			//if(session.getAttribute("colList") == null || target.equals("ShowALL") || changePageSize.length()>0)
		//	{
				for(Iterator<String> it = friendTalks.keySet().iterator();it.hasNext();)
				{
						
						speakerName = it.next().trim();
						
						
						
					//	tempName = speakerName;
					//	tempName = "\""+tempName.trim().replaceAll(" ", "+")+"\"";
						//speakLink = "advancedSearchResult.do?title=&detail=&speaker="+tempName+"&frmYear=&frmMonth=&frmDay=&toYear=&toMonth=&toDay=&sortBy=1";
						
						//speakerList += "<a href='"+speakLink+"' target='blank'>"+speakerName+" ("+speakerTalks.size()+" talks)</a><br/>";
						
						//Filter for name
						
						speakerTalks = friendTalks.get(speakerName);
					/*	
						if(newOldTalks.containsKey(speakerName))
						{
						
						newSize = newOldTalks.get(speakerName)[0];
						oldSize = newOldTalks.get(speakerName)[1];
						}
					*/	
						if(speakerTalks.size() == 0)
							continue;
						else if(speakerTalks.size() == 1)
							talkTag = "talk";
						else
							talkTag = "talks";
							
						speakerList.append("<a id='"+speakerName+"' href=\"javascript:void(0);\" class=\"enable\" onClick=\"loadSingleFriendTalks('"+speakerName+"','"+speakerName+"',1,"+length+",'none')\">"+speakerName+" ("+speakerTalks.size()+" "+talkTag+")</a>"); 
			/*			if(newSize > 0)
							speakerList.append("&nbsp<a id='"+speakerName+"New' href=\"javascript:void(0);\" class=\"enable\" onClick=\"loadSingleFriendTalks('"+speakerName+"New','"+speakerName+"',1,"+length+",'new')\">new("+newSize+")</a>"); 
						if(oldSize > 0)
							speakerList.append("&nbsp<a id='"+speakerName+"Old' href=\"javascript:void(0);\" class=\"enable\" onClick=\"loadSingleFriendTalks('"+speakerName+"Old','"+speakerName+"',1,"+length+",'old')\">old("+oldSize+")</a>"); 
				*/		speakerList.append("<br/>");
						
					
					//	colList.addAll(speakerTalks);
					
						for(Long id: speakerTalks)
						{
						
							colList.add(id);
						}
					
					}
				
				
				
				//session.setAttribute("speakerList", speakerList.toString());
				//session.setAttribute("colList", colList);
				
			/*}else
			{
					colList = (ArrayList<Long>)session.getAttribute("colList");
					speakerList.setLength(0);
					speakerList.append((String)session.getAttribute("speakerList"));
				
			}*/
			
			if(target.trim().length()>0 && friendTalks.containsKey(target))
			{
				speakerTalks = friendTalks.get(target);
				totalTalks = speakerTalks.size();
				colList.clear();
				for(long col_id: speakerTalks)
				{
					
					colList.add(col_id);
				}
				
				
			}
			
			String oldNewTalk = request.getParameter("oldNew") == null? "":(String)request.getParameter("oldNew");
			if(oldNewTalk.equals("old"))
			{
				session.setAttribute("newOldTalks","oldTalks");
			}else if(oldNewTalk.equals("new"))
			{
				session.setAttribute("newOldTalks","newTalks");
			}else
			{
				session.setAttribute("newOldTalks","");
			}
			
			totalTalks = colList.size();
			
			session.setAttribute("searchResultList",colList);
			session.setAttribute("SortByTime", "true");
			session.setAttribute("menu","nothing");
			session.setAttribute("startIndex",start);
			session.setAttribute("endIndex",end);
			
			if(colList.size() > 0)
			{
			
		
			
			
		%>
		
		<tr>
						<td id="talkListsTd" style="font-size:0.9em;">
							<tiles:insert template="/utils/loadTalks.jsp?searchResult=1"/>
						</td>
		</tr>
		
		<%
			}else
			{
		%>	
				<tr>
						<td>
							No talks
						</td>
				</tr>
		<%
			}
		
		 %>
	</table>
</td>
<td valign="top">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" style="font-size:0.9em;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 1em;font-weight: bold;">Friends have talks in CoMeT</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					
					<td>
					
					<%=speakerList.toString()%>
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
</table>
<input type="hidden" id="totalSizeFT" value="<%=totalTalks%>"/>
<input type="hidden" id="newSizeFT" value="<%=totalTalks%>"/>
<input type="hidden" id="oldSizeFT" value="<%=totalTalks%>"/>
	<%
		
		externalProfile.conn.close();
		externalProfile.conn = null;
	 %>


	