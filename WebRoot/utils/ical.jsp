<%@page import="edu.pitt.sis.Html2Text"%><%@page import="net.fortuna.ical4j.model.*"%><%@page import="net.fortuna.ical4j.model.property.*"%><%@page import="net.fortuna.ical4j.model.component.*"%><%@page import="java.util.GregorianCalendar"%><%@page import="java.text.*"%><%@page import="java.util.Date"%><%@page import="net.fortuna.ical4j.util.UidGenerator"%><%@page import="java.util.ArrayList"%><%@page import="net.fortuna.ical4j.model.parameter.Role"%><%@page import="net.fortuna.ical4j.model.parameter.Cn"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="java.sql.*"%><%@page import="java.net.URI"%><%
	Calendar ical = new Calendar();
	ical.getProperties().add(new ProdId("-//Ben Fortuna//iCal4j 1.0//EN"));
	ical.getProperties().add(Version.VERSION_2_0);
	ical.getProperties().add(CalScale.GREGORIAN);
	
	//Create a TimeZone
	TimeZoneRegistry registry = TimeZoneRegistryFactory.getInstance().createRegistry();
	TimeZone timezone = registry.getTimeZone("America/Montreal");//("Europe/Rome");
	VTimeZone tz = timezone.getVTimeZone();
	
	session = request.getSession(false);
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int owner_id = 0;
	int comm_id = 0;
	int series_id = 0;
	int rows = 100;
	int start = 0;
	int affiliate_id = -1;
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	if(request.getParameter("tag_id")!=null){
		tag_id = Integer.parseInt((String)request.getParameter("tag_id"));
	}	
	if(request.getParameter("col_id") != null){
		col_id = Integer.parseInt((String)request.getParameter("col_id"));
	}
	if(request.getParameter("user_id") != null){
		user_id = Integer.parseInt((String)request.getParameter("user_id"));
	}
	if(request.getParameter("owner_id") != null){
		owner_id = Integer.parseInt((String)request.getParameter("owner_id"));
	}
	if(request.getParameter("comm_id") != null){
		comm_id = Integer.parseInt((String)request.getParameter("comm_id"));
	}
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	String[] entity_id_value = request.getParameterValues("entity_id");
	String[] type_value = request.getParameterValues("_type");
	String entity_id_list = "";
	String type_list = "";
	if(entity_id_value !=null){
		for(int i=0;i<entity_id_value.length;i++){
			if(i!=0)entity_id_list += ",";
			entity_id_list += entity_id_value[i];
		}
	}
	if(type_value != null){
		for(int i=0;i<type_value.length;i++){
			if(i!=0)type_list += ",";
			type_list += "'" + type_value[i].replaceAll("'","''") + "'";
		}
	}
	
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT c.col_id,c.title," +
					"cast(c.detail as char character set utf8) detail,date_format(c._date,_utf8'%b %e %Y') AS `day`," +
					"date_format(c.begintime,_utf8'%l:%i %p') _begin, date_format(c.endtime,_utf8'%l:%i %p') _end, " +
					"s.name,c.location,c.owner_id,u.name owner " +
					"FROM colloquium c JOIN speaker s ON c.speaker_id = s.speaker_id " +
					"JOIN userinfo u ON c.owner_id = u.user_id "  +
					"WHERE c._date >= (SELECT beginterm FROM sys_config) AND c._date <= (SELECT endterm FROM sys_config) ";

	if(affiliate_id > 0 ){
		sql += " AND c.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(select child_id from relation where path like concat((SELECT path FROM relation WHERE child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
	}
	if(tag_id > 0){
		sql += " AND c.col_id IN (SELECT u.col_id FROM userprofile u JOIN tags tt ON u.userprofile_id = tt.userprofile_id WHERE tt.tag_id=" + tag_id + ")";
	}
	if(col_id > 0){
		sql += " AND c.col_id=" + col_id; 
	}
	if(user_id > 0){
		sql += " AND c.col_id IN (SELECT u.col_id FROM userprofile u WHERE u.user_id=" + user_id +")";
	}
	if(owner_id > 0){
		sql += " AND c.owner_id =" + owner_id;
	}
	if(comm_id > 0){
		sql += " AND c.col_id IN " +
				"(SELECT u.col_id FROM contribute ct JOIN userprofile u ON ct.userprofile_id = u.userprofile_id " +
				"WHERE ct.comm_id=" + comm_id + ")";
	}
	if(series_id > 0){
		sql += " AND c.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id + ")";
	}
	if(entity_id_value != null){
		sql += " AND c.col_id IN (SELECT col_id FROM entities WHERE entity_id IN (" + entity_id_list + "))";
	}
	if(type_value != null){
		sql+=" AND c.col_id IN (SELECT ee.col_id FROM entities ee,entity e " +
				"WHERE ee.entity_id = e.entity_id AND e._type  IN (" + type_list + "))"; 
	}
	sql += " ORDER BY c._date DESC";

	DateFormat formatter = new SimpleDateFormat("MMM d yyyy h:m a");
	
	rs = conn.getResultSet(sql);
	while(rs.next()){
		String _col_id = rs.getString("col_id");
		String location = rs.getString("location");
		String description = rs.getString("detail");
        String link = "http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=" + _col_id;	
		
		String talkDate = rs.getString("day");
		// Begin Date
		String beginTime = rs.getString("_begin");	
		DateTime _begin = new DateTime(formatter.parse(talkDate + " " + beginTime));

		// End Date
		String endTime = rs.getString("_end");
		DateTime _end = new DateTime(formatter.parse(talkDate + " " + endTime));	
		
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
		
		// add description
		String content = "Speaker: " + speaker + "\n";
		content += "Location: " + location + "\n";
		content += "Link: " + link;
		
		//Tags
		sql = "SELECT t.tag_id,t.tag,COUNT(*) _no FROM tag t,tags tt,userprofile u " +
				"WHERE t.tag_id = tt.tag_id AND " +
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
		sql = "SELECT u.user_id,u.name,COUNT(*) _no FROM userinfo u,userprofile up " +
				"WHERE u.user_id = up.user_id AND up.col_id = " + _col_id +
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
		}

		if(description != null){			
			description = description.trim();
                        description = description.replaceAll("\\<.*?>","");
                        Html2Text parser = new Html2Text();
                        parser.parse(description);
                        description = parser.getText().trim();
			content += "\nDetail: " + description;
			
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