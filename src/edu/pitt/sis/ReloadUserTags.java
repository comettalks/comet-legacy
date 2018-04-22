package edu.pitt.sis;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;

import edu.pitt.sis.db.connectDB;

public class ReloadUserTags {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		connectDB con = new connectDB();
		PreparedStatement pstmt = null;
		
		try{
			pstmt = null;
			String sql = "SELECT userprofile_id,usertags FROM userprofile u";
			ResultSet rs = con.getResultSet(sql);
			long userprofile_id = -1;
			String usertags = "";
			while(rs.next()){
				userprofile_id = rs.getLong("userprofile_id");
				usertags = rs.getString("usertags");
				
				sql = "DELETE FROM tags WHERE userprofile_id = " + userprofile_id;
				con.executeUpdate(sql);

				String tags = usertags.toLowerCase().replaceAll(",", " ");
				String[] tag = tags.trim().split("\\s+");
				if(tag != null){
					for(int i=0;i<tag.length;i++){
						if(tag[i].trim().length() < 1)
							continue;
						sql = "SELECT tag_id FROM tag WHERE tag = ?";
						pstmt = con.conn.prepareStatement(sql);
						pstmt.setString(1, tag[i].toLowerCase().trim());
						long tag_id = -1;

						ResultSet rsTag = pstmt.executeQuery();
						if(rsTag.next()){
							tag_id = rsTag.getInt(1);
						}else{
							sql = "INSERT INTO tag (tag,lastupdate) VALUES (?,now())";
							pstmt.close();
							pstmt = con.conn.prepareStatement(sql);
							pstmt.setString(1, tag[i].toLowerCase());
							pstmt.executeUpdate();
							
							rsTag.close();
							sql = "SELECT LAST_INSERT_ID()";
							rsTag = con.getResultSet(sql);
							if(rsTag.next()){
								tag_id = rs.getLong(1);
							}
							rsTag.close();
						}
						sql = "INSERT INTO tags (tag_id,userprofile_id,lastupdate) VALUES " +
								"(?,?,now())";
						pstmt.close();
						pstmt = con.conn.prepareStatement(sql);
						pstmt.setLong(1, tag_id);
						pstmt.setLong(2, userprofile_id);
						pstmt.executeUpdate();
						pstmt.close();
						rsTag.close();
					}
				}
			}
			
		}catch(SQLException e){
			try {
				if (pstmt != null) pstmt.close();			
				con.conn.close();
				con.conn = null;
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			System.out.println(e.getMessage().toString());
		}

	}

}
