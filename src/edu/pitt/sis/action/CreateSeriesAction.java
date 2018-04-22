package edu.pitt.sis.action;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

//import javax.jms.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.pitt.sis.beans.UserBean;
import edu.pitt.sis.db.*;
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
public class CreateSeriesAction extends Action {

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
			session.setAttribute("SubmitSeriesError", "Please login to create new series");
			return mapping.findForward("Login");
		}
		connectDB conn = new connectDB();
		PreparedStatement pstmt = null;
		CreateSeriesForm csf = (CreateSeriesForm)form;
		
		if(csf.getSeries_id().equalsIgnoreCase("0")){//Add new series
			try{
				String sql = "INSERT INTO series " +
						"(name,description,lastupdate,user_id,url,owner_id) " +
						"VALUES (?,?, now(),?,?,?);";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1,csf.getName());
				pstmt.setString(2,csf.getDescription());
				pstmt.setLong(3, ub.getUserID());
				pstmt.setString(4,csf.getUrl());
				pstmt.setLong(5, ub.getUserID());
				pstmt.execute();
				
				String series_id = "-1";
				sql = "SELECT LAST_INSERT_ID()";
				ResultSet rs = conn.getResultSet(sql);
				if(rs.next()){
					series_id = rs.getString(1);
					csf.setSeries_id(series_id);
				}
				pstmt.close();
				
				if(csf.getSponsor_id() != null){
					sql = "INSERT INTO affiliate_series (affiliate_id,series_id) VALUES ";
					for(int i=0;i<csf.getSponsor_id().length;i++){
						if(i!=0)sql += ",";
						sql += "(" + csf.getSponsor_id()[i] + "," + series_id + ")";
					}
					conn.executeUpdate(sql);
				}
			}catch(SQLException e){
				try {
					if (pstmt != null) pstmt.close();			
					if (conn.conn !=null) conn.conn.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				System.out.println(e.getMessage().toString());
				return mapping.findForward("Failure");
			}
		}else{//Edit series
			try{
				//Backup old version
				String sql = "INSERT INTO series_bk " +
						"(timestamp,series_id,name,description,lastupdate,user_id,url,owner_id) " +
						"SELECT NOW(),series_id,name,description,lastupdate,user_id,url,owner_id " +
						"FROM series WHERE series_id=" + csf.getSeries_id();
				conn.executeUpdate(sql);
				
				sql = "UPDATE series SET name=?,description=?,lastupdate=NOW(),user_id=?,url=? " +
						"WHERE series_id=?";
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1,csf.getName());
				pstmt.setString(2,csf.getDescription());
				pstmt.setLong(3, ub.getUserID());
				pstmt.setString(4, csf.getUrl());
				pstmt.setLong(5, Long.parseLong(csf.getSeries_id()));
				pstmt.execute();
				pstmt.close();
				
				sql = "DELETE FROM affiliate_series WHERE series_id=" + csf.getSeries_id();
				conn.executeUpdate(sql);

				if(csf.getSponsor_id() != null){
					sql = "INSERT INTO affiliate_series (affiliate_id,series_id) VALUES ";
					for(int i=0;i<csf.getSponsor_id().length;i++){
						if(i!=0)sql += ",";
						sql += "(" + csf.getSponsor_id()[i] + "," + csf.getSeries_id() + ")";
					}
					conn.executeUpdate(sql);
				}

			}catch(SQLException e){
				try {
					if (pstmt != null) pstmt.close();			
					if (conn.conn !=null) conn.conn.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				System.out.println(e.getMessage().toString());
				return mapping.findForward("Failure");
			}
		}
		
		//Set Research Area
		try {
			if(csf.getSeries_id() != null){
				String sql = "DELETE FROM area_series WHERE series_id=" + csf.getSeries_id();
				conn.executeUpdate(sql);
				
				if(csf.getArea_id() != null){
					sql = "INSERT INTO area_series (area_id,series_id) VALUES ";
					for(int i=0;i<csf.getArea_id().length;i++){
						if(i!=0)sql += ",";
						sql += "(" + csf.getArea_id()[i] + "," + csf.getSeries_id() + ")";
					}
					conn.executeUpdate(sql);
				}
			}
			
			conn.conn.close();
			conn = null;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		session.setAttribute("createNewSeries",new Object());
		return mapping.findForward("Success");
	}
	
}