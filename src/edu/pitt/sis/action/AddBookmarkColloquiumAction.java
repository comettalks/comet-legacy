package edu.pitt.sis.action;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.*;
import java.util.*;

import javax.servlet.http.*;
//import javax.xml.registry.infomodel.EmailAddress;

import edu.pitt.sis.MailNotifier;
import edu.pitt.sis.db.*;
import edu.pitt.sis.beans.*;
import edu.pitt.sis.form.*;

import org.apache.struts.action.Action;
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
public class AddBookmarkColloquiumAction extends Action {

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
		if(ub == null){
			if(session.getAttribute("HideBar")==null){
				session.setAttribute("HideBar",new Object());
			}
			return mapping.findForward("Login");
		}
		connectDB conn = new connectDB();
		PreparedStatement pstmt = null;
		
		try{
			AddBookmarkColloquiumForm abcf = (AddBookmarkColloquiumForm)form;
			long col_id = abcf.getCol_id();
			if (col_id < 0){
				return mapping.findForward("Failure");
			}
			pstmt = null;
			String sql = "SELECT u.userprofile_id FROM userprofile u,userinfo uu " + 
							"WHERE u.user_id = uu.user_id AND u.user_id = ? AND u.col_id = ?";
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1, ub.getUserID());
			pstmt.setLong(2, abcf.getCol_id());
			ResultSet rs = pstmt.executeQuery();
			long userprofile_id = -1;
			if(rs.next()){
				userprofile_id = rs.getLong("userprofile_id");
				
				sql = "UPDATE userprofile SET lastupdate = NOW()," +
						"comment = ?,usertags = ? WHERE userprofile_id = ?";
				rs.close();
				pstmt.close();
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, abcf.getNote());
				pstmt.setString(2, abcf.getTags());
				//pstmt.setString(3, abcf.getEmail());
				pstmt.setLong(3, userprofile_id);
				pstmt.executeUpdate();
				
				pstmt.close();
				
				sql = "DELETE FROM contribute WHERE userprofile_id = " + userprofile_id;
				conn.executeUpdate(sql);
				
				sql = "DELETE FROM tags WHERE userprofile_id = " + userprofile_id;
				conn.executeUpdate(sql);
			}else{
				rs.close();
				sql = "INSERT INTO userprofile " +
						"(user_id,col_id,lastupdate,comment,usertags) " +
						"VALUES (?,?,NOW(),?,?);";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setLong(1, ub.getUserID());
				pstmt.setLong(2, col_id);
				pstmt.setString(3, abcf.getNote());
				pstmt.setString(4, abcf.getTags());
				pstmt.executeUpdate();
			
				pstmt.close();
				
				sql = "SELECT LAST_INSERT_ID()";
				rs = conn.getResultSet(sql);
				if(rs.next()){
					userprofile_id = rs.getLong(1);
				}

			}
			
			String[] community = abcf.getSelectedCommunities();
			if(community != null){
				HashSet<String> commSet = new HashSet<String>();
				for(int i=0;i<community.length;i++){
					if(!commSet.contains(community[i])){
						commSet.add(community[i]);
						sql = "INSERT INTO contribute (userprofile_id,comm_id,lastupdate) VALUES (?,?,NOW());";
						pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, userprofile_id);
						pstmt.setLong(2, Long.parseLong(community[i]));
						pstmt.executeUpdate();
					}
				}
			}
			String tags = abcf.getTags();
			String[] tag = tags.trim().split(",,");
			if(tag != null){
				for(int i=0;i<tag.length;i++){
					sql = "SELECT tag_id FROM tag WHERE tag = ?";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1, tag[i].toLowerCase());
					long tag_id = -1;
					rs.close();
					rs = pstmt.executeQuery();
					if(rs.next()){
						tag_id = rs.getInt(1);
					}else{
						sql = "INSERT INTO tag (tag,lastupdate) VALUES (?,now())";
						pstmt.close();
						pstmt = conn.conn.prepareStatement(sql);
						pstmt.setString(1, tag[i].toLowerCase());
						pstmt.executeUpdate();
						
						rs.close();
						sql = "SELECT LAST_INSERT_ID()";
						rs = conn.getResultSet(sql);
						if(rs.next()){
							tag_id = rs.getLong(1);
						}
						rs.close();
					}
					sql = "INSERT INTO tags (tag_id,userprofile_id,lastupdate) VALUES " +
							"(?,?,now())";
					pstmt.close();
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setLong(1, tag_id);
					pstmt.setLong(2, userprofile_id);
					pstmt.executeUpdate();
					pstmt.close();
					rs.close();
				}
			}
			
			
		}catch(SQLException e){
			try {
				if (pstmt != null) pstmt.close();			
				conn.conn.close();
				conn = null;
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			System.out.println(e.getMessage().toString());
			return mapping.findForward("Failure");
		}

			
		//HttpSession session = request.getSession();
		if(session.getAttribute("HideBar")!=null){
			session.removeAttribute("HideBar");
		}
		session.setAttribute("menu","colloquium");

		//Call recTalk
		/*try {
			//System.out.println(url_to_get);
			URL url = new URL("http://localhost:8080/recTalk/userprofile.jsp?user_id=" + ub.getUserID());
			//make connection
			URLConnection urlc = url.openConnection();
	        *//** Some web servers requires these properties *//*
	        urlc.setRequestProperty("User-Agent", 
	                "Profile/MIDP-1.0 Configuration/CLDC-1.0");
	        urlc.setRequestProperty("Content-Length", "0");
	        urlc.setRequestProperty("Connection", "close");
	        //urlc.connect();
	
			//get result
			BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
	
			br.close();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		/*try {
			Runtime rt = Runtime.getRuntime();
			Process pr = rt.exec("curl http://localhost:8080/recTalk/userprofile.jsp?user_id=" + ub.getUserID() + " > /dev/null &");
			
			//get result
			BufferedReader br = new BufferedReader(new InputStreamReader(pr.getInputStream()));
	
			br.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		return mapping.findForward("Success");
	}	
	
}