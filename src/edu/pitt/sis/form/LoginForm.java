//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package edu.pitt.sis.form;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 12-03-2004
 * 
 * XDoclet definition:
 * @struts:form name="LoginForm"
 */
public class LoginForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	private static final long serialVersionUID = 1L;

	/** password property */
	private String password;

	/** userEmail property */
	private String userEmail;
	
	// --------------------------------------------------------- Methods

	/** 
	 * Method validate
	 * @param mapping
	 * @param request
	 * @return ActionErrors
	 */
	public ActionErrors validate(
		ActionMapping mapping,
		HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();
		
		HttpSession session = request.getSession();
		if(session.getAttribute("UserSession")!=null){
			return errors;
		}
		
		if(password==null){
			errors.add("password", new ActionError("login.error.password.blank"));
		}else if(password.trim().equalsIgnoreCase("")){
			errors.add("password", new ActionError("login.error.password.blank"));
		}
		if(userEmail==null){
			errors.add("userEmail", new ActionError("login.error.email.blank"));
		}else if(userEmail.trim().equalsIgnoreCase("")){
			errors.add("userEmail", new ActionError("login.error.email.blank"));
		}
		
		return errors;
	}	

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {

		password = null;
		userEmail = null;

	}

	/** 
	 * Returns the password.
	 * @return String
	 */
	public String getPassword() {
		return password;
	}

	/** 
	 * Set the password.
	 * @param password The password to set
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/** 
	 * Returns the userEmail.
	 * @return String
	 */
	public String getUserEmail() {
		return userEmail;
	}

	/** 
	 * Set the userEmail.
	 * @param userEmail The userEmail to set
	 */
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

}