<%@page import="java.util.Calendar"%><%@page import="java.net.URLEncoder"%><%@page import="edu.pitt.sis.Html2Text"%><%@page import="net.fortuna.ical4j.model.*"%><%@page import="net.fortuna.ical4j.model.property.*"%><%@page import="net.fortuna.ical4j.model.component.*"%><%@page import="java.util.GregorianCalendar"%><%@page import="java.text.*"%><%@page import="java.util.Date"%><%@page import="net.fortuna.ical4j.util.UidGenerator"%><%@page import="java.util.ArrayList"%><%@page import="java.util.GregorianCalendar"%><%@page import="net.fortuna.ical4j.model.parameter.Role"%><%@page import="net.fortuna.ical4j.model.parameter.Cn"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="java.sql.*"%><%@page import="java.net.URI"%><%
	net.fortuna.ical4j.model.Calendar ical = new net.fortuna.ical4j.model.Calendar();
	ical.getProperties().add(new ProdId("-//Ben Fortuna//iCal4j 1.0//EN"));
	ical.getProperties().add(Version.VERSION_2_0);
	ical.getProperties().add(CalScale.GREGORIAN);
	
	//Create a TimeZone
	TimeZoneRegistry registry = TimeZoneRegistryFactory.getInstance().createRegistry();
	TimeZone timezone = registry.getTimeZone("America/New_York");//("Europe/Rome");
	VTimeZone tz = timezone.getVTimeZone();
	
	session = request.getSession(false);
	java.util.Calendar calendar = new GregorianCalendar();
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
	int req_day = -1;
	int req_week = -1;
	int req_month = month+1;
	int req_year = year;
	boolean req_specific_date = false;
	boolean req_posted = false;//True means user posts' talks
	boolean req_impact = false;//True means user impact
	boolean req_most_recent = false;
	int col_id = 0;
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	String[] user_id_value = request.getParameterValues("user_id");
	String[] tag_id_value = request.getParameterValues("tag_id");
	//String[] entity_id_value = request.getParameterValues("entity_id");
	//String[] type_value = request.getParameterValues("_type");
	String[] series_id_value = request.getParameterValues("series_id");
	String[] comm_id_value = request.getParameterValues("comm_id");
	String[] affiliate_id_value = request.getParameterValues("affiliate_id");
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
		req_most_recent = true;
	    req_week = calendar.get(Calendar.WEEK_OF_MONTH);
	    req_specific_date = true;
	}
    
    Calendar setcal = new GregorianCalendar();
    setcal.set(req_year, req_month-1, 1);
    int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
    int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
	
	String strBeginDate = "";
	String strEndDate = "";
	
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
	    int daysPrevMonth = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
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
					}else{
					}
				}else{
					strBeginDate = req_year + "-" + req_month + "-" + (7*(req_week - 1) - startday + 1);
				}
			}
			if(7*req_week - startday <= stopday ){
				strEndDate = req_year + "-" + req_month + "-" + (7*req_week - startday);
				if(req_week == 1){
				}else{
				}
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strEndDate = (req_year) + "-" + (req_month+1) + "-" +(7 - ((startday + stopday)%7));
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
			}else{
				if(req_month == 1){
					strBeginDate = (req_year-1) + "-12-" + (31 - startday + 1);
				}else{
					strBeginDate = req_year + "-" + (req_month-1) + "-" + (daysPrevMonth - startday + 1);
					if(req_month == 12){
					}else{
					}
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
	
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT c.col_id,c.title," +
					"cast(c.detail as char character set utf8) detail,date_format(c._date,_utf8'%b %e %Y') AS `day`," +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.name,c.location,c.owner_id,u.name owner " +
					"FROM colloquium c JOIN userinfo u ON c.owner_id = u.user_id " +
					"LEFT OUTER JOIN speaker s ON c.speaker_id = s.speaker_id ";//  +
					//"WHERE c._date >= (SELECT beginterm FROM sys_config) AND c._date <= (SELECT endterm FROM sys_config) ";

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
					//"JOIN contribute ct" + i + " ON upc" + i + ".userprofile_id = ct" + i + ".userprofile_id " + 
					//"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
					"JOIN contribute ct" + i + " ON c.col_id=ct" + i + ".col_id " + 
					"AND ct" + i + ".comm_id = " + comm_id_value[i] + " ";
		}
	}
	if(tag_id_value != null){//Tag Mode
		for(int i=0;i<tag_id_value.length;i++){
			sql += "JOIN userprofile upt" + i + " ON c.col_id=upt" + i + ".col_id " +
					"JOIN tags tt" + i + " ON upt" + i + ".userprofile_id = tt" + i + ".userprofile_id " + 
					"AND tt" + i + ".tag_id = " + tag_id_value[i] + " ";
		}
	}
	if(series_id_value != null){//Series Mode
		for(int i=0;i<series_id_value.length;i++){
			sql += "JOIN seriescol sc" + i + " ON c.col_id = sc" + i + ".col_id AND sc" + i + ".series_id=" + series_id_value[i] + " ";
		}
	}
	/*if(entity_id_value != null){//Entity Mode
		for(int i=0;i<entity_id_value.length;i++){
			sql += "JOIN entities ee" + i + " ON c.col_id = ee" + i + ".col_id AND ee" + i + ".entity_id = " + entity_id_value[i] + " ";
		}
	}
	if(type_value != null){//Entity Type Mode
		for(int i=0;i<type_value.length;i++){
			sql += "JOIN entities eee" + i + " ON c.col_id = eee" + i + ".col_id JOIN entity e" + i + " ON " +
			"e" + i + ".entity_id = eee" + i + ".entity_id AND e" + i + "._type = '" + type_value + "' ";
		}
	}*/
	if(col_id>0){
		sql += "WHERE c.col_id=" + col_id + " ";
	}else if(req_most_recent||req_specific_date){
		if(req_posted){
			sql += "AND pt.posttime >= '" + strBeginDate + " 00:00:00' " +
			"AND pt.posttime <= '" + strEndDate + " 23:59:59' ";
		}else{
			sql += "AND c._date >= '" + strBeginDate + " 00:00:00' " +
			"AND c._date <= '" + strEndDate + " 23:59:59' ";
		}
	}else{
		sql += "WHERE c._date > CURDATE() ";
	}
	sql += " GROUP BY c.col_id,c.title," +
			"cast(c.detail as char character set utf8), date_format(c._date,_utf8'%b %e %Y')," +
			"date_format(c.begintime,_utf8'%l:%i %p'), date_format(c.endtime,_utf8'%l:%i %p')," +
			"s.name,c.location,c.owner_id,u.name " +
			"ORDER BY c._date ";
	sql += "LIMIT 20";

	DateFormat formatter = new SimpleDateFormat("MMM d yyyy h:m a");
	String link = "";
	
	rs = conn.getResultSet(sql);
	while(rs.next()){
		String _col_id = rs.getString("col_id");
		String location = rs.getString("location");
		String description = rs.getString("detail");
        link = "http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=" + _col_id;	
		
		String talkDate = rs.getString("day");
		// Begin Date
		String beginTime = rs.getString("_begin");	
		DateTime _begin = new DateTime(formatter.parse(talkDate + " " + beginTime));
		//Check timezone whether it is daylight saving time or not
		/*if(timezone.inDaylightTime(_begin)){
			_begin.setTime(_begin.getTime() + 4*60*60*1000);
		}else{
			_begin.setTime(_begin.getTime() + 5*60*60*1000);
		}*/
		
		// End Date
		String endTime = rs.getString("_end");
		DateTime _end = new DateTime(formatter.parse(talkDate + " " + endTime));	
		/*if(timezone.inDaylightTime(_end)){
			_end.setTime(_end.getTime() + 4*60*60*1000);
		}else{
			_end.setTime(_end.getTime() + 5*60*60*1000);
		}*/
		
		// Create the event
		String eventName = rs.getString("title");
		VEvent meeting = new VEvent(_begin, _end, eventName);
		
		// generate unique identifier..
		UidGenerator ug = new UidGenerator("uidGen");
		Uid uid = ug.generateUid();
		meeting.getProperties().add(uid);
		
		// add timezone info..
		meeting.getProperties().add(tz.getTimeZoneId());
		
		String speaker = rs.getString("name");
		
		// add location
		Location iLoc = new Location();
		iLoc.setValue(location);
		meeting.getProperties().add(iLoc);
		
		// add link
		Url iUrl = new Url();
		iUrl.setValue(link);
		meeting.getProperties().add(iUrl);
		
		// add description
		String content = speaker + "\n";
		//content += "Location: " + location + "\n";
		content += link;
		
		//Tags
		/*sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
				"JOIN userprofile u ON " +
				"tt.userprofile_id = u.userprofile_id AND " +
				"u.col_id = " + _col_id +
				" GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
		ResultSet rsExt = conn.getResultSet(sql);
		if(rsExt.next()){
			String tag = rsExt.getString("tag");
			long _tag_id = rsExt.getLong("tag_id");
			long _no = rsExt.getLong("_no");
			content += "\nTags: " + tag;
		}
		while(rsExt.next()){
			String tag = rsExt.getString("tag");
			long _tag_id = rsExt.getLong("tag_id");
			long _no = rsExt.getLong("_no");
			content += " " + tag;
		}
		
		sql = "SELECT c.comm_id,c.comm_name,COUNT(*) _no FROM community c,contribute ct,userprofile u " +
				"WHERE c.comm_id = ct.comm_id AND " +
				"ct.userprofile_id = u.userprofile_id AND " + 
				"u.col_id = " + _col_id +
				" GROUP BY c.comm_id,c.comm_name " +
				"ORDER BY c.comm_name";
		rsExt.close();
		rsExt = conn.getResultSet(sql);
		if(rsExt.next()){
			String comm_name = rsExt.getString("comm_name");
			long _comm_id = rsExt.getLong("comm_id");
			long _no = rsExt.getLong("_no");
			content += "\nPosted to communities: " + comm_name;
		}
		while(rsExt.next()){
			String comm_name = rsExt.getString("comm_name");
			long _comm_id = rsExt.getLong("comm_id");
			long _no = rsExt.getLong("_no");
			content += " " + comm_name;
		}
		//Bookmark by
		sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u JOIN userprofile up " +
				"ON u.user_id = up.user_id AND up.col_id = " + _col_id +
				" GROUP BY u.user_id,u.name ORDER BY u.name";
		rsExt.close();
		rsExt = conn.getResultSet(sql);
		if(rsExt.next()){
			String user_name = rsExt.getString("name");
			long _user_id = rsExt.getLong("user_id");
			long _no = rsExt.getLong("_no");
			content += "\nBookmarked by: " + user_name;
		}
		while(rsExt.next()){
			String user_name = rsExt.getString("name");
			long _user_id = rsExt.getLong("user_id");
			long _no = rsExt.getLong("_no");
			content += " " + user_name;
		}*/

		if(description != null){			
			description = description.trim();
            description = description.replaceAll("\\<.*?>"," ");
            Html2Text parser = new Html2Text();
            parser.parse(description);
            description = parser.getText().trim();
			content += "\n\n" + description;		
		}
		
		Description iDesc = new Description();
		iDesc.setValue(content);
		meeting.getProperties().add(iDesc);
		
		// Add the event
		ical.getComponents().add(meeting);

	}
	
	response.setContentType("application/ics");
	response.setHeader("Content-Disposition","attachment; filename=\"comet.ics\"");
	out.print(ical.toString());
	
	ical = null;
	conn = null;
	rs = null;
%>