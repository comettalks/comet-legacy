package edu.pitt.sis;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import edu.pitt.sis.MailNotifier;
import edu.pitt.sis.db.connectDB;

public class MailReminder {

	public static int remindBookmarks(){
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
		
		String subject = "CoMeT: Today Bookmarked Talks Reminder";

		if(today == Calendar.MONDAY){
			//Remind a whole week
			subject = "CoMeT: Weekly Bookmarked Talks Reminder";
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
		}
		
		String sql = "SELECT u.user_id,u.name,u.email FROM userinfo u WHERE u.user_id IN " +
					"(SELECT up.user_id FROM userprofile up JOIN colloquium c ON up.col_id = c.col_id WHERE " +
					"c._date >= '" + _beginDate + "' AND c._date <= '" + _endDate + "')";
		System.out.println(sql);
		connectDB conn = new connectDB();
		ResultSet rs = conn.getResultSet(sql);
		try {
			String[] email = new String[1];
			while(rs.next()){
				String user_id = rs.getString("user_id");
				String name = rs.getString("name");
				email[0] = rs.getString("email");
				
				System.out.println("Name: " + name + " Email: " + email[0]);

				String content = "Dear " + name + ",\n\n" + 
									"This e-mail is on behalf of the CoMeT Sysytem. " +
									"There are the list of talk(s) you have bookmarked as belows.";
				sql = "SELECT c.col_id,c.title,s.name,h.host,c.location,c.detail,date_format(c._date,_utf8'%W, %M %d, %Y') _date," +
						"date_format(c.begintime,_utf8'%l:%i %p') _begin, " +
						"date_format(c.endtime,_utf8'%l:%i %p') _end " +
						"FROM colloquium c,speaker s,host h,userprofile up " +
						"WHERE c.speaker_id = s.speaker_id AND " +
						"c.host_id = h.host_id AND " +
						"c.col_id = up.col_id AND " +
						"up.user_id = " + user_id + " AND " + 
						"c._date >= '" + _beginDate + "' AND c._date <= '" + _endDate + "' " + 
						" ORDER BY c._date";
				
				ResultSet rsExt = conn.getResultSet(sql);
				while(rsExt.next()){
					String col_id = rsExt.getString("col_id");
					String title = rsExt.getString("title");
					String speaker = rsExt.getString("name");
					String host = rsExt.getString("host");
					String location = rsExt.getString("location");
					String detail = rsExt.getString("detail");
					String _date = rsExt.getString("_date");
					String _begin = rsExt.getString("_begin");
					String _end = rsExt.getString("_end");

					System.out.println(_date);

					content += "\n\nTitle: " + title + "\n" +
								"Speaker: " + speaker +  "\n" +
								"Host: " + host + "\n" + 
								"Date: " + _date + "\n" +
								"Time: " + _begin + " - " + _end + "\n" +
								"Location: " + location + "\n" +
								"More detail please visit http://halley.exp.sis.pitt.edu/comet/presentColloquium.do?col_id=" + col_id;
					
				}
				
				System.out.println(content);

				MailNotifier mn= new MailNotifier(localhost, mailhost, mailuser, email);
				try {
					mn.send(subject, content);
					sentEmailNo++;
				} catch (Exception E) {
					System.err.println(E.toString());  
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
		remindBookmarks();
	}

}
