<%@ page language="java"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-template" prefix="template" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-nested" prefix="nested" %>

<%
	session=request.getSession(false);	
	String redirect = (String)session.getAttribute("redirect");
	int affiliate_id = -1;
	if(request.getParameter("affiliate_id") != null){
		affiliate_id = Integer.parseInt((String)request.getParameter("affiliate_id"));
	}
	if(redirect != null){
		session.removeAttribute("redirect");
%>
	<script>
		window.location="<%=redirect%>";
	</script>
<%		
	}
%>
	<style>
		tr.trPopTalk, tr.trPopVideo, tr.trTop3Recent, tr.trCal{
			display: none;
		}
	</style>	
	<table cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td width="70%" valign="top">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
<%-- 
					<tr>
						<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">Featuring Recent Talks</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
--%>
					<tr>
						<td id="tdTop3Recent">
						<div id="divTop3RecentLoading" style="display: none;" align='center'><img border='0' src='images/loading.gif' /></div>
<%-- 
							<tiles:insert template="/utils/loadTalks.jsp?mostrecent=1&rows=3"/>
--%>
							<script type="text/javascript">
								$(document).ready(function(){

									$('#divTop3RecentLoading').show('slow');
									
									$.get('utils/loadTalks.jsp',{mostrecent: 1, rows: 3},
										function(data){
											$('#tdTop3Recent').html(data);
											$('.trTop3Recent').show('fast');

											$.get('utils/loadTalks.jsp',{mostrecent: 1, start: 3, noheader: 1},
													function(data){
														$('#tdMostRecent').html(data);
													}
												);

											$.get('utils/popSeries.jsp',{rows: 5},
													function(data){
														$('#tdPopSeries').html(data);
														$('#tdPopSeries').show('fast');
													}
												);

											$.get('utils/popCommunity.jsp',{rows: 5},
													function(data){
														$('#tdPopCommunity').html(data);
														$('#tdPopCommunity').show('fast');
													}
												);
											
										}
									);
								});
							</script>
						</td>
					</tr>
<%-- 
					<tr>
						<td>&nbsp;</td>
					</tr>
--%>
					<tr class="trTop3Recent">
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
								<tr>
									<td>
<%-- 
										<script type="text/javascript">
											$(document).ready(function(){
												$.get('utils/loadTalks.jsp',{mostrecent: 1, start: 3, noheader: 1},
													function(data){
														$('#tdMostRecent').html(data);
													}
												);
											});
										</script>
--%>
										<div id="divMostRecent">
											<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
												<tr>
													<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
												</tr>
												<tr>
													<td bgcolor="#efefef" style="font-size: 0.9em;font-weight: bold;text-align: center;">
														&nbsp;
														<input class="btn" type="button" id="btnShowRecentMore"
															onclick="showRecentTalksMore();"
															value="Show More" />
													</td>
												</tr>
												<tr>
													<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
												</tr>
											</table>	
										</div>
<%-- 
										<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
											onmouseover="this.style.textDecoration='underline'" 
											onmouseout="this.style.textDecoration='none'"
											onclick="window.location='calendar.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
--%>
									</td>
								</tr>
							</table>
						</td>
					</tr>
<%-- 
					<tr class="trTop3Recent">
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="5" width="95%" align="center">
								<tr>
									<td id="tdPopSeries" style="display: none;" width="50%" valign="top">
										<tiles:insert template="/utils/popSeries.jsp?rows=5"/>
										<script type="text/javascript">
											$(document).ready(function(){
												$.get('utils/popSeries.jsp',{rows: 5},
													function(data){
														$('#tdPopSeries').html(data);
														$('#tdPopSeries').show();
													}
												);
											});
										</script>
									</td>
									<td id="tdPopCommunity" style="display: none;" width="50%" valign="top">
										<tiles:insert template="/utils/popCommunity.jsp?rows=5"/>
										<script type="text/javascript">
											$(document).ready(function(){
												$.get('utils/popCommunity.jsp',{rows: 5},
													function(data){
														$('#tdPopCommunity').html(data);
														$('#tdPopCommunity').show();
													}
												);
											});
										</script>
									</td>
								</tr>				
							</table>
						</td>
					</tr>
--%>

					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="95%" align="center">
									<tr>
										<td colspan="3"><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
									</tr>
									<tr>
										<td id="tdPopSeries" style="display: none;">
<%-- 
											<tiles:insert template="/utils/popSeries.jsp?rows=5"/>
--%>
											<script type="text/javascript">
												$(document).ready(function(){
													$.get('utils/popSeries.jsp',{rows: 5},
														function(data){
															$('#tdPopSeries').html(data);
															$('#tdPopSeries').show();
														}
													);
												});
											</script>
										</td>
										<td>&nbsp;</td>
										<td id="tdPopCommunity" style="display: none;">
<%-- 
											<tiles:insert template="/utils/popCommunity.jsp?rows=5"/>
--%>
											<script type="text/javascript">
												$(document).ready(function(){
													$.get('utils/popCommunity.jsp',{rows: 5},
														function(data){
															$('#tdPopCommunity').html(data);
															$('#tdPopCommunity').show();
														}
													);
												});
											</script>
										</td>
										
									</tr>
							</table>								
						</td>
					</tr>
					
					<logic:present name="UserSession">
						<tr>
							<td>
								<table border="0" cellpadding="0" cellspacing="0" width="95%" align="center">
									<tr>
										<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
									</tr>
									<tr>
										<td id="tdActStream">
<%-- 
											<tiles:insert template="/includes/bookmarks.jsp?v=activity&hiderightbar=1&showstream=1" />
--%>
											<script type="text/javascript">
												$(document).ready(function(){
													$.get('includes/bookmarks.jsp',{v: 'activity',hiderightbar: 1,showstream: 1,rows: 20},
														function(data){
															$('#tdActStream').html(data);
															$('#tdActStream').show('fast');
															//alert($('#btnLoadAct').length);
															if($('#btnLoadAct').length){
																//alert('btnLoadAct found!!!');
																$('#btnLoadAct').click();
															}else{
																//alert('btnLoadAct not found!!!');
															}
														}
													);
												});
											</script>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</logic:present>
				</table>
			</td>			
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr class="trCal">
						<td>
							<table cellpadding="0" cellspacing="0" width="100%" align="center">
								<tr>
									<td>
										<div id="divCal">
<%-- 
											<tiles:insert template="/includes/calendar.jsp"/>
--%>
											<script type="text/javascript">
												$(document).ready(function(){
													$.get('includes/calendar.jsp',{nofeed: 1,mostrecent: 1},
														function(data){
															$('#divCal').html(data);
															$('.trCal').show('slow');
														}
													);
												});
											</script>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="trPopTalk">
						<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr class="trPopTalk">
						<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">Popular Forthcoming Talks</td>
					</tr>
					<tr class="trPopTalk">
						<td>
							<table id="tblPopTalk" style="border: 1px solid #efefef;background-color: #add8e6;" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td id="tdPopTalk">
<%-- 
										<tiles:insert template="/utils/loadTalks.jsp?poprecent=1&rows=3&concise=1"/>
--%>
										<script type="text/javascript">
											$(document).ready(function(){
												$.get('utils/loadTalks.jsp',{poprecent: 1, rows: 3, concise: 1},
													function(data){
														$('#tdPopTalk').html(data);
														$('.trPopTalk').show('slow');
													}
												);
											});
										</script>
									</td>
								</tr>
								<tr>
									<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="trPopTalk">
						<td>
							<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
								<tr>
									<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td bgcolor="#efefef" style="font-size: 0.9em;font-weight: bold;text-align: center;">
										&nbsp;
										<input class="btn" type="button" id="btnShowRecentMore"
											onclick="window.location='popComingCoMeTTalk.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'"
											value="Show More" />
									</td>
								</tr>
								<tr>
									<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
								</tr>
							</table>	
<%-- 
							<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
								onmouseover="this.style.textDecoration='underline'" 
								onmouseout="this.style.textDecoration='none'"
								onclick="window.location='popComingCoMeTTalk.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
--%>
						</td>
					</tr>
					<tr class="trPopTalk">
						<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
					</tr>
<%-- 
					<tr>
						<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">All-Time Popular Talk</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/loadTalks.jsp?topcomet=1&rows=1&concise=1"/>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
								onmouseover="this.style.textDecoration='underline'" 
								onmouseout="this.style.textDecoration='none'"
								onclick="window.location='popCometScore.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
--%>
<%-- 
					<tr>
						<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">Past Popular Talks with Video</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
--%>
					<tr class="trPopVideo">
						<td style="background-color: #f08080;" id="tdPopVideo">
<%-- 
							<tiles:insert template="/utils/loadTalks.jsp?topvideo=1&rows=1&concise=1"/>
--%>
							<script type="text/javascript">
								$(document).ready(function(){
									$.get('utils/loadTalks.jsp',{topvideo: 1, rows: 1, concise: 1},
										function(data){
											$('#tdPopVideo').html(data);
											$('.trPopVideo').show('slow');
										}
									);
								});
							</script>
						</td>
					</tr>
<%-- 
					<tr>
						<td>&nbsp;</td>
					</tr>
--%>
					<tr class="trPopVideo">
						<td>
							<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
								<tr>
									<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
								</tr>
								<tr>
									<td bgcolor="#efefef" style="font-size: 0.9em;font-weight: bold;text-align: center;">
										&nbsp;
										<input class="btn" type="button" id="btnShowRecentMore"
											onclick="window.location='popVideo.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'"
											value="Show More" />
									</td>
								</tr>
								<tr>
									<td bgcolor="#efefef"><div style="height: 4px;overflow: hidden;">&nbsp;</div></td>
								</tr>
							</table>	
<%-- 
							<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
								onmouseover="this.style.textDecoration='underline'" 
								onmouseout="this.style.textDecoration='none'"
								onclick="window.location='popVideo.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
--%>
						</td>
					</tr>
					<tr class="trPopVideo">
						<td><div style="height: 10px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					
<%-- 
					<tr>
						<td bgcolor="#00468c"><div style="height: 2px;overflow: hidden;">&nbsp;</div></td>
					</tr>
					<tr>
						<td bgcolor="#efefef" style="font-size: 0.95em;font-weight: bold;">All-Time Popular Talk with Slide</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/loadTalks.jsp?topslide=1&rows=1&concise=1"/>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<div style="color:#003399;cursor:pointer;font-size: 0.75em;font-weight: bold;" 
								onmouseover="this.style.textDecoration='underline'" 
								onmouseout="this.style.textDecoration='none'"
								onclick="window.location='popSlide.do<%if(affiliate_id>0)out.print("?affiliate_id="+affiliate_id);%>'">More &gt;&gt;</div>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
--%>
<%-- 
					<tr>
						<td>
							<tiles:insert template="/utils/feed.jsp?mostrecent=1"/>
						</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/tagCloud.jsp?mostrecent=1"/>
						</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/tagCloud.jsp"/>
						</td>
					</tr>
--%>
<%--					
					<tr>
						<td>
							<tiles:insert template="/utils/popCometScoreTalk.jsp?rows=3"/>
						</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/popVideoTalk.jsp?rows=3"/>
						</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/popSlideTalk.jsp?rows=3"/>
						</td>
					</tr>
					<tr>
						<td>
							<tiles:insert template="/utils/popAnnotatedTalk.jsp?rows=3"/>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
--%>
				</table>
			</td>
		</tr>
<%-- 
		<tr>
			<td width="30%" valign="top">				
				<tiles:insert template="/utils/recentAnnotatedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/recentViewedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/tagCloud.jsp?rows=20"/>
			</td>
		</tr>
		<tr>
			<td colspan="5">&nbsp;</td>
		</tr>
		<tr>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/popAnnotatedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/popViewedTalk.jsp?rows=5"/>
			</td>
			<td>&nbsp;</td>
			<td width="30%" valign="top">
				<tiles:insert template="/utils/popCommunity.jsp?rows=5"/>
			</td>
		</tr>
--%>
	</table>
