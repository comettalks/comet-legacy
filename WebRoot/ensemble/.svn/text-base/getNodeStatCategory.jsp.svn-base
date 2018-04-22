<%@page language="java"%><%@page import="java.util.HashMap"%><%@ page import="java.io.*"  %><% 
	String filePath = getServletContext().getRealPath("ensemble");
	File f = new File(filePath);
	File[] fList = f.listFiles();
	int i=0;
	//Keep nodes in the map first
	HashMap<String,String> nodeMap = new HashMap<String,String>();
	StringBuffer sb=new StringBuffer(); 
	for(File file : fList){
		String fileName = file.getName();
		if(fileName.trim().toLowerCase().endsWith(".node")){
			//if(i>0){
			//	sb.append(",");
			//}
			InputStream in = new FileInputStream(filePath + "/" + fileName); 
			BufferedInputStream bin = new BufferedInputStream(in); 
			DataInputStream din = new DataInputStream(bin); 
			StringBuffer sbChild = new StringBuffer(); 
			while(din.available()>0){ 
				String line = din.readLine();
		    	//sb.append(line);
		    	sbChild.append(line);
		    }
			nodeMap.put(fileName.replaceAll(".node",""),sbChild.toString().trim());
			in.close(); 
			bin.close(); 
			din.close(); 

			//i++;
		}
	}
	if(nodeMap.size() > 0){
		int ig1 = 0;
		int ig2 = 0;
		int ig3 = 0;
		int ig4 = 0;
		int ig5 = 0;
		int ig6 = 0;
		
		StringBuffer sbg1 = new StringBuffer();
		StringBuffer sbg2 = new StringBuffer();
		StringBuffer sbg3 = new StringBuffer();
		StringBuffer sbg4 = new StringBuffer();
		StringBuffer sbg5 = new StringBuffer();
		StringBuffer sbg6 = new StringBuffer();
		
		int g1view = 0;
		int g2view = 0;
		int g3view = 0;
		int g4view = 0;
		int g5view = 0;
		int g6view = 0;

		int g1post = 0;
		int g2post = 0;
		int g3post = 0;
		int g4post = 0;
		int g5post = 0;
		int g6post = 0;

		int g1area = 0;
		int g2area = 0;
		int g3area = 0;
		int g4area = 0;
		int g5area = 0;
		int g6area = 0;
		
		for(String node : nodeMap.keySet()){
			int _node = Integer.parseInt(node);
			String line = nodeMap.get(node);
			String[] view = line.split("\"view\"");
			int _view = 0;
			if(view != null){
				for(i=0;i<view.length;i++){
					String viewString = view[i];
					viewString = viewString.substring(0, viewString.indexOf(","));
					viewString = viewString.replaceAll("\"","").trim();
					viewString = viewString.replaceAll(":","").trim();
					try{
						_view += Integer.parseInt(viewString);
					}catch(Exception e){
						
					}
				}
			}	
			
			String[] post = line.split("\"post\"");
			int _post = 0;
			if(post != null){
				String lastPostString = post[post.length-1];
				lastPostString = lastPostString.substring(0, lastPostString.indexOf(","));
				lastPostString = lastPostString.replaceAll(":","").trim();
				try{
					_post = Integer.parseInt(lastPostString);
				}catch(Exception e){
					
				}
			}	
			
			String[] area = line.split("\"\\$area\"");
			int _area = 0;
			if(area != null){
				String lastAreaString = area[area.length-1];
				//out.println(node + " lastAreaString: " + lastAreaString);
				lastAreaString = lastAreaString.substring(0, lastAreaString.indexOf("}"));
				lastAreaString = lastAreaString.replaceAll(":","").trim();
				try{
					_area = Integer.parseInt(lastAreaString);
				}catch(Exception e){
					//out.println("_area: " + _area);
				}
			}
			//Ensemble Site Development - Group 1
			//1. The Ensemble Design and Development Effort - node:268
			//2. TECH Developers - node:282
			//3. TECH - node:812
			//4. SIGCSE 2010 Workshop 18 : Using Drupal for Educational Web Site Development - node:586
			//5. Villanova Group - node:800
			switch(_node){
				case 268: case 282: case 812: case 586: case 800:
					g1view += _view;
					g1post += _post;
					g1area += _area;
					if(ig1 > 0){
						sbg1.append(",");	
					}
					String lineG1 = line.replaceAll("id\":\"" + node, "id\":\"g1_" + node);
					sbg1.append(lineG1);
					ig1++;
					break;
			}
			
			//Forums/Discussions - Group 2
			//1. Interdisciplinary Computing - node:904
			//2. AP CS Principles Piloters - node:526
			//3. General Discussions - node:573
			//4. CRA-E - node:894
			//5. SE 2004 Review Task Force - node:7451
			switch(_node){
				case 904: case 526: case 573: case 894: case 7451:
					g2view += _view;
					g2post += _post;
					g2area += _area;
					if(ig2 > 0){
						sbg2.append(",");	
					}
					String lineG2 = line.replaceAll("id\":\"" + node, "id\":\"g2_" + node);
					sbg2.append(lineG2);
					ig2++;
					break;
			}
			
			//Teaching focus - Group 3
			//1. RET Collaborative Portal - node:512
			//2. Interactive Journalism Institute for Middle School (IJIMS) - node:619
			//3. Teaching Track Faculty - node:577
			//4. ACM - node:413
			//5. ACM Computing Education in Community Colleges - node:7531
			//6. Consortium for Computing Sciences in Colleges (CCSC) - node:9387
			//7. Student Centered Interest Group - node:7502
			//8. Bargain Book Announcements - node:499
			//9. CS 10K Initiative - node:527
			//10.JCDL/ICADL 2010 Digital Libraries and Education Workshop - node:645
			//11.What Is Computational Thinking? - node:576
			switch(_node){
				case 512: case 619: case 577: case 413: case 7531: case 9387: case 7502: case 499: case 527: case 645: case 576:
					g3view += _view;
					g3post += _post;
					g3area += _area;
					if(ig3 > 0){
						sbg3.append(",");	
					}
					String lineG3 = line.replaceAll("id\":\"" + node, "id\":\"g3_" + node);
					sbg3.append(lineG3);
					ig3++;
					break;
			}
			
			//Computing Education Projects - Group 4
			//1. LIKES - node:522
			//2. SIGCAS Ontology Project - node:842
			//3. Educational Alliance for a Parallel Future - node:595
			//4. Master of Software Assurance (MSwA) - node:7452
			//5. SE 2004 Review Task Force - node:7451
			//6. The Ensemble Design and Development Effort - node:268
			//7. TECH Pack Ethical issues - node:9386
			//8. CRA-E - node:894
			switch(_node){
				case 522: case 842: case 595: case 7452: case 7451: case 268: case 9386: case 894:
					g4view += _view;
					g4post += _post;
					g4area += _area;
					if(ig4 > 0){
						sbg4.append(",");	
					}
					String lineG4 = line.replaceAll("id\":\"" + node, "id\":\"g4_" + node);
					sbg4.append(lineG4);
					ig4++;
					break;
			}

			//Course and Curriculum - Group 5
			//1.  CS1 Community Site - node:283
			//2.  CS 10K Initiative - node:527
			//3.  CS2013 - node:4572
			//4.  SE 2004 Review Task Force - node:7451
			//5.  Learn Java in N Games - node:7497
			//6.  Educational Alliance for a Parallel Future - node:595
			//7.  Master of Software Assurance (MSwA) - node:7452
			//8.  Passion, Beauty, Joy and Awe - node:575
			//9.  TECH Pack Ethical issues - node:9386
			//10. Music and Computing - node:561
			//11. MediaComp - Media Computation - node:882
			//12. CE21 - node:4249
			switch(_node){
				case 283: case 527: case 4572: case 7451: case 7497: case 595: case 7452: case 575: case 9386: case 561: case 882: case 4249:
					g5view += _view;
					g5post += _post;
					g5area += _area;
					if(ig5 > 0){
						sbg5.append(",");	
					}
					String lineG5 = line.replaceAll("id\":\"" + node, "id\":\"g5_" + node);
					sbg5.append(lineG5);
					ig5++;
					break;
			}
			
			//Meeting/Activity records - Group 6
			//1. TECH Developers - node:282
			//2. Interdisciplinary Computing - node:904
			//3. 2010 CPATH PI Meeting - node:617
			//4. RET Collaborative Portal - node:512
			//5. LIKES - node:522
			//6. JCDL/ICADL 2010 Digital Libraries and Education Workshop - node:645
			//7. SIGCSE 2010 Workshop 18 : Using Drupal for Educational Web Site Development - node:586
			//8. AP CS principles piloters - node:526
			//9. PACE - node:4429
			//10.FOCES - node:226
			//11.ACM - node:413
			//12.ACM Computing Education in Community Colleges - node:7531
			//13.What is Computational Thinking? - node:576
			switch(_node){
				case 282: case 904: case 617: case 512: case 522: case 645: case 586: case 526: case 4429: case 226: case 413: case 7531: case 576:
					g6view += _view;
					g6post += _post;
					g6area += _area;
					if(ig6 > 0){
						sbg6.append(",");	
					}
					String lineG6 = line.replaceAll("id\":\"" + node, "id\":\"g6_" + node);
					sbg6.append(lineG6);
					ig6++;
					break;
			}
		}
	
		i=0;
		if(ig1 > 0){
			String line = "{\"children\": [" + sbg1.toString().trim() + 
			    "],\"data\": {\"post\": " + g1post + ",\"$area\": " + (int)(Math.log(g1area + 1)*100) + 
				"},\"id\":\"g1\",\"name\":\"Ensemble Site Development\"}";
			sb.append(line);
			i++;
		}
		
		if(ig2 > 0){
			if(i > 0){
				sb.append(",");	
			}
			String line = "{\"children\": [" + sbg2.toString().trim() + 
			    "],\"data\": {\"post\": " + g2post + ",\"$area\": " + (int)(Math.log(g2area + 1)*100) + 
				"},\"id\":\"g2\",\"name\":\"Forums/Discussions\"}";
			sb.append(line);
			i++;
		}
		
		if(ig3 > 0){
			if(i > 0){
				sb.append(",");	
			}
			String line = "{\"children\": [" + sbg3.toString().trim() + 
			    "],\"data\": {\"post\": " + g3post + ",\"$area\": " + (int)(Math.log(g3area + 1)*100) + 
				"},\"id\":\"g3\",\"name\":\"Teaching focus\"}";
			sb.append(line);
			i++;
		}

		if(ig4 > 0){
			if(i > 0){
				sb.append(",");	
			}
			String line = "{\"children\": [" + sbg4.toString().trim() + 
			    "],\"data\": {\"post\": " + g4post + ",\"$area\": " + (int)(Math.log(g4area + 1)*100) + 
				"},\"id\":\"g4\",\"name\":\"Computing Education Projects\"}";
			sb.append(line);
			i++;
		}

		if(ig5 > 0){
			if(i > 0){
				sb.append(",");	
			}
			String line = "{\"children\": [" + sbg5.toString().trim() + 
			    "],\"data\": {\"post\": " + g5post + ",\"$area\": " + (int)(Math.log(g5area + 1)*100) + 
				"},\"id\":\"g5\",\"name\":\"Course and Curriculum\"}";
			sb.append(line);
			i++;
		}

		if(ig6 > 0){
			if(i > 0){
				sb.append(",");	
			}
			String line = "{\"children\": [" + sbg6.toString().trim() + 
			    "],\"data\": {\"post\": " + g6post + ",\"$area\": " + (int)(Math.log(g6area + 1)*100) + 
				"},\"id\":\"g6\",\"name\":\"Meeting/Activity records\"}";
			sb.append(line);
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
    