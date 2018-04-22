package edu.pitt.sis.action;

import javax.servlet.http.*;

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
public class PreCreateCommAction extends Action {

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
		
		if(session.getAttribute("UserSession")==null){
			session.setAttribute("HideBar", "");
			session.setAttribute("redirect", "PreMakeCommunity.do");
			return mapping.findForward("Login");
		}
		if(session.getAttribute("HideBar")!=null){
			session.removeAttribute("HideBar");
		}
		if(session.getAttribute("redirect") != null){
			session.removeAttribute("redirect");
		}
		if(session.getAttribute("makeComm") != null){
			session.removeAttribute("makeComm");
		}
		
		session.setAttribute("menu","CreateComm");
		return mapping.findForward("Success");			
		
	}

}