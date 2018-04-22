//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.9.210/xslt/JavaClass.xsl

package edu.pitt.sis.form;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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
public class ColloquiumForm extends ActionForm {

	// --------------------------------------------------------- Instance Variables
	private static final long serialVersionUID = 1L;	
	private long col_id;
	private String title;
	private String speaker;
	private String affiliation;
	private String talkDate;
	private String beginHour;
	private String beginMin;
	private String beginAMPM;
	private String endHour;
	private String endMin;
	private String endAMPM;
	private String location;
	//private String typeoftalk;
	private String detail;
	private String host;
	private String[] series_id;
	private String url;
	private String sponsor_id;
	private String video_url;
	private String slide_url;
	private String paper_url;
	private String picURL;
	private String[] area_id;
	public String[] getArea_id() {
		return area_id;
	}

	public void setArea_id(String[] areaId) {
		area_id = areaId;
	}

	public String getPicURL() {
		return picURL;
	}

	public void setPicURL(String picURL) {
		this.picURL = picURL;
	}

	public String getPaper_url() {
		return paper_url;
	}

	public void setPaper_url(String paperUrl) {
		paper_url = paperUrl;
	}

	private String s_bio;

	// --------------------------------------------------------- Methods
	
	public String getVideo_url() {
		return video_url;
	}

	public void setVideo_url(String videoUrl) {
		video_url = videoUrl;
	}

	public ColloquiumForm(){
		super();
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

		// TODO Auto-generated method stub
		ActionErrors errors = new ActionErrors();
		
		//Basic field validation is here
		if(this.title == null){
			errors.add("title", new ActionError("colloquium.entry.error.title"));
		}else if(this.title.trim().equalsIgnoreCase("") || this.title.length() < 1){
			errors.add("title", new ActionError("colloquium.entry.error.title"));
		}
		if(this.speaker.trim().equalsIgnoreCase("") || this.speaker.length() < 1)
			errors.add("speaker", new ActionError("colloquium.entry.error.speaker"));
		if(this.talkDate.trim().equalsIgnoreCase("") || this.talkDate.length() < 1)
			errors.add("talkDate", new ActionError("colloquium.entry.error.date"));
		if(this.location.trim().equalsIgnoreCase("") || this.location.length() < 1)
			errors.add("location", new ActionError("colloquium.entry.error.location"));
//		if(this.typeoftalk.equalsIgnoreCase("") || this.typeoftalk.length() < 1)
//			errors.add("typeoftalk", new ActionError("colloquium.entry.error.typeoftalk"));
		if(this.detail.trim().equalsIgnoreCase("") || this.detail.length() < 1)
			errors.add("detail", new ActionError("colloquium.entry.error.detail"));
		/*if(this.host.trim().equalsIgnoreCase("") || this.host.length() < 1)
			errors.add("host", new ActionError("colloquium.entry.error.host"));*/
		try {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy");
			dateFormatter.parse(talkDate);
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			errors.add("talkDate", new ActionError("colloquium.entry.error.date.format"));
		}
		
		return errors;
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {

		// TODO Auto-generated method stub
		title = null;
		speaker = null;
		talkDate = null;
		//begintime = null;
		//endtime = null;
		location = null;
		//typeoftalk = null;
		detail = null;
		host = null;
		series_id = null;
		video_url = null;
		slide_url = null;
		s_bio = null;
	}

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getSpeaker() {
		return speaker;
	}

	public void setSpeaker(String speaker) {
		this.speaker = speaker;
	}

	/*public String getTypeoftalk() {
		return typeoftalk;
	}

	public void setTypeoftalk(String typeoftalk) {
		this.typeoftalk = typeoftalk;
	}*/

	public String getTalkDate() {
		return talkDate;
	}

	public void setTalkDate(String talkDate) {
		this.talkDate = talkDate;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

	public String getBeginHour() {
		return beginHour;
	}

	public void setBeginHour(String beginHour) {
		this.beginHour = beginHour;
	}

	public String getBeginMin() {
		return beginMin;
	}

	public void setBeginMin(String beginMin) {
		this.beginMin = beginMin;
	}

	public String getBeginAMPM() {
		return beginAMPM;
	}

	public void setBeginAMPM(String beginAMPM) {
		this.beginAMPM = beginAMPM;
	}

	public String getEndHour() {
		return endHour;
	}

	public void setEndHour(String endHour) {
		this.endHour = endHour;
	}

	public String getEndMin() {
		return endMin;
	}

	public void setEndMin(String endMin) {
		this.endMin = endMin;
	}

	public String getEndAMPM() {
		return endAMPM;
	}

	public void setEndAMPM(String endAMPM) {
		this.endAMPM = endAMPM;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public long getCol_id() {
		return col_id;
	}

	public void setCol_id(long col_id) {
		this.col_id = col_id;
	}

	public String[] getSeries_id() {
		return series_id;
	}

	public void setSeries_id(String[] series_id) {
		this.series_id = series_id;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getSponsor_id() {
		return sponsor_id;
	}

	public void setSponsor_id(String sponsor_id) {
		this.sponsor_id = sponsor_id;
	}

	public String getAffiliation() {
		return affiliation;
	}

	public void setAffiliation(String affiliation) {
		this.affiliation = affiliation;
	}

	public String getSlide_url() {
		return slide_url;
	}

	public void setSlide_url(String slide_url) {
		this.slide_url = slide_url;
	}

	public String getS_bio() {
		return s_bio;
	}

	public void setS_bio(String s_bio) {
		this.s_bio = s_bio;
	}


}

