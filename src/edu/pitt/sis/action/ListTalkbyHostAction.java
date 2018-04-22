package edu.pitt.sis.action;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.GregorianCalendar;
//import java.util.StringTokenizer;


import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;

import org.apache.struts.action.Action;
//import org.apache.struts.action.ActionError;
//import org.apache.struts.action.ActionErrors;
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
public class ListTalkbyHostAction extends Action {

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
	Collection hosts;
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		
		ResultSet rs = null;

		String hostid = (String)request.getParameter("host_id");

		hosts = new ArrayList();
		HttpSession session = request.getSession();
		connectDB conn = new connectDB();
		listAllOntologyFromThisNode(hostid);
		listMonthCal(request);
		
		String list_of_hosts = "(";
		for(int i=0;i<hosts.size();i++){
			list_of_hosts = list_of_hosts + (String)((ArrayList)hosts).get(i);
			if(i+1<hosts.size()){
				list_of_hosts = list_of_hosts + ",";
			}
		}
		list_of_hosts = list_of_hosts + ") ";
		PreparedStatement pstmt = null;
		
		//Colloquium data
		Collection c = new ArrayList();
		//HostedBy data
		Collection d = new ArrayList();
		//Ontology data
		Collection ontology = new ArrayList();
		//Host ontology string
		String h_ont = null;
		//Tags data
		Collection tags = new ArrayList();
		
		String sql = "SELECT v.* FROM vw_listtalks v " +
		             "INNER JOIN hosted_by h ON v.col_id = h.col_id " +
		             "WHERE h.host_id IN " + list_of_hosts + 
		             "ORDER BY sort_date;";
		
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.execute();
			rs = pstmt.getResultSet();
			while(rs.next()){
				ColBriefBean cbb = new ColBriefBean();
				cbb.setCol_id(rs.getString("col_id"));
				cbb.setTitle(rs.getString("title"));
				cbb.setSpeaker(rs.getString("speaker"));
				cbb.setSpeaker_id(rs.getString("speaker_id"));
				cbb.setDate(rs.getString("_date"));
				cbb.setSpeaktime(rs.getString("speaktime"));
				cbb.setLocation(rs.getString("location"));
				cbb.setTypeoftalk_id(rs.getString("typeoftalk_id"));
				cbb.setTalk(rs.getString("talk"));
				cbb.setName(rs.getString("name"));
				cbb.setEmail(rs.getString("email"));

				ResultSet rs_sub = null;
				//sql = "call sp_listHosts(?);";
				sql = "SELECT hosted_by.host_id,host.ontology " +
						"FROM hosted_by INNER JOIN host ON hosted_by.host_id = host.host_id " +
						"WHERE hosted_by.col_id = " + cbb.getCol_id();
				rs_sub = conn.getResultSet(sql);
				while(rs_sub.next()){
					//Add HostedByBean
					HostedByBean hbb = new HostedByBean();
					hbb.setCol_id(cbb.getCol_id());
					hbb.setHost_id(rs_sub.getString("host_id"));
					hbb.setOntology(rs_sub.getString("ontology"));
					d.add(hbb);
				}
				rs_sub.close();
				rs_sub = null;
				c.add(cbb);

				//sql = "call sp_listTags(?);";
				sql = "SELECT tag.tag_id,tag.tag " +
						"FROM tag INNER JOIN tags ON tag.tag_id = tags.tag_id " +
						"WHERE tags.col_id = " + cbb.getCol_id();
				rs_sub = conn.getResultSet(sql);
				while(rs_sub.next()){
					//Add TagBean
					TagBean tb = new TagBean();
					tb.setCol_id(cbb.getCol_id());
					tb.setTag_id(rs_sub.getString("tag_id"));
					tb.setTag(rs_sub.getString("tag"));
					tags.add(tb);
				}
				rs_sub.close();
				rs_sub = null;
			}
			rs.close();
			rs = null;

			//Add a list of hosts
			//sql = "call sp_listAllHosts()";
			sql = "SELECT host_id,host,abbr FROM host";
			rs = null;
			rs = conn.getResultSet(sql);
			while(rs.next()){
				HostBean hb = new HostBean();
				hb.setHost_id(rs.getString("host_id"));
				hb.setAbbr(rs.getString("abbr"));
				hb.setHost(rs.getString("host"));
				ontology.add(hb);
			}
			rs.close();
			rs = null;			

			//Query for host ontology
			//sql = "call sp_showOntology(?)";
			sql = "SELECT ontology FROM host WHERE host_id = " + hostid;
			rs = conn.getResultSet(sql);			
			if(rs.next()){
				h_ont = rs.getString("ontology");
			}
			rs.close();
			rs = null;
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
		
		if(session.getAttribute("HideBar")!=null){
			session.removeAttribute("HideBar");
		}
		if(session.getAttribute("colloquia")!=null){
			session.removeAttribute("colloquia");
		}
		if(session.getAttribute("hostedby")!=null){
			session.removeAttribute("hostedby");
		}
		if(session.getAttribute("ontology")!=null){
			session.removeAttribute("ontology");
		}
		if(session.getAttribute("h_ont")!=null){
			session.removeAttribute("h_ont");
		}
		session.setAttribute("colloquia",c);
		session.setAttribute("hostedby",d);
		session.setAttribute("ontology",ontology);
		session.setAttribute("h_ont",h_ont);
		session.setAttribute("tags",tags);
		return mapping.findForward("Success");			
		
	}
	
	private void listAllOntologyFromThisNode(String host_id){
		if(!hosts.contains(host_id)){
			hosts.add(host_id);
		}
		ResultSet rs = null;		
		
		String sql = "SELECT host_id FROM host WHERE parent_id = " + host_id;
		
		PreparedStatement pstmt = null;
		connectDB conn = new connectDB();
		
		try {
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setInt(1,Integer.parseInt(host_id));
			pstmt.execute();
			rs = pstmt.getResultSet();
			while(rs.next()){
				String sibling = rs.getString("host_id");
				if(!hosts.contains(sibling)){
					hosts.add(sibling);
				}
				listAllOntologyFromThisNode(sibling);
			}
			conn.conn.close();
			conn = null;
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	private void listMonthCal(HttpServletRequest request){
		Collection lecturelist;
		HttpSession session = request.getSession();
		String hostid = (String)request.getParameter("host_id");
		String calmenu = (String)session.getAttribute("calmenu");

		if(request.getParameter("calmenu")!=null){
			calmenu = (String)request.getParameter("calmenu");
		}
		
		if(calmenu == null){
			calmenu = "community";
		}
		
		UserBean ub = null; 
		ub = (UserBean)session.getAttribute("UserSession");
		
		if(calmenu.equalsIgnoreCase("myaccount")){
			if(ub == null){
				calmenu = "community";
			}
		}
		session.setAttribute("calmenu",calmenu);
		CommunityBean cmb = null; 
		cmb = (CommunityBean)session.getAttribute("CommunitySession");
		if(cmb == null){
			cmb = new CommunityBean();
			cmb.setCommID(0);
			cmb.setName("default");
			session.setAttribute("CommunitySession", cmb);
		}
		
		Calendar calendar = new GregorianCalendar();
	    int month = calendar.get(Calendar.MONTH)+1;
	    int year = calendar.get(Calendar.YEAR);		

	    if(request.getParameter("month")!=null){
	        month = Integer.parseInt(request.getParameter("month"));
	    }
	    
	    if(request.getParameter("year")!=null){
	        year = Integer.parseInt(request.getParameter("year"));
	    }
	    
	    lecturelist = new ArrayList();
		
		//sp_listMonthTalks(?,?);
		String sql = "";
		if(calmenu.equalsIgnoreCase("all")){
			sql = "select date_format(c._date,_utf8'%d') AS `day`, COUNT(*) AS lecture_no " +
					"from colloquium c,hosted_by h " +
					"where ( " +
					"MONTH(c._date) = " + month + " " +
					"AND YEAR(c._date) = " + year + ") " +
					"AND c.col_id = h.col_id " +
					"AND h.host_id = " + hostid + " " +
					"GROUP BY date_format(c._date,_utf8'%d');";
		}
		if(calmenu.equalsIgnoreCase("community")){
			sql = "select date_format(c._date,_utf8'%d') AS `day`, COUNT(*) AS lecture_no " +
					"from colloquium c,userprofile u,hosted_by h " +
					"where ( " +
					"MONTH(c._date) = " + month + " " +
					"AND YEAR(c._date) = " + year + ") " +
					"AND c.col_id = u.col_id " +
					"AND u.comm_id = " + cmb.getCommID() + " " +
					"AND c.col_id = h.col_id " +
					"AND h.host_id = " + hostid + " " +
					"GROUP BY date_format(c._date,_utf8'%d');";
		}
		if(calmenu.equalsIgnoreCase("myaccount")){
			sql = "select date_format(c._date,_utf8'%d') AS `day`, COUNT(*) AS lecture_no " +
					"from colloquium c,userprofile u,hosted_by h " +
					"where ( " +
					"MONTH(c._date) = " + month + " " +
					"AND YEAR(c._date) = " + year + ") " +
					"AND c.col_id = u.col_id " +
					"AND u.user_id = " + ub.getUserID() + " " +
					"AND c.col_id = h.col_id " +
					"AND h.host_id = " + hostid + " " +
					"GROUP BY date_format(c._date,_utf8'%d');";
		}
		
		connectDB conn = new connectDB();
		try{
			ResultSet rs = conn.getResultSet(sql);
			while(rs.next()){
				CalendarBean cb = new CalendarBean();
				cb.setDay(rs.getInt("day"));
				cb.setLecture_no(rs.getInt("lecture_no"));
				lecturelist.add(cb);
			}
			session.setAttribute("lecturelist",lecturelist);
			conn.conn.close();
			conn = null;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
}