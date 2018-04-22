<%@ page language="java" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<% 
	session = request.getSession();
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	int tag_id = 0;
	int col_id = 0;
	int user_id = 0;
	int comm_id = 0;
	int series_id = 0;
	int affiliate_id = -1;
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
%>

<table border="0" cellspacing="0" cellpadding="0" width="100%" align="left">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td bgcolor="#efefef" style="background-color: #efefef;font-size: 0.85em;font-weight: bold;">
			Public Comments
		</td>
	</tr>
	<tr>
		<td id="tdCommentContainer">
			<tiles:insert template="/utils/getComments.jsp" />
		</td>
	</tr>
<logic:present name="UserSession">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
 		<tr>
 			<td colspan="2" valign="top">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<textarea id="txtComment" name="comment" rows="5" cols="20"></textarea>
						</td>
					</tr>
					<tr>
						<td><input name="poster_id" type="hidden" value="<%=ub.getUserID()%>">&nbsp;</td>
					</tr>
					<tr>
						<td>
							<input onclick="postColComment(<%=col_id %>,$('#txtComment'),this,$('#tdCommentContainer'));return false;" id="btnAddColComment" class="btn" type="button" value="Post a comment">
						</td>
					</tr>
				</table>
 			</td>
 		</tr>
</logic:present>
</table> 
