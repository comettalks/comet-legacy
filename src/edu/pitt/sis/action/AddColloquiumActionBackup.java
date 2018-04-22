package edu.pitt.sis.action;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

import javax.servlet.http.*;

import edu.pitt.sis.FetchNE;
import edu.pitt.sis.GoogleScholarCitation;
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
public class AddColloquiumActionBackup extends Action {

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
		if(session.getAttribute("Colloquium") != null)session.removeAttribute("Colloquium");
		if(session.getAttribute("SubmitTalkError") != null)session.removeAttribute("SubmitTalkError");
		UserBean ub = (UserBean)session.getAttribute("UserSession");
		if(ub == null){
			session.setAttribute("SubmitTalkError", "Please login to post talk to CoMeT");
			return mapping.findForward("Failure");
		}
		
		ColloquiumForm cqf = (ColloquiumForm)form;
		
		connectDB conn = new connectDB();
		PreparedStatement pstmt = null;
		
		long speaker_id = -1;
		String pic_url = "";
		
		
		//Search for existing speakers
		String[] speakersStr = cqf.getSpeaker().trim().split(";;");
		System.out.println(cqf.getAffiliation());
		String[] affiliationStr = cqf.getAffiliation().split(";;");
		String[] pictureStr = cqf.getPicURL().split(";;");
		
		ArrayList<String> speakers = new ArrayList<String>();
		HashMap<String, Long> speakerID = new HashMap<String,Long>();
		ArrayList<String> affiliations = new ArrayList<String>();
		ArrayList<String> pictures = new ArrayList<String>();
		for (int i = 0; i < speakersStr.length; i++){
			if (!speakersStr[i].equals("")){
				speakers.add(speakersStr[i]);
				if(affiliationStr[i].equals("null"))
					affiliationStr[i] = "";
				affiliations.add(affiliationStr[i]);
				pictures.add(pictureStr[i]);
			}
		}
		
		String sql;	
		/*try{		
			ResultSet rs = conn.getResultSet(sql);		
			if(rs.next()){
				col_id = rs.getLong("maximum");
				col_id++;
			}
			rs.close();
			
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		System.out.println(speakers.size());
		for (int j = 0; j < speakers.size(); j++){
			speaker_id = -1;
			pic_url = "";
			System.out.println(speakers.get(j));
			//String[] name = speakers.get(j).trim().split("\\s+");
			String concatname = "";
			/*for(int i=0;i<name.length;i++){
				concatname += name[i];
			}*/
			concatname = speakers.get(j).trim().replaceAll("\\s+", "");
			
			sql = "SELECT speaker_id, picURL FROM speaker WHERE concatname = ? and affiliation = ?";
			try {
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, concatname.toLowerCase());
				pstmt.setString(2, affiliations.get(j));
				//System.out.println(concatname.toLowerCase() + "\t" + affiliations.get(j));
				ResultSet rs = pstmt.executeQuery();
				
				if(rs.next()){
					//We shall assign the first speaker as the one in the colloquium table
					if(j==0){
						speaker_id = rs.getLong("speaker_id");
					}
					pic_url = rs.getString("picURL");
					
					speakerID.put(speakers.get(j), rs.getLong("speaker_id"));
				}
				rs.close();
				pstmt.close();
				//System.out.println(speaker_id + ";; " + concatname);
				/*if (pic_url == null || (!pic_url.equals(pictures.get(j))) ){				
					sql = "UPDATE speaker SET picURL=? WHERE speaker_id=?";
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1,pictures.get(j));
					pstmt.setLong(2,speaker_id);
					pstmt.executeUpdate();
					pstmt.close();
				}*/
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				try {				
					pstmt.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#1: upating speaker information) occured. Please try again.");
					return mapping.findForward("Failure");
				}
			}
			
			//If not there, insert new speakers
			if(speaker_id == -1){
				
				sql = "INSERT INTO speaker (name,concatname,affiliation, picURL) VALUES (?,?,?,?)";
				try {
					String speaker = "";
					/*for(int i=0;i<name.length;i++){
						speaker += name[i] + " ";
					}*/
					speaker = speakers.get(j).trim().replaceAll("\\s+", " ");
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1, speaker);
					pstmt.setString(2, concatname.toLowerCase());
					pstmt.setString(3, affiliations.get(j));
					pstmt.setString(4, pictures.get(j));
					pstmt.execute();
					pstmt.close();
									
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					try {
						pstmt.close();
					} catch (SQLException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#3: closing database connection) occured. Please try again.");
						return mapping.findForward("Failure");
					}				
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#2: updating speaker information) occured. Please try again.");
					return mapping.findForward("Failure");
				}
				sql = "SELECT LAST_INSERT_ID()";
				try {
					pstmt = conn.conn.prepareStatement(sql);
					ResultSet rs = pstmt.executeQuery();
					if(rs.next()){
						speaker_id = rs.getLong(1);
						
						speakerID.put(speakers.get(j), speaker_id);

						String speaker = "";
						/*for(int i=0;i<name.length;i++){
							speaker += name[i] + " ";
						}*/
						speaker = speakers.get(j).trim().replaceAll("\\s+", " ");
	
						//Make Google Scholar Module Obsolete because we would use MS Academic Search, Scopus, and new Google Citation crawlers instead
						/*GoogleScholarCitation gsc = new GoogleScholarCitation(speaker);
						int citations = gsc.getTotal_cites();
						int publications = gsc.getPublications();
						int h_index = gsc.getH_index();
						String _publication_link = gsc.getLink();
						
						sql = "UPDATE speaker SET citations=?,publications=?,hindex=?,gslink=?,lastupdate=NOW() WHERE speaker_id=?";
						pstmt = conn.conn.prepareStatement(sql);
						pstmt.setInt(1,citations);
						pstmt.setInt(2,publications);
						pstmt.setInt(3,h_index);
						pstmt.setString(4,_publication_link);
						pstmt.setLong(5,speaker_id);
						pstmt.executeUpdate();
						pstmt.close();*/
	
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		//Now host can be null so be aware of it!!!
		//Search for existing hosts
		long host_id = 0;
		if(cqf.getHost() != null){
			String hostconcat = "";
			/*String[] host = cqf.getHost().trim().split("\\s+");
			for(int i=0;i<host.length;i++){
				hostconcat += host[i];
			}*/
			hostconcat = cqf.getHost().replaceAll("\\s+", "");
			sql = "SELECT host_id FROM host WHERE hostconcat = ?";
			try {
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, hostconcat.toLowerCase());
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()){
					host_id = rs.getLong("host_id");
				}
				pstmt.close();
			} catch (SQLException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
				try {
					pstmt.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#5: closing database connection) occured. Please try again.");
					return mapping.findForward("Failure");
				}				
				session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#4: updating host information) occured. Please try again.");
				return mapping.findForward("Failure");
			}
			if(host_id == 0){
				sql = "INSERT INTO host (host,hostconcat) VALUES (?,?)";
				String strHost = "";
				/*for(int i=0;i<host.length;i++){
					strHost += host[i] + " ";
				}*/
				strHost = cqf.getHost().replaceAll("\\s+", " ");
				try {
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setString(1, strHost);
					pstmt.setString(2, hostconcat.toLowerCase());
					pstmt.execute();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					try {
						pstmt.close();
					} catch (SQLException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#7: closing database connection) occured. Please try again.");
						return mapping.findForward("Failure");
					}				
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#6: updating host information) occured. Please try again.");
					return mapping.findForward("Failure");	
				}
				sql = "SELECT LAST_INSERT_ID()";
				try {
					pstmt = conn.conn.prepareStatement(sql);
					ResultSet rs = pstmt.executeQuery();
					if(rs.next()){
						host_id = rs.getLong(1);
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		Date talkDate;
		Date beginTime;
		Date endTime;
		
		try {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy");
			SimpleDateFormat timeFormatter = new SimpleDateFormat("MM/dd/yyyy h:m a");
			talkDate = dateFormatter.parse(cqf.getTalkDate());
			beginTime = timeFormatter.parse(cqf.getTalkDate() + " " + cqf.getBeginHour() + ":" + cqf.getBeginMin() + " " + cqf.getBeginAMPM());
			endTime = timeFormatter.parse(cqf.getTalkDate() + " " + cqf.getEndHour() + ":" + cqf.getEndMin() + " " + cqf.getEndAMPM());
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			session.setAttribute("SubmitTalkError", "Technical problem (DateTime Conversion) occured. Please try again.");
			return mapping.findForward("Failure");
		}
		
		//Need to notify about subscribed series of this talk, too
		//Add/edit talk
		boolean isTalkNew = false;
		if(cqf.getCol_id() == 0){
			isTalkNew = true;
			//Insert talk
			sql = "INSERT INTO colloquium " +
					"(_date,begintime,endtime,location,detail,lastupdate," +
					"title,user_id,speaker_id,host_id,url,owner_id,video_url,slide_url,s_bio) " +
					"VALUES " +
					"(?,?,?,?,?,NOW(),?,?,?,?,?,?,?,?,?)";
			try {
				SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat timeFormatter = new SimpleDateFormat("yyyy-MM-dd H:m");
				
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, dateFormatter.format(talkDate));
				pstmt.setString(2, timeFormatter.format(beginTime));
				pstmt.setString(3, timeFormatter.format(endTime));
				pstmt.setString(4, cqf.getLocation());
				pstmt.setString(5, cqf.getDetail());
				pstmt.setString(6, cqf.getTitle());
				pstmt.setLong(7, ub.getUserID());
				//pstmt.setInt(8, Integer.parseInt(cqf.getTypeoftalk()));
				pstmt.setLong(8, speaker_id);
				pstmt.setLong(9, host_id);
				pstmt.setString(10, cqf.getUrl());
				pstmt.setLong(11, ub.getUserID());
				pstmt.setString(12, cqf.getVideo_url());
				pstmt.setString(13, cqf.getSlide_url());
				pstmt.setString(14, cqf.getS_bio());
				pstmt.executeUpdate();
				pstmt.close();
				
				//Fetch back colloquium id
				sql = "SELECT LAST_INSERT_ID()";
				ResultSet rs = conn.getResultSet(sql);
				if(rs.next()){
					cqf.setCol_id(rs.getLong(1));
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				session.setAttribute("SubmitTalkError", speaker_id + "Technical problem (DB Connection#4: updating talk information) occured. Please try again. " + e.getMessage());
				return mapping.findForward("Failure");
			}
			
		}else{//Edit
			//Copy from colloquium tbl to col_bk tbl
			sql = "INSERT INTO col_bk " +
					"(timestamp,col_id,_date,begintime,endtime,location,detail,lastupdate," +
					"title,user_id,owner_id,speaker_id,host_id,url,video_url,slide_url,s_bio) " +
					"SELECT NOW(),col_id,_date,begintime,endtime,location,detail,lastupdate," +
					"title,user_id,owner_id,speaker_id,host_id,url,video_url,slide_url,s_bio FROM colloquium WHERE col_id=" + cqf.getCol_id();
			conn.executeUpdate(sql);
			
			//Edit talk
			sql = "UPDATE colloquium  SET " +
					"_date = ? ,begintime =?,endtime = ?,location = ?,detail = ?,lastupdate = NOW()," +
					"title = ?,user_id = ?,speaker_id = ?,host_id = ?,url=?, video_url=?, slide_url=?, s_bio=? " +
					"WHERE col_id = ?";
			try {
				SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat timeFormatter = new SimpleDateFormat("yyyy-MM-dd H:m");
				
				pstmt = conn.conn.prepareStatement(sql);
				pstmt.setString(1, dateFormatter.format(talkDate));
				pstmt.setString(2, timeFormatter.format(beginTime));
				pstmt.setString(3, timeFormatter.format(endTime));
				pstmt.setString(4, cqf.getLocation());
				pstmt.setString(5, cqf.getDetail());
				pstmt.setString(6, cqf.getTitle());
				pstmt.setLong(7, ub.getUserID());
				//pstmt.setInt(8, Integer.parseInt(cqf.getTypeoftalk()));
				pstmt.setLong(8, speaker_id);
				pstmt.setLong(9, host_id);
				pstmt.setString(10, cqf.getUrl());
				pstmt.setString(11, cqf.getVideo_url());
				pstmt.setString(12, cqf.getSlide_url());
				pstmt.setString(13, cqf.getS_bio());
				pstmt.setLong(14, cqf.getCol_id());
				pstmt.executeUpdate();
				pstmt.close();
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				session.setAttribute("SubmitTalkError", speaker_id + " Technical problem (DB Connection#4: updating talk information) occured. Please try again. " + e.getMessage());
				return mapping.findForward("Failure");
			}
			
			/**
			 * 		
			 * */
			
		}
		
		
		//Assign speakers into the col_speaker table
		sql = "DELETE FROM col_speaker WHERE col_id=" + cqf.getCol_id();
		conn.executeUpdate(sql);
		for(int i=0;i<speakers.size();i++){
			String name = speakers.get(i);
			
			if(speakerID.containsKey(name)){
				sql = "INSERT INTO col_speaker (col_id, speaker_id) VALUES (?,?)";
				try{
					
					pstmt = conn.conn.prepareStatement(sql);
					pstmt.setLong(1, cqf.getCol_id());
					pstmt.setLong(2, speakerID.get(name));
					pstmt.execute();
					pstmt.close();
									
				}catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					try {
						pstmt.close();
					} catch (SQLException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
						session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#3: closing database connection) occured. Please try again.");
						return mapping.findForward("Failure");
					}				
					session.setAttribute("SubmitTalkError", "Technical problem (DB Connection#2: updating speaker information) occured. Please try again.");
					return mapping.findForward("Failure");
				}				
			}
		}
		
		HashSet<String> sponsorSet = new HashSet<String>();

		//Delete col_id in the seriescol table
		sql = "DELETE FROM seriescol WHERE col_id = " + cqf.getCol_id();
		conn.executeUpdate(sql);

		String raw_series = cqf.getSeries_id()[0];
		String sponsors_from_series = "";
		if(raw_series != null && raw_series.trim().length() > 0){
			String[] selected_series = raw_series.split(";;");
			raw_series = "";
			HashSet<Integer> seriesSet = new HashSet<Integer>();
			for(int i=0;i<selected_series.length;i++){
				try {
					int sID = Integer.parseInt(selected_series[i].trim());
					if(seriesSet.contains(sID)){
						continue;
					}
					if(!raw_series.equalsIgnoreCase("")){
						raw_series += ",";
					}
					raw_series += sID;
					seriesSet.add(sID);
					//Add series_id
					sql = "INSERT INTO seriescol (series_id,col_id) VALUES (" + 
							sID + "," + cqf.getCol_id() + ") ";
					
					conn.executeUpdate(sql);
					
					if(sponsors_from_series.length() > 0){
						sponsors_from_series += ",";
					}
					sponsors_from_series += sID;
					
				} catch (NumberFormatException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		}
		
		if(sponsors_from_series.length() > 0){
			sql = "SELECT DISTINCT affiliate_id FROM affiliate_series WHERE series_id IN (" + sponsors_from_series + ")";
			ResultSet rs = conn.getResultSet(sql);
			try {
				while(rs.next()){
					sponsorSet.add(rs.getString("affiliate_id"));
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		
		//Assign a colloquium to sponsor affiliations
		sql = "DELETE FROM affiliate_col WHERE col_id = " + cqf.getCol_id();
		conn.executeUpdate(sql);

		if(cqf.getSponsor_id() !=null){
			System.out.println(cqf.getSponsor_id());
			String[] sponsors = cqf.getSponsor_id().split(";;");
	/********************/	
			for (String sponsor: sponsors){
				if (!sponsor.trim().equals(""))
					sponsorSet.add(sponsor);
			}
	/********************/			
		}

		sql = "";
		for(String affiliate_id : sponsorSet){
			if(sql.length() > 0){
				sql+=",";
			}
			sql+= "(" + affiliate_id + "," + cqf.getCol_id() + ")";
		}
		if(sql.length() > 0){
			sql = "INSERT INTO affiliate_col (affiliate_id,col_id) VALUES " + sql;
			
			conn.executeUpdate(sql);
		}

		//Assign research areas into the col_area table
		sql = "DELETE FROM area_col WHERE col_id=" + cqf.getCol_id();
		conn.executeUpdate(sql);

		HashSet<String> areaSet = new HashSet<String>();
		//Get research areas from series
		if(raw_series != null & raw_series.trim().length() > 0){
			sql = "SELECT area_id FROM area_series WHERE series_id IN (" + raw_series + ")";
			ResultSet rs = conn.getResultSet(sql);
			try {
				while(rs.next()){
					areaSet.add(rs.getString("area_id"));
				}
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		
		if(cqf.getArea_id()!=null){
			for(int i=0;i<cqf.getArea_id().length;i++){
				if(!areaSet.contains(cqf.getArea_id()[i])){
					areaSet.add(cqf.getArea_id()[i]);
				}
			}
		}
		
		if(areaSet.size()>0){
			sql = "";
			for(String area_id : areaSet){
				if(sql.length() > 0){
					sql+=",";
				}
				sql+= "(" + area_id + "," + cqf.getCol_id() + ")";
			}
			if(sql.length() > 0){
				sql = "INSERT INTO area_col (area_id,col_id) VALUES " + sql;
				
				conn.executeUpdate(sql);
			}
		}

		//Acknowledge bookmark-this-talk and series-subscribed users if the talk is still up-to-date
		//Need to notify only important change: 
		//updated location, updated date, updated time, updated title (possibly talk canceled), updated paper link, updated video link, and update slide link
		
		try {
			int _updateno = 0;
			sql = "SELECT COUNT(*) _no FROM col_bk WHERE col_id=?";
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1, cqf.getCol_id());
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()){
				_updateno = rs.getInt("_no");
			}
			
			sql = "SELECT u.user_id,u.name,u.email, true _isbookmarked " +
					"FROM userinfo u JOIN userprofile up ON u.user_id=up.user_id " +
					"WHERE up.col_id=? " +
					"GROUP BY u.user_id,u.name,u.email " +
					"UNION " +
					"SELECT u.user_id,u.name,u.email, false _isbookmarked " +
					"FROM userinfo u JOIN final_subscribe_series fss ON fss.user_id = u.user_id " +
					"LEFT JOIN seriescol sc ON fss.series_id = sc.series_id " +
					"LEFT JOIN series s ON fss.series_id=s.series_id " +
					"WHERE sc.col_id=? " +
					"GROUP BY u.user_id,u.name,u.email ";
			pstmt = conn.conn.prepareStatement(sql);
			pstmt.setLong(1, cqf.getCol_id());
			pstmt.setLong(2, cqf.getCol_id());
			rs = pstmt.executeQuery();
			SimpleDateFormat dateFormatter = new SimpleDateFormat("MMM d, yyyy");
			SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm a");
			String _talkDate = dateFormatter.format(talkDate);
			String _beginTime = timeFormatter.format(beginTime);
			String _endTime = timeFormatter.format(endTime);
			while(rs.next()){
				String bname = rs.getString("name");
				String[] bemail = new String[1];
				bemail[0] = rs.getString("email");
				String user_id = rs.getString("user_id");
				
				//Is this talk bookmarked by this user?
				boolean isBookmarked = rs.getBoolean("_isbookmarked");//false;
				sql = "SELECT userprofile_id FROM userprofile WHERE user_id=" + user_id + " AND col_id=" + cqf.getCol_id();
				ResultSet rsExt = conn.getResultSet(sql);
				if(rsExt.next()){
					isBookmarked = true;
				}
				
				//Is there any subscribed series? If so, elaborate them
				String[] subSeries = null;
				sql = "SELECT s.name FROM final_subscribe_series fss JOIN series s ON fss.series_id=s.series_id " +
						"JOIN seriescol sc ON s.series_id=sc.series_id " +
						"WHERE fss.user_id=" + user_id + " AND sc.col_id=" + cqf.getCol_id() +
						" GROUP BY s.name";
				rsExt = conn.getResultSet(sql);
				while(rsExt.next()){
					String series = rsExt.getString("name");
					String[] temp = new String[(subSeries==null?1:subSeries.length)];
					if(subSeries != null){
						System.arraycopy(subSeries, 0, temp, 0, subSeries.length);
					}
					subSeries = temp;
					subSeries[subSeries.length-1] = series;
				}
				
				String[] speaker = cqf.getSpeaker().split(";;");
				String s = "";
				if(speaker != null){
					for(int i=0;i<speaker.length;i++){
						if(speaker[i].trim().length()>0){
							if(s.length() > 0){
								s += ", ";
							}
							s += speaker[i];
						}
					}
				}
				
				
				String localhost= "halley.exp.sis.pitt.edu";
				String mailhost= "smtp.gmail.com";
				String mailuser= "NoReply";
				MailNotifier mail = new MailNotifier(localhost,mailhost,mailuser,bemail);
				String emailContent = "Dear " + bname + "\n\n" +
				"Thank you for using CoMeT." +
				(isBookmarked?"\nThe talk you have bookmarked has been updated as shown below.":"") +
				//(isBookmarked && subSeries!=null?" and ":"") +
				(!isBookmarked&&subSeries!=null?"\nAs you are a subscriber to the " + subSeries[0] + "":"") +
				(!isBookmarked&&subSeries!=null?
					(subSeries.length>1?
						" and " + (subSeries.length==2?
							"" + subSeries[1]:"" + (subSeries.length-1) + " other")
						:"")
					:"") +
				(!isBookmarked&&subSeries!=null?(subSeries[0].indexOf("Series") >= 0||subSeries[0].indexOf("series") >= 0?"":" Series"):"") +
				(!isBookmarked&&subSeries!=null?", we wanted to let you know that the following event has been ":"") +
				(!isBookmarked?
						(subSeries!=null&&isTalkNew?"posted as shown below:\n\n":"updated as shown below:\n\n")
						:"") +
				"Title: " + cqf.getTitle() + "\n" +
				"Speaker: " + s +  "\n" +
				((cqf.getHost()!=null||cqf.getHost().trim().length()>0)?("Host: " + cqf.getHost() + "\n"):"") + 
				"Date: " + _talkDate + "\n" +
				"Time: " + _beginTime + " - " + _endTime + "\n" +
				"Location: " + cqf.getLocation() + "\n\n" +
				"Export to iCal: http://pittcomet.info/utils/_ical.jsp?col_id=" + cqf.getCol_id() + " \n" +
				"Export to Google Calendar: http://pittcomet.info/utils/_gcal.jsp?export=1&col_id=" + cqf.getCol_id() + " \n" +
				"More detail please visit http://pittcomet.info/presentColloquium.do?col_id=" + cqf.getCol_id();
				
				try {
					mail.send("CoMeT | " + (_updateno > 0?"[Update #" + _updateno + "]":"") + (subSeries!=null?"[Series Subscription]":"") + " " + cqf.getTitle(), emailContent);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		try {
			conn.conn.close();
			conn = null;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//Fetch Named Entity
		//FetchNE.getNameEntity(cqf.getCol_id());

		session.setAttribute("Colloquium", cqf);
			
		return mapping.findForward("Success");
	}	
}