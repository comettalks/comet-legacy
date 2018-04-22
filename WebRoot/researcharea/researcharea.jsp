<%@ page language="java"%>
<%@ page import="edu.pitt.sis.beans.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="edu.pitt.sis.db.*"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean"
	prefix="bean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html"
	prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic"
	prefix="logic"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles"
	prefix="tiles"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template"
	prefix="template"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested"
	prefix="nested"%>

<table cellspacing="0" cellpadding="0" width="100%" align="center">
<% 
	session=request.getSession(false);
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String menu = (String)session.getAttribute("menu");
	Calendar calendar = new GregorianCalendar();
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
	int today = calendar.get(Calendar.DAY_OF_MONTH);
	int req_day = -1;
	int req_week = -1;
	int req_month = month+1;
	int req_year = year;
	boolean req_recommend = false;
	boolean isdebug = false;
	String[] area_id_value = request.getParameterValues("area_id");

	//researcharea modification
	String[] affiliate_rs_id_value = request.getParameterValues("affiliate_rs_id"); //parameter for affiliate
	String[] location_id_value = request.getParameterValues("location_id"); // parameter for location
	String[] host_rs_id_value = request.getParameterValues("host_rs_id"); //parameter for host
	String[] speaker_rs_id_value = request.getParameterValues("speaker_rs_id"); //parameter for speaker
	String[] group_rs_id_value = request.getParameterValues("group_rs_id"); //parameter for group
	String[] series_rs_id_value = request.getParameterValues("series_rs_id"); //parameter for series
	String[]	bk_rs_id_value = request.getParameterValues("bk_rs_id"); //parameter for bookmark
	String[] owner_rs_id_value = request.getParameterValues("owner_rs_id"); //parameter for owner

	if(request.getParameter("day")!=null){
	    req_day = Integer.parseInt(request.getParameter("day"));
	}
	
	if(request.getParameter("week")!=null){
	    req_week = Integer.parseInt(request.getParameter("week"));
	}
	
	if(request.getParameter("month")!=null){
	    req_month = Integer.parseInt(request.getParameter("month"));
	}
	
	if(request.getParameter("year")!=null){
	    req_year = Integer.parseInt(request.getParameter("year"));
	}else{
		req_week = calendar.get(Calendar.WEEK_OF_MONTH);
	}
	if(request.getParameter("recommend")!=null){
		req_recommend = true;
	}
	if(request.getParameter("isdebug")!=null){
		isdebug = true;
	}
	connectDB conn = new connectDB();

	Calendar setcal = new GregorianCalendar();
	setcal.set(req_year, req_month-1, 1);
	int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
	int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
   
	//daysPrevMonth - startday + 1
	String strBeginDate = "";
	String strEndDate = "";
	   if(req_month == 1){
	   	setcal.set(req_year-1, 11, 1);
	   }else{
	   	setcal.set(req_year, req_month-2, 1);
	   }  
	   int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
	if(startday == 0){
		strBeginDate = req_year + "-" + req_month + "-1";
	}else{
		if(req_month == 1){
			strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
		}else{
			strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);		
		}
	}
	if((startday + stopday)%7 == 0){
		strEndDate = req_year + "-" + req_month + "-" + stopday;
	}else{
		if(req_month == 12){
			strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
		}else{
			strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
		}
	}
	String feed_para = "";
	if(menu.equalsIgnoreCase("calendar") && req_day==-1 && req_week==-1 && req_month == month+1 && req_year==year){
		req_week = calendar.get(Calendar.WEEK_OF_MONTH);
	}

/*****************************************************************/
/* Day View                                                      */
/*****************************************************************/
	if(req_day > 0){
		strBeginDate = req_year + "-" + req_month + "-" + req_day;
		strEndDate = req_year + "-" + req_month + "-" + req_day;
	}else{
	    if(req_month == 1){
	    	setcal.set(req_year-1, 11, 1);
	    }else{
			setcal.set(req_year, req_month-2, 1);
	    }  							
/*****************************************************************/
/* Week View                                                     */
/*****************************************************************/
		if(req_week > 0){
			if(startday == 0){
				strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week-1) + 1);
			}else{
				if(req_week == 1){
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
					String tmpBeginDate = "";
					if(req_month==1){
						strBeginDate = (req_year-1) + "-12-" + (daysPrevMonth - startday + 1);
					}
				}else{
					strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week - 1) - startday + 1);
				}
			}
			if(7*req_week - startday <= stopday ){
				strEndDate = req_year + "-" + req_month + "-" + (7*req_week - startday);
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
				}
			}
		}else{
   /*****************************************************************/
   /* Month View                                                    */
   /*****************************************************************/
			if(startday == 0){
				strBeginDate = req_year + "-" + req_month + "-1";
			}else{
				if(req_month == 1){
					strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
				}else{
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
				}
			}
			if((startday + stopday)%7 == 0){
				strEndDate = req_year + "-" + req_month + "-" + (stopday);
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
				}
			}
		}
	}

	//LEFT OUTER JOIN makes joining tables wrong if area_id is specified
	boolean noLeftOuterJoin = false;
	
	if(area_id_value != null&&area_id_value.length > 0){
		noLeftOuterJoin = true;
	}
	
	//researcharea modification
	int lvl = 1;
	String path = "%";
	boolean affiliate_checkflag = false;
	if (affiliate_rs_id_value != null && affiliate_rs_id_value.length>0) {
		if (affiliate_rs_id_value.length == 1) {
			if (!affiliate_rs_id_value[0].equals("0")) {
				affiliate_checkflag = true;
				lvl = 2;
				path = affiliate_rs_id_value[0]+path;
			}
		} else if (affiliate_rs_id_value.length == 2) {
			affiliate_checkflag = true;
			if (affiliate_rs_id_value[1].equals("-1")) {
				lvl = 2;
				path =  affiliate_rs_id_value[0] + "";
			} else {
				lvl = 3;
				path = affiliate_rs_id_value[1] + ","+affiliate_rs_id_value[0] + "%";
			}
		} else if (affiliate_rs_id_value.length == 3) {
			affiliate_checkflag = true;
			if (affiliate_rs_id_value[2].equals("-1")) {
				lvl = 3;
				path = affiliate_rs_id_value[1] + ","+affiliate_rs_id_value[0] + "";
			}
			else {
				lvl = 3;
				path = affiliate_rs_id_value[1] + ","+affiliate_rs_id_value[2] + "," + affiliate_rs_id_value[0];
			}
		}
	}

	String sql = "FROM (SELECT c.col_id col_id, IFNULL(a.area_id,0) area_id,IFNULL(a.area,'zUnclassified') area, " + 
		(affiliate_checkflag?"afc.affiliate_id  ":"IFNULL(af.affiliate_id,0) ") +
		"affiliate_id, " + 
		(affiliate_checkflag?"IF(afc.affiliate_id=-1,'zOther', af.affiliate) ":"IFNULL(af.affiliate, 'zUnknown') ") +
		"affiliate, " + 
		"IFNULL(c.host_id,0) host_id, IFNULL(h.host, 'zUnknown') host, "+
		"IFNULL(c.speaker_id,0) speaker_id, IFNULL(s.sname, 'zUnknown') sname, "+
		"IFNULL(cmt.comm_id, 0) comm_id, IFNULL(cmt.comm_name, 'zN/A') comm_name, "+
		"IFNULL(se.series_id, 0) series_id, IFNULL(se.name, 'zN/A') series_name, "+
		"IFNULL(lca.loc_id,0) location_id, IFNULL(lca.location, 'zUnknown') location "+
		"FROM colloquium c left outer JOIN area_col ac ON c.col_id=ac.col_id "+
		"left outer JOIN area a ON ac.area_id=a.area_id "+
		(affiliate_checkflag?"":"left outer ") +
		"JOIN (SELECT DISTINCT ac.col_id as col_id, " +
		"IF(CONVERT(SPLIT_STR(path,',', "+lvl+"),UNSIGNED)=0, -1, CONVERT(SPLIT_STR(path,',', "+lvl+"),UNSIGNED)) AS affiliate_id " +
		"FROM affiliate_col ac JOIN relation r on ac.affiliate_id = r.child_id WHERE path LIKE '"+path+"')afc " +
		"ON c.col_id=afc.col_id " +
		"left outer JOIN affiliate af On afc.affiliate_id=af.affiliate_id "+
		"left outer JOIN host h ON c.host_id=h.host_id " +
		"left outer JOIN location_col_copy lcc ON c.col_id=lcc.col_id "+
		"left outer JOIN location_copy lca ON lcc.loc_id=lca.loc_id "+
		"left outer JOIN (SELECT speaker_id, name sname FROM speaker)s ON c.speaker_id=s.speaker_id "+
		"left outer JOIN (SELECT comm_id, col_id FROM contribute) ctb ON c.col_id=ctb.col_id left outer JOIN (SELECT comm_id, comm_name FROM community) cmt ON ctb.comm_id=cmt.comm_id " +
		"left outer JOIN seriescol scl oN c.col_id=scl.col_id left outer JOIN (SELECT series_id, name FROM series) se ON scl.series_id= se.series_id ";

	sql += "WHERE c._date >= '" + strBeginDate + " 00:00:00' " +
			"AND c._date <= '" + strEndDate + " 23:59:59' ";
	

	//researcharea modification
	if(bk_rs_id_value !=null && bk_rs_id_value.length >0){
		sql +="AND c.col_id IN (SELECT col_id FROM userprofile WHERE user_id="+ub.getUserID()+") ";
	}
	
	if(owner_rs_id_value !=null && owner_rs_id_value.length >0){
		sql+="AND c.owner_id="+ub.getUserID()+" ";
	}

	if(area_id_value !=null && area_id_value.length >0){
		for(int i=0; i<area_id_value.length;i++){
			if(!area_id_value[i].equalsIgnoreCase("0")){
				sql += "AND c.col_id IN (SELECT col_id FROM area_col WHERE area_id=" + area_id_value[i] +") ";
			}
			else{
				sql += "AND  c.col_id NOT IN(SELECT col_id FROM area_col) ";
			}
		}
	}

	if(affiliate_rs_id_value !=null&& affiliate_rs_id_value.length>0){
		if(affiliate_rs_id_value[0].equalsIgnoreCase("0")){
			sql += " AND c.col_id NOT IN (SELECT col_id FROM (select ac.col_id as col_id from affiliate_col ac join relation r on ac.affiliate_id = r.child_id group by ac.col_id)afc1) ";
		}
	}
	if(group_rs_id_value !=null&& group_rs_id_value.length>0){
		for(int i=0; i<group_rs_id_value.length;i++){
			if(group_rs_id_value[i].equalsIgnoreCase("0")){
				sql += "AND c.col_id IN (SELECT col_id FROM contribute WHERE comm_id ="+group_rs_id_value[i]+") ";
			}
			else{
				sql += "AND c.col_id NOT IN (SELECT col_id FROM contribute) ";
			}
		}
	}
	if(series_rs_id_value !=null&& series_rs_id_value.length>0){
		for(int i=0;i<series_rs_id_value.length;i++){
			if(!series_rs_id_value[i].equalsIgnoreCase("0")){
				sql += "AND c.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_rs_id_value[i] + ") ";
			}
			else{
				sql += "AND c.col_id NOT IN (SELECT col_id FROM seriescol) ";
			}
		}
	}

	if(area_id_value!=null&&area_id_value.length>0){
		
		for(int i=0;i<area_id_value.length;i++){
			sql += " AND a.area_id<>" + (area_id_value[i].equalsIgnoreCase("0")?"NULL":area_id_value[i]) + " ";
		}
	}
	if(affiliate_rs_id_value!=null&&affiliate_rs_id_value.length>0){
		int af_id = affiliate_rs_id_value.length -1;
		if (af_id == 2) {
		    af_id = 0;
		}
		sql += " AND af.affiliate_id<> " + 	(affiliate_rs_id_value[af_id].equalsIgnoreCase("0")?"NULL":affiliate_rs_id_value[af_id])+" ";
	}
	if(host_rs_id_value!=null&&host_rs_id_value.length>0){
		for(int i=0;i<host_rs_id_value.length;i++){
			sql += " AND c.host_id=" + (host_rs_id_value[i].equalsIgnoreCase("0")?"NULL":host_rs_id_value[i]) + " ";
		}
	}
	if(speaker_rs_id_value!=null&&speaker_rs_id_value.length>0){
		for(int i=0;i<speaker_rs_id_value.length;i++){
			sql += " AND c.speaker_id=" + (speaker_rs_id_value[i].equalsIgnoreCase("0")?"NULL":speaker_rs_id_value[i]) + " ";
		}
	}
	if(group_rs_id_value !=null&& group_rs_id_value.length>0){
		for(int i=0; i<group_rs_id_value.length;i++){
			sql += " AND cmt.comm_id <>" +(group_rs_id_value[i].equalsIgnoreCase("0")?"NULL":group_rs_id_value[i]) + " ";
		}
	}
	if(series_rs_id_value!=null&&series_rs_id_value.length>0){
		for(int i=0;i<series_rs_id_value.length;i++){
			sql += " AND se.series_id<>" + (series_rs_id_value[i].equalsIgnoreCase("0")?"NULL":series_rs_id_value[i]) + " ";
		}
	}

	if(req_recommend){
	    ArrayList<Integer> recList = new ArrayList<Integer>();
		String strRecBeginDate = "";
		String strRecEndDate = "";
		/*****************************************************************/
		/* Day or Week View                                              */
		/*****************************************************************/
		if(req_day > 0 || req_week > 0){
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
				    daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);				
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
		
			/*String _sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.weight >= u.min_score AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 5";
			if(isdebug)System.out.println(_sql);
			ResultSet rs = conn.getResultSet(_sql);
			while(rs.next()){
				recList.add(rs.getInt("col_id"));
			}*/
	
			//Fetch user recommendation method 1,2
			String _sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (1,2) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 5";
					ResultSet rs = conn.getResultSet(_sql);
			if(isdebug)out.println(_sql);
			while(rs.next()){
				recList.add(rs.getInt("col_id"));
			}
			
			//Fetch user recommendation method 4,5
			_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (4,5) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 5";
			rs = conn.getResultSet(_sql);
			if(isdebug)out.println(_sql);
			while(rs.next()){
				recList.add(rs.getInt("col_id"));
			}		
	
			//Fetch user recommendation method 6,7
			_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (6,7) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 5";
			rs = conn.getResultSet(_sql);
			if(isdebug)out.println(_sql);
			while(rs.next()){
				recList.add(rs.getInt("col_id"));
			}	
	
			//Fetch user recommendation method 8,9
			_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (8,9) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 5";
			rs = conn.getResultSet(_sql);
			if(isdebug)out.println(_sql);
			while(rs.next()){
				recList.add(rs.getInt("col_id"));
			}	
			
			//Fetch user recommendation method 10,11
			_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"JOIN userinfo u ON ru.user_id = u.user_id " +
					"WHERE ru.rec_method_id IN (10,11) " + //AND ru.weight >= u.min_score 
					"AND ru.user_id=" + ub.getUserID() + 
					" AND c._date >='" + strRecBeginDate + "' " +
					"AND c._date <='" + strRecEndDate + "' " +
					"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
					"ORDER BY ru.weight DESC LIMIT 5";
			rs = conn.getResultSet(_sql);
			if(isdebug)out.println(_sql);
			while(rs.next()){
				recList.add(rs.getInt("col_id"));
			}	
		}else{
	    /*****************************************************************/
	    /* Month View                                                    */
	    /*****************************************************************/
	    	for(int i=0;i<6;i++){//No more than 6 weeks a month
	
				int week_no = i;
				//Calculate begin date first
				if(startday == 0){//Is Sunday?
	
				}else{//Not Sunday
					if(week_no == 1){//Is the first week of month?
						if(req_month == 1){//January?
					    	setcal.set(req_year-1, 11, 1);
					    }else{
					    	setcal.set(req_year, req_month-2, 1);
					    }  
					    daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);				
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
	
				/*String _sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.weight >= u.min_score AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 5";
				if(isdebug)System.out.println(_sql);
				ResultSet rs = conn.getResultSet(_sql);
				while(rs.next()){
					recList.add(rs.getInt("col_id"));
				}*/
				
				//Fetch user recommendation method 1,2
				String _sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (1,2) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 5";
						ResultSet rs = conn.getResultSet(_sql);
				if(isdebug)out.println(_sql);
				while(rs.next()){
					recList.add(rs.getInt("col_id"));
				}
				
				//Fetch user recommendation method 4,5
				_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (4,5) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 5";
				rs = conn.getResultSet(_sql);
				if(isdebug)out.println(_sql);
				while(rs.next()){
					recList.add(rs.getInt("col_id"));
				}		
		
				//Fetch user recommendation method 6,7
				_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (6,7) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 5";
				rs = conn.getResultSet(_sql);
				if(isdebug)out.println(_sql);
				while(rs.next()){
					recList.add(rs.getInt("col_id"));
				}	
	
				//Fetch user recommendation method 8,9
				_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (8,9) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 5";
				rs = conn.getResultSet(_sql);
				if(isdebug)out.println(_sql);
				while(rs.next()){
					recList.add(rs.getInt("col_id"));
				}	
				
				//Fetch user recommendation method 10,11
				_sql = "SELECT c.col_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
						"JOIN userinfo u ON ru.user_id = u.user_id " +
						"WHERE ru.rec_method_id IN (10,11) " + //AND ru.weight >= u.min_score 
						"AND ru.user_id=" + ub.getUserID() + 
						" AND c._date >='" + strRecBeginDate + "' " +
						"AND c._date <='" + strRecEndDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + ub.getUserID() + ") " +
						"ORDER BY ru.weight DESC LIMIT 5";
				rs = conn.getResultSet(_sql);
				if(isdebug)out.println(_sql);
				while(rs.next()){
					recList.add(rs.getInt("col_id"));
				}	
	    	}
		}
	   	if(recList.size() > 0){
	   		sql += " AND c.col_id IN ( ";
	   		
	   		for (int col_id : recList){
	   		 	sql += "" + col_id + ",";
	   		 	
	   		}
	   		sql = sql.substring(0, sql.length()-1);
	   		
	   		sql += ")";
	   	}else{
			sql += " AND FALSE "; 
			  		
	   	}
	}

	if(isdebug)System.out.println(sql);


	//researcharea modification
	//_7 for ownership
	if(ub!=null&&(owner_rs_id_value ==null || (owner_rs_id_value !=null && owner_rs_id_value.length == 0))){
		String sql_owner= "SELECT COUNT(DISTINCT col_id) _no ";
		sql_owner += sql;
		sql_owner += " AND c.owner_id ="+ub.getUserID()+" ";
		sql_owner += ") t ";
		System.out.println(sql_owner);
		ArrayList<Integer> noTalkList_7 = new ArrayList<Integer>();// for owner
		//for owner
		ResultSet rsowner = conn.getResultSet(sql_owner);
		while(rsowner.next()){
			int talkno = rsowner.getInt("_no");
			noTalkList_7.add(talkno);
		}
		if(noTalkList_7.get(0) >= 0){
%>
	<tr>
		<td style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0" width="100%"
				align="center">
				<tr>
					<td bgcolor="#00468c">
						<div style="height: 2px; overflow: hidden;">&nbsp;</div>
					</td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em; font-weight: bold;">
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addowner(<%=1 %>);refreshTalks();"> Your Posted
							Talks(<%=noTalkList_7.get(0) %>)
						</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
<%
		}
	}

	//_8 for bookmark 
	if(ub!=null&&(bk_rs_id_value ==null || (bk_rs_id_value !=null && bk_rs_id_value.length == 0))){
		String sql_bk= "SELECT COUNT(DISTINCT col_id) _no ";
		sql_bk += sql;
		sql_bk += "AND c.col_id IN (SELECT col_id FROM userprofile WHERE user_id="+ub.getUserID()+") ";
		sql_bk += ") t ";
	
		ArrayList<Integer> noTalkList_8 = new ArrayList<Integer>();// for owner
		ResultSet rsbk = conn.getResultSet(sql_bk);
		while(rsbk.next()){
			int talkno = rsbk.getInt("_no");
			noTalkList_8.add(talkno);
		}
		if(noTalkList_8.get(0) >= 0){
%>
	<tr>
		<td style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0" width="100%"
				align="center">
				<tr>
					<td bgcolor="#00468c"><div
							style="height: 2px; overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef" style="font-size: 0.95em; font-weight: bold;">
						<a href="javascript: return false;"
							style="text-decoration: none; font-size: 0.8em;"
							onmouseout="this.style.textDecoration='none'"
							onmouseover="this.style.textDecoration='underline'"
							onclick="addbk(<%=1 %>);refreshTalks();"> 
							Your Bookmarked Talks(<%=noTalkList_8.get(0) %>)
						</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
<%
		}
	}
	
	//for area
	String sql_area = "SELECT area_id,area,COUNT(DISTINCT col_id) _no ";
	sql_area += sql;
	sql_area += ") t GROUP BY area_id, area ORDER BY area";
	System.out.println(sql_area);
	LinkedHashMap<Integer,String> areaMap = new LinkedHashMap<Integer,String>();
	ArrayList<Integer> noTalkList = new ArrayList<Integer>();
	ResultSet rsArea = conn.getResultSet(sql_area);
	while(rsArea.next()){
		int area_id = rsArea.getInt("area_id");
		String area = rsArea.getString("area");
		int talkno = rsArea.getInt("_no");
		
		areaMap.put(area_id,area);
		noTalkList.add(talkno);
	}
	
	if(areaMap.size() > 0){
%>
	<tr>
		<td style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0" width="100%"
				align="center">
				<tr>
					<td bgcolor="#00468c"><div
							style="height: 2px; overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef"
						style="font-size: 0.95em; font-weight: bold;"><%=area_id_value!=null?"Related ":"" %>Research
						Area<%=(areaMap.size()>1?"s":"") %></td>
				</tr>
<%		
		int i=0;
		for(int area_id : areaMap.keySet()){
			String area = areaMap.get(area_id);
			if(area_id == 0){
				area = area.substring(1, area.length());
			}
	
%>
				<tr>
					<td <%=i%2==1?"style=\"background-color: #efefef;\"":"" %>>
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addArea(<%=area_id %>,'<%=area %>');refreshTalks();">
							<%=area%> (<%=noTalkList.get(i) %>)
						</a>
					</td>
				</tr>
<%		
			i++;
		}
%>
			</table>
		</td>
	</tr>
<%
	}
	
	//researcharea modification
	//_1 for affiliate
	String sql_affiliate= "SELECT affiliate_id, affiliate, COUNT(DISTINCT col_id) _no ";
	sql_affiliate += sql;
	sql_affiliate +=") t GROUP BY affiliate_id,affiliate ORDER BY affiliate";
	
	System.out.println("gyanchen" + sql_affiliate);
	LinkedHashMap<Integer,String> affiliateMap = new LinkedHashMap<Integer,String>();// for affiliate
	ArrayList<Integer> noTalkList_1 = new ArrayList<Integer>();// for affiliate
	//for affiliate
	
	ResultSet rsAffiliate = conn.getResultSet(sql_affiliate);
	while(rsAffiliate.next()){
		int affiliate_rs_id = rsAffiliate.getInt("affiliate_id");
		String affiliate = rsAffiliate.getString("affiliate");
		int talkno = rsAffiliate.getInt("_no");
		
		affiliateMap.put(affiliate_rs_id,affiliate);
		noTalkList_1.add(talkno);
	}
	if(affiliateMap.size() > 0){
%>
	<tr>
		<td style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0" width="100%"
				align="center">
				<tr>
					<td bgcolor="#00468c"><div
						style="height: 2px; overflow: hidden;">&nbsp;</div>
					</td>
				</tr>
				<tr>
					<td bgcolor="#efefef"
						style="font-size: 0.95em; font-weight: bold;">Sponsor<%=(affiliateMap.size()>1?"s":"") %>
					</td>
				</tr>
<%
		int i=0;
		for(int affiliate_rs_id : affiliateMap.keySet()){
			String affiliate = affiliateMap.get(affiliate_rs_id);
			if(affiliate_rs_id ==0 || affiliate_rs_id == -1){
				affiliate = affiliate.substring(1,affiliate.length());
			}
%>
				<tr>
					<td <%=i%2==1?"style=\"background-color: #efefef;\"":"" %>>
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addAffiliate(<%=affiliate_rs_id %>,'<%=affiliate %>');refreshTalks();">
							<%=affiliate%> (<%=noTalkList_1.get(i) %>)
						</a>
					</td>
				</tr>
<%
			i++;
		}
%>
			</table>
		</td>
	</tr>
<%		
	}
	if(host_rs_id_value==null||host_rs_id_value.length==0){
		//for host _2
		String sql_host = "SELECT host_id, host, COUNT(DISTINCT col_id) _no ";
		sql_host += sql;
		sql_host +=") t GROUP BY host_id,host ORDER BY host";
		LinkedHashMap<Integer,String> hostMap = new LinkedHashMap<Integer,String>();
		ArrayList<Integer> noTalkList_2 = new ArrayList<Integer>();
		ResultSet rsHost = conn.getResultSet(sql_host);
		while(rsHost.next()){
			int host_id = rsHost.getInt("host_id");
			String host = rsHost.getString("host");
			int talkno = rsHost.getInt("_no");
			
			if(host.trim().length() == 0){
				host = "N/A";
			}
			
			hostMap.put(host_id,host);
			noTalkList_2.add(talkno);
		}
		if(hostMap.size() > 0){
%>
	<tr>
		<td style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0"
				width="100%" align="center">
				<tr>
					<td bgcolor="#00468c"><div
						style="height: 2px; overflow: hidden;">&nbsp;</div>
					</td>
				</tr>
				<tr>
					<td bgcolor="#efefef"
						style="font-size: 0.95em; font-weight: bold;"><%=location_id_value!=null?"Related":"" %>Host<%=(hostMap.size()>1?"s":"") %>
					</td>
				</tr>
<%
			int i=0;
			for(int host_id : hostMap.keySet()){
				String host = hostMap.get(host_id);
				if(host_id ==0){
									host = host.substring(1,host.length());
				}
%>
				<tr>
					<td <%=i%2==1?"style=\"background-color: #efefef;\"":"" %>>
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addhost(<%=host_id %>,'<%=host %>');refreshTalks();">
							<%=host%> (<%=noTalkList_2.get(i) %>)
						</a>
					</td>
				</tr>
<%
				i++;
			}
%>
			</table>
		</td>
	</tr>
<%
		} 
	}

	//for group _3
	String sql_group = "SELECT comm_id, comm_name, COUNT(DISTINCT col_id) _no ";
	sql_group += sql;
	sql_group +=")t GROUP BY comm_id, comm_name ORDER BY comm_name";
	LinkedHashMap<Integer,String> groupMap = new LinkedHashMap<Integer,String>();
	ArrayList<Integer> noTalkList_3 = new ArrayList<Integer>();
	ResultSet rsgroup = conn.getResultSet(sql_group);
	while(rsgroup.next()){
		int group_id = rsgroup.getInt("comm_id");
		String group = rsgroup.getString("comm_name");
		int talkno = rsgroup.getInt("_no");
		
		groupMap.put(group_id,group);
		noTalkList_3.add(talkno);
	}
	if(groupMap.size() > 0){
%>
	<tr>
		<td style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0"
				width="100%" align="center">
				<tr>
					<td bgcolor="#00468c">
						<div style="height: 2px; overflow: hidden;">&nbsp;</div>
					</td>
				</tr>
				<tr>
					<td bgcolor="#efefef"
						style="font-size: 0.95em; font-weight: bold;"><%=location_id_value!=null?"Related":"" %>Group<%=(groupMap.size()>1?"s":"") %>
					</td>
				</tr>
<%
		int i=0;
		for(int group_id : groupMap.keySet()){
			String group = groupMap.get(group_id);
			if(group_id ==0){
				group = group.substring(1,group.length());
			}
%>
				<tr>
					<td
						<%=i%2==1?"style=\"background-color: #efefef;\"":"" %>>
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addgroup(<%=group_id %>,'<%=group %>');refreshTalks();">
							<%=group%> (<%=noTalkList_3.get(i) %>)
					</a>
					</td>
				</tr>
<%
			i++;
		}
%>
			</table>
		</td>
	</tr>
<%
	}
	
	//for series _4
	String sql_series = "SELECT series_id, series_name, COUNT(DISTINCT col_id) _no ";
	sql_series += sql;
	sql_series +=")t GROUP BY series_id, series_name ORDER BY series_name";
	LinkedHashMap<Integer,String> seriesMap = new LinkedHashMap<Integer,String>();
	ArrayList<Integer> noTalkList_4 = new ArrayList<Integer>();
	ResultSet rsseries = conn.getResultSet(sql_series);
	while(rsseries.next()){
		int series_id = rsseries.getInt("series_id");
		String series = rsseries.getString("series_name");
		int talkno = rsseries.getInt("_no");
		
		seriesMap.put(series_id,series);
		noTalkList_4.add(talkno);
	}
	if(seriesMap.size() > 0){
%>
	<tr>
		<td
			style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0"
				width="100%" align="center">
				<tr>
					<td bgcolor="#00468c"><div
							style="height: 2px; overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef"
						style="font-size: 0.95em; font-weight: bold;">
						<%=location_id_value!=null?"Related":"" %>Series
					</td>
				</tr>
<%
		int i=0;
		for(int series_id : seriesMap.keySet()){
			String series = seriesMap.get(series_id);
			if(series_id ==0){
				series = series.substring(1,series.length());
			}
%>
				<tr>
					<td
						<%=i%2==1?"style=\"background-color: #efefef;\"":"" %>>
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addseries(<%=series_id %>,'<%=series %>');refreshTalks();">
							<%=series%> (<%=noTalkList_4.get(i) %>)
					</a>
					</td>
				</tr>
<%
			i++;
		}
%>
			</table>
		</td>
	</tr>
<%
	} 
	
	//for location _6
	String sql_location = "SELECT location_id, location, COUNT(DISTINCT col_id) _no ";
	sql_location += sql;
	sql_location +=")t GROUP BY location_id, location ORDER BY location";
	LinkedHashMap<Integer,String> locationMap = new LinkedHashMap<Integer,String>();
	ArrayList<Integer> noTalkList_6 = new ArrayList<Integer>();
	/*ResultSet rslocation = conn.getResultSet(sql_location);
	while(rslocation.next()){
		int location_id = rslocation.getInt("location_id");
		String location = rslocation.getString("location");
		int talkno = rslocation.getInt("_no");
		locationMap.put(location_id,location);
		noTalkList_6.add(talkno);
	}*/
	if(locationMap.size() > 0){
%>
	<tr>
		<td
			style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0"
				width="100%" align="center">
				<tr>
					<td bgcolor="#00468c"><div
							style="height: 2px; overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef"
						style="font-size: 0.95em; font-weight: bold;">
						<%=location_id_value!=null?"Related":"" %>Location<%=(locationMap.size()>1?"s":"") %>
					</td>
				</tr>
<%
		int i=0;
		for(int location_id : locationMap.keySet()){
			String location = locationMap.get(location_id);
			if(location_id ==0){
				location = location.substring(1,location.length());
			}
%>
				<tr>
					<td
						<%=i%2==1?"style=\"background-color: #efefef;\"":"" %>>
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addlocation(<%=location_id %>,'<%=location %>');refreshTalks();">
							<%=location%> (<%=noTalkList_6.get(i) %>)
					</a>
					</td>
				</tr>
<%
			i++;
		}
%>
			</table>
		</td>
	</tr>
<%
	} 

	//for speaker _5
	if(speaker_rs_id_value==null||speaker_rs_id_value.length==0){
		String sql_speaker = "SELECT speaker_id, sname, COUNT(DISTINCT col_id) _no ";
		sql_speaker += sql;
		sql_speaker +=") t GROUP BY speaker_id, sname ORDER BY sname";
		LinkedHashMap<Integer,String> speakerMap = new LinkedHashMap<Integer,String>();
		ArrayList<Integer> noTalkList_5 = new ArrayList<Integer>();
		ResultSet rsspeaker = conn.getResultSet(sql_speaker);
		while(rsspeaker.next()){
			int speaker_id = rsspeaker.getInt("speaker_id");
			String speaker = rsspeaker.getString("sname");
			int talkno = rsspeaker.getInt("_no");
			
			speakerMap.put(speaker_id,speaker);
			noTalkList_5.add(talkno);
		}
		if(speakerMap.size() > 0){
%>
	<tr>
		<td
			style="font-size: 0.85em; border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0"
				cellpadding="0" width="100%" align="center">
				<tr>
					<td bgcolor="#00468c"><div
							style="height: 2px; overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td bgcolor="#efefef"
						style="font-size: 0.95em; font-weight: bold;">
						<%=location_id_value!=null?"Related":"" %>Speaker<%=(speakerMap.size()>1?"s":"") %>
					</td>
				</tr>
<%
			int i=0;
			for(int speaker_id : speakerMap.keySet()){
				String speaker = speakerMap.get(speaker_id);
				if(speaker_id ==0){
					speaker = speaker.substring(1,speaker.length());
				}
%>
				<tr>
					<td
						<%=i%2==1?"style=\"background-color: #efefef;\"":"" %>>
						<a href="javascript: return false;"
						style="text-decoration: none; font-size: 0.8em;"
						onmouseout="this.style.textDecoration='none'"
						onmouseover="this.style.textDecoration='underline'"
						onclick="addspeaker(<%=speaker_id %>,'<%=speaker %>');refreshTalks();">
							<%=speaker%> (<%=noTalkList_5.get(i) %>)
					</a>
					</td>
				</tr>
<%
				i++;
			}
%>
			</table>
		</td>
	</tr>
<%
		} 
	}
%>
</table>