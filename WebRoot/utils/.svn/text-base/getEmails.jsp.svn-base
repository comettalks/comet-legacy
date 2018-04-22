<%@page import="java.util.LinkedHashMap"%><%@page import="java.util.Iterator"%><%@page import="java.util.Collections"%><%@page import="java.util.ArrayList"%><%@page import="java.util.List"%><%@page import="java.util.TreeMap"%><%@page import="java.util.Map"%><%@page import="java.util.Comparator"%><%@page import="java.util.HashMap"%><%@page import="java.io.IOException"%><%@page import="java.net.MalformedURLException"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	String user_id = request.getParameter("user_id");
	String col_id = request.getParameter("col_id");
	String outputMode = "xml";//request.getParameter("outputMode");
	
	if(request.getParameter("outputMode") !=null){
		outputMode = request.getParameter("outputMode");
	}
	
	if(outputMode.equalsIgnoreCase("json")){
		response.setContentType("application/json");
		out.print("{");
	}else{
		response.setContentType("application/xml");
		out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
		out.print("<getEmails>");
	}
	
	if(user_id == null && col_id == null){
		if(outputMode.equalsIgnoreCase("json")){
			out.print("\"status\": \"ERROR\",");
			out.print("\"message\": \"col_id and/or user_id are required.\"}");
		}else{
			out.print("<status>ERROR</status>");
			out.print("<message>col_id and/or user_id are required.</message>");
		}
	}else{
		
		connectDB conn = new connectDB();

		//Popular emails
		String sql = "SELECT SQL_CACHE emails FROM emailfriends WHERE LENGTH(TRIM(emails))>0";
		if(user_id!=null){
			sql += " AND user_id=" + user_id;
		}
		if(col_id!=null){
			sql += " AND col_id=" + col_id;
		}
		sql += " GROUP BY emails";
		try{
			if(outputMode.equalsIgnoreCase("json")){
				out.print("\"status\": \"OK\"");
			}else{
				out.print("<status>OK</status>");
			}

			rs = conn.getResultSet(sql);
			HashMap<String,Integer> mapEmail = new HashMap<String,Integer>();			
			while(rs.next()){
				String emails = rs.getString("emails");
				String[] email = emails.split(",");
				if(email != null){
					for(int i=0;i<email.length;i++){
						String aEmail = email[i].trim().toLowerCase();
						if(mapEmail.containsKey(aEmail)){
							int no = mapEmail.get(aEmail);
							no++;
							mapEmail.put(aEmail,no);
						}else{
							mapEmail.put(aEmail,1);
						}
					}
				}
			}
			if(outputMode.equalsIgnoreCase("json")){
				out.print(",\"pop_emails\": [");
			}else{
				out.print("<pop_emails>");
			}
			/*****************************
			 * Sort out the score
			 *****************************/
			List<String> mapKeys = new ArrayList<String>(mapEmail.keySet());
			List<Integer> mapValues = new ArrayList<Integer>(mapEmail.values());
			Collections.sort(mapKeys);
			Collections.sort(mapValues);
			Collections.reverse(mapValues);
			ArrayList<String> popEmailList = new ArrayList<String>();
			for(Iterator<Integer> valueIt = mapValues.iterator();valueIt.hasNext();){
				Integer weight = valueIt.next();
				
				for(Iterator<String> keyIt = mapKeys.iterator();keyIt.hasNext();){
					String key = keyIt.next();
					if(mapEmail.get(key) == weight && weight > 0){
						/**************************************************************
						 * Only top ten highest scores we would provide recommendations
						 **************************************************************/
						//if(row == 10)break;
						popEmailList.add(key);
						//row++;
						//System.out.println("Prediction score of paperID:" + key + "\tOverall Score:\t" + weight);
						mapEmail.remove(key);
						mapKeys.remove(key);
						break;
					}
				}
			}
			int emailno=0;
			for (String email : popEmailList) {
	            if(emailno < 10){
					if(outputMode.equalsIgnoreCase("json")){
						if(emailno!=0){
							out.print(",");
						}
						out.print("{\"email\":\"" + email.replaceAll("\"","\\\"") + "\"}");
					}else{
						out.print("<email><![CDATA[" + email + "]]></email>");
					}
					emailno++;
	            }else{
	            	break;
	            }
	        }
			
			if(outputMode.equalsIgnoreCase("json")){
				out.print("]");
			}else{
				out.print("</pop_emails>");
			}
			
			//Latest emails
			sql = "SELECT SQL_CACHE emails FROM emailfriends WHERE LENGTH(TRIM(emails))>0";
			if(user_id!=null){
				sql += " AND user_id=" + user_id;
			}
			if(col_id!=null){
				sql += " AND col_id=" + col_id;
			}
			sql += " GROUP BY emails ORDER BY timesent DESC";
			rs = conn.getResultSet(sql);
			if(outputMode.equalsIgnoreCase("json")){
				out.print(",\"latest_emails\": [");
			}else{
				out.print("<lastest_emails>");
			}
			emailno = 0;
			mapEmail.clear();
			while(rs.next()){
				String emails = rs.getString("emails");
				String[] email = emails.split(",");
				if(email != null){
					for(int i=0;i<email.length;i++){
						String aEmail = email[i].trim().toLowerCase();
						if(mapEmail.containsKey(aEmail)){
							int no = mapEmail.get(aEmail);
							no++;
							mapEmail.put(aEmail,no);
						}else{
				            if(emailno < 10){
								if(outputMode.equalsIgnoreCase("json")){
									if(emailno!=0){
										out.print(",");
									}
									out.print("{\"email\":\"" + aEmail.replaceAll("\"","\\\"") + "\"}");
								}else{
									out.print("<email><![CDATA[" + aEmail + "]]></email>");
								}
				            }else{
				            	break;
				            }
							mapEmail.put(aEmail,1);
							emailno++;
						}
					}
				}
			}
			if(outputMode.equalsIgnoreCase("json")){
				out.print("]");
			}else{
				out.print("</latest_emails>");
			}
			
			rs = null;
			conn.conn.close();
			conn = null;
		}catch(SQLException e){
			try {
				if (conn.conn !=null) conn.conn.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}	
	if(outputMode.equalsIgnoreCase("json")){
		out.print("}");
	}else{
		out.print("</getEmails>");
	}

%>