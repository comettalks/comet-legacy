//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package edu.pitt.sis.form;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import net.tanesha.recaptcha.ReCaptchaImpl;
import net.tanesha.recaptcha.ReCaptchaResponse;
/** 
 * MyEclipse Struts
 * Creation date: 12-03-2004
 * 
 * XDoclet definition:
 * @struts:form name="LoginForm"
 */
public class SignupForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	private static final long serialVersionUID = 1L;

	private String name;
	private String userEmail;
	private String password;
	private String repassword;
	private String[] affiliate_id;
	private String isOpenID;

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
		
		if(name.trim().equalsIgnoreCase("")||name.length() < 1)
			errors.add("name", new ActionError("signup.error.name.blank"));
		if(userEmail.trim().equalsIgnoreCase("")||userEmail.length() < 1)
			errors.add("userEmail", new ActionError("signup.error.email.blank"));
		if(session.getAttribute("rpx")==null){
			if(password.trim().equalsIgnoreCase("")||password.length() < 1)
				errors.add("password", new ActionError("signup.error.password.blank"));
			if(repassword.trim().equalsIgnoreCase("")||repassword.length() < 1)
				errors.add("repassword", new ActionError("signup.error.repassword.blank"));
			if(!password.equals(repassword)){
				errors.add("password", new ActionError("signup.error.password.notmatch"));
				errors.add("repassword", new ActionError("signup.error.password.notmatch"));
			}
		}
		String remoteAddr = request.getRemoteAddr();
        ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
        //Halley Private Key
        reCaptcha.setPrivateKey("6Ldamb4SAAAAAHTCLlHVW2TSPp2Mn-YkByFU5EXB");
        //Washington Private Key
        //reCaptcha.setPrivateKey("6LfZ6b4SAAAAABgyEW4S1NiKrZBLR_077NCw_-xz");

        String challenge = request.getParameter("recaptcha_challenge_field");
        String uresponse = request.getParameter("recaptcha_response_field");
       
		
        if(session.getAttribute("openIdMap") == null)
        {
	        ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);
	
	        if (!reCaptchaResponse.isValid()) {
	        	errors.add("recaptcha",new ActionError("signup.error.recaptcha.notmatch"));
	        }
        }
        
		return errors;
	}	

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		name = null;
		userEmail = null;
		password = null;
		repassword = null;		
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRepassword() {
		return repassword;
	}

	public void setRepassword(String repassword) {
		this.repassword = repassword;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String[] getAffiliate_id() {
		return affiliate_id;
	}

	public void setAffiliate_id(String[] affiliate_id) {
		this.affiliate_id = affiliate_id;
	}

	public String getIsOpenID() {
		return isOpenID;
	}

	public void setIsOpenID(String isOpenID) {
		this.isOpenID = isOpenID;
	}

	

}