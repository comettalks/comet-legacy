<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="edu.pitt.sis.beans.UserBean"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>


<link rel="stylesheet" type="text/css" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js"> 
</script> 
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js"></script> 
<script type="text/javascript" src="<%=request.getContextPath() + "/scripts/jquery.cookie.js"%>"> 
</script> 
<script src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
<script type='text/javascript' src='scripts/jquery.bgiframe.min.js'></script>
<script type='text/javascript' src='scripts/jquery.autocomplete.js'></script>
<script type='text/javascript' src='scripts/jquery.simplemodal.js'></script>

<style type="text/css">
    #navimenu, #navimenu li {
 	list-style:none;
 	padding:0;
	margin:0;
	}
    #navimenu li { 
    float:left;
    font-size: 0.85em;
    text-decoration:none;
    border-right:1px solid #000;
    }
    #navimenu li a {
    text-decoration:none;

    }
    
    #navimenu li a.last {
    border-right:0;
    }
    
    #speakerlist, #speakerlist li {
    list-style:none;
 	padding:0;
	margin:0;
	}
    #speakerattri, #speakerattri li {
    list-style:none;
 	padding:0;
	margin:3px;
	}
	
	#paging li{font-size:13px;vertical-align:top;display:inline-block;*display:inline;*zoom:1;}
	*{margin:0;padding:0;}
	.paging{font-size:0;list-style:none;display:block;text-align:right;}
	.paging{border-bottom:2px solid #00468c;padding:0px 0;margin-bottom:100px;background:#efefef;}
        .paging li{background:#00468c;padding:2px 5px;border:1px solid #fff;}
        .paging a{color:#fff;text-decoration:none;}
    .pageno {width: 35px; height:15px}
    .curr{font-weight:bold;}
    
    img.speakerImg {
    	display:block;
    	margin-left:auto;
    	margin-right:auto;
    }
    	
</style>
<%  
	session = request.getSession(false);
	String cfirst="uncheck";		//use for checking checkbox
	String csecond="uncheck";
	String cthird="uncheck";
	String cforth="uncheck";
	String cfifth="uncheck";
	String initial = "a";
	int pagesize = 20;				//rows show in a page
	int start = 0;					// start point
	int recordcount = 0;			// the amount of rows
	int maxpage = 0;				// count the the number of pages
	int pageno = 0;					// which page is in
	int i = 0;						// index for displaing two column 
	String findname = "";			// for searching name
	/*String strone = "";
	String strtwo = "";
	String strthr = "";
	String strfor = "";
	String strfif = "";
	String tempone="";
	String temptwo="";
	String tempthr="";
	String tempfor="";
	String tempfif="";*/
	
	// get the parameters
	if(request.getParameter("pageno") != null){
		pageno = Integer.parseInt((String)request.getParameter("pageno"));
	}	
	if(request.getParameter("start") != null){
		start = Integer.parseInt((String)request.getParameter("start"));
		if(start <0){
		start = 0;
		}
	}
	if(request.getParameter("initial")!=null){
		initial = request.getParameter("initial");
	}
	if(request.getParameter("findname")!=null){
		findname = request.getParameter("findname");
	}
	
	if(request.getParameter("cfirst")!=null){
		cfirst = request.getParameter("cfirst");
	}
	
	if(request.getParameter("csecond")!=null){
		csecond = request.getParameter("csecond");
	}
	if(request.getParameter("cthird")!=null){
		cthird = request.getParameter("cthird");
	}
	if(request.getParameter("cforth")!=null){
		cforth = request.getParameter("cforth");
	}
	if(request.getParameter("cfifth")!=null){
		cfifth = request.getParameter("cfifth");
	}
	
	
    //sql
	UserBean ub = (UserBean)session.getAttribute("UserSession");
	String countsql ="SELECT count(DISTINCT s.speaker_id) FROM speaker s " 
	+ "JOIN col_speaker cs ON s.speaker_id=cs.speaker_id "
	+ "JOIN colloquium c ON cs.col_id=c.col_id ";
	
	String sql ="SELECT s.speaker_id, s.name, s.affiliation, s.picurl FROM speaker s "
	+ "JOIN col_speaker cs ON s.speaker_id=cs.speaker_id "
	+ "JOIN colloquium c ON cs.col_id=c.col_id ";
	
	String ordertemp = "s.name ";
	if(csecond.equalsIgnoreCase("checked")){
		sql += "JOIN col_impact ci ON c.col_id=ci.col_id ";
	}
	if(cthird.equalsIgnoreCase("checked")){
		countsql += "JOIN final_subscribe_speaker fss ON s.speaker_id=fss.speaker_id ";
		sql += "JOIN final_subscribe_speaker fss ON s.speaker_id=fss.speaker_id ";
	}
	if(cforth.equalsIgnoreCase("checked")){
		countsql += "JOIN seriescol sc ON c.col_id=sc.col_id JOIN final_subscribe_series fsse ON sc.series_id=fsse.series_id ";
		sql += "JOIN seriescol sc ON c.col_id=sc.col_id JOIN final_subscribe_series fsse ON sc.series_id=fsse.series_id ";
		initial="all";
	}
	if(cfifth.equalsIgnoreCase("checked")){
		countsql += "JOIN contribute ct ON c.col_id=ct.col_id JOIN final_subscribe_community fsc ON ct.comm_id = fsc.comm_id ";
		sql += "JOIN contribute ct ON c.col_id=ct.col_id JOIN final_subscribe_community fsc ON ct.comm_id = fsc.comm_id ";
		initial="all";
	}
	countsql += "WHERE s.notrealperson = 0 ";
	sql += "WHERE s.notrealperson = 0 ";
	if(!initial.equalsIgnoreCase("all")){
		countsql += "AND s.name regexp '^" +initial+ "' ";
		sql += "AND s.name regexp '^" +initial+ "' ";
	}
	if(request.getParameter("findname")!=null){
		countsql += "AND s.name regexp '" +findname+ "' ";
		sql += "AND s.name regexp '" +findname+ "' ";
	}
	if(cfirst.equalsIgnoreCase("checked")){
		countsql += "AND c._date > CURDATE() ";
		sql += "AND c._date > CURDATE() ";
	}
	if(cthird.equalsIgnoreCase("checked")){
		countsql += " AND fss.user_id=" + ub.getUserID();
		sql += " AND fss.user_id=" + ub.getUserID();
	}
	if(cforth.equalsIgnoreCase("checked")){
		countsql += " AND fsse.user_id=" + ub.getUserID();
		sql += " AND fsse.user_id=" + ub.getUserID();
	}
	if(cfifth.equalsIgnoreCase("checked")){
	countsql += " AND fsc.user_id=" + ub.getUserID();
	sql += " AND fsc.user_id=" + ub.getUserID();
	}
	sql +=" GROUP BY s.speaker_id ";
	if(csecond.equalsIgnoreCase("checked")){
		ordertemp = "(3*SUM(ci.bookmarkno) +2*SUM(ci.emailno) + SUM(ci.viewno)) DESC ";
	}
	sql +="ORDER BY " + ordertemp;
	sql +="LIMIT " + start + "," + pagesize;
	
	//database connect
	connectDB conn = new connectDB();
	ResultSet rs = null;
	rs=conn.getResultSet(countsql);
	//the the number of rows and pages
	if(rs.next()){
		recordcount = rs.getInt(1);
		maxpage = (int)Math.ceil(((double)recordcount/(double)pagesize));
	}
	
	
%>

<script type="text/javascript">
function checkbox(obj){
//actions for checkbox
if(obj.name=="first"){
if(obj.checked){
//<%session.setAttribute("first","checked");%>
window.location.href="speakerlist.do?initial=<%=initial%>&cfirst=checked&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>";
}
else{
//<%session.setAttribute("first","unchecked");%>
window.location.href="speakerlist.do?initial=<%=initial%>&cfirst=unchecked&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>";
}
}
if(obj.name=="second"){
if(obj.checked){
window.location.href="speakerlist.do?initial=<%=initial%>&cfirst=<%=cfirst%>&csecond=checked&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>";
}
else{
window.location.href="speakerlist.do?initial=<%=initial%>&cfirst=<%=cfirst%>&csecond=unchecked&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>";
}
}
if(obj.name=="third"){
if(obj.checked){
window.location.href="speakerlist.do?initial=all&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=checked&cforth=<%=cforth%>&cfifth=<%=cfifth%>";
}
else{
window.location.href="speakerlist.do?initial=<%=initial%>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=unchecked&cforth=<%=cforth%>&cfifth=<%=cfifth%>";
}
}
if(obj.name=="forth"){
if(obj.checked){
window.location.href="speakerlist.do?initial=all&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=checked&cfifth=<%=cfifth%>";
}
else{
window.location.href="speakerlist.do?initial=<%=initial%>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=unchecked&cfifth=<%=cfifth%>";
}
}
if(obj.name=="fifth"){
if(obj.checked){
window.location.href="speakerlist.do?initial=all&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=checked";
}
else{
window.location.href="speakerlist.do?initial=<%=initial%>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=unchecked";
}
}
}

//navimenu add and remove css
$(document).ready(function(){
	$("#navimenu > li").hover(function(){
        $(this).addClass('curr');
          },function(){
          $(this).removeClass('curr');
          });
//actions for the search textbox          
    $("input#nameInput").autocomplete("speakers.jsp", {
		  	delay: 20,
			formatItem: function(data, i, n, value) {
				var imageSrc = value.split(";")[2];
				if (imageSrc != "null"){
					if (imageSrc.indexOf("http") != 0){
						imageSrc = "images/speaker/" + imageSrc;
					}
					return "<table><tr><td rowspan=\"2\">" + "<img src='" + imageSrc + "' height=\"50\" width=\"50\" /></td>" 
					+ "<td style=\"font-size:10px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				
				}
				else {
					return "<table><tr><td rowspan=\"2\">" + "<img src='images/speaker/avartar.gif' height=\"50\" width=\"50\" /></td>" 
					+ "<td style=\"font-size:10px\"><b>" + value.split(";")[0] + "</b></td></tr><tr><td style=\"font-size:11px\">" + value.split(";")[1] +"</td></tr></table>";
				}
				
			},
	  		formatResult: function(data, value) {
				return value.split(";")[0];
			}
	  }).result(function(event, data, formatted) {
	  }).blur(function(){
		    $(this).search();
	  });
});
//enter 'enter' and display the result
$("input#nameInput").ready(function(){
	$("input#nameInput").keyup(function(e){
		if(e.keyCode == 13){
			//$("#next_a").focus();
			var name = $("input#nameInput").val();
			if(name!=null){
				window.location.href="speakerlist.do?initial=all&findname="+name ;
			}
	}
	});
});
</script>
<!--filthering bar -->
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
		<td width="80%" valign="top">
<table cellspacing="0" cellpadding="0" width="100%" align="left">
<tr>
<td width="15%" valign="top" style="font-size:0.85em;">
Filtered by Name:
</td>
<td width="65%" valign="top" align="left">
<ul id="navimenu">
<li>
<% 
	if(initial.equalsIgnoreCase("a")){
%>
<b>&nbsp;A&nbsp;</b>
<%	
	}else{
%>
<a id="a" href="speakerlist.do?initial=a&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("a")){out.print("return false");}%>" >&nbsp;A&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("b")){
%>
<b>&nbsp;B&nbsp;</b>
<%	
	}else{
%>
<a id="b" href="speakerlist.do?initial=b&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("b")){out.print("return false");}%>"  >&nbsp;B&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("c")){
%>
<b>&nbsp;C&nbsp;</b>
<%	
	}else{
%>
<a id="c" href="speakerlist.do?initial=c&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("c")){out.print("return false");}%>"  >&nbsp;C&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("d")){
%>
<b>&nbsp;D&nbsp;</b>
<%	
	}else{
%>
<a id="d" href="speakerlist.do?initial=d&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("d")){out.print("return false");}%>"  >&nbsp;D&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("e")){
%>
<b>&nbsp;E&nbsp;</b>
<%	
	}else{
%>
<a id="e" href="speakerlist.do?initial=e&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("e")){out.print("return false");}%>"  >&nbsp;E&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("f")){
%>
<b>&nbsp;F&nbsp;</b>
<%	
	}else{
%>
<a id="f" href="speakerlist.do?initial=f&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("f")){out.print("return false");}%>"  >&nbsp;F&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("g")){
%>
<b>&nbsp;G&nbsp;</b>
<%	
	}else{
%>
<a id="g" href="speakerlist.do?initial=g&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("g")){out.print("return false");}%>"  >&nbsp;G&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("h")){
%>
<b>&nbsp;H&nbsp;</b>
<%	
	}else{
%>
<a id="h" href="speakerlist.do?initial=h&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("h")){out.print("return false");}%>"  >&nbsp;H&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("i")){
%>
<b>&nbsp;I&nbsp;</b>
<%	
	}else{
%>
<a id="i" href="speakerlist.do?initial=i&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("i")){out.print("return false");}%>"  >&nbsp;I&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("j")){
%>
<b>&nbsp;J&nbsp;</b>
<%	
	}else{
%>
<a id="j" href="speakerlist.do?initial=j&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("j")){out.print("return false");}%>"  >&nbsp;J&nbsp;</a>
<%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("k")){
%>
<b>&nbsp;K&nbsp;</b>
<%	
	}else{
%>
<a id="k" href="speakerlist.do?initial=k&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("k")){out.print("return false");}%>"  >&nbsp;K&nbsp;</a><%	
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("l")){
%>
<b>&nbsp;L&nbsp;</b>
<%	
	}else{
%>
<a id="l" href="speakerlist.do?initial=l&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("l")){out.print("return false");}%>"  >&nbsp;L&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("m")){
%>
<b>&nbsp;M&nbsp;</b>
<%	
	}else{
%>
<a id="m" href="speakerlist.do?initial=m&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("m")){out.print("return false");}%>"  >&nbsp;M&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("n")){
%>
<b>&nbsp;N&nbsp;</b>
<%	
	}else{
%>
<a id="n" href="speakerlist.do?initial=n&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("n")){out.print("return false");}%>"  >&nbsp;N&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("o")){
%>
<b>&nbsp;O&nbsp;</b>
<%	
	}else{
%>
<a id="o" href="speakerlist.do?initial=o&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("o")){out.print("return false");}%>"  >&nbsp;O&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("p")){
%>
<b>&nbsp;P&nbsp;</b>
<%	
	}else{
%>
<a id="p" href="speakerlist.do?initial=p&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("p")){out.print("return false");}%>"  >&nbsp;P&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("q")){
%>
<b>&nbsp;Q&nbsp;</b>
<%	
	}else{
%>
<a id="q" href="speakerlist.do?initial=q&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("q")){out.print("return false");}%>"  >&nbsp;Q&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("r")){
%>
<b>&nbsp;R&nbsp;</b>
<%	
	}else{
%>
<a id="r" href="speakerlist.do?initial=r&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("r")){out.print("return false");}%>"  >&nbsp;R&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("s")){
%>
<b>&nbsp;S&nbsp;</b>
<%	
	}else{
%>
<a id="s" href="speakerlist.do?initial=s&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("s")){out.print("return false");}%>"  >&nbsp;S&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("t")){
%>
<b>&nbsp;T&nbsp;</b>
<%	
	}else{
%>
<a id="t" href="speakerlist.do?initial=t&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("t")){out.print("return false");}%>"  >&nbsp;T&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("u")){
%>
<b>&nbsp;U&nbsp;</b>
<%	
	}else{
%>
<a id="u" href="speakerlist.do?initial=u&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("u")){out.print("return false");}%>"  >&nbsp;U&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("v")){
%>
<b>&nbsp;V&nbsp;</b>
<%	
	}else{
%>
<a id="v" href="speakerlist.do?initial=v&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("v")){out.print("return false");}%>"  >&nbsp;V&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("w")){
%>
<b>&nbsp;W&nbsp;</b>
<%	
	}else{
%>
<a id="w" href="speakerlist.do?initial=w&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("w")){out.print("return false");}%>"  >&nbsp;W&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("x")){
%>
<b>&nbsp;X&nbsp;</b>
<%	
	}else{
%>
<a id="x" href="speakerlist.do?initial=x&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("x")){out.print("return false");}%>"  >&nbsp;X&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("y")){
%>
<b>&nbsp;Y&nbsp;</b>
<%	
	}else{
%>
<a id="y" href="speakerlist.do?initial=y&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("y")){out.print("return false");}%>"  >&nbsp;Y&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("z")){
%>
<b>&nbsp;Z&nbsp;</b>
<%	
	}else{
%>
<a id="z" href="speakerlist.do?initial=z&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("z")){out.print("return false");}%>"  >&nbsp;Z&nbsp;</a>
<%
	}
%>
</li>
<li>
<% 
	if(initial.equalsIgnoreCase("all")){
%>
<b>&nbsp;ALL&nbsp;</b>
<%	
	}else{
%>
<a id="all" href="speakerlist.do?initial=all&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" onclick="<% if(initial.equals("all")){out.print("return false");}%>"  >&nbsp;All&nbsp;</a>
<%
	}
%>
</li>
</ul>
</td>
<td valign="top" align="right" width="20%">
</td>
</tr>
</table>
<br/>
<!-- main display window -->
<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td width="60%" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
			Speaker List
		</td>
		<td width="40%"bgcolor="#efefef" style="font-size: 0.85em;" align="right">
		Showing<%=start+1 %>-<%if((start+pagesize) > recordcount){out.print(recordcount);}else{out.print(start+pagesize);}%> of <%=recordcount %><% if(!initial.equals("all")){ out.print(" initialed by "+initial.toUpperCase() );}else{ out.print(" of All");}%>
		</td>
	</tr>
	</table>
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
	<tr>
		<td>
			<ul id="speakerlist">
<%
	try{
	
    	rs = conn.getResultSet(sql);
    	//subscribed function
        while(rs.next()){
	        String speaker_id =rs.getString("speaker_id");
	        int subno = 0;
			if(ub != null){
				String subsql = "SELECT COUNT(*) _no FROM final_subscribe_speaker WHERE speaker_id=" + speaker_id + " AND user_id=" + ub.getUserID();
				ResultSet rsExt = conn.getResultSet(subsql);
					if(rsExt.next()){
						subno = rsExt.getInt("_no");
					}
			}
			//get paramenters	
    	    String picurl = rs.getString("picurl");
    		if(picurl == null){
    			picurl = "./images/speaker/avartar.gif";
    		}
%>
		<li>
			<table width="100%" style="table-layout:fixed;"><tr valign='top'>
				<td width = "10%" height = 100px>
				<a href="speakerprofile.do?speaker_id=<%=speaker_id %>"><img class="speakerImg" alt="avartar" src="<%=picurl%>" onload="javascript:DrawImage(this,80,80)" /></a>
				</td>
				<td width ="40%" height = 100px>
				<ul id="speakerattri">
				<li>
				Name:
					<a href="speakerprofile.do?speaker_id=<%=speaker_id %>" style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
						>
					<span style="font-size: 0.8em;"><%=rs.getString("name") %>
					</a>
<%
					if(ub != null){
%>
					<!-- whether to show the subscribe button or not -->
					<span class="spansubspid<%=speaker_id %>" id="spansubrspid<%=speaker_id %>" 
					style="display: <%=subno==0?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white; font-size: 0.8em;"
					onclick="window.location='speakerprofile.do?speaker_id=<%=speaker_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
					</span>&nbsp;
					<a class="asubspid<%=speaker_id %>" href="javascript:return false;" 
					style="text-decoration: none; font-size: 0.8em;"
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="subscribeSpeaker(<%=ub.getUserID() %>, <%=speaker_id %>, this, 'spansubrspid<%=speaker_id %>')"
					><%=subno>0?"Unsubscribe":"Subscribe" %></a>
					</span>
<%			
					}
%>
					</li>
					<li>Affiliation:<span style="font-size: 0.8em;"><%=rs.getString("affiliation")%></span></li>
					</a>
					</ul>
				</td>
<% 
			// do it again for the second column
			if(rs.next()){
				speaker_id =rs.getString("speaker_id");
				if(ub != null){
					String subsql = "SELECT COUNT(*) _no FROM final_subscribe_speaker WHERE speaker_id=" + speaker_id + " AND user_id=" + ub.getUserID();
					ResultSet rsExt = conn.getResultSet(subsql);
					if(rsExt.next()){
						subno = rsExt.getInt("_no");
					}
				}
		        picurl = rs.getString("picurl");
		    	if(picurl == null){ 
		    		picurl = "./images/speaker/avartar.gif";
		    	}
				%>
				<td width = "10%" height = 100px>
				<a href="speakerprofile.do?speaker_id=<%=speaker_id %>"><img class="speakerImg" alt="avartar" src="<%=picurl%>" onload="javascript:DrawImage(this,80,80)" /></a>
				</td>
				<td width = "40%" height = 100px>
				<ul id="speakerattri">
				<li>
				Name:
					<a href="speakerprofile.do?speaker_id=<%=speaker_id %>" style="text-decoration: none;"
						onmouseover="this.style.textDecoration='underline'" 
						onmouseout="this.style.textDecoration='none'"
						>
					<span style="font-size: 0.8em;"><%=rs.getString("name") %>
					</a>
<%
					if(ub != null){
%>
					<span class="spansubspid<%=speaker_id %>" id="spansubrspid<%=speaker_id %>" 
					style="display: <%=subno==0?"none":"inline" %>;cursor: pointer;background-color: blue;font-weight: bold;color: white; font-size: 0.8em;"
					onclick="window.location='speakerprofile.do?speaker_id=<%=speaker_id %>'"><%=subno>0?"&nbsp;Subscribed&nbsp;":"" %>
				</span>&nbsp;
					<a class="asubspid<%=speaker_id %>" href="javascript:return false;" 
					style="text-decoration: none; font-size: 0.8em;"
					onmouseover="this.style.textDecoration='underline'" 
					onmouseout="this.style.textDecoration='none'"
					onclick="subscribeSpeaker(<%=ub.getUserID() %>, <%=speaker_id %>, this, 'spansubrspid<%=speaker_id %>')"
					><%=subno>0?"Unsubscribe":"Subscribe" %></a>
					</span>
<%			
					}
%>
					</li>
					<li>Affiliation:<span style="font-size: 0.8em;"><%=rs.getString("affiliation")%></span></li>					
					</a>			
					</ul>
				</td>
				<% 

		    }else{
%>
				<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</li>
<%		    	
				break;
		    }
%>
				</tr>
			</table>
		</li>
<%
		}
		rs.close();
	}catch(Exception ex){
	    out.println(ex.toString());
	}finally{
	 if(rs!=null){
	     try{
	         rs.close();
	     }catch(SQLException ex){}
	 }
	}
%>
			</ul>
		</td>
	</tr>
<script type="text/javascript">
//use for paging buttons
$("#pageno").ready(function(){
	$("#pageno").keyup(function(e){
		if(e.keyCode == 13){
			//$("#next_a").focus();
			var p = $("#pageno").val();
			//alert(p);
			if(p><%=maxpage %>){
				p=<%=maxpage %>;
			}
			if(p<0){
				p=1;
			}
			if(p!=null){
				window.location.href="speakerlist.do?start=" + (p-1)*<%=pagesize %> + "&initial=<%=initial %>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" ;
			}
	}
	});
	var st =<%=start%>;
	var tt =<%=recordcount%> - 20;
	if(st == 0){
	$("#firstli").hide();
	$("#previousli").hide();
	}
	if(st >= tt){
	$("#lastli").hide();
	$("#nextli").hide();
	}
});
</script>
</table>

<!-- paging buttons -->
<ul id="paging" class="paging">
<li id="firstli"><a href="speakerlist.do?start=0&initial=<%=initial %>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" >First Page</a></li>
<li id="previousli"><a href="speakerlist.do?start=<%=start-pagesize %>&initial=<%=initial %>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" >Previous Page</a></li>
<li><input type="text" size="4" id="pageno" class="pageno" value="<%=(start/pagesize)+1%>"/><font color="white"> Out Of <%=maxpage %></font></li>
<li id="nextli"><a id="next_a" href="speakerlist.do?start=<%=start+pagesize %>&initial=<%=initial %>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" >Next Page</a></li>
<li id="lastli"><a href="speakerlist.do?start=<%=(recordcount/pagesize)*pagesize %>&initial=<%=initial %>&cfirst=<%=cfirst%>&csecond=<%=csecond%>&cthird=<%=cthird%>&cforth=<%=cforth%>&cfifth=<%=cfifth%>" >Last Page</a></li>
</ul>
</td>
	<td width="20%" align="left" valign="top">
	<br/>
	<table width="95%" align="right" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td colspan="2" bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
	</tr>
	<tr>
		<td colspan="2" width="60%" bgcolor="#efefef" style="font-size: 0.85em;font-weight: bold;">
			Show Speakers By
		</td>
	</tr>
	<!-- side bar -->
	<tr>
	<td style="font-size: 0.85em;">
	<br/>
	<input  type="checkbox"id="upcoming" name="first" onclick="checkbox(this)" <% if(cfirst.equalsIgnoreCase("checked")){out.print("checked");}%> />Upcoming Talks<p/>
	<input type="checkbox" id="popular" name="second" onclick="checkbox(this)" <% if(csecond.equalsIgnoreCase("checked")){out.print("checked");}%> />Popular Talks<p/>
	<logic:present name="UserSession">
	<input type="checkbox" id="subs" name="third" onclick="checkbox(this)" <% if(cthird.equalsIgnoreCase("checked")){out.print("checked");}%> />Your Subscribe<p/>
	<input type="checkbox" id="seriessubs" name="forth" onclick="checkbox(this)" <% if(cforth.equalsIgnoreCase("checked")){out.print("checked");}%> />Your Series Subscribe<p/>
	<input type="checkbox" id="groupssubs" name="fifth" onclick="checkbox(this)" <% if(cfifth.equalsIgnoreCase("checked")){out.print("checked");}%> />Your Groups Subscribe<p/>
	</logic:present>
	Search Name:<input style="font-size: 1em;" id="nameInput" name="nameInput"  size="25" value=""/><p/>
	</td>
	</tr>
</table>
</td>
</tr>
</table>