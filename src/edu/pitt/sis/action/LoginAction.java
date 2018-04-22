package edu.pitt.sis.action;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;


import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;
import edu.pitt.sis.form.LoginForm;

import edu.pitt.sis.*;
import edu.pitt.sis.StringEncrypter.EncryptionException;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 */
public class LoginAction extends Action {

	// --------------------------------------------------------- Instance Variables

	// --------------------------------------------------------- Methods

	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 */
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		if(session.getAttribute("UserSession")!=null){return mapping.findForward("Success");}
		if (this.isCancelled(request)){ return(mapping.findForward("Failure"));}
		
		ResultSet rs = null;
		long userID = -1;
		UserBean ub = new UserBean();
		LoginForm lf = (LoginForm) form;

		connectDB conn = new connectDB();
		
		String encryptionScheme = StringEncrypter.DESEDE_ENCRYPTION_SCHEME;		
		StringEncrypter encrypter;
		String EncryptedPassword = "";
		try {
			encrypter = new StringEncrypter(encryptionScheme, BasicFunctions.encKey);
			EncryptedPassword = encrypter.encrypt(lf.getPassword());
		} catch (EncryptionException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		String sql = "call sp_authenticateUser(?,?) ";
		
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1, lf.getUserEmail());
			pstmt.setString(2, EncryptedPassword);
			pstmt.execute();
			rs = pstmt.getResultSet();
			if(rs.next()){
				userID = rs.getInt("user_id");
			}
			
			if(userID > 0 ){
				rs = null;
				pstmt.close();
				
				sql = "call sp_retrieveUserInfo(?)";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setLong(1, userID);
				pstmt.execute();
				rs = pstmt.getResultSet();
				if(rs.next()){
					ub.setName(rs.getString("name"));
					ub.setRoleID(rs.getInt("role_id"));
					ub.setWritable(rs.getBoolean("writable"));
					ub.setUserID(userID);
				}
				rs.close();
				
				if(session.getAttribute("fAutoID")!=null){
					String fAutoID = (String) session.getAttribute("fAutoID");
					session.removeAttribute("fAutoID");
					
					sql = "INSERT INTO extmapping (user_id,ext_id,exttable,mappedtime) VALUES (?,?,?,NOW())";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setLong(1, userID);
					pstmt.setLong(2, Long.parseLong(fAutoID));
					pstmt.setString(3, "extprofile.facebook");
					pstmt.executeUpdate();
					pstmt.close();
				}
				

			}else{
				//Not found a user in the system
				;
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
			System.out.println(e.getMessage().toString());
			LoginErrorBean leb = new LoginErrorBean();
			leb.setErrorDescription("System failure! Please try next time.");
			session.setAttribute("LoginError",leb);
			return mapping.findForward("Failure");
		}
		if(userID<0){
			LoginErrorBean leb = new LoginErrorBean();
			leb.setErrorDescription("Your email or password is not correct!");
			session.setAttribute("LoginError",leb);
			return mapping.findForward("Failure");
		}else{
			Cookie cid = new Cookie("comet_user_id", "" + ub.getUserID());
	        cid.setMaxAge(365*24*60*60);
	        cid.setPath("/");
	        response.addCookie(cid);
			
			Cookie cname = new Cookie("comet_user_name", ub.getName());
	        cname.setMaxAge(365*24*60*60);
	        cname.setPath("/");
	        response.addCookie(cname);
	
			Cookie cwrite = new Cookie("comet_user_write", ub.isWritable()==true?"1":"0");
	        cname.setMaxAge(365*24*60*60);
	        cname.setPath("/");
	        response.addCookie(cwrite);

	        session.removeAttribute("logout");
	        
	        session.setAttribute("UserSession", ub);
			if(session.getAttribute("HideBar")!=null){
				session.removeAttribute("HideBar");
			}

			if(session.getAttribute("before-login-redirect") != null&&session.getAttribute("redirect") == null){
				session.setAttribute("redirect",session.getAttribute("before-login-redirect"));
				session.removeAttribute("before-login-redirect");
			}

			if(session.getAttribute("redirect") == null){
				session.setAttribute("menu","home");
			}
			
			/*if(session.getAttribute("RegisterSuccess") != null){
				session.removeAttribute("RegisterSuccess");
			}*/
			
			/*
			 *  Mapping local primary key back to rpx server
			 * */
			/*if(session.getAttribute("rpx") != null){
				Rpx rpx = (Rpx)session.getAttribute("rpx");
				Map<String,String> openIdMap = (HashMap<String,String>)session.getAttribute("openIdMap");
				if(openIdMap != null){
					String identifier = openIdMap.get("identifier");
					rpx.map(identifier, String.valueOf(userID));
				}
				
			}*/

			return mapping.findForward("Success");			
		}
		
	}

}