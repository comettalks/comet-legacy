<%@ page language="java"%>
<html>
<head>
<title>LinkedIn JavaScript API Hello World</title>

<!-- 1. Include the LinkedIn JavaScript API and define a onLoad callback function
  //p76qgK1ZG4Ae41NgAzI9SLeJhrbxawHLZpFstB84F69aS9SqYcAjgC8_B0ui2U7I
 -->
<script type="text/javascript" src="http://platform.linkedin.com/in.js">
  api_key: O9aW2MKcw2Uwv42xuFnfBywwYQ4oSdAkBL7NtNyCYUktF7v0Jcs8uKwmqSDOnxl8
  onLoad: onLinkedInLoad
  authorize: true
</script>
<link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel=
  "stylesheet" /> 
  <script type="text/javascript" src="../scripts/jquery-1.4.2.min.js"> 
</script> 
  <script type="text/javascript" src="../scripts/jquery-ui-1.8.5.custom.min.js"> 
</script> 

<script type="text/javascript">
  function onLinkedInLoad() {
    IN.Event.on(IN, "auth", onLinkedInAuth);
  }
	function onLinkedInAuth() {
		IN.API.Profile("me")
			.fields("id","firstName", "lastName", "industry","distance","headline","location",
				    "currentStatus","currentStatusTimestamp","summary","specialties","proposalComments","associations",
				    "honors","interests","positions","publications","patents","languages","skills","certifications",
				    "educations","threeCurrentPositions","threePastPositions","numRecommenders",
				    "recommendationsReceived","relation-to-viewer","apiStandardProfileRequest","siteStandardProfileRequest",
				    "pictureUrl", "publicProfileUrl")
			.result(displayProfiles)
			.error( 
				function(e) {
					alert("something broken " + e.message);
				}
			);
	}
	function displayProfiles(profiles) {
		
	    var me = profiles.values[0];

		var data = "";
	    data += 
			"<p>-1</p>" + 
			"<p>ID: " + me.id + "</p>"+
			"<p>FirstName: "+me.firstName + "</p>" +
			"<p>LastName:" + me.lastName + "</p>" +
			"<p>industry: " + me.industry+"</p>" +
			"<p>headline: " + me.headline+"</p>" +

			if(me.currentStatus){
				data += "<p>currentStatus: " + me.currentStatus + "</p>";
			}
			if(me.currentStatusTimestamp){
				data += "<p>currentStatusTimestamp: " + me.currentStatusTimestamp + "</p>";
			}	
			if(me.location){
				data += "<p>location.name: " + me.location.name+"</p>" +
				"<p>location.country.code: " + me.location.country.code+"</p>";
			}

			data +=
			"<p>siteStandardProfileRequest.url: " + me.siteStandardProfileRequest.url + "</p>" +
			"<p>apiStandardProfileRequest.url: " + me.apiStandardProfileRequest.url + "</p>" +
			"<p>Picture URL: " + me.pictureUrl + "</p>" +
			"<p>Public Profile URL: " + me.publicProfileUrl + "</p><br/>";
			
		document.getElementById("profiles").innerHTML = data;
	      
		IN.API.Connections("me")
		    .fields(
					"id","firstName", "lastName", "industry","headline","apiStandardProfileRequest",
					"siteStandardProfileRequest", "pictureUrl", "publicProfileUrl"
				    )
		    .result(function(connections){

				var members = connections.values;
				var data = "";
				
				for(var member in members){
					data +=
						"<p>"+member+"</p>"+
						"<p>ID: " + members[member].id + "</p>"+
						"<p>FirstName: "+members[member].firstName + "</p>"+
						"<p>LastName:" + members[member].lastName + "</p>"+
						"<p>industry: " + members[member].industry+"</p>"+
						"<p>headline: " + members[member].headline+"</p>"+
						"<p>apiStandardProfileRequest.url: " + members[member].apiStandardProfileRequest.url + "</p>" +
						"<p>siteStandardProfileRequest.url: " + members[member].siteStandardProfileRequest.url + "</p>" +
						"<p>Picture URL: " + members[member].pictureUrl + "</p>" +
						"<p>Public Profile URL: " + members[member].publicProfileUrl + "</p><br/>";
				    /*IN.API.Profile(mems[mem].publicProfileUrl)
						.fields("id","firstName", "lastName", "industry","distance","headline","location",
							    "currentStatus","currentStatusTimestamp","summary",
							    "specialties","proposalComments","associations","honors","interests","positions","publications","patents",
							    "languages","skills","certifications","educations","threeCurrentPositions","threePastPositions","numRecommenders",
							    "recommendationsReceived","relation-to-viewer","apiStandardProfileRequest","siteStandardProfileRequest",
							    "pictureUrl", "publicProfileUrl")
					    .result(
							function(profiles){
	
								var members = profiles.values;
								var data = "";
								for(var member in members){
									data +=
									"<p>ID: " + members[member].id + "</p>"+
									"<p>FirstName: " + members[member].firstName + "</p>" +
									"<p>LastName:" + members[member].lastName + "</p>" +
									"<p>industry: " + members[member].industry+"</p>" +
									"<p>headline: " + members[member].headline+"</p>" +
									"<p>location.name: " + members[member].location.name+"</p>" +
									"<p>location.country.code: " + members[member].location.country.code+"</p>" +			
									"<p>siteStandardProfileRequest: " + members[member].siteStandardProfileRequest.url + "</p>" +
									"<p>apiStandardProfileRequest: " + members[member].apiStandardProfileRequest.url + "</p>" +
									"<p>Picture URL: " + members[member].pictureUrl + "</p>" +
									"<p>Public Profile URL: " + members[member].publicProfileUrl + "</p><br/>";
	
									//i++;
								}
	
								document.getElementById("profiles").innerHTML += data;
							})
					    .error(
							function(e){
								alert("something broken " + e.message);
							});*/
							
				}

				document.getElementById("profiles").innerHTML += data;	
				
		    })
		    .error(
				function(e) {
					alert("something broken1 " + e.message);
				});
		    
	}
</script>
</head>
<body topmargin="0" leftmargin="0">


<script type="IN/Login"></script>


<div id="profiles"></div>
<!--  
<p><a href="http://halley.exp.sis.pitt.edu/comet/utils/friendlinks.html">Friend Links</p>
-->

</body>
</html>