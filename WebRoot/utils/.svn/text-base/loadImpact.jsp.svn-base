<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<div id="divImpactContent">

<% 
final String[] months = {"January","Febuary","March",
	    "April","May","June",
	    "July","August","September",
	    "October","November","December"};

	connectDB conn = new connectDB();
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
    Calendar calendar = new GregorianCalendar();
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
    
	String menu = (String)session.getAttribute("menu");
	if(menu.equalsIgnoreCase("myaccount")){
		String uid = String.valueOf(ub.getUserID());
		if(user_id_value == null){
			String temp[] = new String[1];
			temp[0] = uid;
			user_id_value = temp;
		}else{
			String temp[] = new String[user_id_value.length+1];
			System.arraycopy(user_id_value,0,temp,0,user_id_value.length);
			temp[user_id_value.length] = uid;
			user_id_value = temp;
		}
	}
    
    Calendar setcal = new GregorianCalendar();
    setcal.set(req_year, req_month-1, 1);
    int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
    int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
    
	String strBeginDate = "";
	String strEndDate = "";
	
	String strDisplayDateRange = "";
	/*****************************************************************/
	/* Day View                                                      */
	/*****************************************************************/
	if(req_day > 0){
		strBeginDate = req_year + "-" + req_month + "-" + req_day;
		strEndDate = req_year + "-" + req_month + "-" + req_day;

		strDisplayDateRange = "Date: " + months[req_month-1] + " " + req_day + ", " + req_year; 
	}else{
	    if(req_month == 1){
	    	setcal.set(req_year-1, 11, 1);
	    }else{
	    	setcal.set(req_year, req_month-2, 1);
	    }  
	    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
	/*****************************************************************/
	/* Week View                                                     */
	/*****************************************************************/
		if(req_week > 0){
			strDisplayDateRange = "Week " + req_week + " of " + months[req_month-1] + ": ";
			if(startday == 0){
				strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week-1) + 1);
				strDisplayDateRange += " " + (7*(req_week-1) + 1);
			}else{
				if(req_week == 1){
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
					if(req_month==1){
						strBeginDate = (req_year-1) + "-12-" + (daysPrevMonth - startday + 1);
						strDisplayDateRange += months[11] + " " + (daysPrevMonth - startday + 1) + ", " + (req_year-1);
					}else{
						strDisplayDateRange += months[req_month-2] + " " + (daysPrevMonth - startday + 1);
					}
				}else{
					strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week - 1) - startday + 1);		
					strDisplayDateRange += months[req_month-1] + " " + (7*(req_week - 1) - startday + 1);
				}
			}
			if(7*req_week - startday <= stopday ){
				strEndDate = req_year + "-" + req_month + "-" + (7*req_week - startday);			
				if(req_week == 1){
					strDisplayDateRange += " - " + months[req_month-1] + " " + (7*req_week - startday) + ", " + req_year;
				}else{
					strDisplayDateRange += " - " + (7*req_week - startday) + ", " + req_year;
				}
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[0] + " " + (7 - ((startday + stopday)%7)) + ", " + (req_year+1);
				}else{
					strEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[req_month] + " " + (7 - ((startday + stopday)%7)) + ", " + (req_year);
				}
			}
			if(req_most_recent){
			    int today = calendar.get(Calendar.DAY_OF_MONTH);
				strBeginDate = req_year + "-" + req_month + "-" + today;	
			}
		}else{
    /*****************************************************************/
    /* Month View                                                    */
    /*****************************************************************/
			if(startday == 0){
				strBeginDate = req_year + "-" + req_month + "-1";
				strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": 1";
			}else{
				if(req_month == 1){
					strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
					strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": " + months[11] + " " + (31 - startday + 1) + ", " + (req_year-1);
				}else{
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);		
					if(req_month == 12){
						strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": " + months[req_month-2] + " " + (daysPrevMonth - startday + 1) + ", " + req_year;
					}else{
						strDisplayDateRange = "Month: " + months[req_month-1] + " " + req_year + ": " + months[req_month-2] + " " + (daysPrevMonth - startday + 1);						
					}
				}
			}
			if((startday + stopday)%7 == 0){
				strEndDate = req_year + "-" + req_month + "-" + (stopday);
				strDisplayDateRange += " - " + months[req_month-1] + " " + (stopday) + ", " + req_year;
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[0] + " " + (7 - ((startday + stopday)%7)) + ", " + (req_year+1);
				}else{
					strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
					strDisplayDateRange += " - " + months[req_month] + " " + (7 - ((startday + stopday)%7)) + ", " + req_year;
				}
			}
		}
    }

    /*****************************************************************/
    /* Total Views                                                   */
    /*****************************************************************/
    HashMap<String,Integer> viewTitleMap = new HashMap<String,Integer>();
    HashMap<Integer,Integer> viewCountMap = new HashMap<Integer,Integer>();
    HashMap<Integer,String> viewColDateMap = new HashMap<Integer,String>();
	String sql = "SELECT date_format(c._date,_utf8'%W, %b %e, %Y') AS 'day', c.col_id, c.title, " +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.name,tv.ipaddress,tv.sessionid,COUNT(*) AS view_no " +
					"FROM talkview tv INNER JOIN colloquium c ON tv.col_id = c.col_id " +
					"INNER JOIN speaker s ON s.speaker_id = c.speaker_id " + 
					"WHERE " +
					" tv.viewTime >= '" + strBeginDate + " 00:00:00' " +
					"AND tv.viewTime <= '" + strEndDate + " 23:59:59' ";
		
	if(user_id_value !=null){//User Mode
		for(int i=0;i<user_id_value.length;i++){
			if(req_posted || req_impact){
				sql += "AND c.col_id IN (SELECT col_id FROM colloquium WHERE owner_id=" + user_id_value[i] + ") ";
			}else{
				sql += "AND c.col_id IN (SELECT col_id FROM userprofile WHERE user_id=" + user_id_value[i]+") ";
			}
		}
	}
	if(comm_id_value != null){//Community Mode
		for(int i=0;i<comm_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT u.col_id FROM contribute c,userprofile u WHERE u.userprofile_id = c.userprofile_id AND c.comm_id=" + comm_id_value[i] + ") ";
		}
	}
	if(tag_id_value != null){//Tag Mode
		for(int i=0;i<tag_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT u.col_id FROM tags t,userprofile u WHERE t.userprofile_id = u.userprofile_id AND t.tag_id=" + tag_id_value[i] + ") ";
		}
	}
	if(series_id_value != null){//Series Mode
		for(int i=0;i<series_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id_value[i] + ") ";
		}
	}
	if(entity_id_value != null){//Entity Mode
		for(int i=0;i<entity_id_value.length;i++){
			sql += "AND c.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ") ";
		}
	}
	if(type_value != null){//Entity Type Mode
		for(int i=0;i<type_value.length;i++){
			sql += "AND c.col_id IN (SELECT ee.col_id FROM entity e,entities ee " +
					"WHERE e.entity_id = ee.entity_id AND e._type='" + type_value[i] + "') ";
		}
	}
	if(affiliate_id_value !=null ){
		for(int i=0;i<affiliate_id_value.length;i++){
			sql += "AND c.col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac," +
					"(SELECT child_id FROM relation WHERE " +
					"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
					"WHERE ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
		}
	}
	sql += " GROUP BY date_format(c._date,_utf8'%W, %b %e, %Y'), c.col_id, c.title, " +
					"date_format(c.begintime,_utf8'%l:%i %p'), date_format(c.endtime,_utf8'%l:%i %p'), " +
					"s.name,tv.ipaddress,tv.sessionid";
	String day = "";
	//out.println(sql);
	ResultSet rs = conn.getResultSet(sql);
	
%>
	<table cellspacing="0" cellpadding="0" width="95%" align="center">
<%	
	int viewno = 0;//rs.getInt("view_no");
	int emailno = 0;
	int bookmarkno = 0;
	if(rs != null){
		while(rs.next()){
			int col_id = rs.getInt("col_id");
			String title = rs.getString("title");
			int _viewno = rs.getInt("view_no");
			viewTitleMap.put(title,col_id);
			
			String ipaddress = rs.getString("ipaddress");
			String sessionid = rs.getString("sessionid").trim().toLowerCase();
			
			int _prev_viewno = 0;
			if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
				if(viewCountMap.containsKey(col_id)){
					_prev_viewno = viewCountMap.get(col_id);
				}
				viewCountMap.put(col_id,_prev_viewno + _viewno);
				
				viewno += _viewno;
			}else{
				if(viewCountMap.containsKey(col_id)){
					_prev_viewno = viewCountMap.get(col_id);
				}
				viewCountMap.put(col_id,_prev_viewno + 1);

				viewno++;
			}

			String colDate = "<span style=\"font-size: 0.75em;\"><b>By:</b> " + rs.getString("name") + "&nbsp;" +
								"<b>on:</b> " + rs.getString("day") + " " + rs.getString("_begin")+ " - " + rs.getString("_end") + "</span>";
			viewColDateMap.put(col_id,colDate);
		}
	    /*****************************************************************/
	    /* Total emails                                                  */
	    /*****************************************************************/
	    HashMap<String,Integer> emailTitleMap = new HashMap<String,Integer>();
	    HashMap<Integer,Integer> emailCountMap = new HashMap<Integer,Integer>();
	    HashMap<Integer,String> emailColDateMap = new HashMap<Integer,String>();
	    HashMap<Integer,String> emailSenderMap = new HashMap<Integer,String>();
		sql = "SELECT date_format(c._date,_utf8'%W, %b %e, %Y') AS 'day', c.col_id, c.title, " +
				"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
				"s.name,ef.emails,u.user_id,u.name " +
				"FROM emailfriends ef INNER JOIN colloquium c ON ef.col_id = c.col_id " +
				"INNER JOIN speaker s ON c.speaker_id = s.speaker_id " +
				"INNER JOIN userinfo u ON ef.user_id = u.user_id " + 
				"WHERE ef.timesent >= '" + strBeginDate + " 00:00:00' " +
				"AND ef.timesent <= '" + strEndDate + " 23:59:59' ";		
		if(user_id_value !=null){//User Mode
			for(int i=0;i<user_id_value.length;i++){
				if(req_posted || req_impact){
					sql += "AND c.col_id IN (SELECT col_id FROM colloquium WHERE owner_id=" + user_id_value[i] + ") ";
				}else{
					sql += "AND c.col_id IN (SELECT col_id FROM userprofile WHERE user_id=" + user_id_value[i]+") ";
				}
			}
		}
		if(comm_id_value != null){//Community Mode
			for(int i=0;i<comm_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT u.col_id FROM contribute c,userprofile u WHERE u.userprofile_id = c.userprofile_id AND c.comm_id=" + comm_id_value[i] + ") ";
			}
		}
		if(tag_id_value != null){//Tag Mode
			for(int i=0;i<tag_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT u.col_id FROM tags t,userprofile u WHERE t.userprofile_id = u.userprofile_id AND t.tag_id=" + tag_id_value[i] + ") ";
			}
		}
		if(series_id_value != null){//Series Mode
			for(int i=0;i<series_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id_value[i] + ") ";
			}
		}
		if(entity_id_value != null){//Entity Mode
			for(int i=0;i<entity_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ") ";
			}
		}
		if(type_value != null){//Entity Type Mode
			for(int i=0;i<type_value.length;i++){
				sql += "AND c.col_id IN (SELECT ee.col_id FROM entity e,entities ee " +
						"WHERE e.entity_id = ee.entity_id AND e._type='" + type_value[i] + "') ";
			}
		}
		if(affiliate_id_value !=null ){
			for(int i=0;i<affiliate_id_value.length;i++){
				sql += "AND c.col_id IN " +
						"(SELECT ac.col_id FROM affiliate_col ac," +
						"(SELECT child_id FROM relation WHERE " +
						"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
						"WHERE ac.affiliate_id = cc.child_id " +
						"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
			}
		}
		sql += "";
		//out.println(sql);
		ResultSet rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			HashSet<String> setEmails = new HashSet<String>();
			HashMap<String,Integer> senderMap = new HashMap<String,Integer>();
			int _old_col_id = -1;
			while(rsExt.next()){
				int col_id = rsExt.getInt("col_id");
				String title = rsExt.getString("title");
				String colDate = "<span style=\"font-size: 0.75em;\"><b>By:</b> " + rsExt.getString("name") + "&nbsp;" +
									"<b>on:</b> " + rsExt.getString("day") + " " + 
									rsExt.getString("_begin")+ " - " + rsExt.getString("_end") + "</span>";
				String emails = rsExt.getString("emails");
				if(!emailTitleMap.containsValue(col_id)){
					if(_old_col_id > -1){
						emailCountMap.put(_old_col_id,setEmails.size());
						emailno += setEmails.size();
						
						List<String> senderList = new ArrayList<String>(senderMap.keySet());
						Collections.sort(senderList);
						String senders = "";
						for(Iterator<String> it=senderList.iterator();it.hasNext();){
							String sender = it.next();
							int user_id = senderMap.get(sender);
							senders += " <a href=\"profile.do?user_id=" + user_id + "\">" + sender + "</a>";
						}
						emailSenderMap.put(_old_col_id,senders);
					}
					senderMap.clear();
					setEmails.clear();
					emailTitleMap.put(title,col_id);
					emailColDateMap.put(col_id,colDate);
					_old_col_id = col_id;
				}
				String[] email = emails.split(",");
				if(email != null){
					for(int i=0;i<email.length;i++){
						String aEmail = email[i].trim().toLowerCase();
						setEmails.add(aEmail);
					}
					int user_id = rsExt.getInt("user_id");
					String name = rsExt.getString("name");
					senderMap.put(name,user_id);
				}
								
			}
			if(_old_col_id > -1){
				emailCountMap.put(_old_col_id,setEmails.size());
				emailno += setEmails.size();

				List<String> senderList = new ArrayList<String>(senderMap.keySet());
				Collections.sort(senderList);
				String senders = "";
				for(Iterator<String> it=senderList.iterator();it.hasNext();){
					String sender = it.next();
					int user_id = senderMap.get(sender);
					senders += " <a href=\"profile.do?user_id=" + user_id + "\">" + sender + "</a>";
				}
				emailSenderMap.put(_old_col_id,senders);
			}
		}
	    /*****************************************************************/
	    /* Total bookmarks                                               */
	    /*****************************************************************/
	    HashMap<String,Integer> bookmarkTitleMap = new HashMap<String,Integer>();
	    HashMap<Integer,Integer> bookmarkCountMap = new HashMap<Integer,Integer>();
	    HashMap<Integer,String> bookmarkColDateMap = new HashMap<Integer,String>();
	    HashMap<Integer,String> bookmarkerMap = new HashMap<Integer,String>();
		sql = "SELECT date_format(c._date,_utf8'%W, %b %e, %Y') AS 'day', c.col_id, c.title, " +
				"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
				"s.name speaker,u.user_id,u.name username,COUNT(*) _no " +
				"FROM userinfo u INNER JOIN userprofile up ON u.user_id = up.user_id " +
				"INNER JOIN colloquium c ON up.col_id = c.col_id " +
				"INNER JOIN speaker s ON c.speaker_id = s.speaker_id " +
				"WHERE u.user_id = up.user_id AND " + 
				" up.lastupdate >= '" + strBeginDate + " 00:00:00' " +
				"AND up.lastupdate <= '" + strEndDate + " 23:59:59' ";
		if(user_id_value !=null){//User Mode
			for(int i=0;i<user_id_value.length;i++){
				if(req_posted || req_impact){
					sql += "AND c.col_id IN (SELECT col_id FROM colloquium WHERE owner_id=" + user_id_value[i] + ") ";
				}else{
					sql += "AND c.col_id IN (SELECT col_id FROM userprofile WHERE user_id=" + user_id_value[i]+") ";
				}
			}
		}
		if(comm_id_value != null){//Community Mode
			for(int i=0;i<comm_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT u.col_id FROM contribute c,userprofile u WHERE u.userprofile_id = c.userprofile_id AND c.comm_id=" + comm_id_value[i] + ") ";
			}
		}
		if(tag_id_value != null){//Tag Mode
			for(int i=0;i<tag_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT u.col_id FROM tags t,userprofile u WHERE t.userprofile_id = u.userprofile_id AND t.tag_id=" + tag_id_value[i] + ") ";
			}
		}
		if(series_id_value != null){//Series Mode
			for(int i=0;i<series_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id_value[i] + ") ";
			}
		}
		if(entity_id_value != null){//Entity Mode
			for(int i=0;i<entity_id_value.length;i++){
				sql += "AND c.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ") ";
			}
		}
		if(type_value != null){//Entity Type Mode
			for(int i=0;i<type_value.length;i++){
				sql += "AND c.col_id IN (SELECT ee.col_id FROM entity e,entities ee " +
						"WHERE e.entity_id = ee.entity_id AND e._type='" + type_value[i] + "') ";
			}
		}
		if(affiliate_id_value !=null ){
			for(int i=0;i<affiliate_id_value.length;i++){
				sql += "AND c.col_id IN " +
						"(SELECT ac.col_id FROM affiliate_col ac," +
						"(SELECT child_id FROM relation WHERE " +
						"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
						"WHERE ac.affiliate_id = cc.child_id " +
						"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
			}
		}
		sql +=	" GROUP BY date_format(c._date,_utf8'%W, %b %e, %Y'), c.col_id, c.title, " +
				"date_format(c.begintime,_utf8'%l:%i %p'), date_format(c.endtime,_utf8'%l:%i %p'), " +
				"s.name,u.user_id,u.name";
		//out.println(sql);
		rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				String title = rsExt.getString("title");
				int col_id = rsExt.getInt("col_id"); 
				String user_name = rsExt.getString("username");
				int user_id = rsExt.getInt("user_id");
				int _no = rsExt.getInt("_no");
				bookmarkno += _no;
				String colDate = "<span style=\"font-size: 0.75em;\"><b>By:</b> " + rsExt.getString("speaker") + "&nbsp;" +
									"<b>on:</b> " + rsExt.getString("day") + " " + 
									rsExt.getString("_begin")+ " - " + rsExt.getString("_end") + "</span>";
				if(!bookmarkTitleMap.containsValue(col_id)){
					bookmarkTitleMap.put(title,col_id);
					bookmarkColDateMap.put(col_id,colDate);
				}
				
				int bookmark = 0;
				if(bookmarkCountMap.containsKey(col_id)){
					bookmark = bookmarkCountMap.get(col_id).intValue();
				}
				bookmark += _no;
				bookmarkCountMap.put(col_id,bookmark);
				
				String bookmarker = "";
				if(bookmarkerMap.containsKey(col_id)){
					bookmarker = bookmarkerMap.get(col_id);
				}
				bookmarker += " <a href=\"profile.do?user_id=" + user_id + "\">" + user_name + "</a>";
				bookmarkerMap.put(col_id,bookmarker);
			}
		}
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><%=strDisplayDateRange%></td>
		</tr>
<%
		if(bookmarkno > 0){
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				Total Bookmarks
			</td>
		</tr>
		<tr>
			<td>
				<table align="center" width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.8em;">
					<tr>
						<td valign="top" width="9.5%">
							<table width="100%" border="0" cellpadding="0" cellspacing="1">
<% 
			String strBookmark = "<b>" + bookmarkno + "</b><br/><span style='font-size: 0.55em;'>bookmark";
			if(bookmarkno > 1){
				strBookmark += "s";
			}
			strBookmark += "</span>";
%>
								<tr>
									<td valign="top" align="center" 
										style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
										<%=strBookmark%>
									</td>
								</tr>
							</table>
						</td>
						<td valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.95em;">
<% 
			List<String> bookmarkTitleList = new ArrayList<String>(bookmarkTitleMap.keySet());			
			Collections.sort(bookmarkTitleList);
			for(Iterator<String> it= bookmarkTitleList.iterator();it.hasNext();){
				String title = it.next();
				int col_id = bookmarkTitleMap.get(title);
				int bookmarks = bookmarkCountMap.get(col_id);

				strBookmark = "<b>" + bookmarks + "</b><br/><span style='font-size: 0.55em;'>bookmark";
				if(bookmarks > 1){
					strBookmark += "s";
				}
				strBookmark += "</span>";
				
				String colDate = bookmarkColDateMap.get(col_id);
				String bookmarkers = bookmarkerMap.get(col_id);				
%>
								<tr>
									<td valign="middle">
										<b><a href="presentColloquium.do?col_id=<%=col_id%>"><%=title%></a></b>
										<br/>
										<%=colDate%><br/>
										<span style="font-size: 0.75em;"><b>Bookmarked by:</b> <%=bookmarkers%>
									</td>
									<td valign="top" align="center" width="9.5%"> 
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td valign="top" align="center" 
													style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
													<%=strBookmark%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
<%				
			}
%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<%			
		}
		if(emailno > 0){
			String strEmail = "<b>" + emailno + "</b><br/><span style='font-size: 0.55em;'>email";
			if(emailno > 1){
				strEmail += "s";
			}
			strEmail += "</span>";
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				Total E-Mails
			</td>
		</tr>
		<tr>
			<td>
				<table align="center" width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.8em;">
					<tr>
						<td valign="top" width="9.5%">
							<table width="100%" border="0" cellpadding="0" cellspacing="1">
								<tr>
									<td valign="top" align="center" style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
										<%=strEmail%>
									</td>
								</tr>
							</table>
						</td>
						<td valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.95em;">
<% 
			List<String> emailTitleList = new ArrayList<String>(emailTitleMap.keySet());			
			Collections.sort(emailTitleList);
			for(Iterator<String> it= emailTitleList.iterator();it.hasNext();){
				String title = it.next();
				int col_id = emailTitleMap.get(title);
				int emails = emailCountMap.get(col_id);

				strEmail = "<b>" + emails + "</b><br/><span style='font-size: 0.55em;'>email";
				if(emails > 1){
					strEmail += "s";
				}
				strEmail += "</span>";
				
				String colDate = emailColDateMap.get(col_id);
				String senders = emailSenderMap.get(col_id);				
%>
								<tr>
									<td valign="middle">
										<b><a href="presentColloquium.do?col_id=<%=col_id%>"><%=title%></a></b>
										<br/>
										<%=colDate%><br/>
										<span style="font-size: 0.75em;"><b>Sender:</b> <%=senders%>
									</td>
									<td valign="top" align="center" width="9.5%"> 
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td valign="top" align="center" 
													style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
													<%=strEmail%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
<%				
			}
%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<%			
		}
		if(viewno > 0){
			String strView = "<b>" + viewno + "</b><br/><span style='font-size: 0.55em;'>view";
			if(viewno > 1){
				strView += "s";
			}
			strView += "</span>";
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				Total Views
			</td>
		</tr>
		<tr>
			<td>
				<table align="center" width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.8em;">
					<tr>
						<td valign="top" width="9.5%">
							<table width="100%" border="0" cellpadding="0" cellspacing="1" >
								<tr>
									<td valign="top" align="center" 
										style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
										<%=strView%>
									</td>
								</tr>
							</table>
						</td>
						<td valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.95em;">
<% 
			List<String> viewTitleList = new ArrayList<String>(viewTitleMap.keySet());			
			Collections.sort(viewTitleList);
			for(Iterator<String> it= viewTitleList.iterator();it.hasNext();){
				String title = it.next();
				int col_id = viewTitleMap.get(title);
				int views = viewCountMap.get(col_id);

				strView = "<b>" + views + "</b><br/><span style='font-size: 0.55em;'>view";
				if(views > 1){
					strView += "s";
				}
				strView += "</span>";
				
				String colDate = viewColDateMap.get(col_id);				
%>
								<tr>
									<td valign="middle">
										<b><a href="presentColloquium.do?col_id=<%=col_id%>"><%=title%></a></b>
										<br/>
										<%=colDate%>
									</td>
									<td valign="top" align="center" width="9.5%"> 
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td valign="top" align="center" 
													style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
													<%=strView%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
<%				
			}
%>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<%			
		}
	}
	conn.conn.close();
	conn = null;
%>
<script type="text/javascript">
	window.onload = function(){
		if(typeof divImpactContent != "undefined"){
			if(parent.displayTalks){
				//alert(divImpactContent.innerHTML);
				parent.displayTalks(divImpactContent.innerHTML);
			}
		}
	}
</script>	
<%			
	if(viewno + bookmarkno + emailno == 0){
%>
		<tr>
			<td style="font-size: 0.95em;font-weight: bold;" align="center">No Impacts</td>
		</tr>
<%	
	}
%>
	</table>
</div>