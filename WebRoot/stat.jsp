<%@ page language="java"%>
<%@ page import="java.sql.*" %>
<%@ page import="edu.pitt.sis.db.*" %>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<head>
 <title>Main Page</title>
</head>
<body>
<%
	session=request.getSession(false);	
%>
	<TABLE cellspacing="0" cellpadding="0" width="90%" align="center">

		<TR>
			<TD width="47.5%" height="2px" bgcolor="#00468c"></TD>
			<TD width="5%"></TD>
			<TD width="47.5%" height="2px" bgcolor="#00468c"></TD>
		</TR>

		<TR>
			<TD bgcolor="#efefef">
				<H3>
					Recent Tags
				</H3>
			</TD>
			<TD></TD>
			<TD bgcolor="#efefef">
				<H3>
					Recent Talks
				</H3>
			</TD>
		</TR>
		<TR>
			<TD width="45%" valign="top">

				<OL>
					<%
	    connectDB conn = new connectDB();
	    ResultSet rs = null;
	    String sql = "SELECT DISTINCT tt.tag,tt.tag_id FROM (" +
	    				"SELECT t.tag,t.tag_id " +
    					"FROM tags ts, tag t " +
    					"WHERE ts.tag_id = t.tag_id " +
    					"ORDER BY t.lastupdate DESC) tt " +
  						"LIMIT 20;";

	        try{
	        	rs = conn.getResultSet(sql);
	            while(rs.next()){
					out.print("<li>");	
					out.print("<a href='listbytag.do?tag_id=" + rs.getString("tag_id") + "'>");
					out.print(rs.getString("tag"));	
					out.print("</a>");	
					out.print("</li>");	
                }
                rs.close();
            }catch(SQLException ex){
                System.out.println(ex.toString());
            }finally{
	            if(rs!=null){
	                try{
	                    rs.close();
	                }catch(SQLException ex){}
	            }
            }
    %></OL>
			</TD>
			<TD>
			</TD>
			<TD width="45%" valign="top">


				<OL>

					<%
	    rs = null;
	    sql = "SELECT DISTINCT cc.col_id,cc.title FROM (" +
    			"SELECT c.col_id,c.title " +
    			"FROM colloquium c,userprofile u " +
    			"WHERE c.col_id = u.col_id " +
    			"ORDER BY c._date DESC) cc " +
  				"LIMIT 20;";

	        try{
	        	rs = conn.getResultSet(sql);
	            while(rs.next()){
					out.print("<li>");	
					out.print("<a href='presentColloquium.do?col_id=" + rs.getString("col_id") + "'>");
					out.print(rs.getString("title"));	
					out.print("</a>");	
					out.print("</li>");	
                }
                rs.close();
            }catch(SQLException ex){
                System.out.println(ex.toString());
            }finally{
	            if(rs!=null){
	                try{
	                    rs.close();
	                }catch(SQLException ex){}
	            }
            }
    %>
				</OL>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD height="2px" bgcolor="#00468c"></TD>
			<TD></TD>
			<TD height="2px" bgcolor="#00468c"></TD>
		</TR>
		<TR>
			<TD bgcolor="#efefef">
				<H3>
					Popular Tags
				</H3>
			</TD>
			<TD></TD>
			<TD bgcolor="#efefef">
				<H3>
					Popular Talks
				</H3>
			</TD>
		</TR>
		<TR>
			<TD width="45%" valign="top">
				

				<OL>
					<%
	    rs = null;
	    sql = "SELECT DISTINCT tt.tag,tt.tag_id FROM (" +
    			"SELECT COUNT(*)as no_tag,t.tag_id, t.tag " +
    			"FROM tag t,tags ts,userprofile u " +
    			"WHERE t.tag_id = ts.tag_id " +
    			"AND ts.userprofile_id = u.userprofile_id " +
    			"GROUP BY t.tag_id,t.tag " +
    			"ORDER BY no_tag DESC,t.tag) tt " +
  				"LIMIT 20;";

	        try{
	        	rs = conn.getResultSet(sql);
	            while(rs.next()){
					out.print("<li>");	
					out.print("<a href='listbytag.do?tag_id=" + rs.getString("tag_id") + "'>");
					out.print(rs.getString("tag"));	
					out.print("</a>");	
					out.print("</li>");	
                }
                rs.close();
            }catch(SQLException ex){
                System.out.println(ex.toString());
            }finally{
	            if(rs!=null){
	                try{
	                    rs.close();
	                }catch(SQLException ex){}
	            }
            }
    %>
				</OL>
			</TD>
			<td/>
			<TD width="45%" valign="top">
				

				<OL>

					<%
	    rs = null;
	    sql = "SELECT tt.col_id,tt.title FROM (" +
    			"SELECT COUNT(*) as no_col,c.col_id, c.title " +
    			"FROM colloquium c,userprofile u " +
    			"WHERE c.col_id = u.col_id " +
    			"GROUP BY c.col_id, c.title " +
    			"ORDER BY no_col DESC,c.title ) tt " +
  				"LIMIT 20;";

	        try{
	        	rs = conn.getResultSet(sql);
	            while(rs.next()){
					out.print("<li>");	
					out.print("<a href='presentColloquium.do?col_id=" + rs.getString("col_id") + "'>");
					out.print(rs.getString("title"));	
					out.print("</a>");	
					out.print("</li>");	
                }
                rs.close();
            }catch(SQLException ex){
                System.out.println(ex.toString());
            }finally{
	            if(rs!=null){
	                try{
	                    rs.close();
	                }catch(SQLException ex){}
	            }
            }
    %>
				</OL>
			</TD>
		</TR>
	</TABLE>

 
</body>


