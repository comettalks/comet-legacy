<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps JavaScript API Example</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAJI_zK1PdCwBIN9LKJfow1xSZG4mSLdZO-3rbn4afKBinwLU_IhSwL_cnwkbYzkaSS-XFbDC4Mgv8aA"
      type="text/javascript"></script>
    <script type="text/javascript">

    //<![CDATA[

    function load(address) {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
        var geocoder = new GClientGeocoder();
        //var point = new GLatLng(37.4419, -122.1419);
        //var marker = new GMarker(point);
        map.addControl(new GLargeMapControl());
        map.addControl(new GMapTypeControl());
        map.addControl(new GScaleControl());
		map.enableScrollWheelZoom();        
        //map.setCenter(point, 1);
        //map.addOverlay(marker);
		geocoder.getLatLng(
		  address,
		  function(point) {
		    if (!point) {
		      alert(address + " not found");
		    } else {
		      map.setCenter(point, 5);		      		      
		      var marker = new GMarker(point);
		      map.addOverlay(marker);
		      //marker.openInfoWindowHtml(address);
		      /*GEvent.addListener(marker, "click", function() {
          	  	marker.showMapBlowup();
    			});*/
    		  GEvent.addListener(marker, "click", function() {
                marker.openInfoWindow(address);
    			});
		    }
		  }
		);
	  }
	}
    //]]>
    </script>
  </head>
  <body onload="load('Pittsburgh, PA')" onunload="GUnload()">
    <div id="map" style="width: 800px; height: 500px"></div>
  </body>
</html>