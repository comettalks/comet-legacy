<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<% 
	session = request.getSession(false);
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int series_id = 0;
	int rows = 100;
	int start = 0;
	int affiliate_id = -1;
	boolean req_most_recent = false;
	int speaker_id = 0;
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
	if(request.getParameter("comm_id") != null){
		comm_id = Integer.parseInt((String)request.getParameter("comm_id"));
	}
	if(request.getParameter("series_id") != null){
		series_id = Integer.parseInt((String)request.getParameter("series_id"));
	}
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(request.getParameter("mostrecent")!=null){
		req_most_recent = true;
	}
	if(request.getParameter("speaker_id") != null){
		speaker_id = Integer.parseInt((String)request.getParameter("speaker_id"));
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

	HashMap<String,Integer> occurMap = new HashMap<String,Integer>();
	HashMap<String,Integer> idMap = new HashMap<String,Integer>();
	long totalOccur = 0;
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "SELECT tag_id,tag,COUNT(*) _no FROM (SELECT t.tag_id,t.tag,tt.col_id " +
					"FROM tag t JOIN tags tt ON t.tag_id = tt.tag_id " +
					"AND LENGTH(TRIM(t.tag))>0  " +
					"WHERE TRUE " +
					//"u.col_id IN " +
					//"(SELECT col_id FROM colloquium WHERE " +
					//"_date >= (SELECT beginterm FROM sys_config) AND _date <= (SELECT endterm FROM sys_config)) AND " +
					" ";

	if(affiliate_id > 0 ){
		sql += " AND tt.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac JOIN " +
				"(select child_id from relation where path like concat((SELECT path FROM relation WHERE child_id = "+ affiliate_id + "),',%')) cc " +
				"ON ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
	}
	if(tag_id > 0){
		sql += " AND t.tag_id<>" + tag_id + " AND tt.col_id IN (SELECT col_id FROM tags WHERE tag_id=" + tag_id + ")";
	}
	if(col_id > 0){
		sql += " AND tt.col_id=" + col_id; 
	}
	if(user_id > 0){
		sql += " AND tt.user_id=" + user_id;
	}
	if(comm_id > 0){
		sql += " AND tt.col_id IN " +
				"(SELECT col_id FROM contribute " +
				"WHERE comm_id=" + comm_id + ")";
	}
	if(series_id > 0){
		sql += " AND tt.col_id IN (SELECT col_id FROM seriescol WHERE series_id=" + series_id + ")";
	}
	if(entity_id_value != null){
		sql += " AND tt.col_id IN (SELECT col_id FROM entities WHERE entity_id IN (" + entity_id_list + "))";
	}
	if(type_value != null){
		sql+=" AND tt.col_id IN (SELECT ee.col_id FROM entities ee,entity e " +
				"WHERE ee.entity_id = e.entity_id AND e._type  IN (" + type_list + "))"; 
	}
	if(req_most_recent){
		sql += " AND tt.col_id IN (SELECT col_id FROM colloquium WHERE _date >= CURDATE())";
	}
	if(speaker_id>0){
		sql += " AND tt.col_id IN (SELECT col_id FROM col_speaker WHERE speaker_id=" + speaker_id + ")";
	}
	sql += " GROUP BY t.tag_id,t.tag,tt.col_id) _t GROUP BY tag_id,tag " +
	    	"ORDER BY _no DESC LIMIT " + start + "," + rows + "";
    //out.println(sql);
    try{
    	rs = conn.getResultSet(sql);
        while(rs.next()){
        	String tag = rs.getString("tag");
        	int _no = rs.getInt("_no");
        	int _tag_id = rs.getInt("tag_id");
        	if(tag != null){
        		if(tag.length() > 0){
		        	occurMap.put(tag.toLowerCase(), _no);
		        	idMap.put(tag.toLowerCase(), _tag_id);
		        	totalOccur += rs.getInt("_no");
        		}
        	}
		}
		rs.close();
	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	 conn.conn.close();
	 conn = null;
	}
	//Sort map
	if(occurMap.size() > 0){
%>
<br/>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
<% 
		if(tag_id > 0){
			out.print("Related ");
		}else if(req_most_recent){
			out.print("Recent ");
		}
%>
			Tag Cloud
		</td>
	</tr>
	<tr>
		<td align="left" style="font-size: 0.85em;border: 1px #EFEFEF solid;">
<%
		Vector<String> v = new Vector<String>(occurMap.keySet());
		double avgTagOccur = (double)totalOccur/(double)v.size(); 
		//Calculate Variance
		double variance = 0;
		double dist = 0;
		for(Iterator<String> i = occurMap.keySet().iterator();i.hasNext();){
			int occur = ((Integer)occurMap.get(i.next())).intValue();
			double value = (double)occur - avgTagOccur;
			variance += value*value;
			dist += value;
		}
		if(occurMap.size() > 1){
			variance = variance/(double)(occurMap.size()-1.0);
		}else if(occurMap.size() == 1){
			variance = variance/(double)occurMap.size();	
		}else{
			variance = 0.0;
		}
		Collections.sort(v);
		int i=0;
		for(Iterator<String> it = v.iterator();it.hasNext();){
			String tag = it.next();
			double fontsize = 0.8;
			//Score more than 2SD got biggest font size
			if((double)occurMap.get(tag) > avgTagOccur + 0.25*Math.sqrt(variance)){
				fontsize = 1.25;
			}else if((double)occurMap.get(tag) > avgTagOccur + 0.125*Math.sqrt(variance)){
				fontsize = 0.95;
			}else if((double)occurMap.get(tag) < avgTagOccur -0.25*Math.sqrt(variance)){
				fontsize = 0.5;
			}else if((double)occurMap.get(tag) < avgTagOccur - 0.125*Math.sqrt(variance)){
				fontsize = 0.65;
			}
			if(i!=0){
%>&nbsp;<%				
			}
%>
<a href="tag.do?tag_id=<%=idMap.get(tag)%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" 
		onmouseout="this.style.textDecoration='none'"
		onmouseover="this.style.textDecoration='underline'"
		style="text-decoration: none;font-size: <%=Math.floor(fontsize*100)/100.0 %>em;"><%=tag%></a>
<%			
			i++;
		}

		if(rows < 50){
%>
				<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="window.location='tag.do<%if(affiliate_id>0)out.print("affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
<%	
		}
%>
		</td>
	</tr>
</table>
<br/>
<%				
	}else{
%>
			&nbsp;
<%	
	}
%>