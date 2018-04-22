//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.9.210/xslt/JavaClass.xsl

package edu.pitt.sis.form;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 02-16-2006
 * 
 * XDoclet definition:
 * @struts:form name="LevelChangeForm"
 */
public class AddBookmarkColloquiumForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables
	private static final long serialVersionUID = 1L;	
	private long col_id;
	private String note;
	private String tags;
	private String[] selectedCommunities;
	
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

		// TODO Auto-generated method stub
		ActionErrors errors = new ActionErrors();
		
		//Basic field validation is here
		//if(this.tags.equalsIgnoreCase("") || this.tags.length() < 1)
		//	errors.add("col_id", new ActionError("colloquium.bookmark.error.tags"));
		//Not done yet
		
		return errors;
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {

		// TODO Auto-generated method stub
		//col_id = null;
		note = null;
		tags = null;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String[] getSelectedCommunities() {
		return selectedCommunities;
	}

	public void setSelectedCommunities(String[] selectedCommunities) {
		this.selectedCommunities = selectedCommunities;
	}

	public long getCol_id() {
		return col_id;
	}

	public void setCol_id(long col_id) {
		this.col_id = col_id;
	}


}

