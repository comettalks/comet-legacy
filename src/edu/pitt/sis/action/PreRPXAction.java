package edu.pitt.sis.action;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


import javax.servlet.http.*;

import edu.pitt.sis.Rpx;
import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;
import edu.pitt.sis.form.LoginForm;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.w3c.dom.DOMException;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

//Created by MyEclipse Struts
// XSL source (default): platform:/plugin/com.genuitec.eclipse.cross.easystruts.eclipse_3.8.2/xslt/JavaClass.xsl

/** 
 * MyEclipse Struts
 * Creation date: 11-22-2004
 * 
 * XDoclet definition:
 * @struts:action validate="true"
 */
public class PreRPXAction extends Action {

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
		HttpSession session = request.getSession();
		if(session.getAttribute("HideBar")==null){
			session.setAttribute("HideBar", new Object());
		}
		if(session.getAttribute("rpx")!=null){
			session.removeAttribute("rpx");
		}
		if(session.getAttribute("openIdMap")!=null){
			session.removeAttribute("openIdMap");
		}
		
		/**
		 * The RPX base URL.
		*/	
		final String RPX_BASEURL = "https://rpxnow.com";  
		
		/**
		 * Your secret API code.
		 */	
		final String RPX_APIKEY = "3402b121cffb98806313db238f8cb3686f88cb9c";

		try {
			String rpxToken = request.getParameter("token");
			Rpx rpx = new Rpx(RPX_APIKEY,RPX_BASEURL);
			
			Element rpxAuth = null;
			try {
				rpxAuth = rpx.authInfo(rpxToken);
			} catch (RuntimeException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				return mapping.findForward("Failure");
			}
			// Check if authentication failed.
			String stat = rpxAuth.getAttribute("stat");
			if (!"ok".equals(stat)) {
			    String error = "User authentication failed";
			    try {
					response.sendError(HttpServletResponse.SC_FORBIDDEN, error);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			    return mapping.findForward("Failure");
			}
			// Generate a map of the profile attributes.
			Map<String, String> openIdMap = new HashMap<String, String>();
			Node profile = rpxAuth.getFirstChild();
			NodeList profileFields = profile.getChildNodes();
			for(int k = 0; k < profileFields.getLength(); k++) {
			    Node n = profileFields.item(k);
			    if (n.hasChildNodes()) {
			        NodeList nFields = n.getChildNodes();
			        for (int j = 0; j < nFields.getLength(); j++) {
			            Node nn = nFields.item(j);
			            String nodename = n.getNodeName();
			            if (!nn.getNodeName().startsWith("#"))
			                nodename += "." + nn.getNodeName();
			            openIdMap.put(nodename, nn.getTextContent());
			        }

			    } else
			        openIdMap.put(n.getNodeName(), n.getTextContent());
			}

			// Now openIdMap contains a hash map of all the profile fields we got back.
			/*String openid = openIdMap.get("identifier");
			String username = openIdMap.get("preferredUsername");
			// Nested elements can be accessed with the full path:
			String name = openIdMap.get("name.formatted");
			String mail = openIdMap.get("email");*/
			String primaryKey = openIdMap.get("primaryKey");
			
			//if(mail==null)mail="";
			
			if(primaryKey!=null){
				connectDB conn = new connectDB();
				UserBean ub = new UserBean();
				String sql = "call sp_retrieveUserInfo(?)";
				try {
					PreparedStatement pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1, Integer.parseInt(primaryKey));
					pstmt.execute();
					ResultSet rs = pstmt.getResultSet();
					if(rs.next()){
						ub.setName(rs.getString("name"));
						ub.setRoleID(rs.getInt("role_id"));
						ub.setUserID(Integer.parseInt(primaryKey));

						session.setAttribute("UserSession", ub);
						if(session.getAttribute("HideBar")!=null){
							session.removeAttribute("HideBar");
						}

						if(session.getAttribute("redirect") == null){
							session.setAttribute("menu","home");
						}
						return mapping.findForward("Home");

					}
				} catch (NumberFormatException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			
			session.setAttribute("openIdMap", openIdMap);
			session.setAttribute("rpx", rpx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		    return mapping.findForward("Failure");
		}
		
		return mapping.findForward("Success");					
	}

}