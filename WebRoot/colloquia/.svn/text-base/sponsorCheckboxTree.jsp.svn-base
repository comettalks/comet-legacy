<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.util.HashSet"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="java.sql.*"%>
<script language="JavaScript" src="scripts/prototype.js"></script>
<script language="JavaScript">
function showChildren(obj,srcObj)
{
    var children = obj.immediateDescendants();
    for(var i=0;i<children.length;i++)
    {
        if(children[i].tagName.toLowerCase()=='ul')
            children[i].toggle();
    }
    srcObj.style.width="0px";
    srcObj.style.display="none";
}

function checkChildren(obj,srcObj)
{
    var children = obj.immediateDescendants();
    for(var i=0;i<children.length;i++)
    {
        if(children[i].tagName.toLowerCase()=='input' && children[i].type=='checkbox' && children[i]!=srcObj)
            children[i].checked = srcObj.checked;

        // recursive call
        checkChildren(children[i],srcObj);
    }
}
</script>
<style type='text/css'>

ul li{
    list-style-type:none;
    margin:0;
    padding:0;
    margin-left:8px;
}

</style>

<% 
	connectDB conn = new connectDB();
	HashSet<String> seriesSet = new HashSet<String>();
	String col_id = (String)request.getParameter("col_id");
	if(col_id!=null){
		String sql = "SELECT series_id FROM seriescol WHERE col_id = " + col_id;
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			seriesSet.add(rs.getString("series_id"));	
		}
	}
	String sql = "SELECT series_id,name FROM series " +
	//"WHERE semester = (SELECT currsemester FROM sys_config) " + 
	"ORDER BY name";
	ResultSet rs = conn.getResultSet(sql);
	if(seriesSet.size()==0){
%>
<input type="button" class="btn" onclick='showChildren($("tree_series"),this);' value='Show Series' />
<%		
	}
%>
<span id="tree_series">
	<ul style="display: <%=seriesSet.size()==0?"none":"block" %>;">
<% 
	while(rs.next()){
		String series_id = rs.getString("series_id");
		String name = rs.getString("name");
		String checked="";
		if(seriesSet.contains(series_id)){
			checked = "checked='checked'";
		}
%>
	<li>
		<input type="checkbox" name="series_id" value="<%=series_id%>" <%=checked%>/>&nbsp;<%=name%><br/>
	</li>
<%
	}
%>
	</ul>
</span>
	