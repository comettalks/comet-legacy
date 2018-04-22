//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

package edu.pitt.sis.form;

import javax.servlet.http.HttpServletRequest;

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
public class CreateCommForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	private static final long serialVersionUID = 1L;

	private String comm_id;
	private String name;
	private String description;

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
		
		if(name.trim().equalsIgnoreCase("")||name.length() < 1)
			errors.add("name", new ActionError("create.community.error.name.blank"));
		if(description.trim().equalsIgnoreCase("")||description.length() < 1)
			errors.add("description", new ActionError("create.community.error.description.blank"));
		
		return errors;
	}	

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		name = null;
		description = null;
		comm_id = null;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getComm_id() {
		return comm_id;
	}

	public void setComm_id(String commId) {
		comm_id = commId;
	}



}