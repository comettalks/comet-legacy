<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<script language="JavaScript" src="scripts/prototype.js"></script>
 <script language="JavaScript">
 function showChildren(obj)
 {
     var children = obj.immediateDescendants();
     for(var i=0;i<children.length;i++)
     {
         if(children[i].tagName.toLowerCase()=='ul')
             children[i].toggle();
     }
 }
 
 function checkChildren(obj,srcObj)
 {
     var children = obj.immediateDescendants();
     for(var i=0;i<children.length;i++)
     {
         if(children[i].tagName.toLowerCase()=='input' && children[i].type=='checkbox' && children[i]!=srcObj)
             children[i].checked = srcObj.checked;
 
         // recursive call
         checkChildren(children[i],srcObj);
     }
 }
 </script>
 <style type='text/css' media='all'>
 body {
     font: normal 11px verdana;
     }
 
 ul li{
     list-style-type:none;
     margin:0;
     padding:0;
     margin-left:8px;
 }
 
 ul li a{
     text-decoration:none;
     color:#000;
 }
 </style>
 <ul style="display:block">
     <li id="1"><input type='checkbox' name='f_1'>Web Development<input type="button" onclick='showChildren($("1"));this.style.width="0px";this.style.display="none";' value='Show Children'  />
         <ul style="display:none">
             <li id="2"><input type='checkbox' name='f_2' onclick='checkChildren($("2"),this);'><a href='javascript:void(0);' onclick='showChildren($("2"));'>PHP</a></li>
             <li id="3"><input type='checkbox' name='f_3' onclick='checkChildren($("3"),this);'><a href='javascript:void(0);' onclick='showChildren($("3"));'>ASP</a></li>
         </ul>
     </li>
     <li id="4"><input type='checkbox' name='f_4' onclick='checkChildren($("4"),this);'><a href='javascript:void(0);' onclick='showChildren($("4"));'>VBScript/JScript/DHTML</a>
         <ul style="display:none">
             <li id="5"><input type='checkbox' name='f_5' onclick='checkChildren($("5"),this);'><a href='javascript:void(0);' onclick='showChildren($("5"));'>JScript/JavaScript</a>
                 <ul style="display:none">
                     <li id="8"><input type='checkbox' name='f_8' onclick='checkChildren($("8"),this);'><a href='javascript:void(0);' onclick='showChildren($("8"));'>JScript</a></li>
                     <li id="9"><input type='checkbox' name='f_9' onclick='checkChildren($("9"),this);'><a href='javascript:void(0);' onclick='showChildren($("9"));'>JavaScript</a></li>
                 </ul>
             </li>
             <li id="6"><input type='checkbox' name='f_6' onclick='checkChildren($("6"),this);'><a href='javascript:void(0);' onclick='showChildren($("6"));'>VBScript</a></li>
             <li id="7"><input type='checkbox' name='f_7' onclick='checkChildren($("7"),this);'><a href='javascript:void(0);' onclick='showChildren($("7"));'>CSS</a></li>
         </ul>
     </li>
 </ul>
 
 </body>
</html>