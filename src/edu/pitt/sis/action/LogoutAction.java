package edu.pitt.sis.action;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;
import edu.pitt.sis.form.LoginForm;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
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
public class LogoutAction extends Action {

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
		Cookie cid = new Cookie("comet_user_id", null);
        cid.setMaxAge(10);
        cid.setPath("/");
        response.addCookie(cid);
        
		Cookie cname = new Cookie("comet_user_name", null);
        cname.setMaxAge(10);
        cname.setPath("/");
        response.addCookie(cname);

		HttpSession session = request.getSession();
		if(session.getAttribute("UserSession")!=null){
			session.removeAttribute("UserSession");
		}
		if(session.getAttribute("HideBar")!=null){
			session.removeAttribute("HideBar");
		}
		if(session.getAttribute("rpx")!=null){
			session.removeAttribute("rpx");
		}
		if(session.getAttribute("openIdMap")!=null){
			session.removeAttribute("openIdMap");
		}
		session.removeAttribute("facebookFriends");
		session.removeAttribute("facebookFriendsName");
		session.removeAttribute("facebookUsersName");
		session.removeAttribute("locationfbFriends");
		session.removeAttribute("locationfbUsers");
		session.removeAttribute("linkedInFriends");
		session.removeAttribute("linkedInFriendsName");
		session.removeAttribute("linkedInUsersName");
		session.removeAttribute("locationliFriends");
		session.removeAttribute("locationliUsers");
		
		session.setAttribute("menu","home");
		session.setAttribute("logout",true);
		return mapping.findForward("Success");					
	}

}