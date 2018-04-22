<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>


<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%><script type="text/javascript">
	function chgFrmYear(){
	    document.searchFrom.toYear.value = document.searchFrom.frmYear.value;
	}
	
	function chgFrmMonth(){
	    document.searchFrom.toMonth.value = document.searchFrom.frmMonth.value;
	}
	
	function chgFrmDay(){
	    document.searchFrom.toDay.value = document.searchFrom.frmDay.value;
	}
	function searchProc(){
	    if(document.searchFrom.title.value == "" && document.searchFrom.detail.value == "" && document.searchFrom.speaker.value == 0){
	        alert("Please Enter Your Search Condition");
	    }else if((document.searchFrom.frmMonth.value == 0 && document.searchFrom.frmDay.value !=0) || (document.searchFrom.toMonth.value == 0 && document.searchFrom.toDay.value !=0)){
	        alert("Please specify month");
	    }else if((document.searchFrom.frmYear.value == 0 && document.searchFrom.frmMonth.value != 0 && document.searchFrom.frmDay.value !=0) || (document.searchFrom.toYear.value == 0 && document.searchFrom.toMonth.value != 0 && document.searchFrom.toDay.value !=0)){
	        alert("Please specify year");
	    }else if((document.searchFrom.frmYear.value == 0 && document.searchFrom.frmMonth.value != 0 && document.searchFrom.frmDay.value ==0) || (document.searchFrom.toYear.value == 0 && document.searchFrom.toMonth.value != 0 && document.searchFrom.toDay.value ==0)){
	        alert("Please specify year and day");
	    }else{
	        document.searchFrom.action = "advancedSearchResult.do";
	        document.searchFrom.submit();
	    }
	}

</script>

<table width="100%" align="center">
	<tr>
		<td width="96%" colspan="2" height="55" valign="middle" align="center"><font size="4"><b>Advanced Search</b></font></td>
	</tr>
	<tr>
		<td width="96%" colspan="2" align="center">
			<form name="searchFrom">
				<table width="96%">
					<tr>
						<td width="27%" align="right" >
							<b>Title: &nbsp;</b>
						</td>
						<td>
							<input type="text" name="title" size="70"></input>
						</td>
					</tr>
					<tr>
						<td width="27%" align="right" >
							<b>Detail: &nbsp;</b>
						</td>
						<td>
							<input type="text" name="detail" size="70"></input>
						</td>
					</tr>
					<tr>
						<td width="27%" align="right" >
							<b>Speaker: &nbsp;</b>
						</td>
						<td>
							<input type="text" name="speaker" size="70"></input>
						</td>
					</tr>
					<tr>
						<td width="27%" align="right" >
							<b>Time: &nbsp;</b>
						</td>
						<td valign="middle">
							<b>From </b>
							<select name="frmYear" size="1" onchange="javascript:chgFrmYear()">
								<option value="">- Year -</option>
<% 
	Calendar calendar = new GregorianCalendar();
	int day = calendar.get(Calendar.DAY_OF_MONTH);
	int month = calendar.get(Calendar.MONTH);
	int year = calendar.get(Calendar.YEAR);
%>								
								<option value="<%=year-4 %>"><%=year-4 %></option>
								<option value="<%=year-3 %>"><%=year-3 %></option>
								<option value="<%=year-2 %>"><%=year-2 %></option>
								<option value="<%=year-1 %>"><%=year-1 %></option>
								<option value="<%=year %>"><%=year %></option>
								<option value="<%=year+1 %>"><%=year+1 %></option>
							</select>
							<select name="frmMonth" size="1" onchange="javascript:chgFrmMonth()">
								<option value="">- Month -</option>
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
								<option value="04">April</option>
								<option value="05">May</option>
								<option value="06">June</option>
								<option value="07">July</option>
								<option value="08">August</option>
								<option value="09">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select>
							<select name="frmDay" size="1" onchange="javascript:chgFrmDay()">
								<option value="">- Day -</option>

										<option value="1">1</option>

										<option value="2">2</option>

										<option value="3">3</option>

										<option value="4">4</option>

										<option value="5">5</option>

										<option value="6">6</option>

										<option value="7">7</option>

										<option value="8">8</option>

										<option value="9">9</option>

										<option value="10">10</option>

										<option value="11">11</option>

										<option value="12">12</option>

										<option value="13">13</option>

										<option value="14">14</option>

										<option value="15">15</option>

										<option value="16">16</option>

										<option value="17">17</option>

										<option value="18">18</option>

										<option value="19">19</option>

										<option value="20">20</option>

										<option value="21">21</option>

										<option value="22">22</option>

										<option value="23">23</option>

										<option value="24">24</option>

										<option value="25">25</option>

										<option value="26">26</option>

										<option value="27">27</option>

										<option value="28">28</option>

										<option value="29">29</option>

										<option value="30">30</option>

										<option value="31">31</option>

							</select>
					 		<b> ~ To </b>
					 		<select name="toYear" size="1">
								<option value="">- Year -</option>
								<option value="<%=year-4 %>"><%=year-4 %></option>
								<option value="<%=year-3 %>"><%=year-3 %></option>
								<option value="<%=year-2 %>"><%=year-2 %></option>
								<option value="<%=year-1 %>"><%=year-1 %></option>
								<option value="<%=year %>"><%=year %></option>
								<option value="<%=year+1 %>"><%=year+1 %></option>
							</select>
							<select name="toMonth" size="1">
								<option value="">- Month -</option>
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
								<option value="04">April</option>
								<option value="05">May</option>
								<option value="06">June</option>
								<option value="07">July</option>
								<option value="08">August</option>
								<option value="09">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select>
							<select name="toDay" size="1">
								<option value="">- Day -</option>

										<option value="1">1</option>

										<option value="2">2</option>

										<option value="3">3</option>

										<option value="4">4</option>

										<option value="5">5</option>

										<option value="6">6</option>

										<option value="7">7</option>

										<option value="8">8</option>

										<option value="9">9</option>

										<option value="10">10</option>

										<option value="11">11</option>

										<option value="12">12</option>

										<option value="13">13</option>

										<option value="14">14</option>

										<option value="15">15</option>

										<option value="16">16</option>

										<option value="17">17</option>

										<option value="18">18</option>

										<option value="19">19</option>

										<option value="20">20</option>

										<option value="21">21</option>

										<option value="22">22</option>

										<option value="23">23</option>

										<option value="24">24</option>

										<option value="25">25</option>

										<option value="26">26</option>

										<option value="27">27</option>

										<option value="28">28</option>

										<option value="29">29</option>

										<option value="30">30</option>

										<option value="31">31</option>

							</select>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<input class="btn" type="button" value="Search" onclick="searchProc()">
							<input class="btn" type="reset" value="Reset">
						</td>
					</tr>
				</table>
				<input name="sortBy" value="1" type="hidden" />
			</form>
		</td>
	</tr>
	
</table>