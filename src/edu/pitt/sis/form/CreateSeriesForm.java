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
public class CreateSeriesForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables

	private static final long serialVersionUID = 1L;

	private String name;
	private String url;
	private String description;
	private String[] sponsor_id;
	private String series_id;
	private String[] area_id;
	
	// --------------------------------------------------------- Methods

	public String[] getArea_id() {
		return area_id;
	}

	public void setArea_id(String[] areaId) {
		area_id = areaId;
	}

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
			errors.add("name", new ActionError("create.series.error.name.blank"));
		if(description.trim().equalsIgnoreCase("")||description.length() < 1)
			errors.add("description", new ActionError("create.series.error.description.blank"));
		
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

	public String getSeries_id() {
		return series_id;
	}

	public void setSeries_id(String series_id) {
		this.series_id = series_id;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String[] getSponsor_id() {
		return sponsor_id;
	}

	public void setSponsor_id(String[] sponsor_id) {
		this.sponsor_id = sponsor_id;
	}


}