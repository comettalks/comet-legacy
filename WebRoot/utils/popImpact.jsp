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
<style type='text/css' media='all'>
 ol li{
     margin:0;
     padding:0;
     margin-left:8px;
 }
</style>

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
	boolean req_most_recent = false;
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
    if(request.getParameter("mostrecent")!=null){
    	req_most_recent = true;
	    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
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
					String tmpBeginDate = "";
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
    /* Popularity in Total Scores                                    */
    /*****************************************************************/
    ArrayList<Integer> TotalUserList = new ArrayList<Integer>();
    HashMap<Integer,String> TotalUserNameMap = new HashMap<Integer,String>();
    HashMap<Integer,Integer> TotalUserCountMap = new HashMap<Integer,Integer>();
    /*****************************************************************/
    /* Popularity on Total Views                                     */
    /*****************************************************************/
    HashMap<Integer,String> viewUserNameMap = new HashMap<Integer,String>();
    HashMap<Integer,Integer> viewUserCountMap = new HashMap<Integer,Integer>();
	String sql = "SELECT u.user_id,u.name,tv.ipaddress,tv.sessionid,COUNT(*) AS view_no " +
					"FROM talkview tv INNER JOIN colloquium c ON tv.col_id = c.col_id " +
					"INNER JOIN userinfo u ON c.owner_id = u.user_id " +
					"WHERE " +
					" tv.viewTime >= '" + strBeginDate + " 00:00:00' " +
					"AND tv.viewTime <= '" + strEndDate + " 23:59:59' ";
		
	if(comm_id_value != null){//Community Mode
		for(int i=0;i<comm_id_value.length;i++){
			sql += "AND tv.col_id IN (SELECT u.col_id FROM contribute c,userprofile u WHERE u.userprofile_id = c.userprofile_id AND c.comm_id=" + comm_id_value[i] + ") ";
		}
	}
	if(tag_id_value != null){//Tag Mode
		for(int i=0;i<tag_id_value.length;i++){
			sql += "AND tv.col_id IN (SELECT u.col_id FROM tags t,userprofile u WHERE t.userprofile_id = u.userprofile_id AND t.tag_id=" + tag_id_value[i] + ") ";
		}
	}
	if(series_id_value != null){//Series Mode
		for(int i=0;i<series_id_value.length;i++){
			sql += "AND tv.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id_value[i] + ") ";
		}
	}
	if(entity_id_value != null){//Entity Mode
		for(int i=0;i<entity_id_value.length;i++){
			sql += "AND tv.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ") ";
		}
	}
	if(type_value != null){//Entity Type Mode
		for(int i=0;i<type_value.length;i++){
			sql += "AND tv.col_id IN (SELECT ee.col_id FROM entity e,entities ee " +
					"WHERE e.entity_id = ee.entity_id AND e._type='" + type_value[i] + "') ";
		}
	}
	if(affiliate_id_value !=null ){
		for(int i=0;i<affiliate_id_value.length;i++){
			sql += "AND tv.col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac," +
					"(SELECT child_id FROM relation WHERE " +
					"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
					"WHERE ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
		}
	}
	sql += " GROUP BY u.user_id,u.name,tv.ipaddress,tv.sessionid ORDER BY COUNT(*) DESC";
	if(req_most_recent){
		sql += " LIMIT 3";
	}
	//out.println(sql);
	ResultSet rs = conn.getResultSet(sql);
	
%>
	<table cellspacing="0" cellpadding="0" width="95%" align="center">
<%	
	int viewno = 0;
	int emailno = 0;
	int bookmarkno = 0;
	if(rs != null){
		while(rs.next()){
			int user_id = rs.getInt("user_id");
			String username = rs.getString("name");
			int _viewno = rs.getInt("view_no");
			String ipaddress = rs.getString("ipaddress");
			String sessionid = rs.getString("sessionid").trim().toLowerCase();
			
			int _prev_viewno = 0;
			if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
				viewUserNameMap.put(user_id,username);
				if(viewUserCountMap.containsKey(user_id)){
					_prev_viewno = viewUserCountMap.get(user_id);
				}
				viewUserCountMap.put(user_id,_prev_viewno + _viewno);
				
				TotalUserNameMap.put(user_id,username);
				TotalUserCountMap.put(user_id,_prev_viewno + _viewno);
				
				viewno += _viewno;
			}else{
				if(viewUserCountMap.containsKey(user_id)){
					_prev_viewno = viewUserCountMap.get(user_id);
				}
				viewUserCountMap.put(user_id,_prev_viewno + 1);
				
				TotalUserNameMap.put(user_id,username);
				TotalUserCountMap.put(user_id,_prev_viewno + 1);

				viewno++;
			}

		}
	    /*****************************************************************/
	    /* Popularity on Total emails                                    */
	    /*****************************************************************/
	    HashMap<Integer,String> emailUserNameMap = new HashMap<Integer,String>();
	    HashMap<Integer,Integer> emailUserCountMap = new HashMap<Integer,Integer>();
		sql = "SELECT u.user_id,u.name,ef.emails " +
				"FROM emailfriends ef INNER JOIN colloquium c ON ef.col_id = c.col_id " +
				"INNER JOIN userinfo u ON c.owner_id = u.user_id " + 
				"WHERE ef.timesent >= '" + strBeginDate + " 00:00:00' " +
				"AND ef.timesent <= '" + strEndDate + " 23:59:59' ";		
		if(comm_id_value != null){//Community Mode
			for(int i=0;i<comm_id_value.length;i++){
				sql += "AND ef.col_id IN (SELECT u.col_id FROM contribute c,userprofile u WHERE u.userprofile_id = c.userprofile_id AND c.comm_id=" + comm_id_value[i] + ") ";
			}
		}
		if(tag_id_value != null){//Tag Mode
			for(int i=0;i<tag_id_value.length;i++){
				sql += "AND ef.col_id IN (SELECT u.col_id FROM tags t,userprofile u WHERE t.userprofile_id = u.userprofile_id AND t.tag_id=" + tag_id_value[i] + ") ";
			}
		}
		if(series_id_value != null){//Series Mode
			for(int i=0;i<series_id_value.length;i++){
				sql += "AND ef.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id_value[i] + ") ";
			}
		}
		if(entity_id_value != null){//Entity Mode
			for(int i=0;i<entity_id_value.length;i++){
				sql += "AND ef.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ") ";
			}
		}
		if(type_value != null){//Entity Type Mode
			for(int i=0;i<type_value.length;i++){
				sql += "AND ef.col_id IN (SELECT ee.col_id FROM entity e,entities ee " +
						"WHERE e.entity_id = ee.entity_id AND e._type='" + type_value[i] + "') ";
			}
		}
		if(affiliate_id_value !=null ){
			for(int i=0;i<affiliate_id_value.length;i++){
				sql += "AND ef.col_id IN " +
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
			while(rsExt.next()){
				int user_id = rsExt.getInt("user_id");
				String username = rsExt.getString("name");
				String emails = rsExt.getString("emails");
				if(!emailUserNameMap.containsKey(user_id)){
					emailUserNameMap.put(user_id,username);
					
					if(!TotalUserNameMap.containsKey(user_id)){
						TotalUserNameMap.put(user_id,username);
					}
					
					setEmails.clear();
				}
				String[] email = emails.split(",");
				if(email != null){
					for(int i=0;i<email.length;i++){
						String aEmail = email[i].trim().toLowerCase();
						setEmails.add(aEmail);
					}
					int _emailno = 0;
					if(emailUserCountMap.containsKey(user_id)){
						_emailno = emailUserCountMap.get(user_id);
					}
					_emailno += setEmails.size();
					emailUserCountMap.put(user_id,_emailno);
					int totalno = 0;
					if(TotalUserCountMap.containsKey(user_id)){
						totalno = TotalUserCountMap.get(user_id);
					}
					TotalUserCountMap.put(user_id,totalno + 2*_emailno);
					emailno += _emailno;
				}						
			}
			/*if(emailUserCountMap.size() > 0){
			}*/
		}
	    /*****************************************************************/
	    /* Total bookmarks                                               */
	    /*****************************************************************/
	    HashMap<Integer,String> bookmarkUserNameMap = new HashMap<Integer,String>();
	    HashMap<Integer,Integer> bookmarkUserCountMap = new HashMap<Integer,Integer>();
		sql = "SELECT u.user_id,u.name,COUNT(*) _no " +
				"FROM userprofile up INNER JOIN colloquium c ON up.col_id = c.col_id " +
				"INNER JOIN userinfo u ON c.owner_id = u.user_id " +
				"WHERE " + 
				" up.lastupdate >= '" + strBeginDate + " 00:00:00' " +
				"AND up.lastupdate <= '" + strEndDate + " 23:59:59' ";
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
		sql +=	" GROUP BY u.user_id,u.name ORDER BY COUNT(*) DESC";
		if(req_most_recent){
			sql += " LIMIT 3";
		}
		//out.println(sql);
		rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				String user_name = rsExt.getString("name");
				int user_id = rsExt.getInt("user_id");
				int _no = rsExt.getInt("_no");
				bookmarkno += _no;
				bookmarkUserNameMap.put(user_id,user_name);
				bookmarkUserCountMap.put(user_id,_no);
				
				if(!TotalUserNameMap.containsKey(user_id)){
					TotalUserNameMap.put(user_id,user_name);
				}
				int totalno = 0;
				if(TotalUserCountMap.containsKey(user_id)){
					totalno = TotalUserCountMap.get(user_id);
				}
				TotalUserCountMap.put(user_id,totalno + 3*_no);
			}
		}

		
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><%=strDisplayDateRange%></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				Impact Summary
			</td>
		</tr>
		<tr>
			<td width="100%">
				<ol>
<% 
		if(TotalUserCountMap.size() > 0){
			ArrayList<Integer> TotalList = new ArrayList<Integer>();
			//Sort total counts DESC
		    HashMap<Integer,Integer> TotalUserCountTempMap = new HashMap<Integer,Integer>();

			List<Integer> userList = new ArrayList<Integer>(TotalUserCountMap.keySet());
			List<Integer> countList = new ArrayList<Integer>(TotalUserCountMap.values());
			Collections.sort(userList);
			Collections.sort(countList);
			Collections.reverse(countList);
			Iterator<Integer> valueIt = countList.iterator();
			while(valueIt.hasNext()){
				Integer value = valueIt.next();
				Iterator<Integer> keyIt = userList.iterator();
				while(keyIt.hasNext()){
					Integer key = keyIt.next();
					if(TotalUserCountMap.get(key).toString().equals(value.toString())){
						TotalUserCountMap.remove(key);
						userList.remove(key);
						TotalList.add(key.intValue());
						TotalUserCountTempMap.put(key,value);
						break;
					}
				}
			}
			TotalUserCountMap.clear();
			for(Iterator<Integer> it=TotalUserCountTempMap.keySet().iterator();it.hasNext();){
				int user_id = it.next();
				int _totalno = TotalUserCountTempMap.get(user_id);
				TotalUserCountMap.put(user_id,_totalno);
			}
			for(int i=0;i<TotalList.size();i++){
				int user_id = TotalList.get(i);
				String username = TotalUserNameMap.get(user_id);
				int totalno = TotalUserCountMap.get(user_id);
				
				String strBookmark = "";
				String strEmail = "";
				String strView = "";
				String strTotal = "";
				
				//Bookmark No
				if(bookmarkUserCountMap.containsKey(user_id)){
					int _bookmarkno = bookmarkUserCountMap.get(user_id);

					strBookmark = "<b>" + _bookmarkno + "</b><br/><span style='font-size: 0.55em;'>bookmark";
					if(_bookmarkno > 1){
						strBookmark += "s";
					}
					strBookmark += "</span>";
				}
				
				//Email No
				if(emailUserCountMap.containsKey(user_id)){
					int _emailno = emailUserCountMap.get(user_id);
					
					strEmail = "<b>" + _emailno + "</b><br/><span style='font-size: 0.55em;'>email";
					if(_emailno > 1){
						strEmail += "s";
					}
					strEmail += "</span>";
				}
				
				//View No
				if(viewUserCountMap.containsKey(user_id)){
					int _viewno = viewUserCountMap.get(user_id);

					strView = "<b>" + _viewno + "</b><br/><span style='font-size: 0.55em;'>view";
					if(_viewno > 1){
						strView += "s";
					}
					strView += "</span>";
				}

				//Comet No
				strTotal = "<b>" + totalno + "</b><br/><span style='font-size: 0.55em;'>comet";
				if(totalno > 1){
					strTotal += "s";
				}
				strTotal += "</span>";
%>
					<li>
						<table width="90%" cellpadding="0" cellspacing="1" border="0" style="font-size: 0.8em;">
							<tr>
								<td valign="bottom" >
									<a href="profile.do?user_id=<%=user_id%>"><%=username%></a>
								</td>
<% 
				if(strBookmark.length() > 0){
%>
								<td width="20" align="center"> 3 * </td>
								<td valign="top" align="center" width="40"
									style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
									<%=strBookmark%>
								</td>
<% 
				}
				if(strEmail.length() > 0){
 					if(strBookmark.length() > 0){
%>
								<td width="10" align="center"> + </td>
<%						
					}
 %>
								<td width="20" align="center"> 2 * </td>
								<td valign="top" align="center" width="40"
									style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
									<%=strEmail%>
								</td>
<% 
				}
				if(strView.length() > 0){
					if(strBookmark.length() > 0 || strEmail.length() > 0){
%>
								<td width="10" align="center"> + </td>
<%						
					}
%>
								<td valign="top" align="center" width="40"
									style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
									<%=strView%>
								</td>
<%				
				}
%>
								<td width="10" align="center"> = </td>
								<td valign="top" align="center" width="40"
									style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #ffd700;color: #fff;">
									<%=strTotal%>
								</td>
							</tr>
						</table>
					</li>
<%				
			}
%>				
				</ol>
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
		if(divImpactContent){
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