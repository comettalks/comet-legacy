package edu.pitt.sis;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import edu.pitt.sis.MailNotifier;
import edu.pitt.sis.db.connectDB;

public class MailRecommender {

	public static int recommendTalks(){
		int sentEmailNo = 0;
		String localhost= "halley.exp.sis.pitt.edu";
		String mailhost= "smtp.gmail.com";//"smtp.pitt.edu";
		String mailuser= "NoReply";
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(new Date());
	    int year = calendar.get(Calendar.YEAR);
	    int month = calendar.get(Calendar.MONTH) + 1;
	    int day_of_month = calendar.get(Calendar.DAY_OF_MONTH);
		int today = calendar.get(Calendar.DAY_OF_WEEK);
		String _beginDate = year + "-" + month + "-" + day_of_month;
		String _endDate = _beginDate;
		
		String subject = "CoMeT: Today Talks Recommendation";

		day_of_month += 6;
		if(day_of_month > calendar.getActualMaximum(Calendar.DAY_OF_MONTH)){
			month++;
			if(month==12){
				month=1;
				year++;
			}
			day_of_month -= calendar.getActualMaximum(Calendar.DAY_OF_MONTH); 
		}
		_endDate = year + "-" + month + "-" + day_of_month; 

		if(today == Calendar.MONDAY){
			//Reccommend a whole week
			subject = "CoMeT: Weekly Talks Recommendation";
		}else{//Recommend everyday is not a good idea
			return sentEmailNo;			
		}
		
		String sql = "SELECT u.user_id,u.name,u.email FROM userinfo u WHERE u.ispilot = 1 AND (u.user_id IN " +
					"(SELECT ru.user_id FROM rec_user ru JOIN colloquium c ON ru.col_id = c.col_id " +
					"WHERE ru.weight > 1.49 AND " +
					"c._date >= '" + _beginDate + "' AND c._date <= '" + _endDate + "') " +
					"OR u.user_id IN " +
					"(SELECT up.user_id FROM rec_comm rc JOIN colloquium c ON rc.col_id = c.col_id " +
					"JOIN contribute ct ON rc.comm_id = ct.comm_id " +
					"JOIN userprofile up ON ct.userprofile_id = ct.userprofile_id " +
					"WHERE rc.weight > 1.49 AND " +
					"c._date >= '" + _beginDate + "' AND c._date <= '" + _endDate + "')) ";
		//System.out.println(sql);
		connectDB conn = new connectDB();
		ResultSet rs = conn.getResultSet(sql);
		try {
			String[] email = new String[1];
			while(rs.next()){
				String user_id = rs.getString("user_id");
				String name = rs.getString("name");
				email[0] = rs.getString("email");
				
				String header = "Dear " + name + ",\n\n" + 
									"This e-mail is on behalf of the CoMeT Sysytem. ";
				
				//Talks2User Recommendation
				String recUser = "";
				
				sql = "SELECT c.col_id,c.title,s.name,h.host,c.location,c.detail,date_format(c._date,_utf8'%W, %M %d, %Y') _date," +
						"date_format(c.begintime,_utf8'%l:%i %p') _begin, " +
						"date_format(c.endtime,_utf8'%l:%i %p') _end,date_format(c._date,_utf8'%e') _day " +
						"FROM colloquium c,speaker s,host h,rec_user ru " +
						"WHERE c.speaker_id = s.speaker_id AND " +
						"c.host_id = h.host_id AND " +
						"c.col_id = ru.col_id AND " +
						"ru.weight > 1.49 AND " +
						"ru.user_id=" + user_id + " AND " +
						"c._date >='" + _beginDate + "' " +
						"AND c._date <='" + _endDate + "' " +
						"AND c.col_id NOT IN (SELECT col_id FROM userprofile WHERE user_id=" + user_id + ") " +
						"ORDER BY ru.weight DESC,c._date,c.begintime,c.endtime LIMIT 5";
				//System.out.println(sql);
				
				ResultSet rsExt = conn.getResultSet(sql);
				while(rsExt.next()){
					String col_id = rsExt.getString("col_id");
					String title = rsExt.getString("title");
					String speaker = rsExt.getString("name");
					String host = rsExt.getString("host");
					String location = rsExt.getString("location");
					//String detail = rsExt.getString("detail");
					String _date = rsExt.getString("_date");
					String _begin = rsExt.getString("_begin");
					String _end = rsExt.getString("_end");
					int _day = rsExt.getInt("_day");
					
					//System.out.println(_day);

					if(today != Calendar.MONDAY){
						if(calendar.get(Calendar.DAY_OF_MONTH) == _day){
							
							recUser += "\n\nTitle: " + title + "\n" +
										"Speaker: " + speaker +  "\n" +
										"Host: " + host + "\n" + 
										"Date: " + _date + "\n" +
										"Time: " + _begin + " - " + _end + "\n" +
										"Location: " + location + "\n" +
										"More detail please visit http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=" + col_id;

						}
					}else{

						recUser += "\n\nTitle: " + title + "\n" +
									"Speaker: " + speaker +  "\n" +
									"Host: " + host + "\n" + 
									"Date: " + _date + "\n" +
									"Time: " + _begin + " - " + _end + "\n" +
									"Location: " + location + "\n" +
									"More detail please visit http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=" + col_id;
					}
				}
				
				if(recUser.length() > 0){
					recUser = "There are the list of talk(s) we recommend to you as belows." + recUser;
				}
				
				//Middle
				String middle = "\n\nAlso, there are the list of talk(s) we recommend to your group(s) as belows.";
				
				//Talks2Group Recommendation
				String recGroups = "";
				
				/*sql = "SELECT cc.comm_name,ct.comm_id FROM rec_comm rc JOIN colloquium c ON rc.col_id = c.col_id " +
						"JOIN contribute ct ON rc.comm_id = ct.comm_id " +
						"JOIN userprofile up ON ct.userprofile_id = ct.userprofile_id " +
						"JOIN community cc ON ct.comm_id = cc.comm_id " +
						"WHERE rc.weight > 0.99 AND up.user_id = " + user_id +  
						" AND c._date >= '" + _beginDate + "' AND c._date <= '" + _endDate + "' " +
						"GROUP BY cc.comm_name,ct.comm_id";
				
				ResultSet rsComm = conn.getResultSet(sql);
				while(rsComm.next()){
					String comm_name = rsComm.getString("comm_name");
					String comm_id = rsComm.getString("comm_id");
					
					String recGroup = "";
					
					sql = "SELECT c.col_id,c.title,s.name,h.host,c.location,c.detail,date_format(c._date,_utf8'%W, %M %d, %Y') _date," +
							"date_format(c.begintime,_utf8'%l:%i %p') _begin, " +
							"date_format(c.endtime,_utf8'%l:%i %p') _end,date_format(c._date,_utf8'%e') _day " +
							"FROM colloquium c,speaker s,host h,rec_comm rc " +
							"WHERE c.speaker_id = s.speaker_id AND " +
							"c.host_id = h.host_id AND " +
							"c.col_id = rc.col_id AND " +
							"rc.weight > 0.99 AND rc.comm_id=" + comm_id + " AND " +
							"c._date >= '" + _beginDate + "' AND " +
							"c._date <= '" + _endDate + "' " +
							" ORDER BY rc.weight DESC,c._date,c.begintime,c.endtime LIMIT 5";
					
					rsExt = conn.getResultSet(sql);
					while(rsExt.next()){
						String col_id = rsExt.getString("col_id");
						String title = rsExt.getString("title");
						String speaker = rsExt.getString("name");
						String host = rsExt.getString("host");
						String location = rsExt.getString("location");
						//String detail = rsExt.getString("detail");
						String _date = rsExt.getString("_date");
						String _begin = rsExt.getString("_begin");
						String _end = rsExt.getString("_end");
						int _day = rsExt.getInt("_day");
						
						//System.out.println(_day + " : " + calendar.get(Calendar.DAY_OF_MONTH));
		
						if(today != Calendar.MONDAY){
							if(calendar.get(Calendar.DAY_OF_MONTH) == _day){
								
								recGroup += "\n\nTitle: " + title + "\n" +
											"Speaker: " + speaker +  "\n" +
											"Host: " + host + "\n" + 
											"Date: " + _date + "\n" +
											"Time: " + _begin + " - " + _end + "\n" +
											"Location: " + location + "\n" +
											"More detail please visit http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=" + col_id;

							}
						}else{
							
							recGroup += "\n\nTitle: " + title + "\n" +
										"Speaker: " + speaker +  "\n" +
										"Host: " + host + "\n" + 
										"Date: " + _date + "\n" +
										"Time: " + _begin + " - " + _end + "\n" +
										"Location: " + location + "\n" +
										"More detail please visit http://washington.sis.pitt.edu/comet/presentColloquium.do?col_id=" + col_id;
							
						}
					}
					
					if(recGroup.length() > 0){
						recGroup = "\n\nGroup: " + comm_name + recGroup;
						recGroups += recGroup;
					}
					
				}*/
				
				if(recUser.length() > 0 || recGroups.length() > 0){
					String content = header;
					if(recUser.length() > 0){
						content += recUser;
					}
					if(recGroups.length() > 0){
						content += middle + recGroups;
					}

					//System.out.println("Name: " + name + " Email: " + email[0]);
					//System.out.println(content);

					MailNotifier mn= new MailNotifier(localhost, mailhost, mailuser, email);
					try {
						mn.send(subject, content);
						sentEmailNo++;
					} catch (Exception E) {
						System.err.println(E.toString());  
					}
				}

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			try {
				conn.conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			conn = null;
		}
		return sentEmailNo;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		recommendTalks();
	}

}
