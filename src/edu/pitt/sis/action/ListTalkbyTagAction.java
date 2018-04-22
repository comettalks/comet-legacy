package edu.pitt.sis.action;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.StringTokenizer;


import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;

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
public class ListTalkbyTagAction extends Action {

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
		ResultSet rs = null;

		String tagid = (String)request.getParameter("tag_id");

		connectDB conn = new connectDB();
				
		PreparedStatement pstmt = null;
		
		//Tag header data
		TagBean category_tag = new TagBean();
		//Colloquium data
		Collection c = new ArrayList();
		//HostedBy data
		Collection d = new ArrayList();
		//Ontology data
		Collection ontology = new ArrayList();
		//Tags data
		Collection tags = new ArrayList();
		
		String sql = "call sp_listTalksByTag(?);";
		
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setInt(1,Integer.parseInt(tagid));
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
				sql = "call sp_listHosts(?);";
				PreparedStatement pstmt_sub = null;
				pstmt_sub = conn.conn.prepareStatement(sql);
				pstmt_sub.setInt(1,Integer.parseInt(cbb.getCol_id()));
				pstmt_sub.execute();
				rs_sub = pstmt_sub.getResultSet();
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

				sql = "call sp_listTags(?);";
				pstmt_sub = null;
				pstmt_sub = conn.conn.prepareStatement(sql);
				pstmt_sub.setInt(1,Integer.parseInt(cbb.getCol_id()));
				pstmt_sub.execute();
				rs_sub = pstmt_sub.getResultSet();
				while(rs_sub.next()){
					//Add TagBean
					TagBean tb = new TagBean();
					tb.setCol_id(cbb.getCol_id());
					tb.setTag_id(rs_sub.getString("tag_id"));
					tb.setTag(rs_sub.getString("tag"));
					tags.add(tb);
					if(category_tag.getTag_id()==null){
						if(tagid.equalsIgnoreCase(tb.getTag_id())){
							category_tag.setTag_id(tb.getTag_id());
							category_tag.setTag(tb.getTag());
						}
					}
				}
				rs_sub.close();
				rs_sub = null;
			}
			rs.close();
			rs = null;

			//Add a list of hosts
			sql = "call sp_listAllHosts()";
			rs = null;
			pstmt = null;
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.execute();
			rs = pstmt.getResultSet();
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
			HttpSession session = request.getSession();
			LoginErrorBean leb = new LoginErrorBean();
			leb.setErrorDescription("System failure! Please try next time.");
			session.setAttribute("LoginError",leb);
			return mapping.findForward("Failure");
		}
			
		HttpSession session = request.getSession();
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
		session.setAttribute("category_tag",category_tag);
		session.setAttribute("tags",tags);
		return mapping.findForward("Success");			
		
	}
	
}