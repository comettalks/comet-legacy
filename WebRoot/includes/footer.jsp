<%@ page language="java"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td align="center">
			<span style="cursor: pointer;color: #0080ff; font-size: 0.7em;" onclick="window.location='http://comettalks.wordpress.com/'">CoMeT Blog</span>
		</td>
	</tr>
	<tr>
		<td align="Center" style="font-size: 0.7em;">
						&copy;2009-<%=(new GregorianCalendar()).get(Calendar.YEAR)%> CoMeT - Supported by Google Grant<br>
						<span style="cursor: pointer;" onclick="window.location='http://www.ischool.pitt.edu'">
						School of Information Sciences</span>, 
						<span style="cursor: pointer;" onclick="window.location='http://www.pitt.edu'">University of Pittsburgh</span>, 
						135 North Bellefield Avenue, Pittsburgh, PA 15260							
		</td>
	</tr>
</table>

<%-- 
<script type="text/javascript">
var uservoiceOptions = {
  /* required */
  key: 'comettalks',
  host: 'comettalks.uservoice.com', 
  forum: '40635',
  showTab: true,  
  /* optional */
  alignment: 'right',
  background_color: '#06C', 
  text_color: 'white',
  hover_color: '#f00',
  lang: 'en',
  no_dialog: true
};

function _loadUserVoice() {
  var s = document.createElement('script');
  s.setAttribute('type', 'text/javascript');
  s.setAttribute('src', ("https:" == document.location.protocol ? "https://" : "http://") + "cdn.uservoice.com/javascripts/widgets/tab.js");
  document.getElementsByTagName('head')[0].appendChild(s);
}
_loadSuper = window.onload;
window.onload = (typeof window.onload != 'function') ? _loadUserVoice : function() { _loadSuper(); _loadUserVoice(); };
	$(document).ready(function(){
		_loadUserVoice();
	});
</script>

--%>
<script type="text/javascript">
  var uvOptions = {};
  (function() {
    var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
    uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/Fh8Xib61yOKgroaBzSS8A.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
  })();
</script>

<a title="Real Time Web Analytics" href="http://getclicky.com/66400673"><img alt="Real Time Web Analytics" src="http://static.getclicky.com/media/links/badge.gif" border="0" /></a>
<script src="http://static.getclicky.com/js" type="text/javascript"></script>
<script type="text/javascript">try{ clicky.init(66400673); }catch(err){}</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="http://in.getclicky.com/66400673ns.gif" /></p></noscript>