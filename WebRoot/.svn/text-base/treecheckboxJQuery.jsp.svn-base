<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<!-- include jQuery libraries -->
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.3/jquery-ui.min.js"></script>

<!-- include checkboxTree plugin -->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() + "/css/jquery.checkboxtree.min.css"%>">
<script type="text/javascript" src="scripts/jquery.checkboxtree.min.js"></script>

<!-- initialize checkboxTree plugin -->
<script type="text/javascript">
//<!--
    $(document).ready(function() {
        $('#tree').checkboxTree({
        	initializeChecked: 'expanded',
        	initializeUnchecked: 'collapsed',
        	onCheck: {
			    ancestors: '', //or 'check', 'uncheck'
			    descendants: '', //or 'check', 'uncheck'
			    node: 'expand' // or 'collapse', ''
        	},
        	onUncheck: {
			    ancestors: '', //or 'check', 'uncheck'
			    descendants: '', //or 'check', 'uncheck'
			    node: 'collapse' // or '', 'expand'
        	}
        });
    });
//-->
</script>
</head>
<body>
	<ul id="tree"> 
		<li><input type="checkbox">Root
		    <ul> 
		        <li><input type="checkbox">Node 1
			        <ul> 
			            <li><input type="checkbox">Node 1.1
			        </ul> 
		    </ul> 
		    <ul> 
		        <li><input type="checkbox">Node 2
			        <ul> 
			            <li><input type="checkbox">Node 2.1
			            <li><input type="checkbox">Node 2.2
			            <li><input type="checkbox">Node 2.3
				            <ul> 
				                <li><input type="checkbox">Node 2.3.1
				                <li><input type="checkbox">Node 2.3.2
				            </ul> 
			            <li><input type="checkbox">Node 2.4
			            <li><input type="checkbox">Node 2.5
			            <li><input type="checkbox">Node 2.6
			        </ul> 
		    </ul> 
	</ul>
</body>
</html>