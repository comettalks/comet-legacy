package edu.pitt.sis.db;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author Administrator
 */
public class connectSSHDB {
    public Connection conn;
    /** Creates a new instance of connectDB */
    public connectSSHDB() {
    	//Establish an SSH tunnel
		try {
			Runtime rt = Runtime.getRuntime();
			Process pr = rt.exec("/bin/bash ~/./checkport8888.sh");
			
			//get result
			BufferedReader br = new BufferedReader(new InputStreamReader(pr.getInputStream()));
			String str = "";
			while((str = br.readLine()) != null){
				System.out.println(str);
			}
			
			br.close();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

    	
    	/*DataSource ds;
    	try {
			String context_name = "java:comp/env/jdbc/cn3fromcn20";
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

		String serverName = "127.0.0.1";//"amber.exp.sis.pitt.edu";//
		String myDatabase = "cn3fromcn20";
		String username = "conference";
		String password = "navigator";
		String url = "jdbc:mysql://" + serverName + ":8888/" + 
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
    
    public boolean executeUpdate(String sql){
        Statement stmt = null;
        try{
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);
        }catch(SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());  
            return false;
        }
        return true;
    }
    
    public int executeInsert(String sql){
        Statement stmt = null;
        int autoinckey = -1;
        try{
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);
            ResultSet rs = stmt.executeQuery("SELECT LAST_INSERT_ID()");
            if(rs.next()){
                autoinckey = rs.getInt(1);
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
    
    public static void main(String[] args){
    	new connectSSHDB();
    }
    
}
