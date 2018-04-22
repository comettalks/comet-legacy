<%@page import="java.sql.SQLException"%><%@page import="edu.pitt.sis.beans.UserBean"%><%@page import="java.sql.PreparedStatement"%><%@page import="edu.pitt.sis.StringEncrypter.EncryptionException"%><%@page import="edu.pitt.sis.BasicFunctions"%><%@page import="edu.pitt.sis.StringEncrypter"%><%@ page language="java"%><%@page import="edu.pitt.sis.db.connectDB"%><%@page import="java.sql.ResultSet"%><% 
	session=request.getSession(false);
	response.setContentType("application/xml");
	out.print("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
	out.print("<signup>");

	if(request.getParameter("name") == null){
		out.print("<status>ERROR: Screen Name Required</status>");
	}else if(request.getParameter("name").trim().length()==0){
		out.print("<status>ERROR: Screen Name Cannot Be Blank</status>");
	}else if(request.getParameter("userEmail")==null){
		out.print("<status>ERROR: Email Required</status>");
	}else if(request.getParameter("userEmail").trim().length()==0){
		out.print("<status>ERROR: Email Cannot Be Blank</status>");
	}else if(request.getParameter("password")==null){
		out.print("<status>ERROR: Password Input Required</status>");
	}else if(request.getParameter("password").trim().length()==0){
		out.print("<status>ERROR: Password Input Cannot Be Blank</status>");
	}else if(!request.getParameter("password").equals(request.getParameter("repassword"))){
		out.print("<status>ERROR: Password Not Match with Repassword</status>");
	}else{
		connectDB conn = new connectDB();

		String name = request.getParameter("name");
		String userEmail = request.getParameter("userEmail");
		String password = request.getParameter("password");
		
		String encryptionScheme = StringEncrypter.DESEDE_ENCRYPTION_SCHEME;		
		StringEncrypter encrypter;
		String EncryptedPassword = "";
		try {
			encrypter = new StringEncrypter(encryptionScheme, BasicFunctions.encKey);
			EncryptedPassword = encrypter.encrypt(password);
		} catch (StringEncrypter.EncryptionException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
			out.print("<status>ERROR: Encryption Failed</status>");
		}

		String sql = "call sp_insertUser(?,?,?) ";
		
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, userEmail);
			pstmt.setString(3, EncryptedPassword);

			pstmt.execute();
			pstmt.close();
			
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				int uid = rs.getInt(1);
				
				/*if(sf.getAffiliate_id() != null){
					sql = "DELETE FROM affiliate_user WHERE user_id = " + uid;
					conn.executeUpdate(sql);
					
					sql = "INSERT INTO affiliate_user (affiliate_id,user_id) VALUES ";
					String[] aid = sf.getAffiliate_id();
					for(int i=0;i<aid.length;i++){
						if(i!=0){
							sql += ",";
						}
						sql += "("+ aid[i] + ","+ uid + ")";
					}
					conn.executeUpdate(sql);
				}*/
				
				UserBean ub = new UserBean();
				sql = "call sp_retrieveUserInfo(?)";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setInt(1, uid);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs.next()){
					ub.setName(rs.getString("name"));
					ub.setRoleID(rs.getInt("role_id"));
					ub.setUserID(uid);
					out.println("<status>OK");
					out.println(uid);
					out.print(name);
					out.print("</status>");
				}
				
				session.setAttribute("UserSession", ub);
				
				//Call rpx map api
				/*if(session.getAttribute("rpx") != null){
					Rpx rpx = (Rpx)session.getAttribute("rpx");
					Map<String,String> openIdMap = (HashMap<String,String>)session.getAttribute("openIdMap");
					if(openIdMap != null){
						String identifier = openIdMap.get("identifier");
						rpx.map(identifier, String.valueOf(uid));
					}
				}*/
			}
			
			rs.close();
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
			out.print("<status>ERROR: Signup Failed</status>");
		}
	}
	out.print("</signup>");
%>