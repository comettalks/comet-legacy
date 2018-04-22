package edu.pitt.sis;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.TreeMap;
import java.util.Iterator;
import java.util.LinkedList;

import edu.pitt.sis.db.connectDB;

public class ExternalProfile {
	public Connection conn;
	public String facebookTable = null;
	public String linkedInTable = null;
	public String fuid,fname,fprofile_url,fpic_small_with_logo,fheadline,fcity,luid,lname,lprofile_url,lpic_small_with_logo,lheadLine,llocation,cname,caffiliation,cinterest="";
	public int fAutoID,lAutoID;
	//Friends in facebook are also users in Comet
	public LinkedHashMap<Integer,Integer> facebookFriends = new LinkedHashMap<Integer,Integer>();
	//Friends in linkedIn are also users in Comet
	public LinkedHashMap<Integer,Integer> linkedInFriends = new LinkedHashMap<Integer,Integer>();
	
	//Friends in facebook not in Comet
	public LinkedList<Integer> facebookUsers = new LinkedList<Integer>();
	//Friends in linkedIn not in Comet
	public LinkedList<Integer> linkedInUsers = new LinkedList<Integer>();
	
	public int totalFriendsTalks;
	
	public Hashtable<String,Integer> facebookFriendsName = new Hashtable<String,Integer>();
	public Hashtable<String,Integer> facebookUsersName = new Hashtable<String,Integer>();
	public Hashtable<String,Integer> linkedInFriendsName = new Hashtable<String,Integer>();
	public Hashtable<String,Integer> linkedInUsersName = new Hashtable<String,Integer>();
	public int oldTalks=0;
	public int newTalks=0;
	public Hashtable<String,int[]> newOldTalks = new Hashtable<String,int[]>();
	
	public Hashtable<String,LinkedList<Integer>> locationfbFriends = new Hashtable<String,LinkedList<Integer>>();
	public Hashtable<String,LinkedList<Integer>> locationfbUsers = new Hashtable<String,LinkedList<Integer>>();
	public Hashtable<String,LinkedList<Integer>> locationliFriends = new Hashtable<String,LinkedList<Integer>>();
	public Hashtable<String,LinkedList<Integer>> locationliUsers = new Hashtable<String,LinkedList<Integer>>();
	
	
	
	
	public ExternalProfile()
	{
		//connectDB conns = new connectDB();
		//conn = conns.conn;
	}
	
	public void connectDB()
	{
		connectDB conns = new connectDB();
		conn = conns.conn;
	}
	
	 
	//Get external profile ID and table from facebook or linkedin
	public int getExternalID(long userID,String type) throws SQLException
	{
		
		String tableType = "%" + type +"%";
		String sqlProfile = "select max(ext_id) ext_id,exttable from colloquia.extmapping where user_id=? and exttable like ? GROUP BY exttable";
		PreparedStatement sf = conn.prepareStatement(sqlProfile);
		sf.setLong(1,userID);
		sf.setString(2,tableType);
		
		ResultSet result = sf.executeQuery();
		
		int extfacebook_id=-1;
		String ext_table = null;
		while(result.next())
		{
			extfacebook_id = result.getInt("ext_id");
			ext_table = result.getString("exttable");
		}
		result.close();
		sf.close();
		
		if(type.equals("facebook"))
		{
			facebookTable = ext_table;
		}else
		{
			linkedInTable = ext_table;
		}
		
		return extfacebook_id;
	}
	
	public void getFacebookProfileInfo(int profile_id) throws SQLException
	{
		//Get facebook Info
		
		//Get max id
		String sqlFacebook = "select max(fAutoID) as maxId from extprofile.facebook where uid = (select uid from extprofile.facebook where fAutoID=?)";
		PreparedStatement infoState = conn.prepareStatement(sqlFacebook);
		infoState.setInt(1, profile_id);
		ResultSet infoResult = infoState.executeQuery();
		
		if(infoResult.next())
		{
			profile_id = infoResult.getInt(1);
		}
		
		 sqlFacebook = "select name,profile_url,pic_small_with_logo,current_location as description,uid,city from "+ facebookTable + " where fAutoID=?";
		 infoState = conn.prepareStatement(sqlFacebook);
		infoState.setInt(1, profile_id);
		 infoResult = infoState.executeQuery();
		
		while(infoResult.next())
		{
			
			fuid = infoResult.getString("uid").trim();
			fname = infoResult.getString("name");
			fprofile_url = infoResult.getString("profile_url");
			fpic_small_with_logo = infoResult.getString("pic_small_with_logo");
			fheadline = infoResult.getString("description");
			fcity = infoResult.getString("city");
		}
		infoResult.close();
		infoState.close();
	}
	
	public void getLinkedInProfileInfo(int profile_id) throws SQLException
	{
		//Get linkedIn Info
		String sqllinkedIn = "select max(lAutoID) as maxId from extprofile.linkedin where linkedinID = (select linkedinID from extprofile.linkedin where lAutoID=?)";
		PreparedStatement infoState = conn.prepareStatement(sqllinkedIn);
		infoState.setInt(1, profile_id);
		ResultSet infoResult = infoState.executeQuery();
		
		if(infoResult.next())
		{
			profile_id = infoResult.getInt(1);
		}
		
		 sqllinkedIn = "select CONCAT(l.firstname, ' ', l.lastname) AS fullname, l.lAutoID, l.firstname, l.lastname, l.pictureurl as purl, l.publicprofileurl as profileurl, l.linkedinID, l.headline as description,l.location from extprofile.linkedin l where l.lAutoID=?";
		 infoState = conn.prepareStatement(sqllinkedIn);
		infoState.setInt(1, profile_id);
		 infoResult = infoState.executeQuery();
		
		while(infoResult.next())
		{
			
			luid = infoResult.getString("linkedinID").trim();
			lname = infoResult.getString("fullname");
			lprofile_url = infoResult.getString("profileurl");
			lpic_small_with_logo = infoResult.getString("purl");
			lheadLine = infoResult.getString("description");
			llocation = infoResult.getString("location");
		}
		infoResult.close();
		infoState.close();
	}
	
	public void getCometProfile(int user_id) throws SQLException
	{
		//Get info of user in colloquia
		String sqlcolloquia = "select name,affiliation,interests from colloquia.userinfo where user_id=?";
		PreparedStatement infoState = conn.prepareStatement(sqlcolloquia);
		infoState.setInt(1, user_id);
		ResultSet infoResult = infoState.executeQuery();
		
		while(infoResult.next())
		{
			
			cname = infoResult.getString("name");
			caffiliation = infoResult.getString("affiliation");
			cinterest = infoResult.getString("interests");
		}
		infoResult.close();
		infoState.close();
	}
	
	 
	//Get friends list from facebook or LinkedIn
	public void getFriendList(int fAutoID,String table) throws SQLException
	{
		String field1="";
		String field2="";
		String field3="";
		String field4="";
		String sourceTable = "facebook";
		String orderTag="";
		String idField="";
		String fullName="";
		
		String uid;
		Boolean facebook=false;
		if(table.equalsIgnoreCase("extprofile.vwFacebookFriendship"))
		{
			field1 = "fAuto1ID";
			field2 = "u0id";
			field3 = "fAutoID";
			field4= "city as location";
			orderTag = "first_name";
			fullName = "name as fullname";
			idField = "uid";
			facebookFriends.clear();
			facebookUsers.clear();
			facebookFriendsName.clear();
			facebookUsersName.clear();
			this.locationfbFriends.clear();
			this.locationfbUsers.clear();
			
			sourceTable = "extprofile.facebook";
			this.getFacebookProfileInfo(fAutoID);
			uid = fuid;
			facebook = true;
		
			
		}else
		{
			field1 = "lAuto1ID";
			field2 = "linkedin0ID";
			field3 = "lAutoID";
			field4= "headline as location";
			idField = "linkedinID";
			orderTag = "firstname";
			fullName = "concat(concat(firstname,' '),lastname) as fullname";
			linkedInFriends.clear();
			linkedInUsers.clear();
			linkedInFriendsName.clear();
			linkedInUsersName.clear();
			this.locationliFriends.clear();
			this.locationfbUsers.clear();
			
			sourceTable="extprofile.linkedin";
			this.getLinkedInProfileInfo(fAutoID);
			uid= luid;
			facebook = false;
			
		}
		
		String sqlFriends = 
			"select " + field4+ "," + fullName+"," + orderTag+","+idField+",MAX("+field1+") as id from "+table+ "," + sourceTable+" where "+field2+"=? and "+field1+"="+field3+" " +
		    "GROUP BY " +orderTag + "," + idField + 
			" order by "+orderTag;

		
	//	String sqlFriends = 
	//			"select " + orderTag+","+field1+" as id from "+table+ "," + sourceTable+" where "+field2+"=? and "+field1+"="+field3+" " +
	//			"union " +
	//			"select " + orderTag+","+field2+" as id from "+table+","+sourceTable+" where "+field1+"=? and "+field2+"="+field3+" order by "+orderTag;
		PreparedStatement sfriend = conn.prepareStatement(sqlFriends);
		
		if(facebook)
		{
			sfriend.setLong(1, Long.parseLong(uid));
		}else
		{
			sfriend.setString(1,uid);
		}
		//sfriend.setInt(2,fAutoID);
		
		ResultSet resultfriend = sfriend.executeQuery();
		
		int externalID = -1;
		int userID=-1;
		String fullname="";
		String location="";
		while(resultfriend.next())
		{
			externalID = resultfriend.getInt("id");
			userID = userIncolloquia(externalID,table);
			fullname = resultfriend.getString("fullname");
			location = resultfriend.getString("location").toLowerCase().trim();
				
			if(userID != -1)
			{
				if(table.equalsIgnoreCase("extprofile.vwFacebookFriendship"))
				{
					facebookFriends.put(userID,externalID);
					facebookFriendsName.put(fullname,userID);
					
					if(location.contains("pittsburgh"))
					{
						if(this.locationfbFriends.containsKey("pittsburgh"))
							locationfbFriends.get("pittsburgh").add(userID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(userID);
							locationfbFriends.put("pittsburgh",list);	
						}
					}else
					{
						if(this.locationfbFriends.containsKey("others"))
							locationfbFriends.get("others").add(userID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(userID);
							locationfbFriends.put("others",list);	
						}
					}
					
				}else
				{
					linkedInFriends.put(userID,externalID);
					linkedInFriendsName.put(fullname,userID);
					
					if(location.contains("pittsburgh"))
					{
						if(this.locationliFriends.containsKey("pittsburgh"))
							locationliFriends.get("pittsburgh").add(userID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(userID);
							locationliFriends.put("pittsburgh",list);	
						}
					}else
					{
						if(this.locationliFriends.containsKey("others"))
							locationliFriends.get("others").add(userID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(userID);
							locationliFriends.put("others",list);	
						}
					}
				}
			}else
			{
				if(table.equalsIgnoreCase("extprofile.vwFacebookFriendship"))
				{
					facebookUsers.add(externalID);
					facebookUsersName.put(fullname,externalID);
					
					if(location.contains("pittsburgh"))
					{
						if(this.locationfbUsers.containsKey("pittsburgh"))
							locationfbUsers.get("pittsburgh").add(externalID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(externalID);
							locationfbUsers.put("pittsburgh",list);	
						}
					}else
					{
						if(this.locationfbUsers.containsKey("others"))
							locationfbUsers.get("others").add(externalID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(externalID);
							locationfbUsers.put("others",list);	
						}
					}
					
				}else
				{
					linkedInUsers.add(externalID);
					linkedInUsersName.put(fullname,externalID);
					
					if(location.contains("pittsburgh"))
					{
						if(this.locationliUsers.containsKey("pittsburgh"))
							locationliUsers.get("pittsburgh").add(externalID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(externalID);
							locationliUsers.put("pittsburgh",list);	
						}
					}else
					{
						if(this.locationliUsers.containsKey("others"))
							locationliUsers.get("others").add(externalID);
						else
						{
							LinkedList<Integer> list = new LinkedList<Integer>();
							list.add(externalID);
							locationliUsers.put("others",list);	
						}
					}
				}
				
			}
			
		}
		sfriend.close();
		resultfriend.close();
	}
	
	//Check user exist in colloquia
	public int userIncolloquia(int externalId,String type) throws SQLException
	{
		String sqlUser;
		if(type.equalsIgnoreCase("extprofile.vwFacebookFriendship"))
		{
			 sqlUser = "select * from colloquia.extmapping where exttable='extprofile.facebook' and ext_id in" +
				"(select fAutoID from extprofile.facebook where uid = (select uid from extprofile.facebook where fautoID=?));";
			
		}else
		{
				 sqlUser = "select * from colloquia.extmapping where exttable='extprofile.linkedin' and ext_id in" +
					"(select lAutoID from extprofile.linkedin where linkedinID = (select linkedinID from extprofile.linkedin where lautoID=?));";
		
		}
		PreparedStatement sUser = conn.prepareStatement(sqlUser);
		sUser.setInt(1,externalId);
		
		ResultSet resultUsers = sUser.executeQuery();
		
		int userID = -1;
		
		while(resultUsers.next())
		{
			userID = resultUsers.getInt("user_id");
		}
		
		sUser.close();
		resultUsers.close();
		return userID;
	}
	
	//Check whether users are friends in colloquia
	public String connectionStatus(long user1,int user2) throws SQLException
	{
		
		String sql = "SELECT friend_id FROM colloquia.friend WHERE user0_id=? AND user1_id=? " +
				"AND breaktime IS NULL union " +
				"SELECT friend_id FROM colloquia.friend WHERE user0_id=? AND user1_id=? " +
				"AND breaktime IS NULL";
	
		PreparedStatement infoState = conn.prepareStatement(sql);
		infoState.setLong(1, user1);
		infoState.setInt(2, user2);
		infoState.setInt(3, user2);
		infoState.setLong(4, user1);
		
		ResultSet set = infoState.executeQuery();
		if(set.next()){
			set.close();
			infoState.close();
			return "Connected";
		}else{//They are not friends. So is there any befriending request?
			
			sql = "SELECT request_id FROM colloquia.request WHERE requester_id=? AND target_id=?" + 
				" AND droprequesttime IS NULL ORDER BY request_id DESC LIMIT 1";
			
			infoState = conn.prepareStatement(sql);
			infoState.setLong(1, user1);
			infoState.setInt(2, user2);
			set = infoState.executeQuery();
			
			
			if(set.next()){
				String request_id = set.getString("request_id");
				set.close();
				infoState.close();
				return request_id;
			}else
			{
				set.close();
				infoState.close();
				return "No";
			}
		}
		
		
		
	
	}
	
	public String getSolarSearchPage(String name) throws SQLException
	{
		/*
		String link="";
		String content = new String();
		String tempName = name;
		if(tempName == null)
			return "";
		tempName = "\""+tempName.trim().replaceAll(" ", "+")+"\"";
		
		try
		{
			String url = "http://halley.exp.sis.pitt.edu/solr/db/select/?q=speaker_name%3A%28"+tempName+"%29"+ 
					"&version=2.2&start=0&rows=10&indent=on&sort=score+desc"+ 
					"&facet=true&facet.field=video&facet.field=slide&facet.field=sponsor_str&facet.field=date&facet.mincount=1" +
					"&facet.query=date:[NOW-3MONTHS%20TO%20NOW]&facet.query=date:[NOW-1MONTHS%20TO%20NOW]&facet.query=date:[NOW-30DAYS%20TO%20NOW]&facet.query=date:[NOW%20TO%20NOW%2B30DAYS]&facet.query=date:[NOW%20TO%20NOW%2B1MONTHS]&facet.query=date:[NOW%20TO%20NOW%2B3MONTHS]";
			
			URL rootPage = new URL(url);			  
			BufferedReader reader = new BufferedReader(new InputStreamReader(rootPage.openStream()));
				
			String line = new String();
			while((line = reader.readLine()) != null)
				content += line;
			
		}		
		catch(IOException e){
			e.printStackTrace();
	    }
		
		int beginIndex = 0, endIndex = 0,num=0;
		try{
			beginIndex = content.indexOf("<result name=\"response\" numFound=\"", beginIndex);
			beginIndex += "<result name=\"response\" numFound=\"".length();
			endIndex = content.indexOf("\"", beginIndex);
			num = Integer.parseInt( content.substring(beginIndex, endIndex));
			
		}catch(Exception e)
		{
			num = 0;
		}
		*/
		int num=0;
		String sql = "select count(c.col_id) from colloquium c,speaker s where s.name=? and  c.speaker_id = s.speaker_id";
		PreparedStatement ps  = conn.prepareStatement(sql);
		ps.setString(1, name);
		ResultSet set = ps.executeQuery();
		if(set.next())
		{
			num = set.getInt(1);
		}else
		{
			num = 0;
		}
		
		
		String talkTag="talk";
		if(num > 1)
		{
			talkTag = "talks";
		}
		String link="";
		if(num > 0)
		//	link= "<a href='advancedSearchResult.do?title=&detail=&speaker="+name+"&frmYear=&frmMonth=&frmDay=&toYear=&toMonth=&toDay=&sortBy=1' target='blank'>Speaker's talks in Comet</a>";
			link= "<a id='"+name.trim()+"' href=\"javascript:void(0);\"  class=\"enable\" onClick=\"loadSingleFriendTalks('"+name+"','"+name+"',1,10,'none')\">"+name+" ("+num+" "+talkTag+")</a>";
			
		
			else
			link="";
			
		return link;
			
	}
	
	public ArrayList<Long> getTalkList(String speaker) throws SQLException
	{
		
		/*
		StringBuffer contentBuffer = new StringBuffer();
		
		try
		{
			speaker = "\""+speaker.trim().replaceAll(" ", "+")+"\"";
			
			String url = "http://halley.exp.sis.pitt.edu/solr/db/select/?q=speaker_name%3A%28"+speaker+"%29"+ 
			"&version=2.2&start=0&rows=10&indent=on&sort=score+desc"+ 
			"&facet=true&facet.field=video&facet.field=slide&facet.field=sponsor_str&facet.field=date&facet.mincount=1" +
			"&facet.query=date:[NOW-3MONTHS%20TO%20NOW]&facet.query=date:[NOW-1MONTHS%20TO%20NOW]&facet.query=date:[NOW-30DAYS%20TO%20NOW]&facet.query=date:[NOW%20TO%20NOW%2B30DAYS]&facet.query=date:[NOW%20TO%20NOW%2B1MONTHS]&facet.query=date:[NOW%20TO%20NOW%2B3MONTHS]";
			
			URL rootPage = new URL(url);			  
			BufferedReader reader = new BufferedReader(new InputStreamReader(rootPage.openStream()));
				
			String line = new String();
			while((line = reader.readLine()) != null)
				contentBuffer.append(line);
			
			reader.close();
			
		}		
		catch(IOException e){
			e.printStackTrace();
	    }
		
			String content =contentBuffer.toString();
			int beginIndex = 0, endIndex = 0;
			beginIndex = content.indexOf("<result name=\"response\" numFound=\"", beginIndex);
			beginIndex += "<result name=\"response\" numFound=\"".length();
			endIndex = content.indexOf("\"", beginIndex);
			int num = Integer.parseInt( content.substring(beginIndex, endIndex));
			int temp = 0;
			ArrayList<Long> colList = new ArrayList<Long>();
			if(num > 0)
			{
				while ((beginIndex = content.indexOf("<doc>", beginIndex))!=-1){
					
					beginIndex = content.indexOf("<str name=\"col_id\">", beginIndex);
					beginIndex += "<str name=\"col_id\">".length();
					endIndex = content.indexOf("</str>", beginIndex);
					String col_id = content.substring(beginIndex, endIndex);
					
					colList.add(Long.parseLong(col_id));		
					temp = beginIndex;
			
				}
			}
		*/
		ArrayList<Long> colList = new ArrayList<Long>();
		
		String sql = "select c.col_id from colloquium c,speaker s where s.name=? and  c.speaker_id = s.speaker_id";
		PreparedStatement ps  = conn.prepareStatement(sql);
		ps.setString(1, speaker);
		ResultSet set = ps.executeQuery();
		while(set.next())
		{
			colList.add(set.getLong("col_id"));
		}
		
		int[] count = new int[2];
	/*	sql = "select count(c.col_id) as size from colloquium c,speaker s where s.name=? and  c.speaker_id = s.speaker_id and c._date >= NOW()";
		ps  = conn.prepareStatement(sql);
		ps.setString(1, speaker);
		set = ps.executeQuery();
		if(set.next())
		{
			count[0] = set.getInt("size");
		}else
		{
			count[0] = 0;
		}
		
		
		sql = "select count(c.col_id) as size from colloquium c,speaker s where s.name=? and  c.speaker_id = s.speaker_id and c._date < NOW()";
		ps  = conn.prepareStatement(sql);
		ps.setString(1, speaker);
		set = ps.executeQuery();
		if(set.next())
		{
			count[1] = set.getInt("size");
		}else
		{
			count[1] = 0;
		}
		*/
		newOldTalks.put(speaker, count);
		
		set.close();
		ps.close();
		return colList;
	}
	
	public TreeMap<String,ArrayList<Long>> getFriendsWithTalk(long userID) throws SQLException {
		ArrayList<Long> talkIds = new ArrayList<Long>();
		HashSet<String> speakerNames = new HashSet<String>();
		TreeMap<String,ArrayList<Long>> speakTalkTB = new TreeMap<String,ArrayList<Long>>();
		
		int extId = this.getExternalID(userID, "facebook");
			
		facebookFriends.clear();
		facebookUsers.clear();
				
		this.getFacebookProfileInfo(extId);
		String uid = fuid;
			
		String sqlFriends = "SELECT SQL_CACHE s.name " +
							"FROM col_speaker cs JOIN speaker s ON cs.speaker_id=s.speaker_id " +
							"JOIN extprofile.facebook f ON s.name=f.name " +
							"JOIN extprofile.vwFacebookFriendship t ON " +
							"((t.fAuto1ID=f.fAutoID AND t.u0id=?) OR (t.fAuto0ID=f.fAutoID AND t.u1id=?)) AND f.uid<>? " +
							"GROUP BY s.name";

		
		PreparedStatement sfriend = conn.prepareStatement(sqlFriends);
		sfriend.setString(1,uid);
		sfriend.setString(2,uid);
		sfriend.setString(3,uid);
			
		ResultSet resultfriend = sfriend.executeQuery();
		while(resultfriend.next()){
			String name = resultfriend.getString("name").trim();
			speakerNames.add(name);
		}
			
		linkedInFriends.clear();
		linkedInUsers.clear();
		this.getLinkedInProfileInfo(fAutoID);
		uid= luid;
		extId = this.getExternalID(userID, "linkedin");
			
		sqlFriends = "SELECT SQL_CACHE s.name " +
						"FROM col_speaker cs JOIN speaker s ON cs.speaker_id=s.speaker_id " +
						"JOIN extprofile.linkedin l ON s.name=CONCAT(l.firstname, ' ', l.lastname) " +
						"JOIN extprofile.vwLinkedInConnection t ON " +
						"((t.lAuto1ID=l.lAutoID AND t.linkedin0ID=?) OR (t.lAuto0ID=l.lAutoID AND t.linkedin1ID=?)) AND l.linkedinID<>? " +
						"GROUP BY s.name";
		
		sfriend = conn.prepareStatement(sqlFriends);
		sfriend.setString(1,uid);
		sfriend.setString(2,uid);
		sfriend.setString(3,uid);
			
		resultfriend = sfriend.executeQuery();
		totalFriendsTalks = 0;
			
		while(resultfriend.next()){
			String name = resultfriend.getString("name").trim();
			speakerNames.add(name);
		}
		
		for(String name : speakerNames){
			talkIds = getTalkList(name);
			totalFriendsTalks += talkIds.size();
			oldTalks += newOldTalks.get(name)[1];
			newTalks += newOldTalks.get(name)[0];
			speakTalkTB.put(name, talkIds);		
		}
			
		sfriend.close();
		resultfriend.close();	
			
		return speakTalkTB;
	}
	
	
}
