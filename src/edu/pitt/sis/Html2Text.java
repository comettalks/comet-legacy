package edu.pitt.sis;

import java.io.IOException;
import java.io.StringReader;

import javax.swing.text.html.HTMLEditorKit.ParserCallback;
import javax.swing.text.html.parser.ParserDelegator;

public class Html2Text extends ParserCallback {

	StringBuffer s;
	
	public void parse(String html) throws IOException{
		s = new StringBuffer();
		ParserDelegator delegator = new ParserDelegator();
		delegator.parse(new StringReader(html), this, Boolean.TRUE);
	}
	
	@Override
	public void handleText(char[] data, int pos) {
		// TODO Auto-generated method stub
		super.handleText(data, pos);
		s.append(data);
	}
	
	public String getText(){
		return s.toString();
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Html2Text parser = new Html2Text();
		try {
			parser.parse("<title>CoMeT</title> <b>This is a test.</b>");
			System.out.println(parser.getText());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
