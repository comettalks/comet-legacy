package edu.pitt.sis.action;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;


import javax.servlet.http.*;

import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;
import edu.pitt.sis.form.LoginForm;

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
public class TalksDateAction extends Action {

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
		connectDB conn = new connectDB();
		
		String sql = "SELECT * FROM sp_listDateTalks(?,?)";
		
		PreparedStatement pstmt = null;
		Collection c = new ArrayList();
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.execute();
			rs = pstmt.getResultSet();
			while(rs.next()){
				ColBriefBean cbb = new ColBriefBean();
				cbb.setCol_id(rs.getString("col_id"));
				cbb.setSpeaker(rs.getString("speaker"));
				cbb.setTitle(rs.getString("title"));
				cbb.setDate(rs.getString("_date"));
				cbb.setSpeaktime(rs.getString("speaktime"));
				cbb.setLocation(rs.getString("location"));
				c.add(cbb);
			}
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
		session.setAttribute("colloquia",c);
		return mapping.findForward("Success");			
		
	}

}