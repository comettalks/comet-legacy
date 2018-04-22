/*
 * Created on Nov 30, 2004
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package edu.pitt.sis;

/**
 * @author blbpc
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class BasicFunctions {
	
	public static final String encKey = "g6gh56j67s65t676h6ms6a9cvvb298";
	
    public static String convertTextToHTML(String txt){
        StringBuffer sb = new StringBuffer(txt.length());
           boolean lastWasBlank = false;
           char c;
               
           for(int i = 0; i < txt.length(); i++){
               c = txt.charAt(i);
                   
               if(c == ' '){
                   if(lastWasBlank){
                       lastWasBlank = false;
                       sb.append("&nbsp");
                   }
                   else{
                       lastWasBlank = true;
                       sb.append(' ');
                   }
               }
               else{
                   lastWasBlank = false;
                   //Swtich 
                   switch(c) {
                       case '"': sb.append("&quot;"); break;
                       case '\n': sb.append("<br>"); break; 
                       case '\'': sb.append("`"); break;
                       default: 
                       sb.append(c);
                               
                   }; //end switch
               }//end else
           }//end for
           return sb.toString(); 
       }
}
