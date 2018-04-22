<%@page language="java"%><%@page import="java.util.HashMap"%><%@ page import="java.io.*"  %><% 
	String filePath = getServletContext().getRealPath("ensemble");
	File f = new File(filePath);
	File[] fList = f.listFiles();
	int i=0;
	StringBuffer sb=new StringBuffer(); 
	for(File file : fList){
		String fileName = file.getName();
		if(fileName.trim().toLowerCase().endsWith(".node")){
			if(i>0){
				sb.append(",");
			}
			InputStream in = new FileInputStream(filePath + "/" + fileName); 
			BufferedInputStream bin = new BufferedInputStream(in); 
			DataInputStream din = new DataInputStream(bin); 
			StringBuffer sbChild = new StringBuffer(); 
			while(din.available()>0){ 
		    	sb.append(din.readLine());
		    }
			in.close(); 
			bin.close(); 
			din.close(); 

			i++;
		}
	}
%>
var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
  elem: false,
  write: function(text){
    if (!this.elem) 
      this.elem = document.getElementById('log');
    this.elem.innerHTML = text;
    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};

function treemap_init(){
  //init data
  var json = {
    "children": [
<%=sb.toString() %>
   ], 
   "data": {}, 
   "id": "root", 
   "name": "Ensemble Communities"
   };
  //end
  //init TreeMap
  var tm = new $jit.TM.Squarified({
    //where to inject the visualization
    injectInto: 'infovis',
     //show only two tree levels  
	levelsToShow: 2,  
    //parent box title heights
    titleHeight: 15,
    //enable animations
    animate: animate,
    //box offsets
    offset: 1,
    //Attach left and right click events
    Events: {
      enable: true,
      onClick: function(node) {
        if(node) {
        	if(node.data.url){
        		window.location = node.data.url;
        	}else{
        		tm.enter(node);
        	}
        }
      },
      onRightClick: function() {
        tm.out();
      }
    },
    duration: 1000,
    //Enable tips
    Tips: {
      enable: true,
      //add positioning offsets
      offsetX: 20,
      offsetY: 20,
      //implement the onShow method to
      //add content to the tooltip when a node
      //is hovered
      onShow: function(tip, node, isLeaf, domElement) {
        var html = "<div class=\"tip-title\">" + node.name 
          + "</div><div class=\"tip-text\">";
        var data = node.data;
        if(data.post) {
          html += "post: " + data.post;
        }
        if(data.view) {
          html += "view: " + data.view;
        }
        if(data.image) {
          html += "<img src=\""+ data.image +"\" class=\"album\" />";
        }
        tip.innerHTML =  html; 
      }  
    },
    //Add the name of the node in the corresponding label
    //This method is called once, on label creation.
    onCreateLabel: function(domElement, node){
        domElement.innerHTML = node.name;
        var style = domElement.style;
        style.display = '';
        style.border = '1px solid transparent';
        domElement.onmouseover = function() {
          style.border = '1px solid #9FD4FF';
        };
        domElement.onmouseout = function() {
          style.border = '1px solid transparent';
        };
    }
  });
  tm.loadJSON(json);
  tm.refresh();
  //end
}

var temp_f;
if( window.onload ) {
    temp_f = window.onload;
}

window.onload = function () {
    if( temp_f ) {
        temp_f();
    }
    // do other stuff here
    treemap_init();
}
    