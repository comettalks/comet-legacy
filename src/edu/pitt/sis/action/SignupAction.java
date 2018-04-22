package edu.pitt.sis.action;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.*;

import edu.pitt.sis.BasicFunctions;
import edu.pitt.sis.MailNotifier;
import edu.pitt.sis.Rpx;
import edu.pitt.sis.StringEncrypter;
import edu.pitt.sis.db.*;
import edu.pitt.sis.StringEncrypter.EncryptionException;
import edu.pitt.sis.beans.*;
import edu.pitt.sis.form.SignupForm;

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
public class SignupAction extends Action {

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
	@SuppressWarnings("unchecked")
	public ActionForward execute(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response) {
		
		if (this.isCancelled(request)){ return(mapping.findForward("Failure"));}

		HttpSession session = request.getSession();
		SignupForm sf = (SignupForm) form;
		connectDB conn = new connectDB();

		
		String encryptionScheme = StringEncrypter.DESEDE_ENCRYPTION_SCHEME;		
		StringEncrypter encrypter;
		String EncryptedPassword = "";
		if(session.getAttribute("openIdMap") == null){
			try {
				encrypter = new StringEncrypter(encryptionScheme, BasicFunctions.encKey);
				EncryptedPassword = encrypter.encrypt(sf.getPassword());
			} catch (EncryptionException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
		}

		String sql = "";
		if(session.getAttribute("fAutoID")!=null){
			sql = "call sp_insertUser(?,?,?) ";
		}else{
			sql = "INSERT INTO userinfo_copy "
					+ "(name,email,pass,role_id,lastupdate) "
					+ "VALUES "
					+ "(?,?,?,1,NOW());";
		}
		
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setString(1, sf.getName());
			pstmt.setString(2, sf.getUserEmail());
			pstmt.setString(3, EncryptedPassword);

			pstmt.execute();
			pstmt.close();
			
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = conn.getResultSet(sql);
			if(rs.next()){
				int uid = rs.getInt(1);
				
				if(sf.getAffiliate_id() != null){
					if(session.getAttribute("fAutoID")!=null){
						sql = "DELETE FROM affiliate_user WHERE user_id = " + uid;
					}else{
						sql = "DELETE FROM affiliate_user_copy WHERE user_id = " + uid;
					}

					conn.executeUpdate(sql);
					
					if(session.getAttribute("fAutoID")!=null){
						sql = "INSERT INTO affiliate_user (affiliate_id,user_id) VALUES ";
					}else{
						sql = "INSERT INTO affiliate_user_copy (affiliate_id,user_id) VALUES ";
					}
					String[] aid = sf.getAffiliate_id();
					for(int i=0;i<aid.length;i++){
						if(i!=0){
							sql += ",";
						}
						sql += "("+ aid[i] + ","+ uid + ")";
					}
					conn.executeUpdate(sql);
				}
				
				UserBean ub = new UserBean();
//				sql = "call sp_retrieveUserInfo(?)";
//				pstmt = conn.conn.prepareStatement(sql);
//				pstmt.setInt(1, uid);
//				pstmt.execute();
//				rs.close();
//				
//				rs = pstmt.getResultSet();
//				if(rs.next()){
//					ub.setName(rs.getString("name"));
//					ub.setRoleID(rs.getInt("role_id"));
//					ub.setUserID(uid);
//				}
//				rs.close();
				
				if(session.getAttribute("fAutoID")!=null){
					ub.setName(sf.getName());
					ub.setRoleID(1);
					ub.setUserID(uid);
				}

				
				session.setAttribute("UserSession", ub);
				if(session.getAttribute("HideBar")!=null){
					session.removeAttribute("HideBar");
				}

				if(session.getAttribute("redirect") == null && session.getAttribute("fAutoID")!=null){
					session.setAttribute("menu","home");
				}
				
				//Call rpx map api
				/*if(session.getAttribute("rpx") != null){
					Rpx rpx = (Rpx)session.getAttribute("rpx");
					Map<String,String> openIdMap = (HashMap<String,String>)session.getAttribute("openIdMap");
					if(openIdMap != null){
						String identifier = openIdMap.get("identifier");
						rpx.map(identifier, String.valueOf(uid));
					}
					
				}*/
				
				if(session.getAttribute("fAutoID")!=null){
					String fAutoID = (String) session.getAttribute("fAutoID");
					session.removeAttribute("fAutoID");
					
					sql = "INSERT INTO extmapping (user_id,ext_id,exttable,mappedtime) VALUES (?,?,?,NOW())";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setInt(1, uid);
					pstmt.setLong(2, Long.parseLong(fAutoID));
					pstmt.setString(3, "extprofile.facebook");
					pstmt.executeUpdate();
					pstmt.close();
				}else{
					String unsignedhash = "user_id=" + uid + "&email=" + sf.getUserEmail();
					int signedhash = unsignedhash.hashCode();
					
					sql="UPDATE userinfo_copy SET signedhash=? where user_id=?";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1, String.valueOf(signedhash));
					pstmt.setLong(2, uid);
					pstmt.executeUpdate();
					pstmt.close();
					
					// Adapt to your needs:
					String localhost= "halley.exp.sis.pitt.edu";
					String mailhost= "smtp.gmail.com";//"smtp.pitt.edu";
					String mailuser= "NoReply";
					String subject = "CoMeT: Verifying your new CoMeT Account";
					String content = "Dear "+sf.getName()+",\n\n" + 
										"Welcome to join the CoMeT system!\n\n" + 
										"Just one more step then you are ready to go!\n\n" + 
										"Now we need you please click on this following URL or copy it to the browser to complete the verification process:\n" +
										"http://halley.exp.sis.pitt.edu/comet/verifyemail.do?h=" + signedhash + "\n" +
										"\n\n" + 
										"The CoMeT Team";
					String[] email_notify= {sf.getUserEmail()};//null;//
					/*ArrayList<String> en = new ArrayList<String>();
					en.add(sf.getUserEmail());
					email_notify = (String[])en.toArray();*/
			    
					MailNotifier mn= new MailNotifier(localhost, mailhost, mailuser, email_notify);
					try {
						mn.send(email_notify,subject,content);  
					} catch (Exception E) {
						System.out.println(E.toString());  
					}
				}
			}
			
			rs.close();
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
			SignupErrorBean seb = new SignupErrorBean();
			seb.setErrorDescription("System failure! Please try next time. : " + e.getMessage().toString());
			session.setAttribute("RegisterError",seb);
			return mapping.findForward("Failure");
		}
		//session.setAttribute("RegisterSuccess", new Object());
		if(session.getAttribute("fAutoID")!=null){
			return mapping.findForward("Success");	
		}else{
			return mapping.findForward("Email");
		}
		
		
	}
	
}