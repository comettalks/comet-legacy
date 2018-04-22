package edu.pitt.sis;

import java.sql.*;
import java.util.*;

import edu.pitt.sis.db.connectDB;

public class CoMeTKMedroid {
	private HashMap<Integer, HashSet<Integer>> cluster = new HashMap<Integer, HashSet<Integer>>();
	private HashSet<Integer> talkSet = new HashSet<Integer>();
	private connectDB conn;
	private int k=20;
	private int ngram=1;
	private double totalTalks = -99;
	HashMap<String, Double> IDFMap = new HashMap<String, Double>();//Key: Keyword; Value: idf score
	LinkedHashMap<Integer,HashMap<String,Double>> TFMap = new LinkedHashMap<Integer, HashMap<String,Double>>();//Key: col_id; Value: (Keyword, Occurrence)
	HashSet<Integer> outlierSet = new HashSet<Integer>();
	
	public CoMeTKMedroid(int k,int ngram) throws SQLException{
		this.k = k;
		this.ngram = ngram;
		conn = new connectDB();
		//Randomly assign k seeds from DB
		String sql = "SELECT col_id FROM (SELECT col_id FROM colterm WHERE ngram=" + ngram + " GROUP BY col_id) t " +
						"ORDER BY RAND() LIMIT " + k;
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			System.out.println("Init seed: " + rs.getInt("col_id"));
			cluster.put(rs.getInt("col_id"), null);
		}
		//Get all talks
		sql = "SELECT col_id FROM colterm WHERE ngram=" + ngram + " GROUP BY col_id ORDER BY col_id";
		rs = conn.getResultSet(sql);
		while(rs.next()){
			talkSet.add(rs.getInt("col_id"));
		}
		System.out.println("Done get all talks");
		//In case that it needs to calculate distance on the fly
		sql = "SELECT COUNT(*) totalTalks FROM (SELECT col_id FROM colterm WHERE ngram=" + ngram + " GROUP BY col_id) t";
		rs = conn.getResultSet(sql);
		if(rs.next()){
			totalTalks = rs.getDouble("totalTalks");
		}

	}
	
	public void clusterByCosSim(int round) throws SQLException{
		HashMap<String,Double> simMap = new HashMap<String,Double>();
		String sql = "SELECT col0_id,col1_id,sim FROM colsim WHERE ngram=" + ngram;
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			int c0id = rs.getInt("col0_id");
			int c1id = rs.getInt("col1_id");
			double sim = rs.getDouble("sim");
			String simid = "c0id" + c0id + "c1id" + c1id;
			if(c0id > c1id){
				simid = "c0id" + c1id + "c1id" + c0id;
			}
			simMap.put(simid, sim);
		}
		//Assigning them iterately
		for(int i=0;i<round;i++){
			if(i>0){
				//Find the new medroid in each cluster
				//By using the average of maximum similarity of all data points in the clusters
				HashMap<Integer,HashSet<Integer>> newCluster = new HashMap<Integer,HashSet<Integer>>();
				for(int seed : cluster.keySet()){
					HashSet<Integer> cSet = cluster.get(seed);
					double maxsim = 0;
					int newcid = -1;
					if(cSet==null)continue;
					for(int c0id : cSet){
						double accumsim = 0;
						for(int c1id : cSet){
							if(c0id != c1id){
								String simid = "c0id" + c0id + "c1id" + c1id;
								if(c0id > c1id){
									simid = "c0id" + c1id + "c1id" + c0id;
								}
								if(simMap.containsKey(simid)){
									accumsim += simMap.get(simid);
								}
							}
						}
						accumsim = accumsim/cSet.size();
						if(maxsim < accumsim){
							maxsim = accumsim;
							newcid = c0id;
						}
					}
					if(newcid > 0){
						newCluster.put(newcid, cSet);
						System.out.println("New medroid: " + newcid + " max accum sim: " + maxsim);
					}
				}
				//Clear old data, insert the new ones
				cluster.clear();
				cluster.putAll(newCluster);
			}
			//System.out.println("Before clearing, total initial seeds: " + cluster.size());
			//Reset data in all clusters
			for(int seed : cluster.keySet()){
				if(cluster.get(seed)!=null){
					cluster.put(seed, null);
				}
			}
			//System.out.println("After clearing, total initial seeds: " + cluster.size());
			//Assign data point into the closest cluster
			for(int cid : talkSet){
				//System.out.println("Considering data point: " + cid);
				double maxsim = 0;
				int closestSeed = -1;
				for(int seed : cluster.keySet()){
					if(seed==cid){
						maxsim = 1;
						closestSeed = seed;
						break;
					}else{
						String simid = "c0id" + cid + "c1id" + seed;
						if(cid > seed){
							simid = "c0id" + seed + "c1id" + cid;
						}
						if(simMap.containsKey(simid)){
							if(maxsim < simMap.get(simid)){
								maxsim = simMap.get(simid);
								closestSeed = seed;
							}
						}else{
							//Get seed doc representation
							HashMap<String,Double> doc0 = TFMap.get(seed);
							if(doc0 == null){
								doc0 = getTalkRepresentation(seed);
								TFMap.put(seed, doc0);
							}
							//Get data point representation
							HashMap<String,Double> doc1 = TFMap.get(cid);
							if(doc1 == null){
								doc1 = getTalkRepresentation(cid);
								TFMap.put(seed, doc1);
							}

							double x = 0;
							double docfreq0 = 0;
							for(String term0:doc0.keySet()){
								double tf0 = doc0.get(term0).doubleValue();
								docfreq0 += tf0;
							}
							for(String term0:doc0.keySet()){
								double tf0 = doc0.get(term0).doubleValue()/docfreq0;
								if(IDFMap.containsKey(term0)){
									double idf0 = 0;
									if(IDFMap.get(term0) == null){
										double df = getDocumentFreq(term0);
										idf0 =  Math.log10(totalTalks/df);
										IDFMap.put(term0, Math.log10(totalTalks/df));
									}else{
										idf0 = IDFMap.get(term0);
									}

									double tfidf0 = tf0*idf0;
									if(Double.isNaN(tfidf0)){
										tfidf0 = 0;
										
									}
									//doc0.put(term0, tfidf0);
									x += tfidf0*tfidf0;
								}
							}

							double y = 0;
							double docfreq1 = 0;
							for(String term1 : doc1.keySet()){
								double tf1 = doc1.get(term1).doubleValue();
								docfreq1 += tf1;
							}
							for(String term1 : doc1.keySet()){
								double tf1 = doc1.get(term1).doubleValue()/docfreq1;
								if(IDFMap.containsKey(term1)){
									double idf1 = IDFMap.get(term1);
									if(IDFMap.get(term1) == null){
										double df = getDocumentFreq(term1);
										idf1 =  Math.log10(totalTalks/df);
										IDFMap.put(term1, Math.log10(totalTalks/df));
									}else{
										idf1 = IDFMap.get(term1);
									}
									
									double tfidf1 = tf1*idf1;
									if(Double.isNaN(tfidf1)){
										tfidf1 = 0;
										
									}
									//doc1.put(term1, tfidf1);
									y += tfidf1*tfidf1;
								}
							}
							
							double w = 0.0;
							for(String term0 : doc0.keySet()){
								if(doc1.containsKey(term0)){
									double tf0 = doc0.get(term0).doubleValue();
									double idf0 = 0;
									if(IDFMap.get(term0) == null){
										double df = getDocumentFreq(term0);
										idf0 =  Math.log10(totalTalks/df);
										IDFMap.put(term0, Math.log10(totalTalks/df));
									}else{
										idf0 = IDFMap.get(term0);
									}
									double tfidf0 = tf0*idf0;
									double tf1 = doc1.get(term0).doubleValue();
									double tfidf1 = tf1*idf0;
									w += tfidf0*tfidf1;
								}
							}
							
							double docsim = 0;
							docsim = w/(x*y);
							if(Double.isNaN(docsim)){
								docsim = 0;
							}
							if(Double.isInfinite(docsim)){
								docsim = 1;
							}
							simid = "c0id" + seed + "c1id" + cid;
							if(seed > cid){
								simid = "c0id" + cid + "c1id" + seed;
							}
							simMap.put(simid, docsim);
							sql = "INSERT INTO colsim (col0_id,col1_id,ngram,sim,caldate)VALUES(" +
									(seed < cid?seed + "," + cid:cid + "," + seed) + "," +
									ngram + "," + docsim + ",NOW())";
							conn.executeUpdate(sql);
							
							if(maxsim < docsim){
								maxsim = docsim;
								closestSeed = seed;
							}
							
						}
					}
				}
				if(closestSeed > 0){
					HashSet<Integer> cSet = cluster.get(closestSeed);
					if(cSet == null){
						cSet = new HashSet<Integer>();
					}
					cSet.add(cid);
					cluster.put(closestSeed, cSet);
					//System.out.println("Round #" + (i+1) + " cluster " + closestSeed + " adds " + cid);
				}
			}
			//Print them out
			for(int medroid : cluster.keySet()){
				System.out.println("**********************************************");
				System.out.println("COSINE Medroid: " + medroid);
				System.out.println("**********************************************");
				HashSet<Integer> cSet = cluster.get(medroid);
				System.out.println("Total components in the cluster: " + cSet.size());
				System.out.println("**********************************************");
				sql = "";
				for(int cid : cluster.get(medroid)){
					System.out.println("Round #" + (i+1) + " cluster " + medroid + " adds " + cid);
					if(sql.length()==0){
						sql = "INSERT INTO colkmedroid (cluster,ngram,costfn,round,medroid,col_id,clustertime)VALUES";
					}else{
						sql += ",";
					}
					sql += "(" + k + "," + ngram + ",'COSINE'," + (i+1) + "," + medroid + "," + cid + ",NOW())";
				}
				if(sql.length()>0){
					System.out.println(sql);
					conn.executeUpdate(sql);
				}
			}
			//Avoid assigning to outliers by removing medroids that have only one member
			detectOutliers();
		}//~Clustering Iteration Loop
		simMap.clear();
		simMap = null;
	}
	
	private void detectOutliers() throws SQLException{
		ArrayList<Integer> keySet = new ArrayList<Integer>();
		keySet.addAll(cluster.keySet());
		for(int medroid : keySet){
			HashSet<Integer> cSet = cluster.get(medroid);
			if(cSet != null && cSet.size() < 2){
				//It is an outlier
				outlierSet.add(medroid);
				cluster.remove(medroid);
				String lstMedroid = "";
				for(int m : cluster.keySet()){
					if(lstMedroid.length()>0){
						lstMedroid += ",";
					}
					lstMedroid += m;
				}
				String lstOutlier = "";
				for(int m : outlierSet){
					if(lstOutlier.length()>0){
						lstOutlier += ",";
					}
					lstOutlier += m;
				}
				String sql = "SELECT col_id FROM (SELECT col_id FROM colterm WHERE ngram=" + ngram + " GROUP BY col_id) t " +
								"WHERE col_id NOT IN (" + lstMedroid + //Medroid list
								") AND col_id NOT IN (" + lstOutlier + //Outlier list
								") ORDER BY RAND() LIMIT 1";
				ResultSet rs = conn.getResultSet(sql);
				while(rs.next()){
					cluster.put(rs.getInt("col_id"), null);
				}
			}
		}
	}
	
	public void clusterByEuclidean(int round) throws SQLException{
		//Get pre-processed sim
		HashMap<String,Double> disMap = new HashMap<String,Double>();
		String sql = "SELECT col0_id,col1_id,distance FROM coldistance WHERE ngram=" + ngram;
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			int c0id = rs.getInt("col0_id");
			int c1id = rs.getInt("col1_id");
			double distance = rs.getDouble("distance");
			String disid = "c0id" + c0id + "c1id" + c1id;
			if(c0id > c1id){
				disid = "c0id" + c1id + "c1id" + c0id;
			}
			disMap.put(disid, distance);
		}
		//Assigning them iterately
		for(int i=0;i<round;i++){
			//If not the initial state
			if(i>0){
				//Find the new medroid in each cluster
				//By using the average of minimum distance of all data points in the clusters
				HashMap<Integer,HashSet<Integer>> newCluster = new HashMap<Integer,HashSet<Integer>>();
				for(int seed : cluster.keySet()){
					HashSet<Integer> cSet = cluster.get(seed);
					double mindis = 999999;
					int newcid = -1;
					if(cSet==null)continue;
					for(int c0id : cSet){
						double accumdis = 0;
						for(int c1id : cSet){
							if(c0id != c1id){
								String disid = "c0id" + c0id + "c1id" + c1id;
								if(c0id > c1id){
									disid = "c0id" + c1id + "c1id" + c0id;
								}
								if(disMap.containsKey(disid)){
									accumdis += disMap.get(disid);
								}
							}
						}
						accumdis = accumdis/cSet.size();
						if(mindis > accumdis){
							mindis = accumdis;
							newcid = c0id;
						}
					}
					if(newcid > 0){
						newCluster.put(newcid, null);
						System.out.println("New medroid: " + newcid + " min accum distance: " + mindis);
					}
				}
				//Clear old data, insert the new ones
				cluster.clear();
				cluster.putAll(newCluster);
			}
			//System.out.println("Before clearing, total initial seeds: " + cluster.size());
			//Reset data in all clusters
			for(int seed : cluster.keySet()){
				if(cluster.get(seed)!=null){
					cluster.put(seed, null);
				}
			}
			//System.out.println("After clearing, total initial seeds: " + cluster.size());
			//Assign data point into the closest cluster
			for(int cid : talkSet){
				//System.out.println("Considering data point: " + cid);
				double mindis = 99999;
				int closestSeed = -1;
				for(int seed : cluster.keySet()){
					if(seed==cid){
						mindis = 0;
						closestSeed = seed;
						break;
					}else{
						String disid = "c0id" + cid + "c1id" + seed;
						if(cid > seed){
							disid = "c0id" + seed + "c1id" + cid;
						}
						if(disMap.containsKey(disid)){
							if(mindis > disMap.get(disid)){
								mindis = disMap.get(disid);
								closestSeed = seed;
							}
						}else{
							System.out.println("Cannot find distance between " + seed + " and " + cid);
							//Get seed doc representation
							HashMap<String,Double> doc0 = TFMap.get(seed);
							if(doc0 == null){
								doc0 = getTalkRepresentation(seed);
								TFMap.put(seed, doc0);
							}
							
							HashMap<String,Double> doc1 = TFMap.get(cid);
							if(doc1 == null){
								doc1 = getTalkRepresentation(cid);
								TFMap.put(seed, doc1);
							}

							//double x = 0;
							double docfreq0 = 0;
							for(String term0:doc0.keySet()){
								double tf0 = doc0.get(term0).doubleValue();
								docfreq0 += tf0;
							}
							for(String term0:doc0.keySet()){
								double tf0 = doc0.get(term0).doubleValue()/docfreq0;
								if(IDFMap.containsKey(term0)){
									double idf0 = 0;
									if(IDFMap.get(term0) == null){
										double df = getDocumentFreq(term0);
										idf0 =  Math.log10(totalTalks/df);
										IDFMap.put(term0, Math.log10(totalTalks/df));
									}else{
										idf0 = IDFMap.get(term0);
									}

									double tfidf0 = tf0*idf0;
									if(Double.isNaN(tfidf0)){
										tfidf0 = 0;
										
									}
									//doc0.put(term0, tfidf0);
									//x += tfidf0*tfidf0;
								}
							}

							//double y = 0;
							double docfreq1 = 0;
							for(String term1 : doc1.keySet()){
								double tf1 = doc1.get(term1).doubleValue();
								docfreq1 += tf1;
							}
							for(String term1 : doc1.keySet()){
								double tf1 = doc1.get(term1).doubleValue()/docfreq1;
								if(IDFMap.containsKey(term1)){
									double idf1 = IDFMap.get(term1);
									if(IDFMap.get(term1) == null){
										double df = getDocumentFreq(term1);
										idf1 =  Math.log10(totalTalks/df);
										IDFMap.put(term1, Math.log10(totalTalks/df));
									}else{
										idf1 = IDFMap.get(term1);
									}
									
									double tfidf1 = tf1*idf1;
									if(Double.isNaN(tfidf1)){
										tfidf1 = 0;
										
									}
									//doc1.put(term1, tfidf1);
									//y += tfidf1*tfidf1;
								}
							}
							
							double w = 0.0;
							HashSet<String> doc3 = new HashSet<String>();
							doc3.addAll(doc0.keySet());
							doc3.addAll(doc1.keySet());
							for(String term0 : doc3){
								if(doc1.containsKey(term0)){
									double tfidf0 = 0;
									double tfidf1 = 0;
									double idf0 = 0;
									if(IDFMap.containsKey(term0)){
										if(IDFMap.get(term0) == null){
											double df = getDocumentFreq(term0);
											idf0 =  Math.log10(totalTalks/df);
											IDFMap.put(term0, Math.log10(totalTalks/df));
										}else{
											idf0 = IDFMap.get(term0);
										}
									}
									if(doc0.get(term0)!=null){
										double tf0 = doc0.get(term0).doubleValue();
										tfidf0 = tf0*idf0;
									}
									if(doc1.get(term0)!=null){
										double tf1 = doc1.get(term0).doubleValue();
										tfidf1 = tf1*idf0;
									}
									w += (tfidf0-tfidf1)*(tfidf0-tfidf1);
								}
							}
							
							double docdistance = 999999;
							if((doc0.keySet().size()>0||doc1.keySet().size()>0)&&!Double.isNaN(w)&&!Double.isInfinite(w)){
								docdistance = Math.sqrt(w);
							}
							disid = "c0id" + seed + "c1id" + cid;
							if(seed > cid){
								disid = "c0id" + cid + "c1id" + seed;
							}
							disMap.put(disid, docdistance);
							sql = "INSERT INTO coldistance (col0_id,col1_id,ngram,distance,caldate)VALUES(" +
									(seed < cid?seed + "," + cid:cid + "," + seed) + "," +
									ngram + "," + docdistance + ",NOW())";
							conn.executeUpdate(sql);

							if(mindis > docdistance){
								mindis = docdistance;
								closestSeed = seed;
							}
							
						}
					}
				}
				if(closestSeed > 0){
					HashSet<Integer> cSet = cluster.get(closestSeed);
					if(cSet == null){
						cSet = new HashSet<Integer>();
					}
					cSet.add(cid);
					cluster.put(closestSeed, cSet);
					//System.out.println("Round #" + (i+1) + " cluster " + closestSeed + " adds " + cid);
				}
			}
			//Print them out
			for(int medroid : cluster.keySet()){
				System.out.println("**********************************************");
				System.out.println("EUCLIDEAN Medroid: " + medroid);
				System.out.println("**********************************************");
				HashSet<Integer> cSet = cluster.get(medroid);
				System.out.println("Total components in the cluster: " + cSet.size());
				System.out.println("**********************************************");
				sql = "";
				for(int cid : cluster.get(medroid)){
					System.out.println("Round #" + (i+1) + " cluster " + medroid + " adds " + cid);
					if(sql.length()==0){
						sql = "INSERT INTO colkmedroid (cluster,ngram,costfn,round,medroid,col_id,clustertime)VALUES";
					}else{
						sql += ",";
					}
					sql += "(" + k + "," + ngram + ",'EUCLIDEAN'," + (i+1) + "," + medroid + "," + cid + ",NOW())";
				}
				if(sql.length()>0){
					System.out.println(sql);
					conn.executeUpdate(sql);
				}
			}
			detectOutliers();
		}//~Clustering Iteration Loop
		disMap.clear();
		disMap = null;
	}

	private HashMap<String,Double> getTalkRepresentation(int col_id) throws SQLException{
		HashMap<String,Double> doc0 = new HashMap<String,Double>();
		String sql = "SELECT term,SUM(freq) freq FROM colterm " +
				"WHERE ngram=" + ngram +
				" AND col_id=" + col_id +
				" GROUP BY term";
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			doc0.put(rs.getString("term"), rs.getDouble("freq"));
		}
		return doc0;
	}
	
	private double getDocumentFreq(String term) throws SQLException{
		double _df = 1;
		String sql = "SELECT COUNT(*) _df FROM " +
						"(SELECT term,col_id FROM colterm WHERE ngram=" + ngram +
						" GROUP BY term,col_id) t " +
						"WHERE t.term ='" + term.replaceAll("'", "''") + "'";
		ResultSet rs = conn.getResultSet(sql);
		while(rs.next()){
			_df = rs.getDouble("_df");
		}
		return _df;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			int cluster = 300;
			int ngram = 1;
			int round = 100;
			if(args.length == 1){
				cluster = Integer.parseInt(args[0]);
			}
			if(args.length == 2){
				cluster = Integer.parseInt(args[0]);
				ngram = Integer.parseInt(args[1]);
			}
			if(args.length == 3){
				cluster = Integer.parseInt(args[0]);
				ngram = Integer.parseInt(args[1]);
				round = Integer.parseInt(args[2]);
			}
			
			CoMeTKMedroid kmed = new CoMeTKMedroid(cluster,ngram);
			kmed.clusterByCosSim(round);
			kmed.clusterByEuclidean(round);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
