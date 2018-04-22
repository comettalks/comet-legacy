// define index of folder nodes being closed when navigation bar is clicked  
this.menuFolderIndex = new Array(3);
this.menuFolderIndex[0] = '2';
this.menuFolderIndex[1] = '4';
this.menuFolderIndex[2] = '6';

// use to open side menu from navigation bar
function openMenuIndex(index){
for (i=0;i<menuFolderIndex.length;i=i+1) 
{document.cookie = menuFolderIndex[i] + "=0; path = /";}
if (index != -1) {document.cookie = index + "=1; path = /";}
}

//var rti;
var tree = new WebFXTree("Organizer","");
	var h1 = new WebFXTreeItem("University of Pittsburgh","./listbyhost.do?host_id=1");
	var h2 = new WebFXTreeItem("School of Arts and Sciences","./listbyhost.do?host_id=2");
	var h3 = new WebFXTreeItem("Katz Graduate School of Business","./listbyhost.do?host_id=3");
	var h4 = new WebFXTreeItem("School of Dental Medicine","./listbyhost.do?host_id=4");
	var h5 = new WebFXTreeItem("School of Education","./listbyhost.do?host_id=5");
	var h6 = new WebFXTreeItem("School of Engineering","./listbyhost.do?host_id=6");
	var h7 = new WebFXTreeItem("College of General Studies","./listbyhost.do?host_id=7");
	var h8 = new WebFXTreeItem("School of Health and Rehabilitation Sciences","./listbyhost.do?host_id=8");
	var h9 = new WebFXTreeItem("University Honors College","./listbyhost.do?host_id=9");
	var h10 = new WebFXTreeItem("School of Information Sciences","./listbyhost.do?host_id=10");
	var h11 = new WebFXTreeItem("School of Law","./listbyhost.do?host_id=11");
	var h12 = new WebFXTreeItem("School of Medicine","./listbyhost.do?host_id=12");
	var h13 = new WebFXTreeItem("School of Nursing","./listbyhost.do?host_id=13");
	var h14 = new WebFXTreeItem("School of Pharmacy","./listbyhost.do?host_id=14");
	var h15 = new WebFXTreeItem("Graduate School of Public and International Affairs","./listbyhost.do?host_id=15");
	var h16 = new WebFXTreeItem("Grauate School of Public Health","./listbyhost.do?host_id=16");
	var h17 = new WebFXTreeItem("School of Social Work","./listbyhost.do?host_id=17");
	var h18 = new WebFXTreeItem("Center for Instructional Development and Distance Education","./listbyhost.do?host_id=18");
	var h19 = new WebFXTreeItem("University Center for International Studies","./listbyhost.do?host_id=19");
	var h20 = new WebFXTreeItem("Learning Research and Development Center","./listbyhost.do?host_id=20");
	var h21 = new WebFXTreeItem("Center for Philosophy of Science","./listbyhost.do?host_id=21");
	var h22 = new WebFXTreeItem("University Center for Social and Urban Reseach","./listbyhost.do?host_id=22");
	var h23 = new WebFXTreeItem("Department of Information Science and Telecommunications","./listbyhost.do?host_id=23");
	var h24 = new WebFXTreeItem("Department of Library and Information Science","./listbyhost.do?host_id=24");
	var h25 = new WebFXTreeItem("Graduate Program in Telecommunications and Networking","./listbyhost.do?host_id=25");
	var h26 = new WebFXTreeItem("Carnegie Mellon University","./listbyhost.do?host_id=26");
	var h27 = new WebFXTreeItem("Carnegie Institute of Technology","./listbyhost.do?host_id=27");
	var h28 = new WebFXTreeItem("College of Fine Arts","./listbyhost.do?host_id=28");
	var h29 = new WebFXTreeItem("College of Humanities and Social Sciences","./listbyhost.do?host_id=29");
	var h30 = new WebFXTreeItem("Tepper School of Business","./listbyhost.do?host_id=30");
	var h31 = new WebFXTreeItem("H. John Heinz III School of Public Policy and Management","./listbyhost.do?host_id=31");
	var h32 = new WebFXTreeItem("Mellon College of Science","./listbyhost.do?host_id=32");
	var h33 = new WebFXTreeItem("School of Computer Science","./listbyhost.do?host_id=33");
	var h34 = new WebFXTreeItem("Computer Science Department","./listbyhost.do?host_id=34");
	var h35 = new WebFXTreeItem("Robotics Institute","./listbyhost.do?host_id=35");
	var h36 = new WebFXTreeItem("Institute for Software Research International","./listbyhost.do?host_id=36");
	var h37 = new WebFXTreeItem("Human-Computer Interaction Institute","./listbyhost.do?host_id=37");
	var h38 = new WebFXTreeItem("Language Technologies Institute","./listbyhost.do?host_id=38");
	var h39 = new WebFXTreeItem("Machine Learning Department","./listbyhost.do?host_id=39");
	var h40 = new WebFXTreeItem("Entertainment Technology Center","./listbyhost.do?host_id=40");
	var h41 = new WebFXTreeItem("Electrical and Computer Engineering Department","./listbyhost.do?host_id=41");
	var h42 = new WebFXTreeItem("Engineering and Public Policy Department","./listbyhost.do?host_id=42");
	var h43 = new WebFXTreeItem("Department of Computer Science","./listbyhost.do?host_id=43");
	var h44 = new WebFXTreeItem("Electrical and Computer Engineering Department","./listbyhost.do?host_id=44");
	var h45 = new WebFXTreeItem("Intelligent Systems Program","./listbyhost.do?host_id=45");
	var h46 = new WebFXTreeItem("Laboratory of Education and Research on Security Assured Information System","./listbyhost.do?host_id=46");
	var h47 = new WebFXTreeItem("Johnson Institute for Responsible Leadership","./listbyhost.do?host_id=47");
	var h48 = new WebFXTreeItem("Carnegie Mellon CyLab","./listbyhost.do?host_id=48");
	var h49 = new WebFXTreeItem("Center For National Preparedness","./listbyhost.do?host_id=49");
	var h50 = new WebFXTreeItem("Department of Electrical and Computer Engineering","./listbyhost.do?host_id=50");
	var h51 = new WebFXTreeItem("Department of Physics","./listbyhost.do?host_id=51");
	
	//Pitt	
	tree.add(h1);
	h1.add(h2);
	
	h2.add(h43);
	h2.add(h45);
	
	h1.add(h3);
	h1.add(h4);
	h1.add(h5);
	h1.add(h6);
	
	h6.add(h44);
	h6.add(h50);
	
	h1.add(h7);
	h1.add(h8);
	h1.add(h9);
	h1.add(h10);
	
	h10.add(h23);
	h10.add(h24);
	h10.add(h25);
	h10.add(h46);
	
	h1.add(h11);
	h1.add(h12);
	h1.add(h13);
	h1.add(h14);
	h1.add(h15);
	
	h15.add(h47);
	
	h1.add(h16);
	h1.add(h17);
	h1.add(h18);
	h1.add(h19);
	h1.add(h20);
	h1.add(h21);
	h1.add(h22);
	h1.add(h49);
	
	//CMU
	tree.add(h26);
	h26.add(h27);
	
	h27.add(h41);
	h27.add(h42);
	
	h26.add(h28);
	h26.add(h29);
	h26.add(h30);
	h26.add(h31);
	h26.add(h32);
	
	h32.add(h51);
	
	h26.add(h33);
	
	h33.add(h34);
	h33.add(h35);
	h33.add(h36);
	h33.add(h37);
	h33.add(h38);
	h33.add(h39);
	h33.add(h40);
	
	h26.add(h48);
	
	document.write(tree);