<%@page import="edu.pitt.sis.PostColloquium"%><%@page import="java.text.ParseException"%><%@page import="java.util.Date"%><%@page import="java.text.SimpleDateFormat"%><%@page import="org.apache.struts.action.ActionMapping"%><%@page import="edu.pitt.sis.action.AddColloquiumAction"%><%@page import="edu.pitt.sis.form.ColloquiumForm"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	int userID = -1;
	String title = request.getParameter("title");
	String[] speaker = request.getParameterValues("speaker");
	String[] affiliation = request.getParameterValues("affiliation");
	String[] picURL = request.getParameterValues("picURL");
	String talkDate = request.getParameter("talkDate");
	String beginTime = request.getParameter("beginTime");
	String endTime = request.getParameter("endTime");
	String location = request.getParameter("location");
	String detail = request.getParameter("detail");
	String host = request.getParameter("host");
	String[] series_id = request.getParameterValues("series_id");
	String url = request.getParameter("url");
	String[] sponsor_id = request.getParameterValues("sponsor_id");
	String video_url = request.getParameter("video_url");
	String slide_url = request.getParameter("slide_url");
	String paper_url = request.getParameter("paper_url");
	String[] area_id = request.getParameterValues("area_id");

	response.setContentType("application/xml");
	out.println("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.println("<postNewTalk>");
	if(title == null){
		out.print("<error>");
		out.print("title cannot be blank.");
		out.println("</error>");
	}else if(speaker == null){
		out.print("<error>");
		out.print("speaker cannot be blank.");
		out.println("</error>");
	}else if(affiliation == null){
		out.print("<error>");
		out.print("affiliation cannot be blank.");
		out.println("</error>");
	}else if(talkDate == null){
		out.print("<error>");
		out.print("talkDate cannot be blank.");
		out.println("</error>");
	}else if(beginTime == null){
		out.print("<error>");
		out.print("beginTime cannot be blank.");
		out.println("</error>");
	}else if(endTime == null){
		out.print("<error>");
		out.print("endTime cannot be blank.");
		out.println("</error>");
	}else if(location == null){
		out.print("<error>");
		out.print("location cannot be blank.");
		out.println("</error>");
	}else if(detail == null){
		out.print("<error>");
		out.print("detail cannot be blank.");
		out.println("</error>");
	}else{
		ColloquiumForm cqf = new ColloquiumForm();
		ActionMapping mapping = new ActionMapping();

		cqf.setTitle(title);

		if(speaker != null){
			String raw_speaker = "";
			for(int i=0;i<speaker.length;i++){
				raw_speaker += speaker[i] + ";;";
			}
			cqf.setSpeaker(raw_speaker);
		}

		if(affiliation != null){
			String raw_affiliation = "";
			for(int i=0;i<affiliation.length;i++){
				raw_affiliation += affiliation[i] + ";;";
			}
			cqf.setAffiliation(raw_affiliation);
		}

		if(picURL == null){
			String raw_picURL = "";
			for(int i=0;i<speaker.length;i++){
				raw_picURL += "images/speaker/avartar.gif;;";
			}
			cqf.setPicURL(raw_picURL);
		}else{
			String raw_picURL = "";
			for(int i=0;i<picURL.length;i++){
				if(picURL[i].equalsIgnoreCase("null")){
					raw_picURL += "images/speaker/avartar.gif;;";
				}else{
					raw_picURL += picURL[i] + ";;";
				}
			}
			cqf.setPicURL(raw_picURL);
		}
		
		SimpleDateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy");
		try{
			Date tDate = dateFormatter.parse(talkDate);
			cqf.setTalkDate(talkDate);
		} catch (ParseException e1) {
			out.print("<error>");
			out.print("talkDate needs to be in the \"MM/dd/yyyy\" format. Ex: 12/31/2012");
			out.println("</error>");
			out.println("</postNewTalk>");
			return;
		}
		
		SimpleDateFormat timeFormatter = new SimpleDateFormat("h:m a");
		try{
			beginTime = beginTime.trim();
			Date bTime = timeFormatter.parse(beginTime);
			cqf.setBeginHour(beginTime.substring(0,beginTime.indexOf(":")));
			cqf.setBeginMin(beginTime.substring(beginTime.indexOf(":")+1,beginTime.indexOf(" ")));
			cqf.setBeginAMPM(beginTime.substring(beginTime.indexOf(" ")+1).trim());
		} catch (ParseException e1) {
			out.print("<error>");
			out.print("beginTime needs to be in the \"h:m a\" format. Ex: 10:00 AM");
			out.println("</error>");
			out.println("</postNewTalk>");
			return;
		}

		try{
			endTime = endTime.trim();
			Date eTime = timeFormatter.parse(endTime);
			cqf.setEndHour(endTime.substring(0,endTime.indexOf(":")));
			cqf.setEndMin(endTime.substring(endTime.indexOf(":")+1,endTime.indexOf(" ")));
			cqf.setEndAMPM(endTime.substring(endTime.indexOf(" ")+1).trim());
		} catch (ParseException e1) {
			out.print("<error>");
			out.print("endTime needs to be in the \"h:m a\" format. Ex: 10:00 AM");
			out.println("</error>");
			out.println("</postNewTalk>");
			return;
		}

		cqf.setLocation(location);
		cqf.setDetail(detail);
		cqf.setHost(host);
		
		if(series_id != null){
			String raw_series = "";
			for(int i=0;i<series_id.length;i++){
				raw_series += series_id[i] + ";;";
			}
			String str[] = new String[1];
			str[0] = raw_series;
			cqf.setSeries_id(str);
		}else{
			String str[] = new String[1];
			str[0] = "";
			cqf.setSeries_id(str);
		}
		
		cqf.setUrl(url);

		if(sponsor_id != null){
			String raw_sponsor = "";
			for(int i=0;i<sponsor_id.length;i++){
				raw_sponsor += sponsor_id[i] + ";;";
			}
			cqf.setSponsor_id(raw_sponsor);
		}

		cqf.setVideo_url(video_url);
		cqf.setSlide_url(slide_url);
		cqf.setPaper_url(paper_url);
		cqf.setArea_id(area_id);
		
		PostColloquium pc = new PostColloquium();
		try{
			pc.Post(mapping,cqf,request,response);
		}catch(Exception e){
			
		}
		
		if(session.getAttribute("Colloquium") != null){
			out.println("<status>SUCCESS</status>");
			//out.println("<talk_url>http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=" + 
			//		((ColloquiumForm)session.getAttribute("Colloquium")).getCol_id() + "</talk_url>");
		}else{
			out.println("<status>ERROR</status>");
			out.println("<message>Posting new talk Error. Please try again in the next 5 minutes.</message>");
		}
	}	
	out.println("</postNewTalk>");

%>