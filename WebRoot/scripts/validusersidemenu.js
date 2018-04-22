var rti;
var tree = new WebFXTree("HOME","./index.do","","./images/xp/folder.png","./images/xp/openfolder.png");
	tree.add(new WebFXTreeItem("Calendar","./calendar.do"));
	var account = new WebFXTreeItem("My Colloquia","./mycolloquia.do");

	tree.add(account);   

	//account.add(new WebFXTreeItem("Edit User Preference","./account/editpreference.do"));
	//account.add(new WebFXTreeItem("Edit User Profile","./account/editprofile.do"));
	//account.add(new WebFXTreeItem("Logout","./logout.do"));

	tree.add(new WebFXTreeItem("Logout","./logout.do"));
	
	document.write(tree);