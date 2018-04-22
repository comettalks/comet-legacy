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
	LinkedHashMap<Integer, Integer> facebookFriends = new LinkedHashMap<Integer, Integer>();
	//Friends in facebook not in Comet
	LinkedList<Integer> facebookUsers = new LinkedList<Integer>();
	
	Hashtable<String,Integer> facebookFriendsName = new Hashtable<String,Integer>();
	Hashtable<String,Integer> facebookUsersName = new Hashtable<String,Integer>();
	Hashtable<String,LinkedList<Integer>> locationfbFriends = new Hashtable<String,LinkedList<Integer>>();
	Hashtable<String,LinkedList<Integer>> locationfbUsers = new Hashtable<String,LinkedList<Integer>>();
	
	
	connectDB conn = new connectDB();
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	long my_id =  ub.getUserID();
	//long my_id =  1;
	

	//System.out.println("Start:"+start + "EnD:"+end);
	ExternalProfile externalProfile = new ExternalProfile();
	externalProfile.conn = conn.conn;
	
	//Get external profile ID and table from facebook
	int fExternalID = externalProfile.getExternalID(my_id, "facebook");


	//Get facebook friend list also in Comet
	if(session.getAttribute("facebookFriends") == null)
	{
		externalProfile.getFriendList(fExternalID,
				"extprofile.vwFacebookFriendship");
		facebookFriends = externalProfile.facebookFriends;
		facebookFriendsName = externalProfile.facebookFriendsName;
		facebookUsersName = externalProfile.facebookUsersName;
		locationfbFriends = externalProfile.locationfbFriends;
		locationfbUsers = externalProfile.locationfbUsers;
		
		session.setAttribute("facebookFriends",facebookFriends);
		session.setAttribute("facebookFriendsName",facebookFriendsName);
		session.setAttribute("facebookUsersName",facebookUsersName);
		session.setAttribute("locationfbFriends",locationfbFriends);
		session.setAttribute("locationfbUsers",locationfbUsers);
		
	}else
	{
	
		facebookFriends = (LinkedHashMap<Integer,Integer>)session.getAttribute("facebookFriends");
		facebookFriendsName = (Hashtable<String,Integer>)session.getAttribute("facebookFriendsName");
		facebookUsersName = (Hashtable<String,Integer>)session.getAttribute("facebookUsersName");
		locationfbFriends = (Hashtable<String,LinkedList<Integer>>)session.getAttribute("locationfbFriends");;
		locationfbUsers = (Hashtable<String,LinkedList<Integer>>)session.getAttribute("locationfbUsers");;
	
	}


	//Get info of friends
	
	
	
	int start = request.getParameter("start") == null ? 0: Integer.valueOf(request.getParameter("start"));
	int size = facebookFriends.size();
	int end = request.getParameter("end") == null ? size: Integer.valueOf(request.getParameter("end"));
	
	String target = request.getParameter("target") == null ? "": (String)request.getParameter("target");
	int targetId = request.getParameter("id") == null ? -1: Integer.valueOf(request.getParameter("id"));
	Boolean faceBookFriendSingle = false;
	Boolean faceBookUserSingle = false;
	int faceBookFriendSingleUId=-1;
	int faceBookUserSingleExtid = -1;
	
	//Search for single speaker
	if(facebookFriendsName.containsKey(target))
	{
		faceBookFriendSingle = true;
		faceBookFriendSingleUId = facebookFriendsName.get(target);
	}else
	{
		faceBookFriendSingle = false;
		faceBookFriendSingleUId = -1;
	}
	
	if(facebookUsersName.containsKey(target))
	{
		faceBookUserSingle = true;
		faceBookUserSingleExtid = facebookUsersName.get(target);
	}else
	{
		faceBookUserSingle = false;
		faceBookUserSingleExtid = -1;
	}
	
	
	//Search for location
	String location = request.getParameter("location") == null ? "": (String)request.getParameter("location").toLowerCase();
	
	Boolean locationSearch=false;
	if(location.length() > 0 && !location.equals("all"))
	{
		locationSearch=  true;
		
	}
    
	
	Set<Integer> set = facebookFriends.keySet();
	
	Iterator<Integer> ite = set.iterator();
	
	//If location found, change set
	
	if(locationSearch)
	{
		LinkedList<Integer> sets = new LinkedList<Integer>();
		sets = locationfbFriends.get(location);
		
		if(sets == null)
		{
			size = 0;
			ite = new LinkedList<Integer>().listIterator();
			
		}
		else
		{
			size = sets.size();
			ite = sets.iterator();
		}
		
		
	}
	
	int i = 1;
	String divID = "";
	String spanID="";
	String divRID="";
	String spanRID="";
	String picHTML="";
String sql="";
ResultSet rs;
String speakerLink="";




//For friends also in Comet
	while (ite.hasNext()) {
	if(faceBookUserSingle)
		break;
	
	if( i==1)
		{
		%>
		
			<table cellspacing="0" cellpadding="0" width="100%" align="center" border="1" style="font-size:0.9em;" bordercolor="#003399">
			
			<tr>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">CoMeT Profile</span></th>
				<th bgcolor="#003399" width="60%"><span style="color:#ffffff">Facebook Profile</span></th>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">Friend in CoMeT</span></th>
			</tr>
		
		<%
		
		}
		
		if(i < start)
		{
			i++;
			userId = (Integer) ite.next();
			continue;
		}
		
		
		
		divID = "divAddFriendF" + i;
		spanID = "spanAddAsFriendF"+i;
		divRID = "divResFriendF" + i;
		spanRID = "spanResAsFriendF"+i;
		userId = (Integer) ite.next();
		
		if(faceBookFriendSingle)
			userId = faceBookFriendSingleUId;
		
	//	divID = "divAddFriendF" + userId;
	//	spanID = "spanAddAsFriendF"+userId;
		externalID = facebookFriends.get(userId);
		System.out.println("Facebook  in comet:" +externalID);
		
		//Whether they are friends in Comet
		comfacConnection = externalProfile.connectionStatus(my_id,
				userId);
				
		Boolean isNotNow = false;
		if (comfacConnection.equals("Connected")) {
			connection = "You are friends in CoMeT too!";
		} else if (comfacConnection.equals("No")) {
			sql = "SELECT request_id,notnowtime FROM request WHERE requester_id=" + userId + " AND target_id=" + my_id + " AND accepttime IS NULL AND rejecttime IS NULL AND droprequesttime IS NULL ORDER BY requesttime DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			
			if(rs.next()){
					String request_id = rs.getString("request_id");
					
					if(rs.getString("notnowtime")!=null){
									isNotNow = true;
								}
					
					connection = "<input class =\"btn\" type=\"button\" id=\"btnRespondRequest\" value=\"Respond to Friend Request\" onclick=\"showAddFriendDialog("+ divRID + ");return false;\" />";
		
			}else{

					connection = "<input class =\"btn\" type=\"button\" id=\"btnAddAsFriend\" value=\"Connect in CoMeT\" onclick=\"showAddFriendDialog("+divID+");return false;\" />";
	
			}
							
			
		} else {

			String request_id = comfacConnection;
			connection ="<span style=\"font-size: 0.8em;font-style: italic;color: #aaaaaa;\">Friend Request Sent</span> <a href=\"javascript:return false;\" onclick=\"addFriend("+divID+","+spanID+","+userId+",'drop');return false;\"><img border=\"0\" src=\"images/x.gif\" /></a>";
		}

		//Get profile of user in Comet
		externalProfile.getCometProfile(userId);
		comet_url = "http://halley.exp.sis.pitt.edu/comet.dev/profile.do?user_id="
				+ userId;
		cname = externalProfile.cname;
		caffiliation = externalProfile.caffiliation;
		cinterest = externalProfile.cinterest;

		//Get profile of user in facebook
		externalProfile.getFacebookProfileInfo(externalID);
		
		if(externalProfile.fname == null)
			continue;
			
		fname = externalProfile.fname;
		
	
		fprofile_url = externalProfile.fprofile_url;
		fpic_small_with_logo = externalProfile.fpic_small_with_logo;
		fheadline = externalProfile.fheadline;
		
		//Check whether friends is a speaker in Comet.
		speakerLink = externalProfile.getSolarSearchPage(fname);
		
		
		if(fpic_small_with_logo.contains("http://"))
		{
			picHTML = 
			"<img alt='' src='"+fpic_small_with_logo+"' width='40' height='50'></img>";	
		}else
		{
			picHTML ="<img alt='' src='images/Facebook-Logo.png' width='40' height='50'></img>";	
		}

		//Layout for facebook and comet profile
%>
		<tr>
			<td align="center"  width="20%">
				<div id="<%=i%>" class="fbfriend"></div>
				<b><%=cname%></b>
				<br/>
			<%-- 	<%=caffiliation%>
				<br/>--%>
				<a href="<%=comet_url%>" target="_blank">See CoMeT Profile</a>
			<%
				if(speakerLink.trim().length()>0)
			%>
					<br/>	<%=speakerLink%>
			
			</td>
		
		
			<td  width="60%">
				<table style="font-size:0.9em;">
					<tr>
						<td width="20%"><%=picHTML%></td>
						
						<td width="80%">
							<b><%=fname.trim()%></b>
							<br/>
							<%=fheadline%>
							<br/>
							<a href="<%=fprofile_url%>" target="_blank">See Facebook Profile</a>
						
						</td>
					</tr>
				</table>
				
			</td>
		
		
			<td align="center"  width="20%">
			<span id="<%=spanID%>" style="font-size:0.9em"> 
				<%=connection%>
			</span>
				<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="<%=divID%>">
			
			<table cellpadding="0" cellspacing="0" style="background-color: #fff;width: 400px;border: 1px solid #aaaaaa;">
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
						<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">
							<tr>
								<td colspan="2" style="font-size: 0.75em;padding: 4px;">
									<b><%=cname%></b> will have to confirm your request.
								</td>
							</tr>
							<tr style="background-color: #efefef;">
								<td align="right" width="85%"><input class="btn" type="button" value="Send Request" onclick="addFriend(<%=divID%>,<%=spanID%>,<%=userId%>,'add');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(<%=divID%>);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
			<div style="z-index: 1000;position: absolute;top: 50%;left: 50%;margin-left: -25%;margin-top: -25%;display: none;bacground: rgb(170,170,170) transparent;background: rgba(170,170,170,0.6);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa);-ms-filter: 'progid:DXImageTransform.Microsoft.gradient(startColorstr=#99aaaaaa, endColorstr=#99aaaaaa)';padding: 10px;" 
			id="<%=divRID%>">
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
								<td align="right" width="85%"><input class="btn" type="button" value="Confirm" onclick="addFriend(<%=divRID%>,<%=spanID%>,<%=userId%>,'accept');return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="<%=isNotNow?"Delete Request":"Not Now" %>" onclick="addFriend(<%=divRID%>,<%=spanID%>,<%=userId%>,<%=isNotNow?"'reject'":"'notnow'" %>);return false;"></input></td>
								<td align="center" width="15%"><input class="btn" type="button" value="Cancel" onclick="hideAddFriendDialog(<%=divRID%>);return false;"></input></td>
							</tr>
						</table>		
					</td>
				</tr>
			</table>
		</div>
			</td>
		</tr>
	<%
	//For single friend search
		if(faceBookFriendSingle)
		{
			%>
			</table>
			<%
			break;
		}
		
		i++;
		if(i > end )
		{
			%>
			</table>
			<%
			break;
			
		}
	}
	
		
	//Friends in facebook not in comet
	
	if(session.getAttribute("facebookUsers") == null)
	{
		facebookUsers = externalProfile.facebookUsers;
		session.setAttribute("facebookUsers",facebookUsers);
	}else
	{
	
		facebookUsers = (LinkedList<Integer>)session.getAttribute("facebookUsers");
	}
	
	
	
	int facebookUserSize = facebookUsers.size();
	
	int totalSize = size + facebookUserSize;
	end = request.getParameter("end") == null ? totalSize: Integer.valueOf(request.getParameter("end"));
	
	
	
	ListIterator<Integer> iterator = facebookUsers.listIterator();
	if(locationSearch)
	{
		LinkedList<Integer> sets = new LinkedList<Integer>();
		sets = locationfbUsers.get(location);
		
		if(sets == null)
		{
			totalSize = size;
			iterator = new LinkedList<Integer>().listIterator();
		}
		else
		{
			totalSize = size + sets.size();
			iterator = sets.listIterator();
		}
	
	}
	
	int count=0;
	while(iterator.hasNext())
	{
		if(faceBookFriendSingle)
			break;
		if(  i == 1)
		{
			%>
			
				<table cellspacing="0" cellpadding="0" width="100%" align="center" border="1" style="font-size:0.9em;" bordercolor="#003399">
			
			<tr>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">CoMeT Profile</span></th>
				<th bgcolor="#003399" width="60%"><span style="color:#ffffff">Facebook Profile</span></th>
				<th bgcolor="#003399" width="20%"><span style="color:#ffffff">Friend in CoMeT</span></th>
			</tr>
		
			
			<%
		
		}
		
	
		if(i < start)
		{
			i++;
			externalID = (Integer) iterator.next();
			continue;
		}
		externalID = (Integer) iterator.next();
		if(faceBookUserSingle)
			externalID = faceBookUserSingleExtid;
		System.out.println("Facebook  not in comet:" +externalID);
		
	//	divID = "divAddFriendF" + userId;
	//	spanID = "spanAddAsFriendF"+userId;
		//Get profile of user in facebook
		externalProfile.getFacebookProfileInfo(externalID);
		fuid = externalProfile.fuid;
		fname = externalProfile.fname;
		
		fprofile_url = externalProfile.fprofile_url;
		fpic_small_with_logo = externalProfile.fpic_small_with_logo;
		fheadline = externalProfile.fheadline;
		
		//Check whether friends is a speaker in Comet.
		speakerLink = externalProfile.getSolarSearchPage(fname);
		
		if(fpic_small_with_logo.contains("http://"))
		{
			picHTML = 
			"<img alt='' src='"+fpic_small_with_logo+"' width='40' height='50'></img>";	
		}else
		{
			picHTML ="<img alt='' src='images/Facebook-Logo.png' width='40' height='50'></img>";
		}

		//Layout for facebook and comet profile
%>
		<tr>
			<td align="center" width="20%">
				<div id="<%=i%>" class="fbfriend"></div>
			<a href="javascript:void(0);" onClick="invitation('<%=fuid%>')">Invite him/her join CoMeT </a>
			<%
				if(speakerLink.trim().length()>0)
			%>
					<br/>	<%=speakerLink%>
			</td>
		
		
			<td width="60%">
				<table style="font-size:0.9em;">
					<tr>
						<td width="20%"><%=picHTML%>
					
						</td>
							
						<td width="80%">
							<b><%=fname.trim()%></b>
							<br/>
							<%=fheadline%>
							<br/>
							<a href="<%=fprofile_url%>" target="_blank">See Facebook Profile</a>
						
						</td>
					</tr>
				</table>
			</td>
		
		
			<td align="center" width="20%">
			<span style="font-size:0.9em">
				Not in CoMeT
			</span>
				
			
			
		
			</td>
		</tr>
	<%
		if(faceBookUserSingle)
		{
			%>
			</table>
			<%
			break;
		}
		
		i++;
		if(i > end)
		{
			%>
			</table>
			<%
			break;
			
		}
	}	
	i=1;
	
	%>
		<input type="hidden" id="totalSizeFB" value="<%=totalSize%>"/>
	
	<%
	
	conn.conn.close();
	//conn = null;
%>
