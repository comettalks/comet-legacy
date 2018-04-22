<%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java" pageEncoding="UTF-8"%><%@ page import="java.sql.*" %><%@ page import="edu.pitt.sis.db.*" %><%@page import="edu.pitt.sis.beans.UserBean"%><% 
	session=request.getSession(false);
	ResultSet rs = null;
	int userID = -1;
	String userEmail = request.getParameter("userEmail");
	String password = request.getParameter("password");
	
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<authentication>");
	if(userEmail == null){
		out.println("ERROR");
		out.print("Email cannot be blank.");
	}else if(userEmail.trim().length()==0){
		out.println("ERROR");
		out.print("Email cannot be blank.");
	}else if(password == null){
		out.println("ERROR");
		out.print("Password cannot be blank.");
	}else if(password.trim().length()==0){
		out.println("ERROR");
		out.print("Password cannot be blank.");
	}else{
		
		String encryptionScheme = StringEncrypter.DESEDE_ENCRYPTION_SCHEME;		
		StringEncrypter encrypter;
		String EncryptedPassword = "";
		try {
			encrypter = new StringEncrypter(encryptionScheme, BasicFunctions.encKey);
			EncryptedPassword = encrypter.encrypt(password);
		} catch (StringEncrypter.EncryptionException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
			out.println("ERROR");
			out.print("Authentication error. Please try again.");
		}

		connectDB conn = new connectDB();
		UserBean ub = new UserBean();

		String sql = "SELECT user_id FROM userinfo WHERE email = ? AND pass = ? ";
		
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1, userEmail.trim().toLowerCase());
			pstmt.setString(2, EncryptedPassword);
			rs = pstmt.executeQuery();
			if(rs.next()){
				userID = rs.getInt("user_id");
			}
			
			if(userID > 0 ){
				rs = null;
				pstmt.close();
				
				sql = "SELECT name,role_id FROM userinfo WHERE user_id = ?";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setInt(1, userID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs.next()){
					ub.setName(rs.getString("name"));
					ub.setRoleID(rs.getInt("role_id"));
					ub.setUserID(userID);
					
					out.println("OK");
					out.println(userID);
					out.print(ub.getName());
				}
		
			}
			
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
			out.println("ERROR");
			out.print("Authentication error. Please try again.");
		}
		if(userID<0){
			out.println("ERROR");
			out.print("Your email or password is not correct!");
		}else{
			session.setAttribute("UserSession", ub);
			
			/*
			 *  Mapping local primary key back to rpx server
			 * */
			/*
			if(session.getAttribute("rpx") != null){
				Rpx rpx = (Rpx)session.getAttribute("rpx");
				Map<String,String> openIdMap = (HashMap<String,String>)session.getAttribute("openIdMap");
				if(openIdMap != null){
					String identifier = openIdMap.get("identifier");
					rpx.map(identifier, String.valueOf(userID));
				}
				
			}*/
		}
	}	
	out.print("</authentication>");
%>