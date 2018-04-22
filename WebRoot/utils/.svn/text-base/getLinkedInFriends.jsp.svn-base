<%@ page language="java"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.ExternalProfile"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.ListIterator"%> 
<%@page import="java.util.HashSet"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	String comfacConnection, comLinkedConnection, connection, comet_url, fuid,fname, fprofile_url, fpic_small_with_logo, fheadline,luid, lname, lprofile_url, lpic_small_with_logo, lheadLine, cname, caffiliation, cinterest = "";
	int userId, externalID, cid = -1;
	LinkedHashMap<Integer, Integer> linkedInFriends = new LinkedHashMap<Integer, Integer>();
	//Friends in linkedIn not in Comet
	LinkedList<Integer> linkedInUsers = new LinkedList<Integer>();
	
	Hashtable<String,Integer> linkedInFriendsName = new Hashtable<String,Integer>();
	Hashtable<String,Integer> linkedInUsersName = new Hashtable<String,Integer>();
	Hashtable<String,LinkedList<Integer>> locationliFriends = new Hashtable<String,LinkedList<Integer>>();
	Hashtable<String,LinkedList<Integer>> locationliUsers = new Hashtable<String,LinkedList<Integer>>();
	
	
	connectDB conn = new connectDB();
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	long my_id =  ub.getUserID();
	//long my_id =  1;
	
	

	ExternalProfile externalProfile = new ExternalProfile();
	externalProfile.conn = conn.conn;
	
	
	//Get external profile ID and table from linkedin
	int lExternalID = externalProfile.getExternalID(my_id, "linkedin");


	//Get linkedIn friend list also in Comet
	if(session.getAttribute("linkedInFriends") == null)
	{
		externalProfile.getFriendList(lExternalID,
			"extprofile.vwLinkedInConnection");
			
		linkedInFriends = externalProfile.linkedInFriends;
		linkedInFriendsName = externalProfile.linkedInFriendsName;
		linkedInUsersName = externalProfile.linkedInUsersName;
		locationliFriends = externalProfile.locationliFriends;
		locationliUsers = externalProfile.locationliUsers;
		
		session.setAttribute("linkedInFriends",linkedInFriends);
		session.setAttribute("linkedInFriendsName",linkedInFriendsName);
		session.setAttribute("linkedInUsersName",linkedInUsersName);
		session.setAttribute("locationliFriends",locationliFriends);
		session.setAttribute("locationliUsers",locationliUsers);
		
	}else
	{
	
		linkedInFriends = (LinkedHashMap<Integer,Integer>)session.getAttribute("linkedInFriends");
		linkedInFriendsName = (Hashtable<String,Integer>)session.getAttribute("linkedInFriendsName");
		linkedInUsersName = (Hashtable<String,Integer>)session.getAttribute("linkedInUsersName");
		locationliFriends = (Hashtable<String,LinkedList<Integer>>)session.getAttribute("locationliFriends");;
		locationliUsers = (Hashtable<String,LinkedList<Integer>>)session.getAttribute("locationliUsers");;
	
	
	}
	
	
	
	


	//Get friends from linkedin
	int start = request.getParameter("start") == null ? 0: Integer.valueOf(request.getParameter("start"));
	
	int size = linkedInFriends.size();
	int end = request.getParameter("end") == null ? size: Integer.valueOf(request.getParameter("end"));
	
	String target = request.getParameter("target") == null ? "": (String)request.getParameter("target");
	Boolean linkedInFriendSingle = false;
	Boolean linkedInUserSingle = false;
	int linkedInFriendSingleUId=-1;
	int linkedInUserSingleExtid = -1;
	if(linkedInFriendsName.containsKey(target))
	{
		linkedInFriendSingle = true;
		linkedInFriendSingleUId = linkedInFriendsName.get(target);
	}else
	{
		linkedInFriendSingle = false;
		linkedInFriendSingleUId = -1;
	}
	
	if(linkedInUsersName.containsKey(target))
	{
		linkedInUserSingle = true;
		linkedInUserSingleExtid = linkedInUsersName.get(target);
	}else
	{
		linkedInUserSingle = false;
		linkedInUserSingleExtid = -1;
	}
	
	
	//Search for location
	String location = request.getParameter("location") == null ? "": (String)request.getParameter("location").toLowerCase();
	
	Boolean locationSearch=false;
	if(location.length() > 0 && !location.equals("all"))
	{
		locationSearch=  true;
		
	}
	
	Set<Integer> setL = linkedInFriends.keySet();
	Iterator iteL = setL.iterator();
	
	//If location found, change set
	if(locationSearch)
	{
		LinkedList<Integer> sets = new LinkedList<Integer>();
		sets = locationliFriends.get(location);
		if(sets == null)
		{
			size = 0;
			iteL = new LinkedList<Integer>().listIterator();
			
			
		}
		else
		{
			size = sets.size();
			iteL = sets.iterator();
		}
	}
	
	
	int index = 1;
	String divIDL = "";
	String divRIDL="";
	String spanIDL="";
	String lpicHTML="";
	String connectionL="";
	String sql="";
	ResultSet rs;
	String speakerLink="";
	String picHTML="";
	if(size > 0)
	{
	

//Users in Comet
	while (iteL.hasNext()) {
	if(linkedInUserSingle)
		break;
		
	if( index==1)
		{
		%>
			<table cellspacing="0" cellpadding="0" width="100%" align="center" border="1" style="font-size:0.9em;" bordercolor="#003399">
			
			<tr>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">CoMeT Profile</span></th>
				<th bgcolor="#003399" width="60%"><span style="color:#ffffff">LinkedIn Profile</span></th>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">Friend in CoMeT</span></th>
			</tr>
		
		
		
		<%
		
		}
	
		if(index < start)
		{
			index++;
			userId = (Integer) iteL.next();
			continue;
		}
		
		divIDL = "divAddFriendL" + index;
		divRIDL = "divResFriendL" + index;
		spanIDL = "spanAddAsFriendL" + index;
		
		userId = (Integer) iteL.next();
		if(linkedInFriendSingle)
			userId = linkedInFriendSingleUId;
		//divIDL = "divAddFriendF" + userId;
		//spanIDL = "spanAddAsFriendF"+userId;
		externalID = linkedInFriends.get(userId);
		externalProfile.getLinkedInProfileInfo(externalID);
		if(externalProfile.lname == null)
			continue;
			
		lname = externalProfile.lname;
		
		
		
		System.out.println("Link  in comet:" +externalID);

		//Whether they are friends in Comet
		comLinkedConnection = externalProfile.connectionStatus(my_id,
				userId);
				Boolean isNotNow = false;
		if (comLinkedConnection.equals("Connected")) {
			connectionL = "You are friends in CoMeT too!";
		} else if (comLinkedConnection.equals("No")) {
			sql = "SELECT request_id,notnowtime FROM request WHERE requester_id=" + userId + " AND target_id=" + my_id + " AND accepttime IS NULL AND rejecttime IS NULL AND droprequesttime IS NULL ORDER BY requesttime DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			
			if(rs.next()){
					String request_id = rs.getString("request_id");
					if(rs.getString("notnowtime")!=null){
									isNotNow = true;
								}
					connectionL = "<input class =\"btn\" type=\"button\" id=\"btnRespondRequest\" value=\"Respond to Friend Request\" onclick=\"showAddFriendDialog("+ divRIDL + ");return false;\" />";
					
					
			}else{

					connectionL = "<input class =\"btn\" type=\"button\" id=\"btnAddAsFriend\" value=\"Connect in CoMeT\" onclick=\"showAddFriendDialog("+divIDL+");return false;\" />";
	
			}
							
			
		} else {

			String request_idL = comLinkedConnection;
			connectionL ="<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\" onclick=\"addFriend("+divIDL+","+spanIDL+","+userId+",'drop');return false;\"><img border=\"0\" src=\"images/x.gif\" /></a>";
		}

		

		//Get profile of user in linkedIn
		
		
		lprofile_url = externalProfile.lprofile_url== null ? "" :externalProfile.lprofile_url;
		lpic_small_with_logo = externalProfile.lpic_small_with_logo == null ? "" :externalProfile.lpic_small_with_logo;
		lheadLine = externalProfile.lheadLine == null ? "" :externalProfile.lheadLine;
		
		//Get profile of user in Comet
		externalProfile.getCometProfile(userId);
		comet_url = "http://halley.exp.sis.pitt.edu/comet.dev/profile.do?user_id="
				+ userId;
		cname = externalProfile.cname;
		caffiliation = externalProfile.caffiliation;
		cinterest = externalProfile.cinterest;
		
		//Check whether friends is a speaker in Comet.
		speakerLink = externalProfile.getSolarSearchPage(lname);
		
		if(lpic_small_with_logo.contains("linkedin"))
		{
			lpicHTML = "<div style='display:inline;float:left'>" +
			"<img alt='' src='"+lpic_small_with_logo+"' width='40' height='50'></img></div>";	
		}else
		{
			picHTML ="<img alt='' src='images/LinkedIn_logo.png' width='40' height='50'></img>";	
		}

		//Layout for linkedIn and comet profile
%>
		<tr>
			<td align="center" width="20%">
				<div id="<%=index%>" class="lifriend"></div>
				<b><%=cname%></b>
				<br/>
			<%-- 	<%=caffiliation%>
				<br/>--%>
				<a href="<%=comet_url%>" target="_blank">See CoMeT Profile</a>
<%-- 
				<a href="javascript:void(0);" onclick="showLinkedInPopup('LC3y2gl0D0',$('#linkedInvit'));return false;">Invite him/her join CoMeT </a>
--%>
				<%
				if(speakerLink.trim().length()>0)
				%>
					<br/>	<%=speakerLink%>
			</td>
		
		
			<td width="60%">
				<table style="font-size:0.9em;">
					<tr>
						<td width="10%"><%=lpicHTML%></td>
						
						<td width="90%">
							<b><%=lname.trim()%></b>
							<br/>
							<%=lheadLine%>
							<br/>
							<a href="<%=lprofile_url%>" target="_blank">See LinkedIn Profile</a>
						
						</td>
					</tr>
				</table>
			</td>
		
		
			<td align="center" width="20%">
			<span id="<%=spanIDL%>" style="font-size:0.9em">
				<%=connectionL%>
			</span>
				<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="<%=divIDL%>">
			
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;" >
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
						&nbsp;Send <%=cname%> a friend request?
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center" >
							<tr>
								<td colspan="2" style="font-size: 0.75em;padding: 4px;">
									<b><%=cname%></b> will have to confirm your request.
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="85%"><input class="btn" type="button" value="Send Request" onclick ="addFriend(<%=divIDL%>,<%=spanIDL%>,<%=userId%>,'add');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(<%=divIDL%>);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
		<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="<%=divRIDL%>">
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;">
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;padding: 4px;">
						&nbsp;Confirm <%=cname %> as a friend?
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid #efefef;">
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td colspan="3" style="font-size: 0.75em;padding: 4px;">
									<b><%=cname %></b> would like to be your friend. If you know <%=cname %>, click Confirm.
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="85%"><input class="btn" type="button" value="Confirm" onclick="addFriend(<%=divRIDL%>,<%=spanIDL%>,<%=userId%>,'accept');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="<%=isNotNow?"Delete Request":"Not Now" %>" onclick="addFriend(<%=divRIDL%>,<%=spanIDL%>,<%=userId%>,<%=isNotNow?"'reject'":"'notnow'" %>);return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(<%=divRIDL%>);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
			</td>
		</tr>
	<%
		if(linkedInFriendSingle)
		{
			%>
			</table>
			<%
			break;
		}
		
		index++;
		if(index > end )
		{
			%>
			</table>
			<%
			break;
			
		}
	}
}		
	
		
		
	//Friends in linkedIn not in comet
	
	if(session.getAttribute("linkedInUsers") == null)
	{
		linkedInUsers = externalProfile.linkedInUsers;
		session.setAttribute("linkedInUsers",linkedInUsers);
	}else
	{
	
		linkedInUsers = (LinkedList<Integer>)session.getAttribute("linkedInUsers");
	}
	
	
	int linkedinUserSize = linkedInUsers.size();
	int totalSize = size + linkedinUserSize;
	
	ListIterator<Integer> iteratorL = linkedInUsers.listIterator();
	if(locationSearch)
	{
		LinkedList<Integer> sets = new LinkedList<Integer>();
		sets = locationliUsers.get(location);
		
		if(sets == null)
		{
			totalSize = size;
			iteratorL = new LinkedList<Integer>().listIterator();
			
			
		}
		else
		{
			totalSize = size + sets.size();
			iteratorL = sets.listIterator();
		}
		
		
	}
	
	
	end = request.getParameter("end") == null ? totalSize: Integer.valueOf(request.getParameter("end"));
	
	
	%>
		<input type="hidden" id="totalSizeLI" value="<%=totalSize%>"/>
	<%
	//Show top 5
	int countL=0;
	while(iteratorL.hasNext())
	{
		if(linkedInFriendSingle)
			break;
		if( index == 1)
		{
			%>
			
					<table cellspacing="0" cellpadding="0" width="100%" align="center" border="1" style="font-size:0.9em;" bordercolor="#003399">
			
			<tr>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">CoMeT Profile</span></th>
				<th bgcolor="#003399" width="60%"><span style="color:#ffffff">LinkedIn Profile</span></th>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">Friend in CoMeT</span></th>
			</tr>
			
			<%
		
		}
		
		
		if(index < start)
		{
			index++;
			externalID = (Integer) iteratorL.next();
			continue;
		}
		
	
		externalID = (Integer) iteratorL.next();
		if(linkedInUserSingle)
			externalID = linkedInUserSingleExtid;
		System.out.println("Link Not in comet:" +externalID);
		
			
	//	divID = "divAddFriendF" + userId;
	//	spanID = "spanAddAsFriendF"+userId;
		//Get profile of user in facebook
		externalProfile.getLinkedInProfileInfo(externalID);
		luid = externalProfile.luid;
		
		if(externalProfile.lname == null )
			continue;
		
		lname = externalProfile.lname == null ? "" :externalProfile.lname;
		
		lprofile_url = externalProfile.lprofile_url== null ? "" :externalProfile.lprofile_url;
		lpic_small_with_logo = externalProfile.lpic_small_with_logo== null ? "" :externalProfile.lpic_small_with_logo;
		lheadLine = externalProfile.lheadLine== null ? "" :externalProfile.lheadLine;
		
		//Check whether friends is a speaker in Comet.
		speakerLink = externalProfile.getSolarSearchPage(lname);
		//speakerLink = "<a href='javscript:void(0);' onClick=''></a>";
		
		if(lpic_small_with_logo.contains("http://"))
		{
			picHTML = "<div style='display:inline;float:left'>" +
			"<img alt='' src='"+lpic_small_with_logo+"' width='40' height='50'></img></div>";	
		}else
		{
			picHTML ="<img alt='' src='images/LinkedIn_logo.png' width='40' height='50'></img>";	
		}

		//Layout for facebook and comet profile
%>
  
		<tr >
			<td align="center"  width="20%">
			<div id="<%=index%>" class="lifriend"></div>
			<a href="javascript:void(0);" onclick="showLinkedInPopup('<%=luid%>',$('#linkedInvit'));return false;">Invite him/her join CoMeT </a>
			<%
				if(speakerLink.trim().length()>0)
			%>
					<br/>	<%=speakerLink%>
					

					
			</td>
		
		
			<td width="60%">
				<table style="font-size:0.9em;">
					<tr>
						<td width="10%"><%=picHTML%></td>
						
						<td width="90%">
							<b><%=lname.trim()%></b>
							<br/>
							<%=lheadLine%>
							<br/>
							<a href="<%=lprofile_url%>" target="_blank">See LinkedIn Profile</a>
						
						</td>
					</tr>
				</table>
			</td>
		
		
			<td align="center"  width="20%">
			<span style="font-size:0.9em">
				Not in CoMeT
			</span>
				
			
			
		
			</td>
		</tr>
	
	<%
		if(linkedInUserSingle)
		{
			%>
			</table>
			<%
			break;
		}
		
		index++;
		if(index > end)
		{
			%>
			</table>
			<%
			break;
			
		}
	}	
	index=1;
	
	conn.conn.close();
	//conn = null;
%>

