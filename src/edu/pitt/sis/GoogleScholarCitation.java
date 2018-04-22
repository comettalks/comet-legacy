package edu.pitt.sis;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;

public class GoogleScholarCitation {
	private String gAuthor = "";
	private ArrayList<ArrayList<Integer>> citePages = new ArrayList<ArrayList<Integer>>();
	private int publications = 0;
	private int ret_results = 100;
	private int total_cites = 0;
	private int h_index = -1;
	private String link = "";
	public GoogleScholarCitation(String author){
		/*try {
			gAuthor = URLEncoder.encode("\"" + author.trim() + "\"", "UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String url_to_get = "http://scholar.google.com/scholar?as_q=&num="+ret_results+"&as_sdt=0,39&as_ylo=&as_vis=1&as_sauthors=" + gAuthor;
		link = "http://scholar.google.com/scholar?as_q=&as_sdt=0,39&as_ylo=&as_vis=1&as_sauthors=" + gAuthor;
		String content = fetchHTML(url_to_get);
        // Variables used to find the correct location of the total number of returned results
        String pre = "of about <b>";
		String post = "</b>";//"\\</b>.\\s*\\<b>"; //"/<\/b>\.\s*\(<b>/";

        // Locate the place where the total results value is positioned
		if(content.indexOf(pre) == -1){
			pre = "of <b>";
		}
		if(content.indexOf(pre) == -1){
			return;
		}
        int resultPositionPre = content.indexOf(pre) + pre.length();
        String tResult = content.substring(resultPositionPre);
        int resultPositionPost = tResult.indexOf(post);

        // Extract the total number of results returned
        tResult = tResult.substring(0, resultPositionPost);

        // Remove the comma representing thousands       
        tResult = tResult.replaceAll(",", "");
		//System.out.println(tResult);
        int iResult = Integer.parseInt(tResult);
        // Calculate how many pages we need to fetch
        if(iResult > 100){
        	int pages = (int)Math.ceil((double)iResult/(double)ret_results);
        	
            // Temporary counter as an array indexer
            //int counter = 0;
        	
            // Fetch all fetchable pages (i.e. fetch 'pages' pages[Google's limit] or 10 pages)
            if(pages > 10){
            	pages = 10;
            }
        	//System.out.println("=============================");
        	//System.out.println("Page: 1");
        	//System.out.println("=============================");
        	citePages.add(getCitationCount(content));        	
        	for(int i=1;i<pages;i++){
            	//System.out.println("=============================");
            	//System.out.println("Page: " + (i+1));
            	//System.out.println("=============================");
                int start = i * 100;
                url_to_get = "http://scholar.google.com/scholar?as_q=&num="+ret_results+"&as_sdt=0,39&as_ylo=&as_vis=1&as_sauthors="+gAuthor+"&start="+start;
        		content = fetchHTML(url_to_get);
            	citePages.add(getCitationCount(content));        	
        	}
            
            
        }else{
        	citePages.add(getCitationCount(content));        	
        }
        
        //Calculate H-index
        h_index = h_index();
        //System.out.println("H-index: " + h_index);
*/ 	}
	
	private int h_index(){
		int result = -1;
		ArrayList<Integer> hArray = new ArrayList<Integer>();
		for(int i=0;i<citePages.size();i++){
			ArrayList<Integer> citeArray = citePages.get(i);
			for(int j=0;j<citeArray.size();j++){
				hArray.add(citeArray.get(j));
			}
		}
		Collections.sort(hArray,Collections.reverseOrder());
		for(int i=0;i<hArray.size();i++){
			if(i > hArray.get(i).intValue()){
				return hArray.get(i-1).intValue();
			}
		}
		return result;
	}
	
	// ----------------------
	// Function to tokenize returned HTML response and sum up the Author's citation count
	// ----------------------
	private ArrayList<Integer> getCitationCount(String responseText){
		int cite_exists = 1;
		ArrayList<Integer> citeArray = new ArrayList<Integer>();
		for(int i = 0; cite_exists > 0; i++){
			cite_exists = responseText.indexOf("Cited by");
			if(cite_exists == -1){
				//alert("No more citations for given Author!");
				//return;
			}else{
				responseText = responseText.substring(cite_exists);
				int end = responseText.indexOf("<");
				int cite_count = Integer.parseInt(responseText.substring(8, end).trim());
				total_cites += cite_count;
				citeArray.add(new Integer(cite_count));
				//System.out.println(responseText.substring(0, end));
				publications++;
				responseText = responseText.substring(end);
			}
		}
		return citeArray;
	}
	
	
	private String fetchHTML(String url_to_get){
		String result = "";
		try {
			//System.out.println(url_to_get);
			URL url = new URL(url_to_get);
			//make connection
			URLConnection urlc = url.openConnection();
            /** Some web servers requires these properties */
            urlc.setRequestProperty("User-Agent", 
                    "Profile/MIDP-1.0 Configuration/CLDC-1.0");
            urlc.setRequestProperty("Content-Length", "0");
            urlc.setRequestProperty("Connection", "close");

			//get result
			BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
			String line = null;
			while ((line = br.readLine())!=null) {
				//System.out.println(line);
				result += line;
			}

			br.close();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		new GoogleScholarCitation("Yen-Tzu Lin");
	}

	public int getPublications() {
		return publications;
	}

	public int getTotal_cites() {
		return total_cites;
	}

	public int getH_index() {
		return h_index;
	}

	public String getLink() {
		return link;
	}

}
