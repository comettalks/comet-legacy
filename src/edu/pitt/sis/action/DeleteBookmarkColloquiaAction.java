package edu.pitt.sis.action;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 */
public class DeleteBookmarkColloquiaAction extends Action {

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
		
		if (this.isCancelled(request)){ return(mapping.findForward("Failure"));}
		
		HttpSession session = request.getSession();
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		connectDB conn = new connectDB();
		PreparedStatement pstmt = null;
		
		//try{
		DynaActionForm selectedform = (DynaActionForm)form;
		String[] selected    = (String[])selectedform.get("selected");
		if (selected == null)
			return mapping.findForward("Failure");
		
		for (int count=0;count<selected.length;count++){
			int index = Integer.parseInt(selected[count]);
			String sql = "DELETE FROM userprofile WHERE user_id = " + ub.getUserID() + 
							" AND col_id = " + index;
			conn.executeUpdate(sql);
			sql = "DELETE FROM tags WHERE user_id = " + ub.getUserID() + " AND col_id = " + index;
			conn.executeUpdate(sql);
		}
			//pstmt.close();
			//con.conn.close();
			
		/*}catch(SQLException e){
			try {
				if (pstmt != null) pstmt.close();			
				//if (con.conn !=null) con.conn.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			System.out.println(e.getMessage().toString());
			return mapping.findForward("Failure");
		}*/

		//Copy the codelet from ListMyColloquiaAction

		//PreparedStatement pstmt = null;
		//Colloquium data
		Collection c = new ArrayList();
		//HostedBy data
		Collection d = new ArrayList();
		//Ontology data
		Collection ontology = new ArrayList();
		//Tags data
		Collection tags = new ArrayList();

		try{
			String sql = "SELECT colloquium.col_id,colloquium.title,speaker.name AS speaker, speaker.speaker_id," +
							"date_format(colloquium._date,'%M %d') AS _date," +
							"concat(colloquium.begintime,' - ',colloquium.endtime) AS speaktime,colloquium.location," +
							"colloquium.user_id,userinfo.name,userinfo.email,colloquium.typeoftalk_id,typeoftalk.talk " +
							"FROM (((colloquium INNER JOIN typeoftalk ON colloquium.typeoftalk_id = typeoftalk.typeoftalk_id) " +
							"INNER JOIN userinfo ON colloquium.user_id = userinfo.user_id) " +
							"INNER JOIN speaker ON colloquium.speaker_id = speaker.speaker_id) " +
							"INNER JOIN userprofile ON colloquium.col_id = userprofile.col_id " +
							"WHERE userprofile.user_id = " + ub.getUserID() + " " +
							"ORDER BY colloquium._date DESC;";
			//pstmt = con.conn.prepareStatement(sql);
			//HttpSession session = request.getSession();
			//UserBean ub = (UserBean)session.getAttribute("UserSession");
			//pstmt.setInt(1,ub.getUserID());
			//pstmt.execute();
			ResultSet rs = conn.getResultSet(sql);
			while(rs.next()){
				ColBriefBean cbb = new ColBriefBean();
				cbb.setCol_id(rs.getString("col_id"));
				cbb.setTitle(rs.getString("title"));
				cbb.setSpeaker(rs.getString("speaker"));
				cbb.setDate(rs.getString("_date"));
				cbb.setSpeaktime(rs.getString("speaktime"));
				cbb.setLocation(rs.getString("location"));
				cbb.setTypeoftalk_id(rs.getString("typeoftalk_id"));
				cbb.setTalk(rs.getString("talk"));
				cbb.setName(rs.getString("name"));
				cbb.setEmail(rs.getString("email"));
				cbb.setSpeaker_id(rs.getString("speaker_id"));

				ResultSet rs_sub = null;				
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

				CommunityBean cb = (CommunityBean)session.getAttribute("CommunitySession");
				
				sql = "SELECT t.tag_id,t.tag " +
						"FROM tag t, tags t1, userprofile u " +
						"WHERE " +
						"t.tag_id = t1.tag_id " +
						"AND t1.col_id = u.col_id " +
						"AND u.comm_id = " + cb.getCommID() +
						" AND t1.col_id = " + cbb.getCol_id();
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
			sql = "SELECT host_id,host,abbr FROM host;";
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
			//HttpSession session = request.getSession();
			LoginErrorBean leb = new LoginErrorBean();
			leb.setErrorDescription("System failure! Please try next time.");
			session.setAttribute("LoginError",leb);
			return mapping.findForward("Failure");
		}
			
		//HttpSession session = request.getSession();
		if(session.getAttribute("HideBar")!=null){
			session.removeAttribute("HideBar");
		}
		session.setAttribute("colloquia",c);
		session.setAttribute("hostedby",d);
		session.setAttribute("ontology",ontology);
		session.setAttribute("tags",tags);
		session.setAttribute("listheader","My Colloquia");
		session.setAttribute("action","Delete");
		session.setAttribute("menu","myaccount");

		return mapping.findForward("Success");
	}
	
}