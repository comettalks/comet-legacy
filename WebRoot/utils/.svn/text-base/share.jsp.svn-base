<%@ page language="java"%>
<%@ page import="edu.pitt.sis.beans.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+path+"/";
	String col_id = (String)request.getParameter("col_id");
	String title = (String)request.getParameter("title");
	if(col_id!=null){
		String paperPath = basePath + "presentColloquium.do?col_id=" + col_id;
		if(title==null){
			title = "";
		}
%>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td align="center" width="25%">
			<script src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script>
			<fb:like href="<%=paperPath %>" layout="button_count" action="recommend"></fb:like>		
		</td>
		<td align="center" width="25%">
			<a href="http://twitter.com/share" class="twitter-share-button" data-text="<%=title %>" 
				data-url="<%=paperPath %>" data-count="horizontal">Tweet</a>
			<script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
		</td>
		<td align="center" width="25%">
			<a title="Post to Google Buzz" class="google-buzz-button" href="http://www.google.com/buzz/post" 
				data-button-style="small-count" data-url="<%=paperPath %>"></a>
			<script type="text/javascript" src="http://www.google.com/buzz/api/button.js"></script>		
		</td>
		<td align="center" width="25%">
			<!-- AddThis Button BEGIN -->
			<div class="addthis_toolbox addthis_default_style">
				<a class="addthis_counter addthis_pill_style" href="http://www.addthis.com/bookmark.php" 
					addthis:url="<%=paperPath %>" addthis:title="<%=title %>" ></a>
			</div>
			<script type="text/javascript">var addthis_config = {"data_track_clickback":true};</script>
			<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=chirayukong"></script>
			<!-- AddThis Button END -->
		</td>
	</tr>	
</table>
<%		
	}
%>