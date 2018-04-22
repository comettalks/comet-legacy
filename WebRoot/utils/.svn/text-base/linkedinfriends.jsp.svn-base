<%@ page language="java"%>

<html>
<head>
<title>LinkedIn : Friend Links</title>

<script type="text/javascript" src="http://platform.linkedin.com/in.js">
  api_key: p76qgK1ZG4Ae41NgAzI9SLeJhrbxawHLZpFstB84F69aS9SqYcAjgC8_B0ui2U7I
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
		IN.API.Connections("me")
		    .fields(
			"id","firstName", "lastName", "industry","headline","apiStandardProfileRequest",
			"siteStandardProfileRequest", "pictureUrl", "publicProfileUrl"
			)
		    .result(displayConnections)
		    .error(displayConnectionsErrors);


	}

	function displayConnections(connections) {
		var connectionsDiv = document.getElementById("connections");
		
		var members = connections.values;
		for (var member in members) {
			/*connectionsDiv.innerHTML += "<p>"+member+"</p>"+
			"<p>ID: " + members[member].id + "</p>"+
			"<p>FirstName: "+members[member].firstName + "</p>"+
			"<p>LastName:" + members[member].lastName + "</p>"+
			"<p>industry: " + members[member].industry+"</p>"+
			"<p>headline: " + members[member].headline+"</p>"+
			"<p>apiStandardProfileRequest.url: " + members[member].apiStandardProfileRequest.url + "</p>" +
			"<p>siteStandardProfileRequest.url: " + members[member].siteStandardProfileRequest.url + "</p>" +
			"<p>Picture URL: " + members[member].pictureUrl + "</p>" +
			"<p>Public Profile URL: " + members[member].publicProfileUrl + "</p>";*/

		    IN.API.Profile(members[member].publicProfileUrl)
		    .fields("id","firstName", "lastName", "industry","distance","headline","location",
		    	    "currentStatus","currentStatusTimestamp","summary",
		    	    "specialties","proposalComments","associations","honors","interests","positions","publications","patents",
		    	    "languages","skills","certifications","educations","threeCurrentPositions","threePastPositions","numRecommenders",
		    	    "recommendationsReceived","relation-to-viewer","apiStandardProfileRequest", "pictureUrl", "publicProfileUrl")
		    .result(function(profiles){
				var members = profiles.values;
				for(var member in members){
					connectionsDiv.innerHTML += 
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
					"<p>Public Profile URL: " + members[member].publicProfileUrl + "</p>";

				}
		    })
		    .error( function(e) {alert("something broken " + e);} );
		}

	}

  function displayConnectionsErrors(error) {}
</script>
</head>
<body>

<div id="connections"></div>

</body>
</html>
