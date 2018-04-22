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
						if(normalized.length() > 0){
							entity = normalized;
						}
					}
					rs.close();
					
%>
					<tr>
						<td align="left" valign="middle">
							<table width="100%" cellpadding="0" cellspacing="0">
<%--
								<tr>
									<td bgcolor="#EFEFEF"><div style="height: 1px;overflow: hidden;">&nbsp;</div></td>
								</tr>
--%>
								<tr>
									<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
											<%=type%>
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
						
						if(normalized.length() > 0){
							entity = normalized;
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
									<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
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
										<a href="facet.do?entity_id=<%=id%><%if(affiliate_id>0)out.print("&affiliate_id="+affiliate_id);%>" 
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
%>			
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">
<% 
	int col = 1;
	if(entity_id_value == null && type_value == null && col_id <=0 && tag_id <=0 && comm_id <=0 && series_id <=0){
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
	sql = "SELECT e._type,e.entity_id,e.entity,e.normalized " +
			"FROM entity e,entities ee,colloquium c " +
			"WHERE e.entity_id = ee.entity_id AND ee.col_id = c.col_id"; 

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
					<td align="left" valign="middle" style="background-color: #EFEFEF;font-weight: bold;">
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
						<a href="facet.do?_type=<%=_new_type%>
							<%if(request.getQueryString()!=null)out.print("&" + request.getQueryString());%>" 
							style="text-decoration: none;"
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
						<a href="facet.do?entity_id=<%=_entity_id%>
							<%if(request.getQueryString()!=null)out.print("&" + request.getQueryString());%>" 
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
		System.out.println(e.getMessage());
	}
%>
		</td>
	</tr>
