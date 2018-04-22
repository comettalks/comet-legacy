<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>

<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
<% 
	session = request.getSession(false);
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int series_id = 0;
	int entity_id = 0;
	String _type = "";
	int topic_id = 0;
	int rows = 100;
	int start = 0;
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
	if(request.getParameter("entity_id") != null){
		entity_id = Integer.parseInt((String)request.getParameter("entity_id"));
	}
	if(request.getParameter("_type") != null){
		_type = (String)request.getParameter("_type");
	}
	if(request.getParameter("topic_id") != null){
		topic_id = Integer.parseInt((String)request.getParameter("topic_id"));
	}
%>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
<% 
	if(entity_id > 0 || !_type.equalsIgnoreCase("")){
%>
			Related 
<%	
	}
%>			
			Named Entity
		</td>
	</tr>
	<tr>
		<td style="font-size: 0.9em;">
<%	
	int col = 1;
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "";
	if(tag_id > 0){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,userprofile u,tags tt,colloquium c " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = u.col_id AND " + 
				"u.userprofile_id = tt.userprofile_id AND " + 
				"tt.col_id = c.col_id AND " +
				//"c._date >= CURDATE() AND " +
				"tt.tag_id = " + tag_id +
				" GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else if(col_id > 0){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = " + col_id + 
				" GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else if(user_id > 0){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,userprofile u,colloquium c " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = u.col_id AND " +
				"u.col_id = c.col_id AND " +
				//"c._date >= CURDATE() AND " +
				"u.userprofile_id IN " +
				"(SELECT userprofile_id FROM userprofile " +
				"WHERE user_id = " + user_id + ") " +
				" GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else if(comm_id > 0){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,userprofile u,colloquium c " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = u.col_id AND " +
				"u.col_id = c.col_id AND " +
				//"c._date >= CURDATE() AND " +
				"u.userprofile_id IN " +
				"(SELECT userprofile_id FROM contribute " +
				"WHERE comm_id = " + comm_id + ") " +
				" GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else if(series_id > 0){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,seriescol sc " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = sc.col_id AND " +
				"sc.series_id = " + series_id + " " +
				" GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else if(entity_id > 0){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,colloquium c " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = c.col_id AND " +
				//"c._date >= CURDATE() AND " +
				"e.entity_id <> " + entity_id + " AND " +
				"ee.col_id IN (SELECT col_id FROM entities WHERE entity_id = " + entity_id + ")" + 
				" GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else if(!_type.equalsIgnoreCase("")){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,colloquium c " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = c.col_id AND " +
				//"c._date >= CURDATE() AND " +
				"e._type <> '" + _type + "' AND " +
				"ee.col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id = e.entity_id AND e._type = '" + _type + "') " + 
				" GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else if(topic_id > 0){
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,topics tt,colloquium c " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = tt.col_id AND " +
				"tt.col_id = c.col_id AND " +
				//"c._date >= CURDATE() AND " +
				"tt.topic_id = " + topic_id + " " + 
				"GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}else{
		col = 3;
		sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
				"FROM entity e,entities ee,colloquium c " +
				"WHERE e.entity_id = ee.entity_id AND " +
				"ee.col_id = c.col_id " +//AND " +
				//"c._date >= CURDATE() " +
				"GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	}
    try{
    	rs = conn.getResultSet(sql);
    	String __type = "";
    	HashMap predMap = new HashMap();
    	HashMap rankMap = new HashMap();
    	ArrayList idList = new ArrayList();
    	ArrayList entityList = new ArrayList();
    	ArrayList typeList = new ArrayList();
    	int total_occur = 0;
    	double total_rank_score = 0.0;
    	
    	int total_resources = 99999;
    	//Find total resources
    	sql = "SELECT COUNT(*) _no FROM colloquium";
    	ResultSet rsRes = conn.getResultSet(sql);
    	if(rsRes.next()){
    		total_resources = rsRes.getInt("_no");
    	}
    	rsRes.close();
 %>
 		Total resources: <%=total_resources%><br/><br/>
 <%   	
        while(rs.next()){
        	String _new_type = rs.getString("_type");
        	String entity = rs.getString("entity");
        	String _entity_id = rs.getString("entity_id");
        	String normalized = rs.getString("normalized");
        	int _no = rs.getInt("_no");
        	total_occur += _no;
        	if(!normalized.equalsIgnoreCase("")){
        		entity = normalized;
        	}
%>
		type: <%=_new_type%> entity: <%=entity%> no: <%=_no%><br/>
<%       	
        	if(!__type.equalsIgnoreCase(_new_type)){
        		
        		if(!__type.equalsIgnoreCase("")){
%>
		******************************************<br/>
		Calculating Navigational Sufficiency Score<br/>
		******************************************<br/>
<%        			
        			//Calculate Mu
        			double mu = (double)total_occur/(double)predMap.size();
        			//Calculate Variance
        			double variance = 0;
        			double dist = 0;
        			for(Iterator i = predMap.keySet().iterator();i.hasNext();){
        				int occur = ((Integer)predMap.get(i.next())).intValue();
        				double value = (double)occur - mu;
        				variance += value*value;
        				dist += value;
        			}
        			if(predMap.size() > 1){
        				variance = variance/(double)(predMap.size()-1.0);
        			}else if(predMap.size() == 1){
        				variance = variance/(double)predMap.size();	
        			}else{
        				variance = 0.0;
        			}
%>
		Map size: <%=predMap.size()%> mu: <%=mu%> variance: <%=variance%><br/>
<%
	        		//Calculate Navigational Sufficiency here 3 matrics
					//1)Predicate Balance
					double balance = 0.0;
					if(predMap.size() > 1){
						balance = 1.0 - Math.abs(dist)/((double)(predMap.size()-1)*mu + ((double)total_occur - mu));
					}
%>
		1)Balance Score: <%=balance%><br/>
<%					
					//2)Object Cardinality
					double card = 0.0;//if a number of type is <= 1
					if(predMap.size() > 1){
						double value = (double)predMap.size() - mu;
						value = value*value;
						card = Math.exp(-(value)/(2.0*variance));
					}
%>
		2)Object Cardinality: <%=card%><br/>
<%					
					//3)Predicate Frequency
					double freq = 0.0;
					sql = "SELECT COUNT(*) _no FROM" +
							"(SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id = e.entity_id AND e._type = '" + 
							__type + "' GROUP BY ee.col_id) _res";					
					rsRes = conn.getResultSet(sql);
					double resNo = 0.0;
					if(rsRes.next()){
						resNo = rsRes.getDouble("_no");
					}	
					freq = resNo/(double)total_resources;
					rsRes.close();
%>
		3)Predicate Frequency: <%=freq%> freq: <%=resNo%><br/>
<%					
					
					double final_score = balance + card + freq;//This equation can be weighted.
%>
		Final Score: <%=final_score%><br/>
		*****************************<br/>
<%					
					rankMap.put(__type,final_score);
					total_rank_score += final_score;
        		}
        		
        		__type = _new_type;
        		total_occur = 0;
        		predMap.clear();
        	}
        	
        	predMap.put(entity,_no);
        	idList.add(_entity_id);
        	entityList.add(entity);
        	typeList.add(__type);
		}
		if(!__type.equalsIgnoreCase("")){
%>
		******************************************<br/>
		Calculating Navigational Sufficiency Score<br/>
		******************************************<br/>
<%        			
			//Calculate Mu
   			double mu = (double)total_occur/(double)predMap.size();
   			//Calculate Variance
   			double variance = 0;
   			double dist = 0;
   			for(Iterator i = predMap.keySet().iterator();i.hasNext();){
   				int occur = ((Integer)predMap.get(i.next())).intValue();
   				double value = (double)occur - mu;
   				variance += value*value;
   				dist += value;
   			}
   			if(predMap.size() > 1){
   				variance = variance/(double)(predMap.size()-1.0);
   			}else if(predMap.size() == 1){
   				variance = variance/(double)predMap.size();	
   			}else{
   				variance = 0.0;
   			}
%>
		Map size: <%=predMap.size()%> mu: <%=mu%> variance: <%=variance%><br/>
<%
       		//Calculate Navigational Sufficiency here 3 matrics
			//1)Predicate Balance
			double balance = 0.0;
			if(predMap.size() > 1){
				balance = 1.0 - Math.abs(dist)/((double)(predMap.size()-1)*mu + ((double)total_occur - mu));
			}
%>
		1)Balance Score: <%=balance%><br/>
<%					
			//2)Object Cardinality
			double card = 0.0;//if a number of type is <= 1
			if(predMap.size() > 1){
				double value = (double)predMap.size() - mu;
				value = value*value;
				card = Math.exp(-(value)/(2.0*variance));
			}
%>
		2)Object Cardinality: <%=card%><br/>
<%					
			//3)Predicate Frequency
			double freq = 0.0;
			sql = "SELECT COUNT(*) _no FROM" +
					"(SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id = e.entity_id AND e._type = '" + 
					__type + "' GROUP BY ee.col_id) _res";					
			rsRes = conn.getResultSet(sql);
			double resNo = 0.0;
			if(rsRes.next()){
				resNo = rsRes.getDouble("_no");
			}	
			freq = resNo/(double)total_resources;
			rsRes.close();
%>
		3)Predicate Frequency: <%=freq%> freq: <%=resNo%><br/>
<%					
					
			double final_score = balance + card + freq;//This equation can be weighted.
%>
		Final Score: <%=final_score%><br/>
		*****************************<br/>
<%					
			
			rankMap.put(__type,final_score);
			total_rank_score += final_score;
		}
		rs.close();

		//Calculate ranking mu
		double mu = total_rank_score/(double)rankMap.size();
		
		//Calculate ranking variance
		double variance = 0.0;
		for(Iterator i = rankMap.keySet().iterator();i.hasNext();){
			double value = ((Double)rankMap.get((String)i.next())).doubleValue();
			value -= mu;
			value = value*value;	
			variance += value;
		}
		if(rankMap.size() > 1){
			variance /= (double)(rankMap.size() - 1);
		}else if(rankMap.size() == 1){
			variance /= (double)rankMap.size();
		}else{
			variance = 0.0;
		}

		//Generate facets
		//Sort map
		if(rankMap.size() > 0){
%>
			<table cellspacing="0" cellpadding="0" width="100%" align="center">
<%	
			Vector<String> v = new Vector<String>(rankMap.keySet());
			Collections.sort(v);
			int j = 0;
			for(Iterator<String> i=v.iterator();i.hasNext();){
				String type = i.next();
				double score = ((Double)rankMap.get(type)).doubleValue();
				double fontsize = 0.9;
				//Score more than 2SD got biggest font size
				if(score > mu + 2*Math.sqrt(variance)){
					fontsize = 1.3;
				}else if(score > mu + Math.sqrt(variance)){
					fontsize = 1.1;
				}else if(score < mu - 2*Math.sqrt(variance)){
					fontsize = 0.5;
				}else if(score < mu - Math.sqrt(variance)){
					fontsize = 0.7;
				}
				
				//Check col 1 or 3, then insert a new row
				if(j%col==0){
%>
				<tr>
<%				
				}
%>
					<td align="center" valign="center">
						<a href="entity.do?_type=<%=type%>" style="text-decoration: none;font-size: <%=fontsize%>em;"
							onmouseout="this.style.textDecoration='none'"
							onmouseover="this.style.textDecoration='underline'"
							>
							<%=type%>
						</a>					
					</td>
<%				
				if(j%col==col-1){
%>
				</tr>
<%				
				}
				j++;
			}
%>
			</table>
<%						
		}

	}catch(SQLException ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>
		</td>
	</tr>
	<tr>
		<td>
<% 
	if(rows==20){
%>
				<div style="color:#0080ff;cursor:pointer;" 
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="window.location='entity.do'">More &gt;&gt;</div>
<%	
	}else{

	}
%>
		</td>
	</tr>
