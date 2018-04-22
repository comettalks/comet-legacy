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

<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
<%
	try{ 
	session = request.getSession(false);
	
	int rows = 100;
	int start = 0;
	String[] user_id_value = request.getParameterValues("user_id");
	String[] tag_id_value = request.getParameterValues("tag_id");
	String[] entity_id_value = request.getParameterValues("entity_id");
	String[] type_value = request.getParameterValues("_type");
	String[] series_id_value = request.getParameterValues("series_id");
	String[] comm_id_value = request.getParameterValues("comm_id");
	String[] affiliate_id_value = request.getParameterValues("affiliate_id");
	String[] col_id_value = request.getParameterValues("col_id");
	if(request.getParameter("rows")!=null){
		rows = Integer.parseInt((String)request.getParameter("rows"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
	}
	//if(request.getParameter("topic_id") != null){
	//	topic_id = Integer.parseInt((String)request.getParameter("topic_id"));
	//}
	connectDB conn = new connectDB();
	ResultSet rs = null;
	String sql = "";

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

	if(entity_id_value != null || type_value != null){
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
		<td style="font-size: 0.85em;border: 1px #EFEFEF solid;">
			<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
<% 
		if(entity_id_value != null){
			for(int i = 0;i<entity_id_value.length;i++){
				int entity_id = Integer.parseInt((String)entity_id_value[i]);
				
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
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
								</tr>
<%--
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
--%>
								<tr>
									<td bgcolor="#efefef" style="font-size: 0.8em;font-weight: bold;">
											<%=type%>
									</td>
								</tr>
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td>
										<a href="entity.do?entity_id=<%=entity_id%><%
					if(affiliate_id_value != null){
						for(int ii = 0;i<affiliate_id_value.length;ii++){
							int affiliate_id = Integer.parseInt((String)affiliate_id_value[ii]);
							out.print("&affiliate_id="+affiliate_id);	
						}
					}%>" 
											style="text-decoration: none;font-size: 0.7em;"
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
				String _type = type_value[i].trim();
				sql = "SELECT e.entity_id,e.entity,e.normalized " +
						"FROM entity e JOIN entities ee ON e.entity_id = ee.entity_id JOIN colloquium c " +
						"ON ee.col_id = c.col_id WHERE " +
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
						<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td align="left" valign="middle">
							<table width="100%" cellpadding="0" cellspacing="0">
<%--
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
--%>
								<tr>
									<td bgcolor="#efefef" style="font-size: 0.8em;font-weight: bold;">
											<%=_type%>
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
										<a href="entity.do?entity_id=<%=id%><%
							if(affiliate_id_value != null){
								for(int ii = 0;i<affiliate_id_value.length;ii++){
									int affiliate_id = Integer.parseInt((String)affiliate_id_value[ii]);
									out.print("&affiliate_id="+affiliate_id);	
								}
							}
							%>" 
											style="text-decoration: none;font-size: 0.7em;"
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

	int col = 1;
	if(entity_id_value == null && type_value == null && col_id_value == null && tag_id_value == null && comm_id_value == null && series_id_value == null){
		col = 3;
	}
        if(col==3){
%>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.8em;font-weight: bold;">
			Entities
		</td>
	</tr>
<%
        }
	if(entity_id_value != null || type_value != null){
%>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.8em;font-weight: bold;">
			Related Entities
		</td>
	</tr>
<%	
	}
%>			
	<tr>
		<td style="font-size: 0.8em;<%if(col==1)out.print("border: 1px #EFEFEF solid;");%>">
<%	
	sql = "SELECT e._type,e.entity_id,e.entity,e.normalized " +
			"FROM entity e JOIN entities ee ON e.entity_id = ee.entity_id JOIN colloquium c " +
			"ON ee.col_id = c.col_id "; 

	if(affiliate_id_value != null ){
		for(int i=0;i<affiliate_id_value.length;i++){
			int affiliate_id = Integer.parseInt(affiliate_id_value[i]);
			sql += "AND ee.col_id IN " +
				"(SELECT ac.col_id FROM affiliate_col ac," +
				"(select child_id from relation where path like concat((SELECT path from relation where child_id = "+ affiliate_id + "),',%')) cc " +
				"WHERE ac.affiliate_id = cc.child_id " +
				"UNION SELECT col_id FROM affiliate_col WHERE affiliate_id = " + affiliate_id + ") ";
		}
	}
	if(tag_id_value != null){
		String tag_ids = null;
		for(int i=0;i<tag_id_value.length;i++){
			if(tag_ids == null){
				tag_ids = tag_id_value[i];
			}else{
				tag_ids += "," + tag_id_value[i];
			}
		}
		sql += "JOIN userprofile up ON ee.col_id=up.col_id JOIN tags tt ON tt.userprofile_id=u.userprofile_id AND " +
			"tt.tag_id IN (" + tag_ids + ") ";
	}
	if(col_id_value != null){
		String col_ids = null;
		for(int i=0;i<col_id_value.length;i++){
			if(col_ids == null){
				col_ids = col_id_value[i];
			}else{
				col_ids += "," + col_id_value[i];
			}
		}
		sql += "AND ee.col_id IN (" + col_ids + ") ";
	}
	if(user_id_value !=null){
		String user_ids = null;
		for(int i=0;i<user_id_value.length;i++){
			if(user_ids == null){
				user_ids = user_id_value[i];
			}else{
				user_ids += "," + user_id_value[i];
			}
		}
		sql += "JOIN userprofile uup ON ee.col_id=uup.col_id " +
				"AND uup.user_id IN (" + user_ids + ") ";
	}
	if(comm_id_value !=null){
		String comm_ids = null;
		for(int i=0;i<comm_id_value.length;i++){
			if(comm_ids == null){
				comm_ids = comm_id_value[i];
			}else{
				comm_ids += "," + comm_id_value[i];
			}
		}
		sql += " JOIN userprofile upp ON ee.col_id=upp.col_id JOIN contribute cc " +
				"ON upp.userprofile_id = cc.userprofile_id AND c.comm_id IN (" + comm_ids + ") ";
	}
	if(series_id_value !=null){
		String series_ids = null;
		for(int i=0;i<series_id_value.length;i++){
			if(series_ids == null){
				series_ids = series_id_value[i];
			}else{
				series_ids += "," + series_id_value[i];
			}
		}
		sql += "JOIN seriescol sc ON ee.col_id=sc.col_id " +
				"AND sc.series_id IN (" + series_ids + ") ";
	}
	if(entity_id_value != null){
		sql += "AND e.entity_id NOT IN (" + entity_id_list + ") " +
				"JOIN entities eee ON ee.col_id = eee.col_id AND eee.entity_id IN (" + entity_id_list + ") ";
	}
	if(type_value != null){
		sql+="AND e._type NOT IN (" + type_list + ") " +
				"JOIN entities e3 ON ee.col_id=e3.col_id JOIN entity e2 ON e3.entity_id=e2.entity_id AND e2._type IN (" + type_list + ")";
	}
	sql += " GROUP BY e._type,e.entity_id,e.entity,e.normalized";
	
    try{
    	rs = conn.getResultSet(sql);
    	String __type = "";
 		
%>
			<table cellspacing="0" cellpadding="0" width="100%" align="center">
<%	
	int j=0;
     while(rs.next()){
     		String _new_type = rs.getString("_type");
        	String entity = rs.getString("entity");
        	String _entity_id = rs.getString("entity_id");
        	String normalized = rs.getString("normalized");
			if(normalized != null){
				if(normalized.length() > 0){
					entity = normalized;
				}
			}
        	//New Type
        	if(!__type.equalsIgnoreCase(_new_type)){
        		//Not the first type
        		if(!__type.equalsIgnoreCase("")){
        		
        		
			}
			if(col==1){
%>
				<tr>
					<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
				</tr>
				<tr>
					<td align="left" valign="middle" style="font-size: 0.8em;background-color: #EFEFEF;font-weight: bold;">
							<%=_new_type%>
					</td>
				</tr> 
				<tr>
					<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
				</tr>
<%
			}else{// col == 3
				if(j%col==0){
%>
				<tr>
<%				
				}
%>
					<td align="left" valign="middle">
						<a href="entity.do?_type=<%=_new_type%>
<%
				if(request.getQueryString()!=null){
					String[] param = request.getQueryString().split("&");
					String newQueryString = "";
					for(int q=0;q<param.length;q++){
						if(!param[q].startsWith("col_id")){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param[q];
						}
					}
					if(newQueryString.length() > 0){
						out.print("&" + newQueryString);
					}
				}
%>" 
							style="text-decoration: none;font-size: 0.8em;"
							onmouseout="this.style.textDecoration='none'"
							onmouseover="this.style.textDecoration='underline'"
							>
							<%=_new_type%>
						</a>
					</td>

<%
					if(j%col==2){
%>
				</tr>
<%				
					}
				}
				
				
        		__type = _new_type;
        		j++;
        	}

			if(col==1){
%>
				<tr>
					<td>
						<a href="entity.do?entity_id=<%=_entity_id%>
<%
				if(request.getQueryString()!=null){
					String[] param = request.getQueryString().split("&");
					String newQueryString = "";
					for(int q=0;q<param.length;q++){
						if(!param[q].startsWith("col_id")){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param[q];
						}
					}
					if(newQueryString.length() > 0){
						out.print("&" + newQueryString);
					}
				}
%>" 
							style="text-decoration: none;font-size: 0.7em;"
							onmouseout="this.style.textDecoration='none'"
							onmouseover="this.style.textDecoration='underline'"
							>
							<%=entity%>
						</a>
					</td>
				</tr> 

<%
			}
	        	
		}
%>
			</table>
<%						
		rs.close();
		conn.conn.close();
		conn = null;

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
					onclick="window.location='entity.do
<%
				if(request.getQueryString()!=null){
					String[] param = request.getQueryString().split("&");
					String newQueryString = "";
					for(int q=0;q<param.length;q++){
						if(!param[q].startsWith("col_id")){
							if(newQueryString.length() > 0){
								newQueryString += "&";
							}
							newQueryString += param[q];
						}
					}
					if(newQueryString.length() > 0){
						out.print("?" + newQueryString);
					}
				}
%>" 
				>More &gt;&gt;</div>
<%	
	}else{
%>
			&nbsp;
<%
	}
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
%>
		</td>
	</tr>