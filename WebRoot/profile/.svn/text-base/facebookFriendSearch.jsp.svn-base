<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="edu.pitt.sis.db.connectDB"%>
<%@page import="edu.pitt.sis.ExternalProfile"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>
<%@page import="edu.pitt.sis.beans.UserBean"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Hashtable"%>



<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<% 
		Hashtable<String,Integer> facebookFriendsName = (Hashtable<String,Integer>)session.getAttribute("facebookFriendsName");
		Hashtable<String,Integer> facebookUsersName = (Hashtable<String,Integer>)session.getAttribute("facebookUsersName");
		
	
		String item;
		String fullname="";
		String output = "[";
		String query = request.getParameter("term");
		String temp="";
		for(Iterator<String> it = facebookFriendsName.keySet().iterator();it.hasNext();)
		{
			item = (String)it.next();
			temp = item.toLowerCase();
		
				if(temp.contains(query.toLowerCase()))
					output += "\""+item + "\","; 
		}
		
		for(Iterator<String> it = facebookUsersName.keySet().iterator();it.hasNext();)
		{
			item = (String)it.next();
			temp = item.toLowerCase();
		
				if(temp.contains(query.toLowerCase()))
					output += "\""+item + "\","; 
		}
		
		
		
		output = output.substring(0,output.length()-1)+"]";
	//	System.out.println(output);
		out.print(output);
%>