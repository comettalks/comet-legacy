package edu.pitt.sis;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import edu.pitt.sis.db.connectDB;

public class CometStemmer {
	
	public CometStemmer(connectDB conn) throws SQLException, IOException {
		String sql = "SELECT col_id FROM colloquium";// WHERE col_id >= 1119";
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			long col_id = rs.getLong("col_id");
			new CometStemmer(conn, col_id);
		}
	}
	
	public CometStemmer(connectDB conn, long col_id) throws SQLException, IOException {
		String sql = "SELECT title,detail FROM colloquium WHERE col_id=" + col_id;
		ResultSet rs = conn.getResultSet(sql);
		if(rs.next()){
			String title = rs.getString("title");
			String detail = rs.getString("detail");
			
			Html2Text htmlParser = new Html2Text();
			removeStopWords rsw = new removeStopWords();
			
			title = cleanNstem(title, htmlParser, rsw);
			detail = cleanNstem(detail, htmlParser, rsw);
			
			HashMap<String, Integer> title_unigram_tf = extractTF(title,1);
			HashMap<String, Integer> detail_unigram_tf = extractTF(detail,1);
			
			HashMap<String, Integer> title_bigram_tf = extractTF(title,2);
			HashMap<String, Integer> detail_bigram_tf = extractTF(detail,2);

			if(title_unigram_tf != null || detail_unigram_tf != null){
				sql = "DELETE FROM colterm WHERE ngram=1 AND col_id=" + col_id;
				conn.executeUpdate(sql);
				
				if(title_unigram_tf != null){
					for(String term : title_unigram_tf.keySet()){
						int freq = title_unigram_tf.get(term);
						sql = "INSERT INTO colterm (col_id,termtype,term,freq,ngram,timestamp) VALUES (?,?,?,?,1,NOW())";
						PreparedStatement pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, col_id);
						pstmt.setString(2, "title");
						pstmt.setString(3, term);
						pstmt.setInt(4, freq);
						pstmt.executeUpdate();
						pstmt.close();
					}
				}
				
				if(detail_unigram_tf != null){
					for(String term : detail_unigram_tf.keySet()){
						int freq = detail_unigram_tf.get(term);
						sql = "INSERT INTO colterm (col_id,termtype,term,freq,ngram,timestamp) VALUES (?,?,?,?,1,NOW())";
						PreparedStatement pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, col_id);
						pstmt.setString(2, "abstract");
						pstmt.setString(3, term);
						pstmt.setInt(4, freq);
						pstmt.executeUpdate();
						pstmt.close();
					}
				}
				
			}
			
			if(title_bigram_tf != null || detail_bigram_tf != null){
				sql = "DELETE FROM colterm WHERE ngram=2 AND col_id=" + col_id;
				conn.executeUpdate(sql);
				
				if(title_bigram_tf != null){
					for(String term : title_bigram_tf.keySet()){
						int freq = title_bigram_tf.get(term);
						sql = "INSERT INTO colterm (col_id,termtype,term,freq,ngram,timestamp) VALUES (?,?,?,?,2,NOW())";
						PreparedStatement pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, col_id);
						pstmt.setString(2, "title");
						pstmt.setString(3, term);
						pstmt.setInt(4, freq);
						pstmt.executeUpdate();
						pstmt.close();
					}
				}
				
				if(detail_bigram_tf != null){
					for(String term : detail_bigram_tf.keySet()){
						int freq = detail_bigram_tf.get(term);
						sql = "INSERT INTO colterm (col_id,termtype,term,freq,ngram,timestamp) VALUES (?,?,?,?,2,NOW())";
						PreparedStatement pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, col_id);
						pstmt.setString(2, "abstract");
						pstmt.setString(3, term);
						pstmt.setInt(4, freq);
						pstmt.executeUpdate();
						pstmt.close();
					}
				}
				
			}
		}
		
	}

	private String cleanNstem(String content, Html2Text htmlParser, removeStopWords rsw) throws IOException{
		//Cleaning and stemming processes
		content = content.trim().replaceAll("\\<.*?>"," ");
		htmlParser.parse(content);
		content = htmlParser.getText();
		content = rsw.getResult(content);
		content = RunKStemmer.transform(content);
		return content;
	}
	
	private HashMap<String, Integer> extractTF(String content,int ngram){
		/**
		 * Extracting Term Frequency (TF)
		 * */
		String[] token = content.split("\\s+");
		HashMap<String, Integer> tfMap = null;
		if(token != null){
			tfMap = new HashMap<String, Integer>();
			for(int i=0;i < token.length - ngram;i++){
				int freq = 0;
				String term = token[i];
				for(int j=1;j<ngram;j++){
					term += " " + token[i + j];
				}
				if(tfMap.containsKey(term)){
					freq = tfMap.get(term);
				}
				freq++;
				tfMap.put(term, freq);
			}
		}
		return tfMap;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		connectDB conn = new connectDB();
		try {
			new CometStemmer(conn);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
