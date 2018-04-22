<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="org.apache.commons.lang.StringUtils"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"> 
</script> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"> 
</script> 
<% 
	final String[] months = {"January","February","March",
		    "April","May","June",
		    "July","August","September",
		    "October","November","December"};
	String insertFirst = (String)request.getParameter("insertfirst");
	String appendLast = (String)request.getParameter("appendlast");
	int num = 0;
%>
<style>
	img.speakerImg {
	    display: block;
	    margin-left: auto;
	    margin-right: auto;
	}

</style>
<script type="text/javascript">

<!--
window.onload = function(){
<%
	if(insertFirst!=null){
%>	
	if(typeof $('#divTalkContent') != "undefined"){
		if(typeof parent.insertTalks != "undefined"){
			parent.insertTalks($("#divTalkContent").html());
		}
	}
<% 
	}else if(appendLast!=null){
%>	
	if(typeof $('#divTalkContent') != "undefined"){
		if(typeof parent.appendTalks != "undefined"){
			parent.appendTalks($('#divTalkContent').html());
		}
	}
<% 
	}else{
%>	
	if(typeof $('#divTalkContent') != "undefined"){
		if(typeof parent.displayTalks != "undefined"){
			parent.displayTalks($('#divTalkContent').html());
		}
	}
<% 
	}
%>
}

//-->
	
</script>


<div id="divTalkContent">
<% 
	connectDB conn = new connectDB();
	session = request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
    Calendar calendar = new GregorianCalendar();
    int month = calendar.get(Calendar.MONTH);
    int year = calendar.get(Calendar.YEAR);
    int this_year = year;
    int req_day = -1;
    int req_week = -1;
    int req_month = month+1;
    int req_year = year;
    boolean isdebug = false;
	boolean req_specific_date = false;
	boolean req_recommend = false;
    boolean req_posted = false;//True means user posts' talks
	boolean req_impact = false;//True means user impact
	boolean req_most_recent = false;
	boolean req_pop_recent = false;
	boolean searchResult = false;
	boolean req_top_comet = false;
	boolean req_top_video = false;
	boolean req_top_slide = false;
	boolean req_concise = false;
	boolean SortByTime = false;
	boolean req_no_header = false;
	String newOldTalks = "";
	int start=0;
	int end = 0;
	int length=0;
	int req_start = 0;
	int req_rows = 20;
	int req_speaker_id = 0;
	int req_bookmarked_alike_col_id = 0;
	int req_viewed_alike_col_id = 0;
	String[] user_id_value = request.getParameterValues("user_id");
	String[] tag_id_value = request.getParameterValues("tag_id");
	//String[] entity_id_value = request.getParameterValues("entity_id");
	//String[] type_value = request.getParameterValues("_type");
	String[] series_id_value = request.getParameterValues("series_id");
	String[] comm_id_value = request.getParameterValues("comm_id");
	String[] affiliate_id_value = request.getParameterValues("affiliate_id");
	String[] area_id_value = request.getParameterValues("area_id");
	
	//Wenyuan, researcharea modification, for BOOKMARK
	String[] bk_rs_id_value = request.getParameterValues("bk_rs_id");
	//modified on 11.12.2014 
	//Wenyuan-11.15.2014.start
		String[] affiliate_rs_id_value = request.getParameterValues("affiliate_rs_id");
		String[] host_rs_id_value = request.getParameterValues("host_rs_id");
		String[] speaker_rs_id_value = request.getParameterValues("speaker_rs_id");
		String[] group_rs_id_value = request.getParameterValues("group_rs_id");
		String[] series_rs_id_value = request.getParameterValues("series_rs_id");
		String[] owner_rs_id_value = request.getParameterValues("owner_rs_id");
		String[] location_rs_id_value = request.getParameterValues("location_rs_id");
	//Wenyuan-11.15.2014.end
						
    if(request.getParameter("day")!=null){
        req_day = Integer.parseInt(request.getParameter("day"));
        req_specific_date = true;
        //out.println("d:" + req_day);
    }
    
    if(request.getParameter("week")!=null){
        req_week = Integer.parseInt(request.getParameter("week"));
        req_specific_date = true;
        //out.println("w:" + req_week);
    }
    
    if(request.getParameter("month")!=null){
        req_month = Integer.parseInt(request.getParameter("month"));
        req_specific_date = true;
        //out.println("m:" + req_month);
    }
    
    if(request.getParameter("year")!=null){
        req_year = Integer.parseInt(request.getParameter("year"));
        req_specific_date = true;
        //out.println("y:" + req_year);
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
        //out.println("mostrecent");
    	req_most_recent = true;
        req_specific_date = true;
        String sql = "SELECT MIN(_date) mindate FROM colloquium WHERE _date >= CURDATE()";
        ResultSet rs = conn.getResultSet(sql);
        if(rs.next()){
        	Date mindate = rs.getDate("mindate");
        	if(mindate == null){
        		mindate = new Date();
        	}
        	calendar.setTime(mindate);
        	req_day = calendar.get(Calendar.DAY_OF_MONTH);
        	req_month = calendar.get(Calendar.MONTH) + 1;
        	req_year = calendar.get(Calendar.YEAR);
        }else{
    	    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
        }
    }
    if(request.getParameter("noheader")!=null){
    	req_no_header = true;
    }
    if(request.getParameter("recommend")!=null){
    	req_recommend = true;
    }
    if(request.getParameter("poprecent")!=null){
    	req_pop_recent = true;
    }
    if(request.getParameter("concise")!=null){
    	req_concise = true;
    }
    if(request.getParameter("isdebug")!=null){
    	isdebug = true;
    }
    if(request.getParameter("searchResult") != null){
    	searchResult = true;
    }
    if(request.getParameter("topcomet") != null){
    	req_top_comet = true;
    }
    if(request.getParameter("topvideo") != null){
    	req_top_video = true;
    }
    if(request.getParameter("topslide") != null){
    	req_top_slide = true;
    }
    if(request.getParameter("speaker_id") != null){
    	req_speaker_id = Integer.parseInt(request.getParameter("speaker_id"));
    }
    if(request.getParameter("bookmarked_alike_col_id") != null){
    	req_bookmarked_alike_col_id = Integer.parseInt(request.getParameter("bookmarked_alike_col_id"));
    }
    if(request.getParameter("viewed_alike_col_id") != null){
    	req_viewed_alike_col_id = Integer.parseInt(request.getParameter("viewed_alike_col_id"));
    }
    if(request.getParameter("start") != null){
		req_start = Integer.parseInt((String)request.getParameter("start"));
    }
    if(request.getParameter("rows") != null){
		req_rows = Integer.parseInt((String)request.getParameter("rows"));
    }
	if(session.getAttribute("SortByTime") != null){
		start = (Integer)session.getAttribute("startIndex")-1;
 	 	end = (Integer)session.getAttribute("endIndex")-1;
 	 	length = start + end + 1;
		SortByTime = true;
    }
    
	if(session.getAttribute("newOldTalks") != null){
    	newOldTalks = (String)session.getAttribute("newOldTalks");
    }
    
	String menu = (String)session.getAttribute("menu");
	if(menu == null){
		menu = "home";
	}
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
	}else if(menu.equalsIgnoreCase("affiliate")||menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("community")){
		req_specific_date = true;
		if(appendLast==null){
			req_day = calendar.get(Calendar.DAY_OF_MONTH);
			req_month = month+1;
			req_year = year;
		}
	}else if(menu.equalsIgnoreCase("calendar") && req_day==-1 && req_week==-1 && req_month == month+1 && req_year==year){
        req_specific_date = true;
        /*if(req_recommend){
			req_week = calendar.get(Calendar.WEEK_OF_MONTH);
        }*/
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
				strDisplayDateRange = "Month: " + months[req_month-1] + " 1, " + req_year;
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

//=================================================================
// Recommendation Part
//=================================================================
	HashSet<Integer> recSet = null;
	HashMap<Integer,HashMap<Integer,Integer>> recRankMapMap = new HashMap<Integer,HashMap<Integer,Integer>>();
	HashMap<Integer,HashMap<Integer,Double>> recRatingMapMap = new HashMap<Integer,HashMap<Integer,Double>>();
	if(ub != null){
		if(ub.getRecSet() != null){
			recSet = ub.getRecSet();
		}else{
			recSet = new HashSet<Integer>();
		}
		
		//Clear recommendation hashset
		String sql = "SELECT col_id FROM colloquium WHERE _date>='" + strBeginDate + "' AND _date<='" + strEndDate + "'";
		if(isdebug)out.println(sql);
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			int col_id = rs.getInt("col_id");
			recSet.remove(new Integer(col_id));
		}

	    setcal.set(req_year, req_month-1, 1);
		String strRecBeginDate = "";
		String strRecEndDate = "";
		/*****************************************************************/
		/* Day or Week View                                                      */
		/*****************************************************************/
		if(req_day > 0 || req_week > 0){
			if(req_day > 0){
			    setcal.set(req_year, req_month-1, req_day);
			}
			int week_no = setcal.get(Calendar.WEEK_OF_MONTH);
			if(req_week > 0){
				week_no = req_week;
			}
			//Calcuate begin date first
			if(startday == 0){//Is Sunday?
				strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no-1) + 1);
			}else{//Not Sunday
				if(week_no == 1){//Is the first week of month?
					if(req_month == 1){//January?
				    	setcal.set(req_year-1, 11, 1);
				    }else{
				    	setcal.set(req_year, req_month-2, 1);
				    }  
				    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);				
					int rec_prev_month = req_month-1;
					int rec_year = req_year;
					if(rec_prev_month == 0){
						rec_prev_month = 12;
						rec_year = req_year - 1;
					}
					strRecBeginDate = rec_year + "-" + (rec_prev_month) + "-" + (daysPrevMonth - startday + 1);		
				}else{//Not the first week
					strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no - 1) - startday + 1);
				}
			}
			
			//Calculate end date second
			if(7*week_no - startday <= stopday ){
				strRecEndDate = req_year + "-" + req_month + "-" + (7*week_no - startday);			
			}else{
				if(req_month == 12){
					strRecEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strRecEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
				}
			}
			/*sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (1,2) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 5";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				recSet.add(col_id);
			}*/		

			/*sql = "SELECT GROUP_CONCAT(DISTINCT c.col_id SEPARATOR ',') " +
					"FROM colloquium c JOIN userprofile up ON c.col_id=up.col_id " +
					"WHERE up.user_id=" + ub.getUserID() +
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' ";
			String bookmarkTalkList = "";
			rs = conn.getResultSet(sql);
			if(rs.next()){
				bookmarkTalkList = rs.getString(1);
			}*/
			
			//Fetch user recommendation method 1,2
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (1,2) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			int i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
			
			//Fetch user recommendation method 4,5
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (4,5) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}

			//Fetch user recommendation method 6,7
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (6,7) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}

			//Fetch user recommendation method 8,9
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (8,9) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}

			//Fetch user recommendation method 10,11
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (10,11) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}

			//Fetch user recommendation method 12,13 -- KMeans Centroid
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (12,13) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 14,15 -- KMeans KNN
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (14,15) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 16,17 -- KMeans Centroid Metadata
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (16,17) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 18,19 -- KMeans KNN Metadata
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (18,19) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 20,21 -- SOM Centroid
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (20,21) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 22,23 -- SOM KNN
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (22,23) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 24,25 -- SOM Centroid Metadata
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (24,25) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 26,27 -- SOM KNN Metadata
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (26,27) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 28,29 -- KMedoids Centroid
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (28,29) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 30,31 -- KMedoids KNN
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (30,31) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 32,33 -- KMedoids Centroid Metadata
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (32,33) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 34,35 -- KMedoids KNN Metadata
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (34,35) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
			
			//Fetch user recommendation method 36,37 -- KNN CiteULike
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (36,37) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 38,39 -- KNN CiteULike -- title only
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (38,39) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 40,41 -- SVD KNN CiteULike
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (40,41) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 42,43 -- SVD KNN CiteULike
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (42,43) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
			//Fetch user recommendation method 500,501 -- CBCF Keyword
			sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (500,501) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 1";
			rs = conn.getResultSet(sql);
			if(isdebug)out.println(sql);
			i = 1;
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				int rec_method_id = rs.getInt("rec_method_id");
				recSet.add(col_id);
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
				if(recRankMap==null){
					recRankMap = new HashMap<Integer,Integer>();
				}
				recRankMap.put(rec_method_id,i);
				recRankMapMap.put(col_id,recRankMap);
				i++;

				String rating = rs.getString("rating");
				if(rating != null){
					HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
					if(recRatingMap==null){
						recRatingMap = new HashMap<Integer,Double>();
					}
					recRatingMap.put(rec_method_id,Double.parseDouble(rating));
					recRatingMapMap.put(col_id,recRatingMap);
				}
			}
		
		}else{
	    /*****************************************************************/
	    /* Month View                                                    */
	    /*****************************************************************/
	    	for(int i=0;i<6;i++){//No more than 6 weeks a month

				int week_no = i;
				
				//Calculate begin date first
				if(startday == 0){//Is Sunday?
					strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no-1) + 1);
				}else{//Not Sunday
					if(week_no == 1){//Is the first week of month?
						if(req_month == 1){//January?
					    	setcal.set(req_year-1, 11, 1);
					    }else{
					    	setcal.set(req_year, req_month-2, 1);
					    }  
					    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);				
						int rec_prev_month = req_month-1;
						int rec_year = req_year;
						if(rec_prev_month == 0){
							rec_prev_month = 12;
							rec_year = req_year - 1;
						}
						strRecBeginDate = rec_year + "-" + (rec_prev_month) + "-" + (daysPrevMonth - startday + 1);		
					}else{//Not the first week
						strRecBeginDate = req_year + "-" + req_month + "-" + (7*(week_no - 1) - startday + 1);
					}
				}
				
				//Get out of the for loop if begin date is beyond that month
				if((7*(week_no - 1) - startday + 1) > stopday){
					break;
				}
				
				//Then calculate the end date
				if(7*week_no - startday <= stopday ){
					strRecEndDate = req_year + "-" + req_month + "-" + (7*week_no - startday);			
				}else{
					if(req_month == 12){
						strRecEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
					}else{
						strRecEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
					}
				}

				/*sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (1,2) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					recSet.add(col_id);
				}*/		
				/*sql = "SELECT GROUP_CONCAT(DISTINCT c.col_id SEPARATOR ',') " +
						"FROM colloquium c JOIN userprofile up ON c.col_id=up.col_id " +
						"WHERE up.user_id=" + ub.getUserID() +
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' ";
				String bookmarkTalkList = "";
				rs = conn.getResultSet(sql);
				if(rs.next()){
					bookmarkTalkList = rs.getString(1);
				}*/
				
				//Fetch user recommendation method 1,2
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (1,2) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				int ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
				
				//Fetch user recommendation method 4,5
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (4,5) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
		
				//Fetch user recommendation method 6,7
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (6,7) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}

				//Fetch user recommendation method 8,9
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (8,9) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}

				//Fetch user recommendation method 10,11
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (10,11) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
				
				//Fetch user recommendation method 12,13 -- KMeans Centroid
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (12,13) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 14,15 -- KMeans KNN
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (14,15) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 16,17 -- KMeans Centroid Metadata
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (16,17) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 18,19 -- KMeans KNN Metadata
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (18,19) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 20,21 -- SOM Centroid
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (20,21) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					i++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 22,23 -- SOM KNN
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (22,23) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					i++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 24,25 -- SOM Centroid Metadata
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (24,25) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 26,27 -- SOM KNN Metadata
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (26,27) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 28,29 -- KMedoids Centroid
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (28,29) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 30,31 -- KMedoids KNN
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (30,31) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 32,33 -- KMedoids Centroid Metadata
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (32,33) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 34,35 -- KMedoids KNN Metadata
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (34,35) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
				
				//Fetch user recommendation method 36,37 -- KNN CiteULike
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (36,37) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 38,39 -- KNN CiteULike -- title only
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (38,39) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 40,41 -- SVD Centroid CiteULike
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (40,41) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 42,43 -- KNN CiteULike
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (42,43) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,ii);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
				//Fetch user recommendation method 500,501 -- CBCF Keyword
				sql = "SELECT SQL_CACHE c.col_id,ru.rec_method_id,ru.rating FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (500,501) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 1";
				rs = conn.getResultSet(sql);
				if(isdebug)out.println(sql);
				ii = 1;
				while(rs.next()){
					int col_id = rs.getInt("col_id");
					int rec_method_id = rs.getInt("rec_method_id");
					recSet.add(col_id);
					HashMap<Integer,Integer> recRankMap = recRankMapMap.get(col_id);
					if(recRankMap==null){
						recRankMap = new HashMap<Integer,Integer>();
					}
					recRankMap.put(rec_method_id,i);
					recRankMapMap.put(col_id,recRankMap);
					ii++;

					String rating = rs.getString("rating");
					if(rating != null){
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(col_id);
						if(recRatingMap==null){
							recRatingMap = new HashMap<Integer,Double>();
						}
						recRatingMap.put(rec_method_id,Double.parseDouble(rating));
						recRatingMapMap.put(col_id,recRatingMap);
					}
				}
			
	    	}

	    }
	}
//=================================================================
// ~ Recommendation Part
//=================================================================

	//Search Result Part
	ArrayList<Long> searchList = new ArrayList<Long>();
	if(searchResult){
		searchList = (ArrayList<Long>)session.getAttribute("searchResultList");
	}
	
	Date mindate = new Date();
	if(menu.equalsIgnoreCase("calendar")){
		String sql = "SELECT SQL_CACHE MIN(_date) mindate FROM colloquium WHERE _date >= CURDATE()";
	    ResultSet rs = conn.getResultSet(sql);
	    if(rs.next()){
	    	mindate = rs.getDate("mindate");
	    }
	}

	String sql = "SELECT SQL_CACHE date_format(c._date,_utf8'%W, %b %d') `day`, c.col_id, c.title, " +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.speaker_id,s.name,c.location,c.video_url,s.affiliation, " +
					"date_format(c._date,_utf8'%Y') _year,c.slide_url,s.picURL,(c._date = CURDATE()) _istoday,c.paper_url,c._date " +
					"FROM colloquium c LEFT JOIN speaker s ON c.speaker_id = s.speaker_id ";// +
					//"JOIN userinfo u ON c.owner_id = u.user_id ";// +
					//"LEFT JOIN host h ON c.host_id = h.host_id " +
					//"LEFT JOIN loc_col lc ON c.col_id = lc.col_id ";// +
					//"WHERE TRUE ";// +
					//"c._date >= (SELECT beginterm FROM sys_config) " +
					//"AND c._date <= (SELECT endterm FROM sys_config) ";
	if(req_posted){
		sql = "SELECT SQL_CACHE date_format(pt.posttime,_utf8'%W, %b %d') `day`, c.col_id, c.title, " +
				"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
				"s.speaker_id,s.name,c.location,c.video_url,s.affiliation, " +
				"date_format(c._date,_utf8'%Y') _year,c.slide_url,s.picURL,(c._date = CURDATE()) _istoday,c.paper_url,c._date " +
				"FROM colloquium c LEFT JOIN speaker s ON c.speaker_id = s.speaker_id " +
				//"JOIN userinfo u ON c.owner_id = u.user_id " +
				"JOIN " +
				"(SELECT col_id,MIN(lastupdate) posttime FROM " +
				" (SELECT col_id,MIN(lastupdate) lastupdate FROM col_bk GROUP BY col_id " +
				" UNION " +
				" SELECT col_id,lastupdate FROM colloquium) tpost " +
				"GROUP BY col_id) pt ON c.col_id = pt.col_id ";// +
				//"LEFT JOIN host h ON c.host_id = h.host_id " +
				//"LEFT JOIN loc_col lc ON c.col_id = lc.col_id ";// +
				//"WHERE TRUE ";
	}
		
	if(user_id_value !=null){//User Mode
		for(int i=0;i<user_id_value.length;i++){
			if(req_posted){
				sql += "JOIN colloquium cc" + i + " ON c.col_id=cc" + i + ".col_id AND cc"+ i + ".owner_id = " + user_id_value[i] + " ";
			}else{
				sql += "JOIN userprofile up" + i + " ON c.col_id=up" + i + ".col_id AND up" + i + ".user_id = " + user_id_value[i] + " ";
			}
		}
	}
	if(comm_id_value != null){//Community Mode
		for(int i=0;i<comm_id_value.length;i++){
			sql += //"JOIN userprofile upc" + i + " ON c.col_id=upc" + i + ".col_id " +
					"JOIN contribute ct" + i + " ON c.col_id=ct" + i + ".col_id " + 
					"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
		}
		//sql += "AND c._date >= (SELECT beginterm FROM sys_config) AND c._date < (SELECT endterm FROM sys_config) ";
	}
	if(tag_id_value != null){//Tag Mode
		for(int i=0;i<tag_id_value.length;i++){
			sql += "JOIN tags tt" + i + " ON c.col_id=tt" + i + ".col_id " + 
					"AND tt" + i + ".tag_id = " + tag_id_value[i] + " ";
		}
	}
	if(series_id_value != null){//Series Mode
		for(int i=0;i<series_id_value.length;i++){
			sql += "JOIN seriescol sc" + i + " ON c.col_id = sc" + i + ".col_id AND sc" + i + ".series_id=" + series_id_value[i] + " ";
		}
		//sql += "AND c._date >= (SELECT beginterm FROM sys_config) AND c._date < (SELECT endterm FROM sys_config) ";
	}
	/*if(entity_id_value != null){//Entity Mode
		for(int i=0;i<entity_id_value.length;i++){
			sql += "JOIN entities ee" + i + " ON c.col_id = ee" + i + ".col_id AND ee" + i + ".entity_id = " + entity_id_value[i] + " ";
		}
	}
	if(type_value != null){//Entity Type Mode
		for(int i=0;i<type_value.length;i++){
			sql += "JOIN entities eee" + i + " ON c.col_id = eee" + i + ".col_id JOIN entity e" + i + " ON " +
			"e" + i + ".entity_id = eee" + i + ".entity_id AND e" + i + "._type = '" + type_value[i] + "' ";
		}
	}*/
	if(area_id_value!=null&&area_id_value.length>0){
		for(int i=0;i<area_id_value.length;i++){
			if(!area_id_value[i].equalsIgnoreCase("0")){
				sql += "JOIN area_col ac" + i + " ON c.col_id=ac" + i+ ".col_id AND ac" + i + ".area_id=" + area_id_value[i] + " ";
			}
		}
	}
	
	//Wenyuan-11.22.2014.start
	//researcharea modification
	String relation_path = "%";
	if (affiliate_rs_id_value != null && affiliate_rs_id_value.length>0) {
		if (affiliate_rs_id_value.length == 1) {
			if (!affiliate_rs_id_value[0].equals("0")) {
				relation_path = affiliate_rs_id_value[0] + relation_path;
			}
		} else if (affiliate_rs_id_value.length == 2) {
			if (affiliate_rs_id_value[1].equals("-1")) {
				relation_path =  affiliate_rs_id_value[0] + "";
			} else {
			    relation_path = affiliate_rs_id_value[1] + ","+ affiliate_rs_id_value[0] + "%";
			}
		} else if (affiliate_rs_id_value.length == 3) {
			if (affiliate_rs_id_value[2].equals("-1")) {
				relation_path = affiliate_rs_id_value[1] + "," + affiliate_rs_id_value[0] + "";
			}
			else {
			    relation_path = affiliate_rs_id_value[1] + "," +affiliate_rs_id_value[2] + ","+ affiliate_rs_id_value[0] + "";
			}
		}
	}

	if(affiliate_rs_id_value !=null && affiliate_rs_id_value.length>0){
		if (!affiliate_rs_id_value[0].equals("0")) {
		    System.out.println("gyanchen"+relation_path);
		    
			sql += "JOIN (SELECT DISTINCT ac.col_id as col_id FROM affiliate_col ac JOIN relation r on ac.affiliate_id = r.child_id WHERE path LIKE '" + relation_path + "')afr ON c.col_id = afr.col_id ";
		}
	}
	
	if(group_rs_id_value !=null && group_rs_id_value.length>0){
		for(int i=0;i<group_rs_id_value.length;i++){
			if(!group_rs_id_value[i].equalsIgnoreCase("0")){
				sql += "JOIN (SELECT comm_id, col_id FROM contribute) ctb" +i+ " ON c.col_id=ctb" +i+ ".col_id AND ctb" +i+ ".comm_id=" +group_rs_id_value[i] + " ";
			}
		}
	}
	
	if(series_rs_id_value !=null && series_rs_id_value.length>0){
		for(int i=0; i<series_rs_id_value.length; i++){
			if(!series_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " JOIN seriescol scl" +i+ " ON c.col_id=scl" +i+ ".col_id AND scl" +i+ ".series_id=" +series_rs_id_value[i] + " ";
			}
		}
	}
	if(location_rs_id_value !=null && location_rs_id_value.length>0){
		for(int i=0; i<location_rs_id_value.length; i++){
			if(!location_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " JOIN location_col_copy lcc" +i+ " ON c.col_id=lcc" +i+ ".col_id AND lcc" +i+ ".loc_id=" +location_rs_id_value[i] + " ";
			}
		}
	}
	//Wenyuan-11.22.2014.end
	
	if(req_top_comet || req_top_video || req_top_slide || req_most_recent||req_pop_recent||req_bookmarked_alike_col_id>0||req_viewed_alike_col_id>0){
		sql += "JOIN col_impact ci ON ci.col_id= c.col_id ";
	}
	if(req_speaker_id>0){
		sql += "JOIN col_speaker cs ON c.col_id=cs.col_id AND cs.speaker_id=" + req_speaker_id + " ";
	}
	if(req_bookmarked_alike_col_id>0){
		sql += "JOIN userprofile up ON c.col_id=up.col_id AND c._date > CURDATE() AND c.col_id<>" + req_bookmarked_alike_col_id +
				" JOIN (SELECT user_id FROM userprofile WHERE col_id=" + req_bookmarked_alike_col_id + ") up0 " +
				"ON up0.user_id=up.user_id ";
	}
	if(req_viewed_alike_col_id>0){
		sql += "JOIN talkview tv ON c.col_id=tv.col_id AND c._date > CURDATE() AND c.col_id<>" + req_viewed_alike_col_id +
				" JOIN (SELECT user_id FROM talkview WHERE col_id=" + req_viewed_alike_col_id + ") tv0 " +
				"ON tv0.user_id=tv.user_id ";
	}
	
	sql += //"LEFT JOIN host h ON c.host_id = h.host_id " +
			//"LEFT JOIN loc_col lc ON c.col_id = lc.col_id " +
			"WHERE TRUE ";
	if(req_top_video){
		sql += "AND c.video_url IS NOT NULL and LENGTH(TRIM(c.video_url)) > 0 ";
		if(req_concise){
			sql += " AND DATEDIFF(CURDATE(),c._date) <= 90 ";
		}
	}
	if(req_top_slide){
		sql += "AND c.video_url IS NOT NULL and LENGTH(TRIM(c.slide_url)) > 0 ";
	}
	if(affiliate_id_value !=null ){
		for(int i=0;i<affiliate_id_value.length;i++){
			sql += "AND c.col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac JOIN " +
					"(SELECT child_id FROM relation WHERE " +
					"path LIKE CONCAT((SELECT path FROM relation WHERE child_id="+ affiliate_id_value[i] + "),',%')) cc " +
					"ON ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id_value[i] + ") ";
		}
	}
	if(searchResult&&searchList.size()>0){
		sql += " AND c.col_id IN ( ";
		for (long a: searchList){
		 	sql += "" + a + ",";
		}
		sql = sql.substring(0, sql.length()-1);
		sql += ") ";
	}else if(searchResult&&searchList.size()<=0){
		sql += " AND FALSE ";
	}
	if(req_recommend&&recSet.size()>0){
		sql += " AND c.col_id IN ( ";
		for (Integer a: recSet){
		 	sql += "" + a + ",";
		}
		sql = sql.substring(0, sql.length()-1);
		sql += ") ";
	}else if(req_recommend&&recSet.size()<=0){
		sql += " AND FALSE ";
	}
	if(area_id_value!=null&&area_id_value.length>0){
		for(int i=0;i<area_id_value.length;i++){
			if(area_id_value[i].equalsIgnoreCase("0")){
				sql += " AND c.col_id NOT IN (SELECT col_id FROM area_col) ";
			}
		}
	}
	
	//Wenyuan-11.22.2014.start
	//Wenyuan, researcharea modification for BOOKMARK vaapad CHANGED POSITION
	//researcharea modification
	if(affiliate_rs_id_value!=null&&affiliate_rs_id_value.length>0){
		for(int i=0;i<affiliate_rs_id_value.length;i++){
			if(affiliate_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " AND c.col_id NOT IN (SELECT col_id FROM affiliate_col) ";
			}
		}
	}
	if(host_rs_id_value!=null &&host_rs_id_value.length>0){
		for(int i=0; i<host_rs_id_value.length; i++){
			if(!host_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " AND c.host_id ="+host_rs_id_value[i]+" ";
			}
			else {
				sql += " AND c.host_id =0 ";
			}
		}
	}
	if(speaker_rs_id_value!=null &&speaker_rs_id_value.length>0){
		for(int i=0; i<speaker_rs_id_value.length; i++){
			if(!speaker_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " AND c.speaker_id ="+speaker_rs_id_value[i]+" ";
			}
			else {
				sql += " AND c.speaker_id =0 ";
			}
		}
	}
	if(group_rs_id_value!=null&& group_rs_id_value.length>0){
		for(int i=0;i<group_rs_id_value.length; i++){
			if(group_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " AND c.col_id NOT IN (SELECT col_id FROM contribute) ";
			}
		}
	}
	if(series_rs_id_value!=null&& series_rs_id_value.length>0){
		for(int i=0;i<series_rs_id_value.length; i++){
			if(series_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " AND c.col_id NOT IN (SELECT col_id FROM seriescol) ";
			}
		}
	}
	if(location_rs_id_value!=null&& location_rs_id_value.length>0){
		for(int i=0;i<location_rs_id_value.length; i++){
			if(location_rs_id_value[i].equalsIgnoreCase("0")){
				sql += " AND c.col_id NOT IN (SELECT col_id FROM location_col_copy) ";
			}
		}
	}
	if(bk_rs_id_value!=null&& bk_rs_id_value.length>0){
		sql +=" AND c.col_id IN (SELECT col_id FROM userprofile WHERE user_id ="+ub.getUserID()+") ";
	}
	if(owner_rs_id_value!=null && owner_rs_id_value.length>0){
		sql +=" AND c.col_id IN (SELECT col_id FROM colloquium WHERE owner_id ="+ub.getUserID()+") ";
	}
	
	//Wenyuan-11.15.2014.end
	//Wenyuan-11.22.2014.end
	
	int olderTalkNo = 0;
	String olderTalkPara = "";
	if(menu.equalsIgnoreCase("calendar")||menu.equalsIgnoreCase("myaccount")||req_most_recent||req_specific_date){
		if(req_posted){
			sql += "AND pt.posttime >= '" + strBeginDate + " 00:00:00' " +
			"AND pt.posttime <= '" + strEndDate + " 23:59:59' ";
		}else{
			if(menu.equalsIgnoreCase("affiliate")||menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("community")||menu.equalsIgnoreCase("speaker")){
				if(insertFirst==null){
					sql += "AND c._date >='" + strBeginDate + " 00:00:00' ";
					
					//Count # earlier talks
					String _sql = "SELECT SQL_CACHE COUNT(*) _no FROM colloquium c ";
					if(series_id_value != null){//Series Mode
						for(int i=0;i<series_id_value.length;i++){
							_sql += "JOIN seriescol sc" + i + " ON c.col_id = sc" + i + ".col_id AND sc" + i + ".series_id=" + series_id_value[i] + " ";
							if(olderTalkPara.length()>0){
								olderTalkPara += "&";
							}
							olderTalkPara += "series_id=" + series_id_value[i];
						}
					}
					if(comm_id_value != null){//Community Mode
						for(int i=0;i<comm_id_value.length;i++){
							_sql += //"JOIN userprofile upc" + i + " ON c.col_id=upc" + i + ".col_id " +
									//"JOIN contribute ct" + i + " ON upc" + i + ".userprofile_id = ct" + i + ".userprofile_id " + 
									//"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
									"JOIN contribute ct" + i + " ON c.col_id=ct" + i + ".col_id " + 
									"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
							if(olderTalkPara.length()>0){
								olderTalkPara += "&";
							}
							olderTalkPara += "comm_id=" + comm_id_value[i];
						}
					}
					if(affiliate_id_value != null){//Affiliation Mode
						for(int i=0;i<affiliate_id_value.length;i++){
							_sql += "JOIN affiliate_col ac" + i + " ON c.col_id=ac" + i + ".col_id " +
									"AND ac" + i + ".affiliate_id = " + affiliate_id_value[i] + " ";
							if(olderTalkPara.length()>0){
								olderTalkPara += "&";
							}
							olderTalkPara += "affiliate_id=" + affiliate_id_value[i];
						}
					}
					if(req_speaker_id > 0){//Speaker Mode
						_sql += "JOIN col_speaker cs ON c.col_id=cs.col_id ";
						if(olderTalkPara.length()>0){
							olderTalkPara += "&";
						}
						olderTalkPara += "speaker_id=" + req_speaker_id;
					}
					_sql += "AND c._date < '" + strBeginDate + " 00:00:00' ";
					ResultSet rs = conn.getResultSet(_sql);
					if(rs.next()){
						olderTalkNo = rs.getInt("_no");
						if(olderTalkNo > 0){
%>
	<br/>
	<div id="divOlderTalks" align="center">
		<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
			<tr>
				<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
			</tr>
			<tr>
				<td bgcolor="#efefef" style="font-size: 0.9em;font-weight: bold;text-align: center;">
					&nbsp;
					<input class="btn" type="button" 
						onclick="this.value='Loading...';this.style.disabled='disabled';showOlderTalks('<%=olderTalkPara %>');return false;" 
						value="Show <%=olderTalkNo %> Earlier Talk<%=(olderTalkNo>0?"s":"") %>" />
				</td>
			</tr>
			<tr>
				<td bgcolor="#efefef" ><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
			</tr>
		</table>	
	</div>
<%							
						}
					}
				}else{
					sql += "AND c._date < '" + strBeginDate + " 00:00:00' ";
				}
			}else{
				if(insertFirst==null){
					sql += "AND c._date >= '" + strBeginDate + " 00:00:00' " +
					"AND c._date <= '" + strEndDate + " 23:59:59' ";
				}else{
					sql += "AND c._date < '" + strBeginDate + " 00:00:00' ";
				}
			}
		}
	}
	/*if(req_recommend&&!req_specific_date){
		sql += "AND c._date >= CURDATE() ";
	}*/
	if(req_pop_recent){
		sql += "AND c._date > CURDATE() ";
	}
	
	if(newOldTalks.trim().length()>0)
	{
		if(newOldTalks.equals("oldTalks"))
			sql += " AND c._date < NOW() ";
		else if (newOldTalks.equals("newTalks"))
			sql += " AND c._date >= NOW() ";
	}
	
	sql += "GROUP BY c.col_id ";
	
	if(SortByTime){
		sql += " ORDER BY c._date DESC LIMIT " + start + "," + length;
	}else if(searchResult){
		//No order
		sql += " ORDER BY FIELD(c.col_id, ";
		for (long a: searchList){
		 	sql += "'" + a + "',";
		}
		sql = sql.substring(0, sql.length()-1);
		sql += ")";

	}else{
		if(req_posted){
			sql += "ORDER BY pt.posttime";
		}else{
			if(req_top_comet || req_top_video || req_top_slide || req_most_recent || req_pop_recent || req_recommend){
				if (!req_recommend){
					sql += "ORDER BY (3*ci.bookmarkno +2*ci.emailno + ci.viewno) DESC ";
				}else{
					sql += "ORDER BY (c._date) ";
				}
				if(req_top_video && req_start == 0 && req_rows <= 3){
					int randSeed = (int)Math.random()*41;
					
					sql += "LIMIT " + randSeed + "," + req_rows;
				}else{
					sql += "LIMIT " + req_start + "," + req_rows;
				}
			}
			else{
				if(req_bookmarked_alike_col_id > 0){
					sql += "HAVING COUNT(DISTINCT(up.user_id)) >=4 ";
					sql += "ORDER BY COUNT(DISTINCT(up.user_id)) DESC,(3*ci.bookmarkno +2*ci.emailno + ci.viewno) DESC ";
					sql += "LIMIT " + req_start + "," + req_rows;  		  
				}else if(req_viewed_alike_col_id > 0){
					sql += "HAVING COUNT(DISTINCT(tv.user_id)) >=4 ";
					sql += "ORDER BY COUNT(DISTINCT(tv.user_id)) DESC,(3*ci.bookmarkno +2*ci.emailno + ci.viewno) DESC ";
					sql += "LIMIT " + req_start + "," + req_rows;  		  
				}else{
					sql += "ORDER BY c._date,c.begintime ";
				}
			}
		}
	}
	//sql += " LIMIT 100";
	
	String day = "";
	if(isdebug){
		out.println(sql);
	}
	ResultSet rs = conn.getResultSet(sql);
	
	ArrayList<String> talk_day = new ArrayList<String>();
	ArrayList<Integer> talk_col_id = new ArrayList<Integer>();
	ArrayList<String> talk_title = new ArrayList<String>();
	ArrayList<String> talk_begin = new ArrayList<String>();
	ArrayList<String> talk_end = new ArrayList<String>();
	ArrayList<Integer> talk_speaker_id = new ArrayList<Integer>();
	ArrayList<String> talk_name = new ArrayList<String>();
	ArrayList<String> talk_location = new ArrayList<String>();
	ArrayList<String> talk_video_url = new ArrayList<String>();
	ArrayList<String> talk_affiliation = new ArrayList<String>();
	ArrayList<String> talk_year = new ArrayList<String>();
	ArrayList<String> talk_slide_url = new ArrayList<String>();
	ArrayList<String> talk_picURL = new ArrayList<String>();
	ArrayList<Boolean> talk_istoday = new ArrayList<Boolean>();
	ArrayList<String> talk_paper_url = new ArrayList<String>();
	ArrayList<Date> talk_date = new ArrayList<Date>();
	
	ArrayList<String> talk_bookmarks = new ArrayList<String>();
	ArrayList<Integer> talk_bookmarkno = new ArrayList<Integer>();
	
	HashSet<Integer> talk_bookmark_speaker_id = new HashSet<Integer>();
	
	ArrayList<String> talk_tags = new ArrayList<String>();
	ArrayList<String> talk_communities = new ArrayList<String>();
	
	ArrayList<LinkedHashMap<Integer,String>> talk_series = new ArrayList<LinkedHashMap<Integer,String>>();
	HashSet<Integer> talk_bookmark_series_id = new HashSet<Integer>();

	String col_id_list = null;
	String speaker_id_list = null;
	while(rs.next()){
		talk_day.add(rs.getString("day"));
		talk_col_id.add(rs.getInt("col_id"));
		if(col_id_list==null){
			col_id_list = rs.getString("col_id");
		}else{
			col_id_list += "," + rs.getString("col_id");
		}
		talk_title.add(rs.getString("title"));
		talk_begin.add(rs.getString("_begin"));
		talk_end.add(rs.getString("_end"));
		talk_speaker_id.add(rs.getInt("speaker_id"));
		if(speaker_id_list==null){
			speaker_id_list = rs.getString("speaker_id");
		}else{
			speaker_id_list += "," + rs.getString("speaker_id");
		}
		talk_name.add(rs.getString("name"));
		talk_location.add(rs.getString("location"));
		talk_video_url.add(rs.getString("video_url"));
		talk_affiliation.add(rs.getString("affiliation"));
		talk_year.add(rs.getString("_year"));
		talk_slide_url.add(rs.getString("slide_url"));
		talk_picURL.add(rs.getString("picURL"));
		talk_istoday.add(rs.getBoolean("_istoday"));
		talk_paper_url.add(rs.getString("paper_url"));
		talk_date.add(rs.getDate("_date"));
		
		talk_bookmarks.add(null);
		talk_bookmarkno.add(0);
		
		talk_tags.add("");
		talk_communities.add("");
		
		talk_series.add(null);
	}
	
	//Bookmark by
	HashSet<Integer> bookSet = null; 
	if(ub != null){
		if(ub.getBookSet() != null){
			bookSet = ub.getBookSet();				
		}else{
			bookSet = new HashSet<Integer>();
		}
	}
	if(col_id_list != null){
		sql = "SELECT SQL_CACHE up.col_id,u.user_id,u.name FROM userinfo u JOIN userprofile up " +
				"ON u.user_id = up.user_id WHERE up.col_id IN (" + col_id_list +
				") GROUP BY up.col_id,u.user_id,u.name ORDER BY up.col_id,up.lastupdate, u.name";
		rs = conn.getResultSet(sql);
		if(rs!=null){
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				String user_name = rs.getString("name");
				long user_id = rs.getLong("user_id");
				//long _no = rsExt.getLong("_no");
				if(user_name.length() > 0 && talk_col_id.contains(col_id)){
					String bookmarks = talk_bookmarks.get(talk_col_id.indexOf(col_id))==null?"":talk_bookmarks.get(talk_col_id.indexOf(col_id));
					int bookmarkno = talk_bookmarkno.get(talk_col_id.indexOf(col_id));
					
					bookmarks += "&nbsp;<a href=\"profile.do?user_id=" + user_id + "\">" + user_name + "</a>";
					bookmarkno++;
					
					talk_bookmarks.set(talk_col_id.indexOf(col_id),bookmarks);
					talk_bookmarkno.set(talk_col_id.indexOf(col_id),bookmarkno);
					
					if(ub!=null && ub.getUserID()==user_id){
						bookSet.add(col_id);
					}

				}
			}
		}
		
	}

	//speaker subscribed
	if(ub != null){
		sql = "SELECT SQL_CACHE speaker_id FROM final_subscribe_speaker " + 
				"WHERE speaker_id IN (" + speaker_id_list + ") AND user_id=" + ub.getUserID() +
				" GROUP BY speaker_id";
		rs = conn.getResultSet(sql);
		if(rs.next()){
			int speaker_id = rs.getInt("speaker_id");
			talk_bookmark_speaker_id.add(speaker_id);
		}
	}

	if(!req_concise){
		//Tags
		sql = "SELECT SQL_CACHE tt.col_id,t.tag_id,t.tag FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
				"WHERE  tt.col_id IN (" + col_id_list +") " +
				//"OR tt.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id IN (" + col_id_list + "))" + 
				" GROUP BY tt.col_id,t.tag,t.tag_id";
		rs = conn.getResultSet(sql);
		if(rs != null){
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				String tag = rs.getString("tag");
				long tag_id = rs.getLong("tag_id");
				String tags = talk_tags.get(talk_col_id.indexOf(col_id));
				if(tag.length() > 0){
					tags +=	"&nbsp;<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
				}
				talk_tags.set(talk_col_id.indexOf(col_id),tags);
			}
		}

		sql = "SELECT SQL_CACHE ct.col_id,c.comm_id,c.comm_name,COUNT(*) _no FROM community c JOIN contribute ct " +
				"ON c.comm_id = ct.comm_id WHERE " +
				"ct.col_id IN (" + col_id_list + ")" +
				//" OR ct.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id=" + col_id + ")" +
				" GROUP BY ct.col_id,c.comm_name,c.comm_id";
		rs = conn.getResultSet(sql);
		if(rs != null){
			while(rs.next()){
				int col_id = rs.getInt("col_id");
				String communities = talk_communities.get(talk_col_id.indexOf(col_id));		
				String comm_name = rs.getString("comm_name");
				long comm_id = rs.getLong("comm_id");
				long _no = rs.getLong("_no");
				if(comm_name.length() > 0){
					communities += "&nbsp;<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>"; 
				}
				talk_communities.set(talk_col_id.indexOf(col_id),communities);
			}
		}

	}
	
	sql = "SELECT SQL_CACHE sc.col_id,s.series_id,s.name,ISNULL(fss.user_id)=0 _sub FROM series s JOIN seriescol sc ON s.series_id = sc.series_id " +
			"LEFT JOIN final_subscribe_series fss ON s.series_id=fss.series_id AND fss.user_id=" + (ub!=null?ub.getUserID():0) +
			" WHERE sc.col_id IN (" + col_id_list +
			") GROUP BY sc.col_id,s.series_id,s.name,fss.user_id";
	rs = conn.getResultSet(sql);
	while(rs.next()){
		int col_id = rs.getInt("col_id");
		int series_id = rs.getInt("series_id");
		String series_name = rs.getString("name");
		boolean _sub = rs.getBoolean("_sub");
		
		LinkedHashMap<Integer,String> seriesMap = talk_series.get(talk_col_id.indexOf(col_id));
		if(seriesMap == null){
			seriesMap = new LinkedHashMap<Integer,String>();
		}
		
		seriesMap.put(series_id,series_name);
		talk_series.set(talk_col_id.indexOf(col_id),seriesMap);
		
		if(_sub){
			talk_bookmark_series_id.add(series_id);
		}
	}
	
	boolean noTalks = true;
	
	if(menu.equalsIgnoreCase("myaccount")){
%>
	<form name="talkForm" method="post">
<%		
	}
%>
	<table border="0" cellspacing="0" cellpadding="0" width="<%=(req_top_video&&req_rows==1)||(req_no_header)||((req_top_video||req_top_slide||req_top_comet||req_pop_recent)&&req_start>0)?"100":"95" %>%" align="center">
<%
	if(area_id_value!=null){
		sql = "SELECT a.area_id,a.area " +
				"FROM area a " +
				"WHERE a.area_id IN (" + StringUtils.join(area_id_value,",") +
				") GROUP BY a.area_id,a.area ORDER BY a.area";
		ResultSet rsArea = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> areaMap = new LinkedHashMap<Integer,String>();
		while(rsArea.next()){
			int area_id = rsArea.getInt("area_id");
			String area = rsArea.getString("area");
			
			areaMap.put(area_id,area);
		}
		for(int i=0;i<area_id_value.length;i++){
			if(area_id_value[i].equalsIgnoreCase("0")){
				areaMap.put(0,"Unclassified");
			}
		}
		
		if(areaMap.size() > 0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<% 
			for(int area_id : areaMap.keySet()){
				String area = areaMap.get(area_id);
%>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				Interest Area: <%=area %> <a href="javascript: return false;" onclick="removeArea(<%=area_id %>);refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%				
			}
%>				
<%			
		}
	}

//Wenyuan-11.22.2014.start
//Wenyuan, researcharea modification for BOOKMARK vaapad
//researcharea modification
	if(affiliate_rs_id_value!=null){
		sql = "SELECT a.affiliate_id, a.affiliate " +
		"FROM affiliate a " +
		"WHERE a.affiliate_id IN (" + StringUtils.join(affiliate_rs_id_value, ",") +
		") GROUP BY a.affiliate_id,a.affiliate ORDER BY a.affiliate";
		ResultSet rsAffiliate = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> affiliateMap = new LinkedHashMap<Integer,String>();
		while(rsAffiliate.next()){
			int affiliate_rs_id = rsAffiliate.getInt("affiliate_id");
			String affiliate_rs = rsAffiliate.getString("affiliate");
			
			affiliateMap.put(affiliate_rs_id,affiliate_rs);
		}
	
		for(int i=0;i<affiliate_rs_id_value.length;i++){
			if(affiliate_rs_id_value[i].equalsIgnoreCase("0")){
				affiliateMap.put(0,"Unknown");
			}
			else if (affiliate_rs_id_value[i].equalsIgnoreCase("-1")) {
				affiliateMap.put(-1,"Other");
			}
		}
		if(affiliateMap.size()>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<% 
			for(int affiliate_rs_id : affiliateMap.keySet()){
				String affiliate_rs = affiliateMap.get(affiliate_rs_id);
%>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				Sponsors: <%=affiliate_rs %> <a href="javascript: return false;" onclick="removeAffiliate(<%=affiliate_rs_id %>);refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%				
			}
%>				
<%	
		}
		
		
	}
	if(host_rs_id_value!=null){
		sql = "SELECT host_id, host " +
		"FROM host " +
		"WHERE host_id IN (" + StringUtils.join(host_rs_id_value, ",") +
		") GROUP BY host_id,host ORDER BY host";
		ResultSet rshost = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> hostMap = new LinkedHashMap<Integer,String>();
		while(rshost.next()){
			int host_rs_id = rshost.getInt("host_id");
			String host_rs = rshost.getString("host");
			
			hostMap.put(host_rs_id,host_rs);
		}
	
		for(int i=0;i<host_rs_id_value.length;i++){
			if(host_rs_id_value[i].equalsIgnoreCase("0")){
				hostMap.put(0,"Unknown");
			}
		}
		if(hostMap.size()>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<% 
			for(int host_rs_id : hostMap.keySet()){
				String host_rs = hostMap.get(host_rs_id);
%>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				Host: <%=host_rs %> <a href="javascript: return false;" onclick="removeHost(<%=host_rs_id %>);refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%				
			}
%>				
<%	
		}
		
		
	}
	if(speaker_rs_id_value!=null){
		sql = "SELECT speaker_id, name " +
		"FROM speaker " +
		"WHERE speaker_id IN (" + StringUtils.join(speaker_rs_id_value, ",") +
		") GROUP BY speaker_id,name ORDER BY name";
		ResultSet rsspeaker = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> speakerMap = new LinkedHashMap<Integer,String>();
		while(rsspeaker.next()){
			int speaker_rs_id = rsspeaker.getInt("speaker_id");
			String speaker_rs = rsspeaker.getString("name");
			
			speakerMap.put(speaker_rs_id,speaker_rs);
		}
	
		for(int i=0;i<speaker_rs_id_value.length;i++){
			if(speaker_rs_id_value[i].equalsIgnoreCase("0")){
				speakerMap.put(0,"Unknown");
			}
		}
		if(speakerMap.size()>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<% 
			for(int speaker_rs_id : speakerMap.keySet()){
				String speaker_rs = speakerMap.get(speaker_rs_id);
%>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				speaker: <%=speaker_rs %> <a href="javascript: return false;" onclick="removeSpeaker(<%=speaker_rs_id %>);refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%				
			}
%>				
<%	
		}
		
		
	}

if(group_rs_id_value!=null){
		sql = "SELECT comm_id, comm_name " +
		"FROM community " +
		"WHERE comm_id IN (" + StringUtils.join(group_rs_id_value, ",") +
		") GROUP BY comm_id,comm_name ORDER BY comm_name";
		ResultSet rsgroup = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> groupMap = new LinkedHashMap<Integer,String>();
		while(rsgroup.next()){
			int group_rs_id = rsgroup.getInt("comm_id");
			String group_rs = rsgroup.getString("comm_name");
			
			groupMap.put(group_rs_id,group_rs);
		}
	
		for(int i=0;i<group_rs_id_value.length;i++){
			if(group_rs_id_value[i].equalsIgnoreCase("0")){
				groupMap.put(0,"N/A");
			}
		}
		if(groupMap.size()>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<% 
			for(int group_rs_id : groupMap.keySet()){
				String group_rs = groupMap.get(group_rs_id);
%>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				Group: <%=group_rs %> <a href="javascript: return false;" onclick="removeGroup(<%=group_rs_id %>);refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%				
			}
%>				
<%	
		}
		
		
}
	
if(series_rs_id_value!=null){
		sql = "SELECT series_id, name " +
		"FROM series " +
		"WHERE series_id IN (" + StringUtils.join(series_rs_id_value, ",") +
		") GROUP BY series_id,name ORDER BY name";
		
		ResultSet rsseries = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> seriesMap = new LinkedHashMap<Integer,String>();
		while(rsseries.next()){
			int series_rs_id = rsseries.getInt("series_id");
			String series_rs = rsseries.getString("name");
			
			seriesMap.put(series_rs_id,series_rs);
		}
	
		for(int i=0;i<series_rs_id_value.length;i++){
			if(series_rs_id_value[i].equalsIgnoreCase("0")){
				seriesMap.put(0,"N/A");
			}
		}
		if(seriesMap.size()>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<% 
			for(int series_rs_id : seriesMap.keySet()){
				String series_rs = seriesMap.get(series_rs_id);
%>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				Series: <%=series_rs %> <a href="javascript: return false;" onclick="removeSeries(<%=series_rs_id %>);refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%				
			}
%>				
<%	
		}
		
		
	}
if(location_rs_id_value!=null){
		sql = "SELECT loc_id, location " +
		"FROM location_copy " +
		"WHERE loc_id IN (" + StringUtils.join(location_rs_id_value, ",") +
		") GROUP BY loc_id,location ORDER BY location";
		ResultSet rslocation = conn.getResultSet(sql);
		LinkedHashMap<Integer,String> locationMap = new LinkedHashMap<Integer,String>();
		while(rslocation.next()){
			int location_rs_id = rslocation.getInt("loc_id");
			String location_rs = rslocation.getString("location");
			
			locationMap.put(location_rs_id,location_rs);
		}
	
		for(int i=0;i<location_rs_id_value.length;i++){
			if(location_rs_id_value[i].equalsIgnoreCase("0")){
				locationMap.put(0,"Unknown");
			}
		}
		if(locationMap.size()>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<% 
			for(int location_rs_id : locationMap.keySet()){
				String location_rs = locationMap.get(location_rs_id);
%>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				location: <%=location_rs %> <a href="javascript: return false;" onclick="removelocation(<%=location_rs_id %>);refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%				
			}
%>				
<%	
		}
		
		
}

	if(owner_rs_id_value!=null && owner_rs_id_value.length>0){
%>				

		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				Your Posted Talks <a href="javascript: return false;" onclick="removeowner();refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%
	}

	if(bk_rs_id_value!=null&& bk_rs_id_value.length>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td style="color: #003399;font-weight: bold;font-size: 0.9em;text-align: left;">
				Your Bookmarked Talks <a href="javascript: return false;" onclick="removebk();refreshTalks();"><img border="0" style="width: 0.8em;height: auto;" src="images/x.gif" /></a>
			</td>
		</tr>
<%
	}
//modified on 11.12.2014 
//Wenyuan-11.22.2014.end

	if(!req_top_slide && !req_top_video && !req_top_comet && !req_most_recent && tag_id_value==null 
			/*&& entity_id_value==null*/ && series_id_value==null && comm_id_value==null && affiliate_id_value==null
			&& !searchResult && !req_pop_recent && req_speaker_id <= 0 
			&& req_bookmarked_alike_col_id <= 0 && req_viewed_alike_col_id <= 0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td style="font-size: 0.9em;"><%=strDisplayDateRange%></td>
		</tr>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<%		
	}

	if((req_top_video||req_top_slide||req_top_comet||req_pop_recent)&&req_start>0||req_speaker_id>0){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<%		
	}

	int deli=0;
	//ResultSet rsExt;
	boolean membered = false;
	if (comm_id_value !=  null && ub!=null){
		sql = "SELECT SQL_CACHE user_id FROM final_member_community WHERE user_id=" + ub.getUserID() +
				" AND comm_id=" + comm_id_value[0];
		rs = conn.getResultSet(sql);
		
		if(rs.next()){
			membered = true;
		}
	}
	boolean firstTalkofDay = true;
	for(num=0;num<talk_day.size();num++){//while(rs.next()){
		//num++;
		noTalks = false;
		Date _date = talk_date.get(num);//rs.getDate("_date");
		boolean todayTalk = talk_istoday.get(num);//rs.getBoolean("_istoday");
		String aDay = talk_day.get(num);//rs.getString("day");
		String _year = talk_year.get(num);//rs.getString("_year");
		if(this_year != Integer.parseInt(_year)){
			aDay += ", " + _year;
		}
		//String host = rs.getString("host");
		//String owner_id = rs.getString("owner_id");
		//String owner = rs.getString("owner");
		String pic_url = "images/speaker/avartar.gif";
		if (/*rs.getString("picURL")*/talk_picURL.get(num) != null)
			pic_url = talk_picURL.get(num);//rs.getString("picURL");
		if(!day.equalsIgnoreCase(aDay)){
			if(!day.equalsIgnoreCase("")){
				firstTalkofDay = true;
%>
				</table>
			</td>
		</tr>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<%			
			}else if(menu.equalsIgnoreCase("myaccount")){
%>
		<tr>
			<td align="right">
				<input class="btn" type="button" value="<%=req_posted?"Delete":"Unbookmark" %>" onclick="deleteCols();" >
			</td>
		</tr>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<%			}else if(menu.equalsIgnoreCase("affiliate")||menu.equalsIgnoreCase("series")||menu.equalsIgnoreCase("community")||menu.equalsIgnoreCase("speaker")){
				if(insertFirst!=null&&day.equalsIgnoreCase("")){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
<%					
				}
			}		
			day = aDay;
%>
<%-- 
		<tr>
			<td>&nbsp;</td>
		</tr>
--%>
<% 
			if(!req_no_header){
%>
		<tr>
			<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
				<%=req_most_recent?"Most Popular Talks on ":"" %><%=req_most_recent&&todayTalk?"Today, ":"" %><%=req_recommend?"Recommended Talks on ": ""%><%=req_top_video&&req_rows==1?"Past Popular Talks with Video":day %>
<% 
				if(_date.compareTo(mindate)==0){
%>
				<a id="today"></a>
				<script type="text/javascript">
					$(document).ready(function(){
						//window.scrollTo(0,$('#focusdate').position().top());
						window.setTimeout(function(){
							window.scrollTo(0,$('#today').position().top);
						},500);
						//$('html,body').animate({scrollTop: $("#focusdate").offset().top},'slow');
					});
				</script>
<%					
				}
%>				
			</td>
		</tr>
		<tr>
			<td align="center" style="border: 1px #EFEFEF solid;">
				<table border="0" cellspacing="5" cellpadding="0" width="100%" align="center">
<%				
			}else{
%>	
		<tr>
			<td align="center">
				<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
<%
			}
		}
		//Show talk snap shot
		String col_id = "" + talk_col_id.get(num);//rs.getString("col_id");
%>
					<tr>
<% 
		if(menu.equalsIgnoreCase("myaccount")){
%>
						<td align="left" valign="top" width="10">
							<input id="deleted<%=deli %>" class="chkDelCol" name="deleted" type="checkbox" value="<%=col_id%>" />
						</td>
<% 
		}
		deli++;
		//How many emails
		int emailno = 0;
		/*sql = "SELECT emails FROM emailfriends WHERE col_id=" + col_id;
		ResultSet rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			HashSet<String> setEmails = new HashSet<String>();
			while(rsExt.next()){
				String emails = rsExt.getString("emails");
				String[] email = emails.split(",");
				if(email != null){
					for(int i=0;i<email.length;i++){
						String aEmail = email[i].trim().toLowerCase();
						setEmails.add(aEmail);
					}
				}
			}
			emailno = setEmails.size();
		}*/
		
		//How many views
		int viewno = 0;
		/*sql = "SELECT ipaddress,sessionid,COUNT(*) _no FROM talkview WHERE col_id=" + col_id + " GROUP BY ipaddress,sessionid";
		rsExt = conn.getResultSet(sql);
		if(rsExt!=null){
			while(rsExt.next()){
				String ipaddress = rsExt.getString("ipaddress");
				String sessionid = rsExt.getString("sessionid").trim().toLowerCase();
				if(ipaddress.trim().length()==0||sessionid.trim().length()==0){
					viewno += rsExt.getInt("_no");
				}else{
					viewno++;
				}
				
			}
		}*/
		
		//Bookmark by
		/*HashSet<Integer> bookSet = null; 
		if(ub != null){
			if(ub.getBookSet() != null){
				bookSet = ub.getBookSet();				
			}else{
				bookSet = new HashSet<Integer>();
			}
		}*/
		String bookmarks = talk_bookmarks.get(num)==null?"":talk_bookmarks.get(num);
		int bookmarkno = talk_bookmarkno.get(num);
		/*sql = "SELECT SQL_CACHE u.user_id,u.name FROM userinfo u JOIN userprofile up " +
				"ON u.user_id = up.user_id WHERE up.col_id = " + col_id +
				" GROUP BY u.user_id,u.name ORDER BY up.lastupdate, u.name";
		rs = conn.getResultSet(sql);
		if(rs!=null){
			while(rs.next()){
				String user_name = rs.getString("name");
				long user_id = rs.getLong("user_id");
				//long _no = rsExt.getLong("_no");
				if(user_name.length() > 0){
					bookmarks += "&nbsp;<a href=\"profile.do?user_id=" + user_id + "\">" + user_name + "</a>";
					bookmarkno++;				
				}
				if(ub != null){
					if(ub.getUserID()==user_id){
						bookSet.add(Integer.parseInt(col_id));
					}
				}
			}
		}*/
		
		sql = "SELECT SQL_CACHE viewno,emailno FROM col_impact WHERE col_id=" + col_id;
		rs = conn.getResultSet(sql);
		while(rs.next()){
			viewno = rs.getInt("viewno");
			emailno = rs.getInt("emailno");
		}
%>
						<td>
							<table align="center" width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size: 0.8em;<%=!firstTalkofDay||(firstTalkofDay&&req_no_header)?"border-top: 1px #EFEFEF solid;":"" %>" >

								<tr>
<%
		firstTalkofDay = false;
		if (comm_id_value != null){// && membered){
			
			long user_id = 0;
			int voteno = 0; //vote # for this col in this community
			sql = "SELECT SQL_CACHE vote FROM contribute_vote WHERE col_id=" + col_id + " and comm_id =" + comm_id_value[0];
			rs = conn.getResultSet(sql);
			while(rs.next()){
				voteno += rs.getInt("vote");
			}
			int voteStatus = 0;
			if (ub != null){
				user_id = ub.getUserID();
				sql = "select SQL_CACHE vote from contribute_vote where col_id=" + col_id + " and user_id=" + user_id;
				rs = conn.getResultSet(sql);			
				while(rs.next()){
					voteStatus += rs.getInt("vote");
				}
			}
%>
									
									<td valign="top" width="38px">
										<table>
											<tr>
												<td>
													<a id="vote_up_<%=col_id %>" class="<%=voteStatus!=1?"vote_up_off":"vote_up_on" %>" title="This talk is interesting; it is useful(click again to undo)" onclick="vote('<%=membered%>', 'up', <%=voteno%>, <%=col_id%>,<%=comm_id_value[0] %>,<%=user_id%>, <%= voteStatus%>)" >vote up</a>
												</td>
											</tr>
											<tr>
												<td>
													<span class="vote_count" id="vote_no_<%=col_id %>"><%=voteno %></span>
												</td>
											</tr>
											<tr>
												<td>
													<a id="vote_down_<%=col_id %>" class="<%=voteStatus!=-1?"vote_down_off":"vote_down_on" %>" title="This talk is not interesting; it is not useful(click again to undo)" onclick="vote('<%=membered%>', 'down', <%=voteno%>,<%=col_id%>,<%=comm_id_value[0] %>, <%= user_id%>, <%= voteStatus%>)" >vote down</a>
												</td>
											</tr>
										</table>
										
									</td>
							
<%
		}
%>						
									<td valign="top" width="9.5%">
<%
		String strBookmark = "", strEmail = "", strView = "";
		if(viewno > 0 || emailno > 0 || bookmarkno > 0){
%>
<%-- 
										<table width="100%" border="0" cellpadding="0" cellspacing="1">
--%>
<% 
			if(bookmarkno > 0){
				strBookmark = "<b>" + bookmarkno + "</b>";
				if(!req_concise){
					strBookmark += "<br/><span style='font-size: 0.55em;'>bookmark";
					if(bookmarkno > 1){
						strBookmark += "s";
					}
				}
				strBookmark += "</span>";
%>
<%-- 
											<tr>
												<td valign="top" align="center" 
													style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
													<%=strBookmark%>
												</td>
											</tr>
--%>
<%			
			}
			if(emailno > 0){
				strEmail = "<b>" + emailno + "</b>";
				if(!req_concise){
					strEmail += "<br/><span style='font-size: 0.55em;'>email";
					if(emailno > 1){
						strEmail += "s";
					}
				}
				strEmail += "</span>";
%>
<%-- 
											<tr>
												<td valign="top" align="center" style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
													<%=strEmail%>
												</td>
											</tr>
--%>
<%			
			}
			if(viewno > 0){
				strView = "<b>" + viewno + "</b>";
				if(!req_concise){
					strView += "<br/><span style='font-size: 0.55em;'>view";
					if(viewno > 1){
						strView += "s";
					}
				}
				strView += "</span>";
%>
<%-- 
											<tr>
												<td valign="top" align="center" 
													style="padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
													<%=strView%>
												</td>
											</tr>
--%>
<%			
			}
%>											
<%-- 
										</table>
--%>
<%		
		}
%>
										<table width="100%" border="0" cellpadding="0" cellspacing="1">
											<tr>
<% 
		if(req_pop_recent||req_top_comet||req_top_video||req_top_slide/*||req_recommend*/){
%>
												<td align="center" valign="top" style="font-weight: bold;<%=req_rows==1?"display: none;":"" %>">
														<%=req_start+deli %>.
												</td>
<%			
		}
%>
												<td align="center" valign="top">
													<table width="100%" border="0" cellpadding="0" cellspacing="1">
														<tr>
															<td class="td<%=req_concise?"C":"" %>BookNoColID<%=col_id %>" valign="top" align="center" 
																style="display:<%=bookmarkno==0?"none":"block" %>;padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #228b22;color: #fff;">
																<%=strBookmark%>
															</td>
														</tr>
														<tr>												
															<td class="td<%=req_concise?"C":"" %>EmailNoColID<%=col_id %>" valign="top" align="center" 
																style="display:<%=emailno==0?"none":"block" %>;padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #eedd82;color: #fff;">
																<%=strEmail%>
															</td>
														</tr>
														<tr>
															<td class="td<%=req_concise?"C":"" %>ViewNoColID<%=col_id %>" valign="top" align="center" 
																style="display:<%=viewno==0?"none":"block" %>;padding-right: 1px;padding-left: 1px;padding-top: 3px;padding-bottom: 3px;font-weight: bold;background-color: #9370db;color: #fff;">
																<%=strView%>
															</td>
														</tr>
													</table>									
												</td>
											</tr>
										</table>
									</td>
									<td width="<%=pic_url.trim().contains("images/speaker/avartar.gif")?"90.5%":"80.5%" %>" valign="top">

							<b><a id="aTitleColID<%=col_id %>" href="presentColloquium.do?col_id=<%=col_id%>"><%=talk_title.get(num)/*rs.getString("title")*/ %></a></b>
<% 
		String video_url = talk_video_url.get(num);//rs.getString("video_url");
		if(video_url != null){
			if(video_url.length() > 7){
%>
							&nbsp;<a href="<%=video_url%>"><img alt="Video Link" src="images/video-icon.jpg" border="0" /></a>
<%				
			}
		}
		String slide_url = talk_slide_url.get(num);//rs.getString("slide_url");
		if(slide_url != null){
			if(slide_url.length() > 7){
%>
							&nbsp;<a href="<%=slide_url%>"><img alt="Slide Link" src="images/Slide-Show-icon.jpg" border="0" /></a>
<%				
			}
		}
		String paper_url = talk_paper_url.get(num);//rs.getString("paper_url");
		if(paper_url != null){
			if(paper_url.length() > 7){
%>
							&nbsp;<a href="<%=paper_url%>"><img alt="Paper Link" src="images/attachment_icon.png" border="0" /></a>
<%				
			}
		}
		boolean bookmarked = false;
%>
							<logic:present name="UserSession">
<%		
		if(bookSet != null){
			if(bookSet.contains(Integer.parseInt(col_id))){
				bookmarked = true;
			}
		}
		if(recSet != null){
			if(recSet.contains(Integer.parseInt(col_id))&&!bookmarked){
%>
<span class="spanreccolid<%=col_id %>">
&nbsp;<span style="cursor: pointer;font-size: 1em;background-color: red;font-weight: bold;color: white;"
onclick="window.location='calendar.do?recommend=1'">&nbsp;Recommended&nbsp;</span>
</span>
<%				
			}
		}
		/*sql = "SELECT SQL_CACHE COUNT(*) _no FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
				"WHERE LENGTH(t.tag) > 0 AND ((tt.col_id = " + col_id + " AND tt.user_id=" + ub.getUserID() +
				") OR (tt.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id = " + col_id + 
				" AND user_id=" + ub.getUserID() + "))) GROUP BY t.tag_id ";
		boolean usertagged = false;
		rsExt = conn.getResultSet(sql);
		if(rsExt != null){
			while(rsExt.next()){
				long _no = rsExt.getLong("_no");
				if(_no > 0)usertagged = true;
			}
		}*/
%>
<span id="spanbookcolid<%=col_id %>" class="spanbookcolid<%=col_id %>" 
style="display:<%=bookmarked?"inline":"none" %>;">&nbsp;
<span style="cursor: pointer;font-size: 1em;background-color: green;font-weight: bold;color: white;"
onclick="window.location='myaccount.do'">&nbsp;Bookmarked&nbsp;</span></span>
&nbsp;
<a class="abookcolid<%=col_id %>" href="javascript:return false;" 					
	style="text-decoration: none;"
	onmouseover="this.style.textDecoration='underline'" 
	onmouseout="this.style.textDecoration='none'"
	onclick="$('#spanBookmarkHeader').show();bookmarkTalk(<%=ub.getUserID() %>, <%=col_id %>, this, 'spanbookcolid<%=col_id %>');"
><%=bookmarked?"Unbookmark":"Bookmark" %></a>
<%-- 
&nbsp;
<a class="atagcolid<%=col_id %>" href="javascript:return false;"
	style="text-decoration: none;"
	onmouseover="this.style.textDecoration='underline'" 
	onmouseout="this.style.textDecoration='none'"
	onclick="$('#spanBookmarkHeader').hide();$('#btnTagClose').val('Cancel');showPopupTag(<%=ub.getUserID() %>,<%=col_id %>,this,'.spanTagColID<%=col_id %>');addMoreTagInputRow();"
><%=usertagged?"Edit Keywords":"Add Keywords" %></a>
--%>
<%-- 
&nbsp;
<a class="abookcolid<%=col_id %>" href="javascript:return false;" 					
	style="text-decoration: none;"
	onmouseover="this.style.textDecoration='underline'" 
	onmouseout="this.style.textDecoration='none'"
	onclick="bookmarkTalk(<%=ub.getUserID() %>, <%=col_id %>, this, 'spanbookcolid<%=col_id %>')"
><%=bookmarked?"Unbookmark":"Bookmark" %></a>
--%>
<%-- 
<input class="btn" type="button" value="<%=bookmarked?"Unbookmark":"Bookmark" %>"
					onclick="bookmarkTalk(<%=ub.getUserID() %>,<%=col_id %>,this,'spanbookcolid<%=col_id %>');" />
--%>
							</logic:present>
<%	
		String speaker_id = "" + talk_speaker_id.get(num);//rs.getString("speaker_id");
		String speaker = talk_name.get(num);//rs.getString("name");
		String affiliation = talk_affiliation.get(num);//rs.getString("affiliation");
		if(speaker==null)speaker="N/A";
		if(affiliation==null)affiliation="N/A";
%>							
							<br/>
							<span style="font-size: 0.75em;"><b>By:</b> 
								<a href="speakerprofile.do?speaker_id=<%=speaker_id %>">
								<span style="font-size: 1.25em;font-weight: bold;" id="spanSpeakerColID<%=col_id %>"><%=speaker.trim() %></span>
								</a>
								<logic:present name="UserSession">
<% 
		int subno = 0;
		if(ub != null){
			subno = talk_bookmark_speaker_id.contains(Integer.parseInt(speaker_id))?1:0;			
		}
		/*if(ub != null){
			sql = "SELECT COUNT(*) _no FROM final_subscribe_speaker WHERE speaker_id=" + speaker_id + " AND user_id=" + ub.getUserID();
			rs = conn.getResultSet(sql);
			if(rs.next()){
				subno = rs.getInt("_no");
			}
		}*/
%>
									<span class="spansubspid<%=speaker_id %>" id="spansubspcid<%=col_id %>" 
										style="display: <%=subno==0?"none":"inline" %>;font-size: 0.9em;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
										onclick="window.location='speakerprofile.do?speaker_id=<%=speaker_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
									</span>
									&nbsp;	
									<a class="asubspid<%=speaker_id %>" href="javascript:return false;" 					
										style="text-decoration: none;"
										onmouseover="this.style.textDecoration='underline'" 
										onmouseout="this.style.textDecoration='none'"
										onclick="subscribeSpeaker(<%=ub.getUserID() %>, <%=speaker_id %>, this, 'spansubspcid<%=col_id %>')"
									><%=subno>0?"Unsubscribe":"Subscribe" %></a>
								</logic:present>
									<%=!affiliation.equalsIgnoreCase("n/a")?", " + affiliation:"" %>
									&nbsp;
<% 
		if(req_rows>1){
%>
								<b>at:</b> <span style="font-size: 1.25em;font-weight: bold;"><%=talk_begin.get(num)/*rs.getString("_begin")*/ %> - <%=talk_end.get(num)/*rs.getString("_end")*/ %></span>
<%			
		}
%>
							<br/>
<% 
		if(!req_concise){
%>
							<b>Location:</b> <span style="font-size: 1.25em;font-weight: bold;"><%=talk_location.get(num)/*rs.getString("location")*/ %></span>
<%
		}
		/*if(!req_concise){
%>
<%-- 
							<br/>
							<b>Posted By:</b> <a href="profile.do?user_id=<%=owner_id%>"><%=owner%></a> <b>on</b>&nbsp; 
<%			
			sql = "SELECT SQL_CACHE date_format(MIN(lastupdate),_utf8'%b %d %r') posttime " +
					"FROM (SELECT lastupdate FROM colloquium WHERE col_id = "+col_id+" " +
					"UNION " +
					"SELECT SQL_CACHE MIN(lastupdate) lastupdate FROM col_bk WHERE col_id = "+col_id+") ptime";
			rsExt = conn.getResultSet(sql);
			if(rsExt.next()){
				String posttime = rsExt.getString("posttime");
%>
							<%=posttime%>
--%>
<%
			}
		}*/
%>
		<logic:present name="UserSession">
<%
		if(!req_concise){
			//Tags
			/*sql = "SELECT SQL_CACHE t.tag_id,t.tag,COUNT(*) _no FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
					"WHERE  tt.col_id = " + col_id +
					" OR tt.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id=" + col_id + ")" + 
					" GROUP BY t.tag,t.tag_id";*/
			String tags = talk_tags.get(num);
			/*rs = conn.getResultSet(sql);
			if(rs != null){
				while(rs.next()){
					String tag = rs.getString("tag");
					long tag_id = rs.getLong("tag_id");
					long _no = rs.getLong("_no");
					if(tag.length() > 0){
						tags +=	"&nbsp;<a href=\"tag.do?tag_id=" + tag_id + "\">" + tag + "</a>";
					}
				}
			}*/
			
%>
							<span class="spanTagColID<%=col_id %>" style="display:<%=tags.length()>0?"inline":"none" %>;">
								<br/><b>Keywords:</b><%=tags %>
							</span>
<%
			
			/*sql = "SELECT SQL_CACHE c.comm_id,c.comm_name,COUNT(*) _no FROM community c JOIN contribute ct " +
					"ON c.comm_id = ct.comm_id WHERE " +
					"ct.col_id = " + col_id +
					//" OR ct.userprofile_id IN (SELECT userprofile_id FROM userprofile WHERE col_id=" + col_id + ")" +
					" GROUP BY c.comm_name,c.comm_id";
			rs.close();
			rs = conn.getResultSet(sql);*/
			String communities = talk_communities.get(num);		
			/*if(rs != null){
				while(rs.next()){
					String comm_name = rs.getString("comm_name");
					long comm_id = rs.getLong("comm_id");
					long _no = rs.getLong("_no");
					if(comm_name.length() > 0){
						communities += "&nbsp;<a href=\"community.do?comm_id=" + comm_id + "\">" + comm_name + "</a>"; 
					}
				}
			}*/
%>
							<span class="spanPostGroupColID<%=col_id %>" style="display:<%=communities.length()>0?"inline":"none" %>;">
								<br/><b>Posted to groups:</b><%=communities%>
							</span>

							<span class="spanWhomBookmarkColID<%=col_id %>" style="display:<%=bookmarks.length()>0?"inline":"none" %>;">
								<br/><b>Bookmarked by:</b><%=bookmarks %>
							</span>
<%
		}		
%>
		</logic:present>
<% 
		/*String _sql = "SELECT SQL_CACHE s.series_id,s.name FROM series s,seriescol sc " +
						"WHERE s.series_id = sc.series_id AND sc.col_id=" + col_id +
						" GROUP BY s.series_id,s.name";
		
		ResultSet rsSeries = conn.getResultSet(_sql);
		if(rsSeries.next()){
			String series_id = rsSeries.getString("series_id");
			String series_name = rsSeries.getString("name");*/
			LinkedHashMap<Integer,String> seriesMap = talk_series.get(num);
			if(seriesMap != null){
				if(!seriesMap.isEmpty()){
%>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 1em;">
			<tr>
				<td style="font-weight: bold;" width="8%" align="left" valign="top">Series:</td>
				<td>
<% 
					int series_no = 0;
					for(int series_id : seriesMap.keySet()){
						String series_name = seriesMap.get(series_id);
						int subno = talk_bookmark_series_id.contains(series_id)?1:0;
%>
					<%=series_no>0?"<br/>":"" %>
					<a href="series.do?series_id=<%=series_id%>"><%=series_name%></a>
					<logic:present name="UserSession">
					&nbsp;
					<span class="spansubsid<%=series_id %>" id="spansubcid<%=col_id %>" 
						style="display: <%=subno==0?"none":"inline" %>;font-size: 0.9em;cursor: pointer;background-color: blue;font-weight: bold;color: white;"
						onclick="window.location='series.do?series_id=<%=series_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
					</span>
					&nbsp;	
					<a class="asubsid<%=series_id %>" href="javascript:return false;" 					
						style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
						onclick="subscribeSeries(<%=ub.getUserID() %>, <%=series_id %>, this, 'spansubcid<%=col_id %>')"
					><%=subno>0?"Unsubscribe":"Subscribe" %></a>
					</logic:present>	
<%
						series_no++;

			/*int subno = 0;
			if(ub != null){
				sql = "SELECT SQL_CACHE COUNT(*) _no FROM final_subscribe_series WHERE series_id=" + series_id + " AND user_id=" + ub.getUserID();
				rs = conn.getResultSet(sql);
				if(rs.next()){
					subno = rs.getInt("_no");
				}
			}*/
					}
%>
				</td>
			</tr>
		</table>
<%					
				}
			}
		//rsSeries.close();
		/*if(!req_concise && !req_most_recent && !req_pop_recent){
			sql = "SELECT SQL_CACHE r.path FROM affiliate_col ac INNER JOIN relation r ON ac.affiliate_id = r.child_id WHERE ac.col_id = " + col_id;
			ResultSet rsSponsor = conn.getResultSet(sql);
			ArrayList<String> relationList = new ArrayList<String>();
			HashMap<String,String> aList = new HashMap<String,String>();
			while(rsSponsor.next()){
				String relation = rsSponsor.getString("path");
				
				relationList.add(relation);
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
			sql = "SELECT SQL_CACHE affiliate_id,affiliate FROM affiliate WHERE affiliate_id IN ("+affList+")";
			rsSponsor = conn.getResultSet(sql);
			while(rsSponsor.next()){
				aList.put(rsSponsor.getString("affiliate_id"),rsSponsor.getString("affiliate"));
			}
			rsSponsor.close();
			if(relationList.size()>0){
%>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 1em;font-family: arial,Verdana,sans-serif,serif;">
								<tr>
									<td valign="top" width="8%" style="font-weight: bold;">Sponsor:</td>
									<td align="left" style="">
<% 
				for(int i=0;i<relationList.size();i++){
					String[] path = relationList.get(i).split(",");
					for(int j=0;j<path.length;j++){
%>
								<a href="affiliate.do?affiliate_id=<%=path[j]%>"><%=(String)aList.get(path[j])%>
									</a>
<%					
							if(j!=path.length-1){
%>
								&nbsp;&gt;&nbsp;
<%
							}
					}			
					if(i!=relationList.size()-1){
%>
								<br/>ß
<%
					}
				}
%>									
									</td>
								</tr>
							</table>
<%		
			}
		}*/
%>
							</span>

									</td>
									<td width="<%=pic_url.trim().contains("images/speaker/avartar.gif")?"0":"10%" %>" valign = "top" 
										style="<%=(pic_url.trim().contains("images/speaker/avartar.gif")||req_concise)?"display: none;":"" %>">
										<img class="speakerImg" src="<%=pic_url %>" onload="javascript: DrawImage(this, 65, 65)" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
<%		
		if(ub != null && req_recommend){
			//Show recommendation ranking and methods
			if(recRankMapMap.containsKey(new Integer(col_id))){
				HashMap<Integer,Integer> recRankMap = recRankMapMap.get(new Integer(col_id));
				
				if(recRankMap != null){
%>
					<tr>
						<td colspan="3">
							<span style="font-size: 0.8em;">
								The talk is ranked<br/>
<%					
					ArrayList<String> contentRec = null;
					ArrayList<String> clusterRec = null;
					ArrayList<String> externalSourceRec = null;
					ArrayList<String> modelRec = null;
				
					int i=0;
					for(Integer rec_method_id : recRankMap.keySet()){
						int rank = recRankMap.get(rec_method_id);
						
						String rating = null;
						double _rating = -1;
						HashMap<Integer,Double> recRatingMap = recRatingMapMap.get(new Integer(col_id));
						if(recRatingMap != null){
							if(recRatingMap.containsKey(rec_method_id)){
								try{
								_rating = recRatingMap.get(rec_method_id);
								if(_rating >= 0 && _rating <= 5.0){			
									rating = "" + (int)Math.floor(recRatingMap.get(rec_method_id)) + 
									"." + (int)Math.round((recRatingMap.get(rec_method_id)*10.0))%10;
								}
								}catch(Exception e){}
							}
						}
						
						int rec_category = 0;
						
						String rec_method_name = "";
						switch (rec_method_id.intValue()){
							case 1: rec_method_name = "Keyword-based KNN Current Interest User Model<br/>";rec_category = 1;break;
							case 2: rec_method_name = "Keyword-based KNN General Preference User Model<br/>";rec_category = 1;break;
							case 3: rec_method_name = "Collaborative Topic Model<br/>";rec_category = 4;break;
							case 4: rec_method_name = "SVD-based KNN Current Interest User Model<br/>";rec_category = 1;break;
							case 5: rec_method_name = "SVD-based KNN General Preference User Model<br/>";rec_category = 1;break;
							case 6: rec_method_name = "SVD-based Centroid Current Interest User Model<br/>";rec_category = 1;break;
							case 7: rec_method_name = "SVD-based Centroid General Preference User Model<br/>";rec_category = 1;break;
							case 8: rec_method_name = "SVD-based KNN Metadata-Concatenation Current Interest User Model<br/>";rec_category = 1;break;
							case 9: rec_method_name = "SVD-based KNN Metadata-Concatenation General Preference User Model<br/>";rec_category = 1;break;
							case 10: rec_method_name = "SVD-based Centroid Metadata-Concatenation Current Interest User Model<br/>";rec_category = 1;break;
							case 11: rec_method_name = "SVD-based Centroid Metadata-Concatenation General Preference User Model<br/>";rec_category = 1;break;
							case 12: rec_method_name = "K-Means Centroid Current Interest User Model<br/>";rec_category = 2;break;
							case 13: rec_method_name = "K-Means Centroid General Preference User Model<br/>";rec_category = 2;break;
							case 14: rec_method_name = "K-Means KNN Current Interest User Model<br/>";rec_category = 2;break;
							case 15: rec_method_name = "K-Means KNN General Preference User Model<br/>";rec_category = 2;break;
							case 16: rec_method_name = "K-Means Centroid Metadata-Concatenation Current Interest User Model<br/>";rec_category = 2;break;
							case 17: rec_method_name = "K-Means Centroid Metadata-Concatenation General Preference User Model<br/>";rec_category = 2;break;
							case 18: rec_method_name = "K-Means KNN Metadata-Concatenation Current Interest User Model<br/>";rec_category = 2;break;
							case 19: rec_method_name = "K-Means KNN Metadata-Concatenation General Preference User Model<br/>";rec_category = 2;break;
							case 20: rec_method_name = "Self-Organizing Map Centroid Current Interest User Model<br/>";rec_category = 2;break;
							case 21: rec_method_name = "Self-Organizing Map Centroid General Preference User Model<br/>";rec_category = 2;break;
							case 22: rec_method_name = "Self-Organizing Map KNN Current Interest User Model<br/>";rec_category = 2;break;
							case 23: rec_method_name = "Self-Organizing Map KNN General Preference User Model<br/>";rec_category = 2;break;
							case 24: rec_method_name = "Self-Organizing Map Centroid Metadata-Concatenation Current Interest User Model<br/>";rec_category = 2;break;
							case 25: rec_method_name = "Self-Organizing Map Centroid Metadata-Concatenation General Preference User Model<br/>";rec_category = 2;break;
							case 26: rec_method_name = "Self-Organizing Map KNN Metadata-Concatenation Current Interest User Model<br/>";rec_category = 2;break;
							case 27: rec_method_name = "Self-Organizing Map KNN Metadata-Concatenation General Preference User Model<br/>";rec_category = 2;break;
							case 28: rec_method_name = "K-Medoids Centroid Current Interest User Model<br/>";rec_category = 2;break;
							case 29: rec_method_name = "K-Medoids Centroid General Preference User Model<br/>";rec_category = 2;break;
							case 30: rec_method_name = "K-Medoids KNN Current Interest User Model<br/>";rec_category = 2;break;
							case 31: rec_method_name = "K-Medoids KNN General Preference User Model<br/>";rec_category = 2;break;
							case 32: rec_method_name = "K-Medoids Centroid Metadata-Concatenation Current Interest User Model<br/>";rec_category = 2;break;
							case 33: rec_method_name = "K-Medoids Centroid Metadata-Concatenation General Preference User Model<br/>";rec_category = 2;break;
							case 34: rec_method_name = "K-Medoids KNN Metadata-Concatenation Current Interest User Model<br/>";rec_category = 2;break;
							case 35: rec_method_name = "K-Medoids KNN Metadata-Concatenation General Preference User Model<br/>";rec_category = 2;break;
							case 36: rec_method_name = "Keyword-based KNN CiteULike Augmentation Current Interest User Model<br/>";rec_category = 3;break;
							case 37: rec_method_name = "Keyword-based KNN CiteULike Augmentation General Preference User Model<br/>";rec_category = 3;break;
							case 38: rec_method_name = "Keyword-based Title-Only KNN CiteULike Augmentation Current Interest User Model<br/>";rec_category = 3;break;
							case 39: rec_method_name = "Keyword-based Title-Only KNN CiteULike Augmentation General Preference User Model<br/>";rec_category = 3;break;
							case 40: rec_method_name = "SVD-based KNN CiteULike Augmentation Current Interest User Model<br/>";rec_category = 3;break;
							case 41: rec_method_name = "SVD-based KNN CiteULike Augmentation General Preference User Model<br/>";rec_category = 3;break;
							case 42: rec_method_name = "SVD-based Centroid CiteULike Augmentation Current Interest User Model<br/>";rec_category = 3;break;
							case 43: rec_method_name = "SVD-based Centroid CiteULike Augmentation General Preference User Model<br/>";rec_category = 3;break;

							case 500: rec_method_name = "Content-boosted Collaborative Filtering Current Interest User Model<br/>";rec_category = 1;break;
							case 501: rec_method_name = "Content-boosted Collaborative Filtering General Preference User Model<br/>";rec_category = 1;break;
						}
						
						if(rec_method_name.length() > 0){						
%>
<%-- 
								<%=i==0?"":"," %>&nbsp;<%=(i==recRankMap.keySet().size()-1&&i!=0)?"and&nbsp;":"" %>
								<span style="color: blue;font-weight: bold;font-size: 1.2em;">#<%=rank %></span> 
								<%=rating!=null?"with predicted rating <span style=\"color: blue;font-weight: bold;font-size: 1.2em;\">" + _rating + "</span> CoMeTs ":"" %>
								<span style="color: green;font-weight: bold;">by the <%=rec_method_name %><%=(i==recRankMap.keySet().size()-1&&i!=0)?"&nbsp;Recommendation" + (i>1?"s":""):"" %></span>
--%>
<%					
								String _rec_ex = "<span style=\"color: blue;font-weight: bold;font-size: 1.2em;\">#" + rank + "</span>" +
								(rating!=null?
									" with predicted rating <span style=\"color: blue;font-weight: bold;font-size: 1.2em;\">" + 
									rating + "</span> CoMeTs ":""
								) +
								"&nbsp;by the <span style=\"color: green;font-weight: bold;\">" + rec_method_name + "</span>";
							if(rec_category == 1){//content
								if(contentRec == null)contentRec = new ArrayList<String>();
								contentRec.add(_rec_ex);
							}
							
							if(rec_category == 2){//cluster
								if(clusterRec == null)clusterRec = new ArrayList<String>();
								clusterRec.add(_rec_ex);
							}
							
							if(rec_category == 3){//external source
								if(externalSourceRec == null)externalSourceRec = new ArrayList<String>();
								externalSourceRec.add(_rec_ex);								
							}
							
							if(rec_category == 4){//model
								if(modelRec == null)modelRec = new ArrayList<String>();
								modelRec.add(_rec_ex);
							}

						}
						i++;
					}
					
					if(contentRec != null){
%>
								<span style="font-weight: bold;font-size: 1.2em;">Content-Based Recommendation</span><br/>
<%						
						for(String s : contentRec){
%>
								<%=s %>
<%						
						}		
%>
								<br/>
<%						
					}
					if(clusterRec != null){
%>
								<span style="font-weight: bold;font-size: 1.2em;">Clustering-Based Recommendation</span><br/>
<%						
						for(String s : clusterRec){
%>
								<%=s %>
<%						
						}
%>
								<br/>
<%						
					}
					if(externalSourceRec != null){
%>
								<span style="font-weight: bold;font-size: 1.2em;">Content-Based Recommendation with External Source Augmentation</span><br/>
<%						
						for(String s : externalSourceRec){
%>
								<%=s %>
<%						
						}		
%>
								<br/>
<%						
					}
					if(modelRec != null){
%>
								<span style="font-weight: bold;font-size: 1.2em;">Model-Based Recommendation</span><br/>
<%						
						for(String s : modelRec){
%>
								<%=s %>
<%						
						}		
%>
								<br/>
<%						
					}
%>
							</span>
						</td>
					</tr>
<%									
				}
			}
			double rating = -1;
			sql = "SELECT luf.rating " +
					"FROM lastuserfeedback luf " +
					"WHERE luf.user_id=" + ub.getUserID() +
					" AND luf.col_id=" + col_id;
			ResultSet rsRating = conn.getResultSet(sql);
			if(rsRating.next()){
				rating = rsRating.getDouble(1);				
%>
					<tr>
						<td colspan="3" id="tdUserRecFeedback<%=col_id %>">
							<span style="font-size: 0.85em;font-weight: bold;">
								Your rating is <span style="color: blue;"><%=rating %></span>
							</span> 
							<a style="font-size: 0.7em;" href="javascript: return false;" 
								onclick="document.getElementById('tdRecFeedbackBar<%=col_id %>').style.display = 'block';document.getElementById('tdUserRecFeedback<%=col_id %>').style.display = 'none';">Update Rating</a>
						</td>
					</tr>
<%
			}
%>
					<tr>
						<td colspan="3" id="tdRecFeedbackBar<%=col_id %>" <%=rating>-1?"style=\"display: none;\"":"" %>>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 0.7em;">
								<tr>
									<td style="font-weight: bold;">
										Rate relevance of this talk to your interest (0 CoMeT: not at all - 5 CoMeTs: totally relevant)
									</td>
								</tr>
								<tr>
									<td id="tdRecFeedbackBar<%=col_id %>">
										<iframe style="border: none;" scrolling="no" width="800" height="50" src="SliderBarFeedback.html?col_id=<%=col_id %>&nocommrating=1"></iframe>
									</td>
								</tr>
							</table>
						</td>
					</tr>
<%			
		}
	}
		
	if(!day.equalsIgnoreCase("")){
		if(req_most_recent&&!req_no_header){
%>
					<tr id="trMostRecent" style="display: none;">
						<td id="tdMostRecent"><div align='center'><img border='0' src='images/loading.gif' /></div></td>
					</tr>
<%		
		}
%>
				</table>
			</td>
		</tr>
<%			
		if(menu.equalsIgnoreCase("myaccount")){
%>
		<tr>
			<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
		</tr>
		<tr>
			<td align="right">
				<input class="btn" type="button" value="<%=req_posted?"Delete":"Unbookmark" %>" onclick="deleteCols();" >
			</td>
		</tr>
<%			
		}
	}
	
	if((req_top_comet || req_top_slide || req_top_video || req_pop_recent) && !req_concise){
		String req_more_talk_para = "";
		if(req_top_comet){
			req_more_talk_para = "topcomet";
		}
		if(req_top_slide){
			req_more_talk_para = "topslide";
		}
		if(req_top_video){
			req_more_talk_para = "topvideo";
		}
		if(req_pop_recent){
			req_more_talk_para = "poprecent";
		}
		
		//Check whether there are some talks left
		String _sql = "SELECT SQL_CACHE COUNT(*) _no FROM colloquium c JOIN col_impact ci ON ci.col_id= c.col_id " +
						"WHERE TRUE ";
		if(req_top_video){
			_sql += "AND c.video_url IS NOT NULL and LENGTH(TRIM(c.video_url)) > 0 ";
		}
		if(req_top_slide){
			_sql += "AND c.video_url IS NOT NULL and LENGTH(TRIM(c.slide_url)) > 0 ";
		}
		if(req_pop_recent){
			_sql += "AND c._date > CURDATE() ";
		}
		rs = conn.getResultSet(_sql);
		if(rs.next()){
			int _no = rs.getInt(1);
			
			if(req_start + req_rows < _no){
				//There are some talks left, so show the "show more" button
%>
		<tr>
			<td>
				<div id="divMoreTalk<%=req_start %>" style="text-align: center;">
					<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
						<tr>
							<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
						</tr>
						<tr>
							<td bgcolor="#efefef" style="font-size: 0.9em;font-weight: bold;text-align: center;">&nbsp;
								<input id="btnLoadTalkMore" class="btn" type="button" 
									onclick="this.value='Loading...';this.style.disabled='disabled';showMoreTalk('<%=req_more_talk_para %>','divMoreTalk<%=req_start %>','<%=(req_start + req_rows) %>');return false;" 
									value="Show More" />
							</td>
						</tr>
						<tr>
							<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
						</tr>
					</table>	
				</div>
			</td>
		</tr>
<%				
			}
		}
	}
	
	if(noTalks && !req_most_recent){
%>
		<tr>
			<td id="lblNoTalk" style="font-size: 0.95em;font-weight: bold;" align="center"><%=olderTalkNo>0?"No Forthcoming Talks":"No Talks" %></td>
		</tr>
<%
	}
%>
	</table>
	<input type="hidden" id="count" value="<%= num %>" />
<% 
	if(menu.equalsIgnoreCase("myaccount")){
%>
	</form>
<%
	}
	conn.conn.close();
	conn = null;
	session.removeAttribute("SortByTime");
	session.removeAttribute("startIndex");
	session.removeAttribute("endIndex");
	session.removeAttribute("newOldTalks");
%>
</div>