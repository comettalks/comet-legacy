package edu.pitt.sis.db;

import java.sql.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author Administrator
 */
public class connectDB {
    public Connection conn;
    
    /** Creates a new instance of connectDB */
    public connectDB() {
    	/*DataSource ds;
    	try {
			String context_name = "java:comp/env/jdbc/colloquia";
			Context initCtx = new InitialContext();
			Object obj = initCtx.lookup(context_name);
			ds = (DataSource)obj;
			conn = ds.getConnection();
		} catch (NamingException e) {
			// TODO Auto-generated catch block
            System.out.println("Naming Exception: " + e.toString());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
            System.out.println("SQL Exception: " + e.toString());
		}*/
    	
		String serverName = "127.0.0.1";
		String myDatabase = "colloquia";
		String username = "chirayu";
		String password = "yes";
		String url = "jdbc:mysql://" + serverName + ":8888/" + //":3306/" + 
						myDatabase + "?user=" + username + "&" + "password=" + password;
		//System.out.println(url);
        try{
            //Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection(url);//("jdbc:odbc:AAA");                        
        }catch(Exception ex){
            // handle any errors
            System.out.println("Load Driver Exception: " + ex.toString());
        }
    }
    
    public ResultSet getResultSet(String sql){
        Statement stmt = null;        
        ResultSet rs = null;
        try{
            stmt = conn.createStatement();
            if(stmt.execute(sql)){
                rs = stmt.getResultSet();
            }
        }catch(SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        return rs;
    }
    
    public void executeUpdate(String sql){
        Statement stmt = null;
        try{
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);
        }catch(SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());            
        }
    }
    
    public long executeInsert(String sql){
        Statement stmt = null;
        long autoinckey = -1;
        try{
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);
            ResultSet rs = stmt.executeQuery("SELECT LAST_INSERT_ID()");
            if(rs.next()){
                autoinckey = rs.getLong(1);
            }
            rs.close();
            rs = null;
        }catch(SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());            
        }
        return autoinckey;
    }
    
}
