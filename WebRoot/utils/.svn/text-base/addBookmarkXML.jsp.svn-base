<%@page import="java.io.IOException"%><%@page import="java.net.MalformedURLException"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.URLConnection"%><%@page import="java.net.URL"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	String user_id = request.getParameter("user_id");
	String col_id = request.getParameter("col_id");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<addbookmark>");
	if(user_id == null){
		out.print("<status>ERROR: user_id required</status>");
	}else if(user_id.trim().length()==0){
		out.print("<status>ERROR: user_id cannot be blank</status>");
	}else if(col_id == null){
		out.print("<status>ERROR: col_id required</status>");
	}else if(col_id.trim().length()==0){
		out.print("<status>ERROR: col_id cannot be blank</status>");
	}else{
		
		connectDB conn = new connectDB();

		String sql = "SELECT u.userprofile_id FROM userprofile u,userinfo uu " + 
		"WHERE u.user_id = uu.user_id AND u.user_id = ? AND u.col_id = ?";
		
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1, Long.parseLong(user_id));
			pstmt.setLong(2, Long.parseLong(col_id));
			rs = pstmt.executeQuery();
			long userprofile_id = -1;
			//pstmt.execute();
			//rs = pstmt.getResultSet();
			if(rs.next()){
				userprofile_id = rs.getLong("userprofile_id");
				
				/**sql = "UPDATE userprofile SET lastupdate = NOW()," +
						"comment = ?,usertags = ? WHERE userprofile_id = ?";
				rs.close();
				pstmt.close();
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, abcf.getNote());
				pstmt.setString(2, abcf.getTags());
				//pstmt.setString(3, abcf.getEmail());
				pstmt.setLong(3, userprofile_id);
				pstmt.executeUpdate();
				
				pstmt.close();
				
				sql = "DELETE FROM contribute WHERE userprofile_id = " + userprofile_id;
				conn.executeUpdate(sql);
				
				sql = "DELETE FROM tags WHERE userprofile_id = " + userprofile_id;
				conn.executeUpdate(sql);*/
			}else{
				rs.close();
				sql = "INSERT INTO userprofile " +
						"(user_id,col_id,lastupdate,comment,usertags) " +
						"VALUES (?,?,NOW(),'','');";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setLong(1, Long.parseLong(user_id));
				pstmt.setLong(2, Long.parseLong(col_id));
				pstmt.executeUpdate();
			
				pstmt.close();
				
				sql = "SELECT LAST_INSERT_ID()";
				rs = conn.getResultSet(sql);
				if(rs.next()){
					userprofile_id = rs.getLong(1);
				}

			}
			out.print("<status>OK</status>");
			
			//Call recTalk
			/*try {
				//System.out.println(url_to_get);
				URL url = new URL("http://localhost:8080/recTalk/userprofile.jsp?user_id=" + user_id);
				//make connection
				URLConnection urlc = url.openConnection();
		        // Some web servers requires these properties 
		        urlc.setRequestProperty("User-Agent", 
		                "Profile/MIDP-1.0 Configuration/CLDC-1.0");
		        urlc.setRequestProperty("Content-Length", "0");
		        urlc.setRequestProperty("Connection", "close");
		        //urlc.connect();
		
				//get result
				BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
		
				br.close();
			} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}*/
			
			rs = null;
			pstmt.close();
			conn.conn.close();
			conn = null;
		}catch(SQLException e){
			try {
				if (pstmt != null) pstmt.close();			
				if (conn.conn !=null) conn.conn.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}	
	out.print("</addbookmark>");
%>