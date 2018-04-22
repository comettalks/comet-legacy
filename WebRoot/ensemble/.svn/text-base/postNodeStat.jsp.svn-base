<%@page import="java.util.HashMap"%><%@page language="java"%>
<%@ page import="java.io.*"  %> 
<% 
	/*String fileName=getServletContext().getRealPath("ensemble/jsp.txt"); 
	File f=new File(fileName); 
	InputStream in = new FileInputStream(f); 
	BufferedInputStream bin = new BufferedInputStream(in); 
	DataInputStream din = new DataInputStream(bin); 
	StringBuffer sb=new StringBuffer(); 
	while(din.available()>0){ 
    	sb.append(din.readLine()); 
    } 
	out.println(sb.toString());*/
	String req_node = request.getParameter("node");
	String req_node_title = request.getParameter("node_title");
	String req_node_view = request.getParameter("node_view");
	String[] req_children_node_value = request.getParameterValues("children_node");
	String[] req_children_node_title_value = request.getParameterValues("children_node_title");
	String[] req_children_node_type_value = request.getParameterValues("children_node_type");
	String[] req_children_node_view_value = request.getParameterValues("children_node_view");
	
	StringBuffer sb=new StringBuffer();
	sb.append("{");
	sb.append("\"children\": [");

	double max_child_node_view = 0;
	
	HashMap<String,Integer> typeMap = new HashMap<String,Integer>();
	HashMap<String,Integer> typeViewMap = new HashMap<String,Integer>();
	HashMap<Integer,String> nodeTitleMap = new HashMap<Integer,String>();
	HashMap<String,HashMap<Integer,Integer>> typeChildNodeViewMap = new HashMap<String,HashMap<Integer,Integer>>();
	
	for(int i=0;i<req_children_node_value.length;i++){
		//Map type -> typeno
		int typeno = 0;
		if(typeMap.containsKey(req_children_node_type_value[i])){
			typeno = typeMap.get(req_children_node_type_value[i]);
		}
		typeno++;
		typeMap.put(req_children_node_type_value[i],new Integer(typeno));
		
		//Map type -> typeview
		int typeview = 0;
		if(typeViewMap.containsKey(req_children_node_type_value[i])){
			typeview = typeViewMap.get(req_children_node_type_value[i]);
		}
		typeview += Integer.parseInt(req_children_node_view_value[i]);
		typeViewMap.put(req_children_node_type_value[i],new Integer(typeview));
		
		//Map nodeId -> Title
		nodeTitleMap.put(new Integer(req_children_node_value[i]),req_children_node_title_value[i].replace("\"","\\\""));
		
		HashMap<Integer,Integer> childNodeViewMap = typeChildNodeViewMap.get(req_children_node_type_value[i]);
		if(childNodeViewMap == null){
			childNodeViewMap = new HashMap<Integer,Integer>();
		}
		
		childNodeViewMap.put(new Integer(req_children_node_value[i]),new Integer(req_children_node_view_value[i]));
		typeChildNodeViewMap.put(req_children_node_type_value[i],childNodeViewMap);
		
		if(max_child_node_view < Double.parseDouble(req_children_node_view_value[i])){
			max_child_node_view = Double.parseDouble(req_children_node_view_value[i]);
		}

	}
	
	double max_children_view = 0;
	for(String _type : typeViewMap.keySet()){
		if(max_children_view < typeViewMap.get(_type)){
			max_children_view = (double)typeViewMap.get(_type);
		}
	}
	
	int i=0;
	int totaltypeno = 0;
	for(String _type : typeMap.keySet()){
		int typeno = typeMap.get(_type);
		int typeview = typeViewMap.get(_type);
		
		totaltypeno += typeno;
		
		double ratio = ((double)typeview)/max_children_view;
		
		if(i==0){
			sb.append("{");
		}else{
			sb.append(",{");
		}
		
		sb.append("\"children\": [");
		
		//The third tree level
		int j=0;
		HashMap<Integer,Integer> childNodeViewMap = typeChildNodeViewMap.get(_type);
		
		for(Integer child_node : childNodeViewMap.keySet()){
			double child_ratio = ((double)childNodeViewMap.get(child_node))/max_child_node_view;
		
			if(j==0){
				sb.append("{");
			}else{
				sb.append(",{");
			}

			sb.append("\"children\": [],");
			sb.append("\"data\": {");
			sb.append("\"view\": \"" + childNodeViewMap.get(child_node).intValue() + "\",");
			//sb.append("\"$color\": \"#8E7032\",");
			
			if(child_ratio > .5){
				sb.append("\"$color\": \"#4E991F\",");
			}else if (child_ratio > .1 && child_ratio <= .5){
				sb.append("\"$color\": \"#AADE8A\",");
			}else{
				sb.append("\"$color\": \"#B9FF7F\",");
			}
			
			sb.append("\"$area\": " + (int)(Math.log(childNodeViewMap.get(child_node) + 1)*100) + ",");
			sb.append("\"url\": \"node/" + child_node.intValue() + "\"");
			sb.append("},\n");
			sb.append("\"id\":\"" + req_node + "_" + child_node.intValue() + "\",");
			sb.append("\"name\":\"" + nodeTitleMap.get(child_node) + "\"");
			sb.append("}\n");
				
			j++;	
		}
		
		sb.append("],");	
		sb.append("\"data\": {");
		sb.append("\"post\": \"" + typeno + "\",");
		//sb.append("\"$color\": \"#8E7032\",");
		
		if(ratio > .5){
			sb.append("\"$color\": \"#4E991F\",");
		}else if (ratio > .1 && ratio <= .5){
			sb.append("\"$color\": \"#AADE8A\",");
		}else{
			sb.append("\"$color\": \"#B9FF7F\",");
		}
		
		sb.append("\"$area\": " + (int)(Math.log(typeno + 1)*100));
		sb.append("},\n");
		sb.append("\"id\":\"" + req_node + "_" + _type + "\",");
		sb.append("\"name\":\"" + _type + "\"");
		sb.append("}\n");
		
		i++;
	}
	
	sb.append("],");
	sb.append("\"data\": {");
	sb.append("\"post\": " + totaltypeno + ",");
	sb.append("\"$area\": " + (int)(Math.log(totaltypeno + 1)*100));
	sb.append("},\n");
	sb.append("\"id\":\"" + req_node + "\",");
	sb.append("\"name\":\"" + req_node_title + "\"");
	sb.append("}\n");
	
	try {    
	    PrintWriter pw = new PrintWriter(new FileOutputStream(getServletContext().getRealPath(".") + "/ensemble/" + req_node + ".node"));// save file 
	    pw.println(sb.toString()); 
	    pw.close(); 
	} catch(IOException e) { 
	   out.println(e.getMessage()); 
	} 
          
	//in.close(); 
	//bin.close(); 
	//din.close(); 
%> 