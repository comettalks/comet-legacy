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

<table cellspacing="0" cellpadding="0" width="100%" align="center">
<%
	try{ 
	session = request.getSession(false);
	
	boolean isDebugged = false;
	
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int series_id = 0;
	int entity_id = 0;
	int affiliate_id = -1;
	String _type = "";
	//int topic_id = 0;
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
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(request.getParameter("_type") != null){
		_type = (String)request.getParameter("_type");
	}
	//if(request.getParameter("topic_id") != null){
	//	topic_id = Integer.parseInt((String)request.getParameter("topic_id"));
	//}
	connectDB conn = (connectDB)session.getAttribute("connectDB");
	if(conn == null){
		conn = new connectDB();
		session.setAttribute("connectDB",conn);
	}
	ResultSet rs = null;
	String sql = "";

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
			type_list += "'" + type_value[i] + "'";
		}
	}

	if(entity_id > 0 || !_type.equalsIgnoreCase("")){
%>
<%--
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
			Keyword
		</td>
	</tr>	
--%>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td style="font-size: 0.9em;border: 1px #EFEFEF solid;">
			<table cellspacing="0" cellpadding="0" width="100%" align="center">
<% 
		if(entity_id_value != null){
			for(int i = 0;i<entity_id_value.length;i++){
				entity_id = Integer.parseInt((String)entity_id_value[i]);
				
				sql = "SELECT e._type,e.entity,e.normalized " +
						"FROM entity e " +
						"WHERE e.entity_id = ?";// + entity_id;
			    try{
			    	PreparedStatement pstmt = conn.conn.prepareStatement(sql);
			    	pstmt.setInt(1,entity_id);
					rs = pstmt.executeQuery();
					String type = "";
					String entity = "";
					if(rs.next()){
						type = rs.getString("_type");
						entity = rs.getString("entity");
						String normalized = rs.getString("normalized");
						if(normalized != null){
							if(normalized.length() > 0){
								entity = normalized;
							}
						}
					}
					rs.close();
					
%>
					<tr>
						<td align="left" valign="middle">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td>
										<a href="facet.do?_type=<%=type%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" style="text-decoration: none;font-size: 0.9em;"
											onmouseout="this.style.textDecoration='none'"
											onmouseover="this.style.textDecoration='underline'"
											>
											<%=type%>
										</a>
									</td>
								</tr>
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td>
										<a href="facet.do?entity_id=<%=entity_id%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" style="text-decoration: none;font-size: 0.7em;"
											onmouseout="this.style.textDecoration='none'"
											onmouseover="this.style.textDecoration='underline'"
											><%=entity%>
										</a>&nbsp;
									</td>
								</tr>
							</table>
						</td>
					</tr>
<%		
				}catch(SQLException ex){
				    out.println(ex.toString());
				}finally{
					if(rs!=null){
					    try{
					        rs.close();
					    }catch(SQLException ex){}
					}
				}
			}
		}
		
		if(type_value != null){
			for(int i=0;i<type_value.length;i++){
				_type = type_value[i].trim();
				sql = "SELECT e.entity_id,e.entity,e.normalized " +
						"FROM entity e,entities ee,colloquium c " +
						"WHERE e.entity_id = ee.entity_id AND " +
						"ee.col_id = c.col_id AND " +
						"e._type = ? " + //'" + _type + "' " +
						"GROUP BY e.entity_id,e.entity,e.normalized";
	
				try{
					PreparedStatement pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1,_type);
					rs = pstmt.executeQuery();
					HashMap<String,String> facetMap = new HashMap<String,String>();
					while(rs.next()){
						String id = rs.getString("entity_id");
						String entity = rs.getString("entity");
						String normalized = rs.getString("normalized");
						
						if(normalized != null){
							if(normalized.length() > 0){
								entity = normalized;
							}
						}
						
						facetMap.put(entity,id);
					}	
					rs.close();					
%>
					<tr>
						<td align="left" valign="middle">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td>
										<a href="facet.do?_type=<%=_type%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" style="text-decoration: none;font-size: 0.9em;"
											onmouseout="this.style.textDecoration='none'"
											onmouseover="this.style.textDecoration='underline'"
											>
											<%=_type%>
										</a>
									</td>
								</tr>
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
<% 
					if(facetMap.size() > 0){
						Vector<String> v = new Vector<String>(facetMap.keySet());
						Collections.sort(v);
						for(Iterator<String> it=v.iterator();it.hasNext();){
							String entity = (String)it.next();
							String id = (String)facetMap.get(entity);
%>
								<tr>
									<td>
										<a href="facet.do?entity_id=<%=id%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" style="text-decoration: none;font-size: 0.7em;"
											onmouseout="this.style.textDecoration='none'"
											onmouseover="this.style.textDecoration='underline'"
											>
											<%=entity%>
										</a>&nbsp;
									</td>
								</tr>
<%		
						}
					}
%>
						</table>
					</td>
				</tr>
<%
				}catch(SQLException ex){
				    out.println(ex.toString());
				}finally{
					if(rs!=null){
					    try{
					        rs.close();
					    }catch(SQLException ex){}
					}
				}
			}
%>
<%
		}
%>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
<%	
	}
%>			
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
<% 
	int col = 1;
	if(entity_id_value == null && type_value == null && col_id <=0 && tag_id <=0){
		col = 3;
	}
	if(entity_id > 0 || !_type.equalsIgnoreCase("")){
%>
			Related 
<%	
	}
%>			
			Entities
		</td>
	</tr>
	<tr>
		<td style="font-size: 0.9em;<%if(col==1)out.print("border: 1px #EFEFEF solid;");%>">
<%	
	sql = "SELECT e._type,e.entity_id,e.entity,e.normalized,COUNT(*) _no " +
			"FROM entity e,entities ee " +
			"WHERE e.entity_id = ee.entity_id AND ee.col_id IN (SELECT col_id FROM colloquium)"; 

	if(affiliate_id > 0 ){
		sql += " AND ee.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
	}
	if(tag_id > 0){
		sql += " AND ee.col_id IN " + 
				"(SELECT u.col_id FROM tags tt,userprofile u WHERE tt.userprofile_id=u.userprofile_id AND " +
				"tt.tag_id = " + tag_id + ")";
	}
	if(col_id > 0){
		sql += " AND ee.col_id = " + col_id;
	}
	if(user_id > 0){
		sql += " AND ee.col_id IN (SELECT col_id " +
				"FROM userprofile " +
				"WHERE user_id = " + user_id + ")";
	}
	if(comm_id > 0){
		sql += " AND ee.col_id IN (SELECT u.col_id FROM contribute c,userprofile u " +
				"WHERE u.userprofile_id = c.userprofile_id AND c.comm_id = " + comm_id + ")";
	}
	if(series_id > 0){
		sql += " AND ee.col_id IN (SELECT col_id " +
				"FROM seriescol " +
				"WHERE series_id = " + series_id + ")";
	}
	if(entity_id_value != null){
		sql += " AND e.entity_id NOT IN (" + entity_id_list + ")";
		for(int i=0;i<entity_id_value.length;i++){
			sql += " AND ee.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ")";
		}
	}
	if(type_value != null){
		sql+=" AND e._type NOT IN (" + type_list + ")";
		for(int i=0;i<type_value.length;i++){
			sql+=" AND ee.col_id IN (SELECT ee.col_id FROM entities ee,entity e " +
					"WHERE ee.entity_id = e.entity_id AND e._type='" + type_value[i] + "')"; 
		}
	}
	sql += " GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	
	if(isDebugged){
		out.print(sql + "<br/>");
	}
	//return;
    try{
    	rs = conn.getResultSet(sql);
    	String __type = "";
    	HashMap<String,HashMap<String,String>> predMap = new HashMap<String,HashMap<String,String>>();//Map of Entity-ID Map
    	HashMap<String,Double> rankMap = new HashMap<String,Double>();
    	HashMap<String,Integer> predResMap = new HashMap<String,Integer>();//Map of Predicate-Resource
    	double total_rank_score = 0.0;
    	
    	int total_resources = 99999;
    	//Find total resources
    	sql = "SELECT COUNT(*) _no FROM colloquium WHERE TRUE ";
    	if(entity_id_value != null){
			for(int i=0;i<entity_id_value.length;i++){
	    		sql += "AND col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ")";
			}
    	}
    	if(type_value != null){
 			for(int i=0;i<type_value.length;i++){
		   		sql += "AND col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id=e.entity_id AND " +
						"e._type='" + type_value[i] + "')"; 
			}
    	}
		if(affiliate_id > 0 ){
			sql += "AND col_id IN " +
					"(SELECT ac.col_id FROM affiliate_col ac," +
					"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
					"WHERE ac.affiliate_id = cc.child_id " +
					"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id=" + affiliate_id + ")";
		}
		//System.out.println(sql);
    	ResultSet rsRes = conn.getResultSet(sql);
    	if(rsRes.next()){
    		total_resources = rsRes.getInt("_no");
    	}
    	rsRes.close();
    	if(isDebugged){
 %>
 		<%=sql%><br/>
 		Total resources: <%=total_resources%><br/><br/>
 <%   	
 		}
 		
 		HashMap<String,String> entityIDMap = new HashMap<String,String>();
        while(rs.next()){
        	String _new_type = rs.getString("_type");
        	String entity = rs.getString("entity");
        	String _entity_id = rs.getString("entity_id");
        	String normalized = rs.getString("normalized");
        	int _no = rs.getInt("_no");
		if(normalized != null){
			if(normalized.length() > 0){
				entity = normalized;
			}
		}
        	if(isDebugged){
%>
		type: <%=_new_type%> entity: <%=entity%> no: <%=_no%><br/>
<%       	
			}
        	if(!__type.equalsIgnoreCase(_new_type)){
        		if(!__type.equalsIgnoreCase("")){
					if(isDebugged){	
%>
		******************************************<br/>
		Calculating Navigational Sufficiency Score<br/>
		******************************************<br/>
<%        		
					}	
					HashMap<String,Integer> occurMap = new HashMap<String,Integer>();
    				double total_occur = 0.0;
					sql = "SELECT e.entity_id,COUNT(*) _no FROM entities ee,entity e " +
							"WHERE ee.entity_id = e.entity_id AND e._type = '" + __type + "'"; 
			    	if(entity_id_value != null){
						for(int i=0;i<entity_id_value.length;i++){
				    		sql += "AND ee.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ")";
						}
			    	}
			    	if(type_value != null){
			 			for(int i=0;i<type_value.length;i++){
					   		sql += "AND ee.col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id=e.entity_id AND " +
									"e._type='" + type_value[i] + "')"; 
						}
			    	}
					if(affiliate_id > 0 ){
						sql += "AND ee.col_id IN " +
								"(SELECT ac.col_id FROM affiliate_col ac," +
								"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
								"WHERE ac.affiliate_id = cc.child_id " +
								"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
					}
					sql += " GROUP BY e.entity_id";					
			    	rsRes = conn.getResultSet(sql);
			    	while(rsRes.next()){
			    		String e_id = rsRes.getString("entity_id");
			    		int occur = rsRes.getInt("_no");
			    		occurMap.put(e_id,occur);
			    		total_occur += occur;
			    	}
			    	rsRes.close();
        			//Calculate Mu
        			double mu = (double)total_occur/(double)occurMap.size();
        			//Calculate Variance
        			double variance = 0;
        			double dist = 0;
        			for(Iterator<String> i = occurMap.keySet().iterator();i.hasNext();){
        				int occur = ((Integer)occurMap.get(i.next())).intValue();
        				double value = (double)occur - mu;
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
        			if(isDebugged){
%>
		Map size: <%=occurMap.size()%> mu: <%=mu%> variance: <%=variance%><br/>
<%
					}
	        		//Calculate Navigational Sufficiency here 3 matrics
					//1)Predicate Balance
					double balance = 0.0;
					if(occurMap.size() > 1){
						balance = 1.0 - Math.abs(dist)/((double)(occurMap.size()-1)*mu + ((double)total_occur - mu));
					}
					if(isDebugged){
%>
		1)Balance Score: <%=balance%><br/>
<%					
					}
					//2)Object Cardinality
					double card = 0.0;//if a number of type is <= 1
					if(occurMap.size() > 1){
						double value = (double)occurMap.size() - mu;
						value = value*value;
						card = Math.exp(-(value)/(2.0*variance));
					}
					if(isDebugged){
%>
		2)Object Cardinality: <%=card%><br/>
<%					
					}
					//3)Predicate Frequency
					double freq = 0.0;
					sql = "SELECT COUNT(*) _no FROM" +
							"(SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id = e.entity_id AND e._type = '" + 
							__type + "'";
			    	if(entity_id_value != null){
						for(int i=0;i<entity_id_value.length;i++){
				    		sql += "AND ee.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ")";
						}
			    	}
			    	if(type_value != null){
			 			for(int i=0;i<type_value.length;i++){
					   		sql += "AND ee.col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id=e.entity_id AND " +
									"e._type='" + type_value[i] + "')"; 
						}
			    	}
					if(affiliate_id > 0 ){
						sql += "AND ee.col_id IN " +
								"(SELECT ac.col_id FROM affiliate_col ac," +
								"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
								"WHERE ac.affiliate_id = cc.child_id " +
								"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
					}
					sql += " GROUP BY ee.col_id) _res";					
					rsRes = conn.getResultSet(sql);
					int resNo = 0;
					if(rsRes.next()){
						resNo = rsRes.getInt("_no");
					}	
					freq = (double)resNo/(double)total_resources;
					rsRes.close();
					if(isDebugged){
%>
		3)Predicate Frequency: <%=freq%> freq: <%=resNo%><br/>
<%					
					}
					
					double final_score = balance + card + freq;//This equation can be weighted.
					if(isDebugged){
%>
		Final Score: <%=final_score%><br/>
		*****************************<br/>
<%					
					}
					rankMap.put(__type,final_score);
					predMap.put(__type,entityIDMap);
					predResMap.put(__type,resNo);
					total_rank_score += final_score;
        		}
          		entityIDMap = new HashMap<String,String>();      		
        		__type = _new_type;
        	}
        	entityIDMap.put(entity,_entity_id);
		}

		//Last Predicate Insertion
		if(!__type.equalsIgnoreCase("")){
			if(isDebugged){
%>
		******************************************<br/>
		Calculating Navigational Sufficiency Score<br/>
		******************************************<br/>
<%        			
			}
			HashMap<String,Integer> occurMap = new HashMap<String,Integer>();
  			double total_occur = 0.0;
			sql = "SELECT e.entity_id,COUNT(*) _no " +
					"FROM entities ee,entity e " +
					"WHERE ee.entity_id = e.entity_id AND e._type = '" + __type + "' ";
	    	if(entity_id_value != null){
				for(int i=0;i<entity_id_value.length;i++){
		    		sql += "AND ee.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ")";
				}
	    	}
	    	if(type_value != null){
	 			for(int i=0;i<type_value.length;i++){
			   		sql += "AND ee.col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id=e.entity_id AND " +
							"e._type='" + type_value[i] + "')"; 
				}
	    	}
			if(affiliate_id > 0 ){
				sql += "AND ee.col_id IN " +
						"(SELECT ac.col_id FROM affiliate_col ac," +
						"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
						"WHERE ac.affiliate_id = cc.child_id " +
						"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
			}
			sql += " GROUP BY e.entity_id";					
	    	rsRes = conn.getResultSet(sql);
	    	if(isDebugged){
	    		out.println(sql + "<br/>");
	    	}
	    	while(rsRes.next()){
	    		String e_id = rsRes.getString("entity_id");
	    		int occur = rsRes.getInt("_no");
	    		occurMap.put(e_id,occur);
	    		total_occur += occur;
	    	}
	    	rsRes.close();
   			//Calculate Mu
   			double mu = (double)total_occur/(double)occurMap.size();
   			//Calculate Variance
   			double variance = 0;
   			double dist = 0;
   			for(Iterator<String> i = occurMap.keySet().iterator();i.hasNext();){
   				int occur = ((Integer)occurMap.get(i.next())).intValue();
   				double value = (double)occur - mu;
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
   			if(isDebugged){
%>
		Map size: <%=occurMap.size()%> mu: <%=mu%> variance: <%=variance%><br/>
<%
			}
       		//Calculate Navigational Sufficiency here 3 matrics
			//1)Predicate Balance
			double balance = 0.0;
			if(occurMap.size() > 1){
				balance = 1.0 - Math.abs(dist)/((double)(occurMap.size()-1)*mu + ((double)total_occur - mu));
			}
			if(isDebugged){
%>
		1)Balance Score: <%=balance%><br/>
<%					
			}
			//2)Object Cardinality
			double card = 0.0;//if a number of type is <= 1
			if(occurMap.size() > 1){
				double value = (double)occurMap.size() - mu;
				value = value*value;
				card = Math.exp(-(value)/(2.0*variance));
			}
			if(isDebugged){
%>
		2)Object Cardinality: <%=card%><br/>
<%				
			}	
			//3)Predicate Frequency
			double freq = 0.0;
			sql = "SELECT COUNT(*) _no FROM" +
					"(SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id = e.entity_id AND e._type = '" + 
					__type + "' ";
	    	if(entity_id_value != null){
				for(int i=0;i<entity_id_value.length;i++){
		    		sql += "AND ee.col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[i] + ")";
				}
	    	}
	    	if(type_value != null){
	 			for(int i=0;i<type_value.length;i++){
			   		sql += "AND ee.col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id=e.entity_id AND " +
							"e._type='" + type_value[i] + "')"; 
				}
	    	}
			if(affiliate_id > 0 ){
				sql += "AND ee.col_id IN " +
						"(SELECT ac.col_id FROM affiliate_col ac," +
						"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
						"WHERE ac.affiliate_id = cc.child_id " +
						"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
			}
			sql += " GROUP BY ee.col_id) _res";					
			rsRes = conn.getResultSet(sql);
			int resNo = 0;
			if(rsRes.next()){
				resNo = rsRes.getInt("_no");
			}	
			freq = (double)resNo/(double)total_resources;
			rsRes.close();
			if(isDebugged){
%>
		3)Predicate Frequency: <%=freq%> freq: <%=resNo%><br/>
<%					
			}
			
			double final_score = balance + card + freq;//This equation can be weighted.
			if(isDebugged){
%>
		Final Score: <%=final_score%><br/>
		*****************************<br/>
<%					
			}
			rankMap.put(__type,final_score);
			predMap.put(__type,entityIDMap);
			predResMap.put(__type,resNo);
			total_rank_score += final_score;
		}
		rs.close();
		
		//Calculate ranking mu
		double mu = total_rank_score/(double)rankMap.size();
		
		//Calculate ranking variance
		double variance = 0.0;
		for(Iterator<String> i = rankMap.keySet().iterator();i.hasNext();){
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
		//*********************************************
		//Generate facets
		//*********************************************
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
				int resNo = ((Integer)predResMap.get(type)).intValue();
				sql = "SELECT COUNT(*) _no FROM colloquium " + 
						"WHERE col_id IN (SELECT ee.col_id FROM entities ee,entity e " +
						"WHERE ee.entity_id = e.entity_id AND " +
						"e._type = '" + type + "') ";					
		    	if(entity_id_value != null){
					for(int k=0;k<entity_id_value.length;k++){
			    		sql += "AND col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[k] + ") ";
					}
		    	}
		    	if(type_value != null){
		 			for(int k=0;k<type_value.length;k++){
				   		sql += "AND col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id=e.entity_id AND " +
								"e._type='" + type_value[k] + "')"; 
					}
		    	}
				if(affiliate_id > 0 ){
					sql += "AND col_id IN " +
							"(SELECT ac.col_id FROM affiliate_col ac," +
							"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
							"WHERE ac.affiliate_id = cc.child_id " +
							"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
				}
				if(tag_id > 0){
					sql += "AND col_id IN " +
							"(SELECT col_id FROM tags WHERE tag_id = " + tag_id + ")";					
				}
				if(comm_id>0){
					sql += " AND col_id IN " +
							"(SELECT col_id FROM contribute WHERE comm_id = " + comm_id +")";					
				}
				rsRes = conn.getResultSet(sql);
				if(isDebugged){
					out.println(sql + "<br/>");
				}
				if(rsRes.next()){
					resNo = rsRes.getInt("_no");
				}
				rsRes.close();	
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
					if(col==1){
%>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
<%				
					}
%>
				<tr>
<%				
				}
%>
					<td align="left" valign="middle" <%if(col==1)out.print("style='background-color: #EFEFEF;'");%>>
						<a href="facet.do?_type=<%=type%><%if(request.getQueryString()!=null)out.print("&" + request.getQueryString());%>" style="text-decoration: none;font-size: <%=fontsize%>em;"
							onmouseout="this.style.textDecoration='none'"
							onmouseover="this.style.textDecoration='underline'"
							>
							<%=type%> 
<%
				if(col_id<=0)out.print("(" + resNo + ")");
%>
						</a>&nbsp;
<% 
				if(col==1){
%>
					</td>

				</tr>
				<tr>
					<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
				</tr>
<% 
					HashMap<String,String> hm = (HashMap<String,String>)predMap.get(type);
					Vector<String> vv = new Vector<String>(hm.keySet());
					Collections.sort(vv);
					for(Iterator <String> it=vv.iterator();it.hasNext();){
						String entity = it.next();
						String _entity_id = (String)hm.get(entity);

						sql = "SELECT COUNT(*) _no FROM colloquium WHERE " +
								"col_id IN (SELECT col_id FROM entities WHERE entity_id = " + _entity_id + ")";					
				    	if(entity_id_value != null){
							for(int ii=0;ii<entity_id_value.length;ii++){
					    		sql += "AND col_id IN (SELECT col_id FROM entities WHERE entity_id=" + entity_id_value[ii] + ")";
							}
				    	}
				    	if(type_value != null){
				 			for(int ii=0;ii<type_value.length;ii++){
						   		sql += "AND col_id IN (SELECT ee.col_id FROM entities ee,entity e WHERE ee.entity_id=e.entity_id AND " +
										"e._type='" + type_value[ii] + "')"; 
							}
				    	}
						if(affiliate_id > 0 ){
							sql += "  AND col_id IN " +
									"(SELECT ac.col_id FROM affiliate_col ac," +
									"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
									"WHERE ac.affiliate_id = cc.child_id " +
									"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ")";
						}
						if(tag_id > 0){
							sql += "AND col_id IN " +
									"(SELECT col_id FROM tags WHERE tag_id = " + tag_id + ")";					
						}
						if(comm_id>0){
							sql += " AND col_id IN " +
									"(SELECT col_id FROM contribute WHERE comm_id = " + comm_id +")";					
						}
						rsRes = conn.getResultSet(sql);
						resNo = 0;
						if(isDebugged){
							out.println(sql + "<br/>");
						}
						if(rsRes.next()){
							resNo = rsRes.getInt("_no");
						}	
%>
				<tr>
					<td>
						<a href="facet.do?entity_id=<%=hm.get(entity)%><%if(request.getQueryString()!=null)out.print("&" + request.getQueryString());%>" style="text-decoration: none;font-size: 0.7em;"
							onmouseout="this.style.textDecoration='none'"
							onmouseover="this.style.textDecoration='underline'"
							>
							<%=entity%> 
<%
				if(col_id<=0)out.print("(" + resNo + ")");
%>

						</a>&nbsp;
<%					
					}
				}
				if(j%col==col-1){
%>
					</td>
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
					onclick="window.location='facet.do<%if(request.getQueryString()!=null)out.print("?" + request.getQueryString());%>'">More &gt;&gt;</div>
<%	
	}else{
%>
			&nbsp;
<%
	}
	}catch(Exception e){
		//out.println(e.getMessage());
	}
%>
		</td>
	</tr>
