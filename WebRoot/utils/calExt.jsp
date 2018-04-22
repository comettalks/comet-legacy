<%@ page language="java" %>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>

<div id="divExtension">
<%
	session = request.getSession(false);

    Calendar calendar = new GregorianCalendar();
    int month = calendar.get(Calendar.MONTH);
    int year = calendar.get(Calendar.YEAR);
    int today = calendar.get(Calendar.DAY_OF_MONTH);
    int req_day = -1;
    int req_week = -1;
    int req_month = month+1;
    int req_year = year;
	long req_id = -1;
	int req_type = -1;//1:user 2:community 3:tag
	boolean req_posted = false;//True means user posts' talks 
	String debugText = " ";	
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
    }
    
    if(request.getParameter("id")!=null){
        req_id = Long.parseLong(request.getParameter("id"));
    }
    
    if(request.getParameter("type")!=null){
        req_type = Integer.parseInt(request.getParameter("type"));
    }
    
    if(request.getParameter("post")!=null){
    	req_posted = true;
    }
    if(request.getParameter("user_id")!=null){
    	req_id = Integer.parseInt(request.getParameter("user_id"));
    	req_type = 1;
    }
    if(request.getParameter("comm_id")!=null){
    	req_id = Integer.parseInt(request.getParameter("comm_id"));
    	req_type = 2;
    }
    if(request.getParameter("tag_id")!=null){
    	req_id = Integer.parseInt(request.getParameter("tag_id"));
    	req_type = 3;
    }
    
    Calendar setcal = new GregorianCalendar();
    setcal.set(req_year, req_month-1, 1);
    int startday = setcal.get(Calendar.DAY_OF_WEEK) - 1;
    int stopday = setcal.getActualMaximum(Calendar.DAY_OF_MONTH);
    
	//daysPrevMonth - startday + 1
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
				strEndDate = req_year + "-" + req_month + "-" + stopday;
			}else{
				if(req_month == 12){
					strEndDate = (req_year+1) + "-1-" + (7 - ((startday + stopday)%7));
				}else{
					strEndDate = (req_year) + "-" + (req_month + 1) + "-" +(7 - ((startday + stopday)%7));
				}
			}
		}
    }
	
	String sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no " +
					"FROM colloquium c,userprofile u,tags tt,tag t " +
					"WHERE " +
					"c.col_id = u.col_id " +
					"AND u.userprofile_id = tt.userprofile_id " +
					"AND tt.tag_id = t.tag_id " +
					"AND c._date >= '" + strBeginDate + "' " +
					"AND c._date <= '" + strEndDate + "' " +
					"GROUP BY t.tag_id,t.tag " +
					"ORDER BY t.tag";
		
	if(req_type == 1){//User Mode
		sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
				"FROM colloquium c,userprofile u,tags tt,tag t " +
				"WHERE " +
				"c.col_id = u.col_id " +
				"AND u.userprofile_id = tt.userprofile_id " +
				"AND tt.tag_id = t.tag_id " +
				"AND u.user_id = " + req_id + " " +
				"AND c._date >= '" + strBeginDate + "' " +
				"AND c._date <= '" + strEndDate + "' " +
				"GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
		if(req_posted){
			sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
					"FROM colloquium c,userprofile u,tags tt,tag t " +
					"WHERE " +
					"c.col_id = u.col_id " +
					"AND u.userprofile_id = tt.userprofile_id " +
					"AND tt.tag_id = t.tag_id " +
					"AND c._date >= '" + strBeginDate + "' " +
					"AND c._date <= '" + strEndDate + "' " +
					"AND c.user_id = " + req_id +
					" GROUP BY t.tag_id,t.tag " +
					"ORDER BY t.tag";
		}
	}else if(req_type == 2){//Community Mode
		sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
				"FROM colloquium c,tags tt,tag t,contribute cc " +
				"WHERE " +
				"c.col_id = u.col_id " +
				"AND tt.tag_id = t.tag_id " +
				"AND cc.userprofile_id = tt.userprofile_id AND " +
				"cc.comm_id = " + req_id + " AND " +
				"c._date >= '" + strBeginDate + "' AND " +
				"c._date <= '" + strEndDate + "' " +
				"GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
	}else if(req_type == 3){//Tag Mode
		sql = "SELECT t.tag_id,t.tag, COUNT(*) AS tag_no  " +
				"FROM colloquium c,tags tt,tag t " +
				"WHERE " +
				"c.col_id = u.col_id " +
				"AND tt.tag_id = t.tag_id " +
				"AND tt.userprofile_id IN " +
				"(SELECT userprofile_id FROM tags WHERE tag_id = " + req_id + ") " +
				"AND t.tag_id <> " + req_id + " AND " +
				"c._date >= '" + strBeginDate + "' " +
				"AND c._date <= '" + strEndDate + "' " +
				"GROUP BY t.tag_id,t.tag " +
				"ORDER BY t.tag";
	}
	connectDB conn = new connectDB();
	ResultSet rs = conn.getResultSet(sql);
	HashMap<String,Integer> occurMap = new HashMap<String,Integer>();
	HashMap<String,Integer> idMap = new HashMap<String,Integer>();
	long totalOccur = 0;
	while(rs.next()){
       	occurMap.put(rs.getString("tag").toLowerCase(), rs.getInt("tag_no"));
       	idMap.put(rs.getString("tag").toLowerCase(), rs.getInt("tag_id"));
       	totalOccur += rs.getInt("tag_no");
	}
	if(totalOccur > 0){
%>
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td style="font-size: 0.95em;font-weight: bold;background-color: #efefef;">
			Tag Cloud
		</td>
	</tr>
	<tr>
		<td style="font-size: 0.9em;">
<% 
		//Sort map
		if(occurMap.size() > 0){
			Vector<String> v = new Vector<String>(occurMap.keySet());
			Collections.sort(v);
			double avgTagOccur = (double)totalOccur/(double)v.size(); 
			for(Iterator<String> it = v.iterator();it.hasNext();){
				String tag = it.next();
				double fontsize = (double)occurMap.get(tag)/avgTagOccur;
%>
			<a href="javascript: return false;" onclick="window.location='tag.do?tag_id=<%=idMap.get(tag)%>'" 
				onmouseout="this.style.textDecoration='none'"
				onmouseover="this.style.textDecoration='underline'"
				style="font-size: <%=Math.floor(fontsize*100)/100.0 %>em;"><%=tag%></a>&nbsp;
<%			
			}		
		}
%>
		</td>
	</tr>
</table>
<%	
	}
%>
&nbsp;
</div>
<script type="text/javascript">
	window.onload = function(){
		if(divExtension){
			parent.displayExtension(divExtension.innerHTML);
		}
	}
</script>	
