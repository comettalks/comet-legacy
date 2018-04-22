package edu.pitt.sis;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import edu.pitt.sis.db.connectDB;

public class FetchNE {

	/**
	 * @param args
	 */
	public static void getNameEntity(long col_id){
	//public static void main(String args[]){
		//long col_id = 19;
		try {
			URL url = new URL("http://api.opencalais.com/enlighten/rest/");
			String license = "t32k95r9k8n9ftdp256e8esw";
			String paramsXML = "<c:params xmlns:c=\"http://s.opencalais.com/1/pred/\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">" +
								"<c:processingDirectives c:contentType=\"text/txt\" c:enableMetadataType=\"GenericRelations\" c:outputFormat=\"text/simple\">" +
								"</c:processingDirectives>" +
								"<c:userDirectives c:allowDistribution=\"true\" c:allowSearch=\"true\" c:externalID=\"17cabs901\" c:submitter=\"jahn\">" +
								"</c:userDirectives>" +
								"<c:externalMetadata>" +
								"</c:externalMetadata>" +
								"</c:params>";
		
			try {
				String sql = "SELECT c.col_id,c.title,s.name,h.host,c.location,c.detail " +
								"FROM colloquium c,speaker s,host h " +
								"WHERE c.speaker_id = s.speaker_id AND " +
								"c.host_id = h.host_id AND " +
								"c.col_id = " + col_id;
				
				connectDB conn = new connectDB();
				ResultSet rs = conn.getResultSet(sql);

				try {
					if(rs.next()){
						col_id = rs.getLong("col_id");
					
						String content = rs.getString("title") + 
									"\n" + rs.getString("name") + 
									"\n" + rs.getString("host") +
									"\n" + rs.getString("location") +
									"\n" + rs.getString("detail");
						if(content.length() > 100000){
							content = content.substring(0, 99999);
						}
						
						String query = "licenseID=" + URLEncoder.encode(license,"UTF-8") + "&" +
										"content=" + URLEncoder.encode(content, "UTF-8") + "&" +
										"paramsXML=" + URLEncoder.encode(paramsXML, "UTF-8");
	
						//make connection
						URLConnection urlc = url.openConnection();
					
						//use post mode
						urlc.setDoOutput(true);
						urlc.setAllowUserInteraction(false);
	
						//send query
						PrintStream ps = new PrintStream(urlc.getOutputStream());		
						ps.print(query);
						ps.close();
						
						//get result
						BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
						String line = null;
						String result = "";
						while ((line = br.readLine())!=null) {
							System.out.println(line);
							result += line;
						}
			
						br.close();
						
						//save opencalais response
						sql = "INSERT INTO opencalais (col_id,content,output,_date) VALUES (?,?,?,NOW())";
						PreparedStatement pstmt = conn.conn.prepareStatement(sql);
						pstmt.setLong(1, col_id);
						pstmt.setString(2, content);
						pstmt.setString(3, result);
						pstmt.executeUpdate();
						
						try {
							Document document  = DocumentHelper.parseText(result);
						
							Element root = document.getRootElement();
							
							//topics and topic tables were merged into entities and entity tables
							//sql = "DELETE FROM topics WHERE col_id = " + col_id;
							//conn.executeUpdate(sql);
							sql = "DELETE FROM entities WHERE col_id = " + col_id;
							conn.executeUpdate(sql);
							
				            // iterate through child elements of root with element name "CalaisSimpleOutputFormat"
				            for (Iterator i = root.elementIterator("CalaisSimpleOutputFormat"); i.hasNext(); ) {
				            	Element element = (Element)i.next();
					            for(Iterator j = element.elementIterator();j.hasNext();){
					            	Element e = (Element)j.next();
					            	System.out.println(e.getName() + " : " + e.getText());
					            	if(e.getName().trim().equalsIgnoreCase("topics")){//Insert topics => entities
						            	for(Iterator l = e.elementIterator();l.hasNext();){
						            		Element ee = (Element)l.next();
					    	            	System.out.println(ee.getName() + " : " + ee.getText());
					    	            	
					    	            	sql = "SELECT entity_id FROM entity WHERE entity = ?";
					    	            	
					    	            	pstmt = conn.conn.prepareStatement(sql);
					    	            	pstmt.setString(1, ee.getText().replaceAll("_", " "));
					    	            	ResultSet rst = pstmt.executeQuery();
					    	            	
					    	            	long entity_id = -1;
					    	            	
					    	            	if(rst.next()){
					    	            		entity_id = rst.getLong("entity_id");
					    	            	}else{
					    	            		sql = "INSERT INTO entity (entity,_type,_date) VALUES (?,'Topic',NOW())";
					    	            		pstmt = conn.conn.prepareStatement(sql);
					    	            		pstmt.setString(1, ee.getText());
					    	            		pstmt.executeUpdate();
					    	            		
					    	            		sql = "SELECT LAST_INSERT_ID()";
					    	            		ResultSet rsst = conn.getResultSet(sql);
					    	            		if(rsst.next()){
					    	            			entity_id = rsst.getLong(1);
					    	            		}
					    	            	}
					    	            	
					    	            	sql = "INSERT INTO entities (entity_id,col_id) VALUES (?,?)";
					    	            	
					    	            	pstmt = conn.conn.prepareStatement(sql);
					    	            	pstmt.setLong(1, entity_id);
					    	            	pstmt.setLong(2, col_id);
					    	            	pstmt.executeUpdate();
					    	            	//for(Iterator m = e.attributeIterator();m.hasNext();){
					    	            	//	Attribute aa = (Attribute)m.next();
					    	            	//	System.out.println(aa.getName() + " : " + aa.getText());
					    	            	//}
						            	}
					            		
					            	}else{
					            		String entity = e.getText();
					            		String _type = e.getName();
					            		String normalized = "";
					            		String other = "";
					            		int count = -1;
					            		double relevance = 0.0;
						            	for(Iterator k = e.attributeIterator();k.hasNext();){
						            		Attribute a = (Attribute)k.next();
						            		System.out.println(a.getName() + " : " + a.getText());
						            		if(a.getName().equalsIgnoreCase("count")){
						            			count = Integer.parseInt(a.getText());
						            		}else if(a.getName().equalsIgnoreCase("relevance")){
						            			relevance = Double.parseDouble(a.getText());
						            		}else if(a.getName().equalsIgnoreCase("normalized")){
						            			normalized = a.getText();
						            		}else{
						            			other += a.getText();
						            		}
						            		
						            	}
					            		
						            	//Find an entity in db
						            	sql = "SELECT entity_id FROM entity WHERE entity = ?";
						            	pstmt = conn.conn.prepareStatement(sql);
						            	pstmt.setString(1, entity);
						            	ResultSet rsEntity = pstmt.executeQuery();
						            	
						            	long entity_id = -1;
						            	
						            	if(rsEntity.next()){
						            		entity_id = rsEntity.getLong("entity_id");
						            	}else{
						            		sql = "INSERT INTO entity (entity,_type,normalized,other,_date) VALUES (?,?,?,?,NOW())";
						            		pstmt = conn.conn.prepareStatement(sql);
						            		pstmt.setString(1, entity);
						            		pstmt.setString(2, _type);
						            		pstmt.setString(3, normalized);
						            		pstmt.setString(4, other);
						            		pstmt.executeUpdate();
						            		
						            		sql = "SELECT LAST_INSERT_ID()";
						            		rsEntity = conn.getResultSet(sql);
						            		if(rsEntity.next()){
						            			entity_id = rsEntity.getLong(1);
						            		}
						            	}

						            	sql = "INSERT INTO entities (entity_id,relevance,occur,col_id) VALUES (?,?,?,?)";
				    	            	
				    	            	pstmt = conn.conn.prepareStatement(sql);
				    	            	pstmt.setLong(1, entity_id);
				    	            	pstmt.setDouble(2, relevance);
				    	            	pstmt.setInt(3, count);
				    	            	pstmt.setLong(4, col_id);
				    	            	pstmt.executeUpdate();

					            	}
					            	
					            }
				            }
							                					                        
						} catch (DocumentException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					conn.conn.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}finally{
					conn = null;
				}
												
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//return 1;
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		getNameEntity(749);
	}

}
