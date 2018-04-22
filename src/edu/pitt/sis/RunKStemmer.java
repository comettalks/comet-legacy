package edu.pitt.sis;
/**
 * 
 */


//import java.util.*;
import java.util.StringTokenizer;

import org.apache.lucene.analysis.KStemmer;

/**
 * @author Chirayu
 *
 */
public class RunKStemmer {
    public static String transform(String content){
        String result = "";
        String st;
        
        KStemmer s = new KStemmer();
        
        /*content = content.toLowerCase();
        String[] token = content.split("\\s+");
        if(token != null){
        	for(int i=0;i<token.length;i++){
        		result = result + s.stem(token[i]) + " ";
        	}
        }*/
        StringTokenizer token = new StringTokenizer(content);
        while(token.hasMoreTokens()){
            st = token.nextToken();
            st = st.toLowerCase();
            st = st.trim();
            result = result + s.stem(st) + " ";
        }
        return result.trim();
    }
}
