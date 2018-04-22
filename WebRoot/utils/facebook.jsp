<%@ page language="java"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
 
<html xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:fb="http://www.facebook.com/2008/fbml"> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<meta property="fb:app_id" content="345817736440" /> 
  <title>CoMeT Facebook</title> 
<link type="text/css" href="../css/jquery-ui-1.8.5.custom.css" rel=
  "stylesheet" /> 
  <script type="text/javascript" src="../scripts/jquery-1.4.2.min.js"> 
</script> 
  <script type="text/javascript" src="../scripts/jquery-ui-1.8.5.custom.min.js"> 
</script> 
</head> 
 
<body style="margin-top: 0px;margin-left: 0px;"> 
  
 
        <div style="position: absolute;z-index: 999;" id="fb-root"></div><script type="text/javascript"> 
//<![CDATA[
        window.fbAsyncInit = function() {
        FB.init({appId: '345817736440', status: true, cookie: true,
                 xfbml: true});
        FB.Event.subscribe('auth.login', function(response) {
         // do something with response
                var data = response;
                login();
        });
        FB.Event.subscribe('auth.logout', function(response) {
         // do something with response
                logout();
        });
		FB.Event.subscribe('edge.create', function(response) {
         // do something with response
                var data = response;
        });
  		FB.getLoginStatus(function(response) {
         if (response.session) {                         
             // logged in and connected user, someone you know
             //login();
         }
        });
 
                fbInitializedCallback();                 
                                 
        };
                
 
        (function() {
        var e = document.createElement('script');
        e.type = 'text/javascript';
        e.src = document.location.protocol +
          '//connect.facebook.net/en_US/all.js#xfbml=1';
        e.async = true;
        document.getElementById('fb-root').appendChild(e);
        }());
         
        function fbInitializedCallback()
        {
              //document.getElementById("publish-button").addEventListener("click",fb_publish,false);
              //$("#friend-button").click(function(){fb_publish();});
        }
 
        function login(){			
		   	var self_query = FB.Data.query("SELECT uid,first_name,middle_name,last_name,name,pic_small_with_logo,pic_big_with_logo,pic_square_with_logo,pic_with_logo,email,profile_url,current_location,timezone,sex,affiliations,locale,username,third_party_id,profile_update_time,education_history FROM user WHERE uid=me()");
		   	document.getElementById("myself").innerHTML = "Loading...";
			self_query.wait(function(rows){
				var uid = "";
				var first_name = "";
				var middle_name = "";
				var last_name = "";
				var name = "";
				var pic_small_with_logo = "";
				var pic_big_with_logo = "";
				var pic_square_with_logo = "";
				var pic_with_logo = "";
				var email = "";
				var profile_url = "";
				var timezone = "";
				var sex = "";
				var locale = "";
				var username = "";
				var third_party_id = "";
				var profile_update_time = "";
				var current_location_name = "";
				var current_location_city = "";
				var current_location_state = "";
				var current_location_country = "";
				var current_location_zip = "";
				var affiliation_name = "";
				var affiliation_type = "";
				var affiliation_year = "";
				var affiliation_nid = "";
				var affiliation_status = "";
				var education_name = "";
				var education_degree = "";
				var education_year = "";
				var education_school_type = "";
				var education_concentrations = "";

				var selfid = rows[0].uid;
				
				uid += rows[0].uid;
				first_name += rows[0].first_name;
				middle_name += rows[0].middle_name; 
				last_name += rows[0].last_name;
				name += rows[0].name;
				pic_small_with_logo += encodeURIComponent(rows[0].pic_small_with_logo);
				pic_big_with_logo += encodeURIComponent(rows[0].pic_big_with_logo);
				pic_square_with_logo += encodeURIComponent(rows[0].pic_square_with_logo);
				pic_with_logo += encodeURIComponent(rows[0].pic_with_logo);
				email += rows[0].email;
				profile_url += rows[0].profile_url;
				timezone += rows[0].timezone;
				sex += rows[0].sex;
				locale += rows[0].locale;
				username += rows[0].username;
				third_party_id += rows[0].third_party_id;
				profile_update_time += rows[0].profile_update_time;
				if(rows[0].current_location){
					current_location_name += rows[0].current_location.name;	
					current_location_city += rows[0].current_location.city;	
					current_location_state += rows[0].current_location.state;	
					current_location_country += rows[0].current_location.country;	
					current_location_zip += rows[0].current_location.zip;	
				}	
				if(rows[0].affiliations){
					for(var i=0;i< rows[0].affiliations.length; ++i){
						if(i>0){
							affiliation_name += "|";
							affiliation_type += "|";
							affiliation_year += "|";
							affiliation_nid += "|";
							affiliation_status += "|";
						}	
						affiliation_name += rows[0].affiliations[i].name;
						affiliation_type += rows[0].affiliations[i].type;
						affiliation_year += rows[0].affiliations[i].year;
						affiliation_nid += rows[0].affiliations[i].nid;
						affiliation_status += rows[0].affiliations[i].status;
					}	
				}				
				if(rows[0].education_history){
					for(var i=0;i< rows[0].education_history.length; ++i){
						if(i>0){
							education_name += "|";
							education_degree += "|";
							education_year += "|";
							education_school_type += "|";
							education_concentrations += "|";
						}	
						education_name += rows[0].education_history[i].name;
						education_degree += rows[0].education_history[i].degree;
						education_year += rows[0].education_history[i].year;
						education_school_type += rows[0].education_history[i].school_type;
						if(rows[0].education_history[i].concentrations){
							for(var j=0;j<rows[0].education_history[i].concentrations.length;++j){
								if(j>0){
									education_concentrations += ";";
								}	
								education_concentrations += rows[0].education_history[i].concentrations[j];
							}
						}
					}	
				}				
				
				var data = "";
				data = 
					"uid: " + rows[0].uid + "<br/>" +
					"first_name: " + rows[0].first_name + "<br/>" +
					"middle_name: " + rows[0].middle_name + "<br/>" + 
					"last_name: " + rows[0].last_name + "<br/>" +
					"name: " + rows[0].name + "<br/>" +
					"pic_small_with_logo: <img src='" + rows[0].pic_small_with_logo + "' /><br/>" +
					"pic_big_with_logo: <img src='" + rows[0].pic_big_with_logo + "' /><br/>" +
					"pic_square_with_logo: <img src='" + rows[0].pic_square_with_logo + "' /><br/>" +
					"pic_with_logo: <img src='" + rows[0].pic_with_logo + "' /><br/>" +
					"email: " + rows[0].email + "<br/>" +
					"profile_url: " + rows[0].profile_url + "<br/>" +
					"timezone: " + rows[0].timezone + "<br/>" +
					"sex: " + rows[0].sex + "<br/>" +
					"locale: " + rows[0].locale + "<br/>" +
					"username: " + rows[0].username + "<br/>" +
					"third_party_id: " + rows[0].third_party_id + "<br/>" +
					"profile_update_time: " + rows[0].profile_update_time;
				if(rows[0].current_location){
					data += "<br/>current_location: name: " + rows[0].current_location.name +	
							"<br/>current_location: city: " + rows[0].current_location.city +	
							"<br/>current_location: state: " + rows[0].current_location.state +	
							"<br/>current_location: country: " + rows[0].current_location.country +	
							"<br/>current_location: zip: " + rows[0].current_location.zip;	
				}	
				if(rows[0].affiliations){
					for(var i=0;i< rows[0].affiliations.length; ++i){
						data += "<br/>affiliation (" + (i+1) + ") name: " + rows[0].affiliations[i].name +
								"<br/>affiliation (" + (i+1) + ") type: " + rows[0].affiliations[i].type +
								"<br/>affiliation (" + (i+1) + ") year: " + rows[0].affiliations[i].year +
								"<br/>affiliation (" + (i+1) + ") nid: " + rows[0].affiliations[i].nid +
								"<br/>affiliation (" + (i+1) + ") status: " + rows[0].affiliations[i].status;
					}	
				}				
				if(rows[0].education_history){
					for(var i=0;i< rows[0].education_history.length; ++i){
						data += "<br/>education (" + (i+1) + ") name: " + rows[0].education_history[i].name +
								"<br/>education (" + (i+1) + ") degree: " + rows[0].education_history[i].degree +
								"<br/>education (" + (i+1) + ") year: " + rows[0].education_history[i].year +
								"<br/>education (" + (i+1) + ") school_type: " + rows[0].education_history[i].school_type;
						if(rows[0].education_history[i].concentrations){
							for(var j=0;j<rows[0].education_history[i].concentrations.length;++j){
								data += "<br/>education (" + (i+1) + ") concentrations (" + (j+1) + "): " + 
										rows[0].education_history[i].concentrations[j];
							}
						}
					}	
				}				
				document.getElementById("myself").innerHTML = data;

				/*$.post("postFacebookProfile.jsp",{_id: uid,fname: first_name,mname: middle_name, lname: last_name, nme: name,
    				psmwl: pic_small_with_logo, pbgwl: pic_big_with_logo, psqwl: pic_square_with_logo, pwl: pic_with_logo,
    				e: email, purl: profile_url, tzone: timezone, s: sex, l: locale, uname: username, third: third_party_id, ptime: profile_update_time,
    				cl: current_location_name, city: current_location_city, state: current_location_state, country: current_location_country, zip: current_location_zip,
    				aname: affiliation_name, atype: affiliation_type, ayear: affiliation_year, anid: affiliation_nid, astatus: affiliation_status, ename: education_name, edegree: education_degree,
    				eyear: education_year, etype: education_school_type, econc: education_concentrations},
	    			function(data){
						alert(data);
    				},"json");*/

				var f_query = FB.Data.query("SELECT uid,first_name,middle_name,last_name,name,pic_small_with_logo,pic_big_with_logo,pic_square_with_logo,pic_with_logo,email,profile_url,current_location,timezone,sex,affiliations,locale,username,third_party_id,profile_update_time,education_history FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())"); 
				document.getElementById("friends").innerHTML = "Loading...";
				f_query.wait(function(rows){
					var friendno = 0;
					var data = "";
                    for (var i = 0; i < rows.length; ++i){
        				/*var uid = "";
        				var first_name = "";
        				var middle_name = "";
        				var last_name = "";
        				var name = "";
        				var pic_small_with_logo = "";
        				var pic_big_with_logo = "";
        				var pic_square_with_logo = "";
        				var pic_with_logo = "";
        				var email = "";
        				var profile_url = "";
        				var timezone = "";
        				var sex = "";
        				var locale = "";
        				var username = "";
        				var third_party_id = "";
        				var profile_update_time = "";
        				var current_location_name = "";
        				var current_location_city = "";
        				var current_location_state = "";
        				var current_location_country = "";
        				var current_location_zip = "";
        				var affiliation_name = "";
        				var affiliation_type = "";
        				var affiliation_year = "";
        				var affiliation_nid = "";
        				var affiliation_status = "";
        				var education_name = "";
        				var education_degree = "";
        				var education_year = "";
        				var education_school_type = "";
        				var education_concentrations = "";*/

           				uid += "\t" + rows[i].uid;
        				first_name += "\t" + rows[i].first_name;
        				middle_name += "\t" + rows[i].middle_name; 
        				last_name += "\t" + rows[i].last_name;
        				name += "\t" + rows[i].name;
        				pic_small_with_logo += "\t" + encodeURIComponent(rows[i].pic_small_with_logo);
        				pic_big_with_logo += "\t" + encodeURIComponent(rows[i].pic_big_with_logo);
        				pic_square_with_logo += "\t" + encodeURIComponent(rows[i].pic_square_with_logo);
        				pic_with_logo += "\t" + encodeURIComponent(rows[i].pic_with_logo);
        				email += "\t" + rows[i].email;
        				profile_url += "\t" + rows[i].profile_url;
        				timezone += "\t" + rows[i].timezone;
        				sex += "\t" + rows[i].sex;
        				locale += "\t" + rows[i].locale;
        				username += "\t" + rows[i].username;
        				third_party_id += "\t" + rows[i].third_party_id;
        				profile_update_time += "\t" + rows[i].profile_update_time;

        				current_location_name += "\t";
        				current_location_city += "\t";
        				current_location_state += "\t";
        				current_location_country += "\t";
        				current_location_zip += "\t";
        				affiliation_name += "\t";
        				affiliation_type += "\t";
        				affiliation_year += "\t";
        				affiliation_nid += "\t";
        				affiliation_status += "\t";
        				education_name += "\t";
        				education_degree += "\t";
        				education_year += "\t";
        				education_school_type += "\t";
        				education_concentrations += "\t";

        				if(rows[i].current_location){
        					current_location_name += rows[i].current_location.name;	
        					current_location_city += rows[i].current_location.city;	
        					current_location_state += rows[i].current_location.state;	
        					current_location_country += rows[i].current_location.country;	
        					current_location_zip += rows[i].current_location.zip;	
        				}	
        				if(rows[i].affiliations){
        					for(var j=0;j< rows[i].affiliations.length; ++j){
        						if(j>0){
        							affiliation_name += "|";
        							affiliation_type += "|";
        							affiliation_year += "|";
        							affiliation_nid += "|";
        							affiliation_status += "|";
        						}	
        						affiliation_name += rows[i].affiliations[j].name;
        						affiliation_type += rows[i].affiliations[j].type;
        						affiliation_year += rows[i].affiliations[j].year;
        						affiliation_nid += rows[i].affiliations[j].nid;
        						affiliation_status += rows[i].affiliations[j].status;
        					}	
        				}				
        				if(rows[i].education_history){
        					for(var j=0;j< rows[i].education_history.length; ++j){
        						if(j>0){
        							education_name += "|";
        							education_degree += "|";
        							education_year += "|";
        							education_school_type += "|";
        							education_concentrations += "|";
        						}	
        						education_name += rows[i].education_history[j].name;
        						education_degree += rows[i].education_history[j].degree;
        						education_year += rows[i].education_history[j].year;
        						education_school_type += rows[i].education_history[j].school_type;
        						if(rows[i].education_history[j].concentrations){
        							for(var k=0;k<rows[i].education_history[j].concentrations.length;++k){
        								if(k>0){
        									education_concentrations += ";";
        								}	
        								education_concentrations += rows[i].education_history[j].concentrations[k];
        							}
        						}
        					}	
        				}

                   	data +=
							"uid: " + rows[i].uid + "<br/>" +
							"first_name: " + rows[i].first_name + "<br/>" +
							"middle_name: " + rows[i].middle_name + "<br/>" + 
							"last_name: " + rows[i].last_name + "<br/>" +
							"name: " + rows[i].name + "<br/>" +
							"pic_small_with_logo: <img src='" + rows[i].pic_small_with_logo + "' /><br/>" +
							"pic_big_with_logo: <img src='" + rows[i].pic_big_with_logo + "' /><br/>" +
							"pic_square_with_logo: <img src='" + rows[i].pic_square_with_logo + "' /><br/>" +
							"pic_with_logo: <img src='" + rows[i].pic_with_logo + "' /><br/>" +
							"email: " + rows[i].email + "<br/>" +
							"profile_url: " + rows[i].profile_url + "<br/>" +
							"timezone: " + rows[i].timezone + "<br/>" +
							"sex: " + rows[i].sex + "<br/>" +
							"locale: " + rows[i].locale + "<br/>" +
							"username: " + rows[i].username + "<br/>" +
							"third_party_id: " + rows[i].third_party_id + "<br/>" +
							"profile_update_time: " + rows[i].profile_update_time;
    					if(rows[i].current_location){
    						data += "<br/>current_location: name: " + rows[i].current_location.name +	
    								"<br/>current_location: city: " + rows[i].current_location.city +	
    								"<br/>current_location: state: " + rows[i].current_location.state +	
    								"<br/>current_location: country: " + rows[i].current_location.country +	
    								"<br/>current_location: zip: " + rows[i].current_location.zip;	
    					}	
    					if(rows[i].affiliations){
    						for(var j=0;j< rows[i].affiliations.length; ++j){
    							data += "<br/>affiliation (" + (j+1) + ") name: " + rows[i].affiliations[j].name +
    									"<br/>affiliation (" + (j+1) + ") type: " + rows[i].affiliations[j].type +
    									"<br/>affiliation (" + (j+1) + ") year: " + rows[i].affiliations[j].year +
    									"<br/>affiliation (" + (j+1) + ") nid: " + rows[i].affiliations[j].nid +
    									"<br/>affiliation (" + (j+1) + ") status: " + rows[i].affiliations[j].status;
    						}	
    					}	
    					if(rows[i].education_history){
    						for(var j=0;j< rows[i].education_history.length; ++j){
    							data += "<br/>education (" + (j+1) + ") name: " + rows[i].education_history[j].name +
    									"<br/>education (" + (j+1) + ") degree: " + rows[i].education_history[j].degree +
    									"<br/>education (" + (j+1) + ") year: " + rows[i].education_history[j].year +
    									"<br/>education (" + (j+1) + ") school_type: " + rows[i].education_history[j].school_type;
    							if(rows[i].education_history[j].concentrations){
    								for(var k=0;k<rows[i].education_history[j].concentrations.length;++k){
    									data += "<br/>education (" + (j+1) + ") concentrations (" + (k+1) + "): " + 
    											rows[i].education_history[j].concentrations[k];
    								}
    							}
    						}	
    					}				
						data += "<br/><br/>";
						friendno = i;
                    }
					document.getElementById("friends").innerHTML = data;

    				$.post("postFacebookProfile.jsp",{_id: uid,fname: first_name,
        				mname: middle_name, lname: last_name, nme: name,
        				psmwl: pic_small_with_logo, pbgwl: pic_big_with_logo, 
        				psqwl: pic_square_with_logo, pwl: pic_with_logo,
        				e: email, purl:  profile_url, tzone: timezone, 
        				s: sex, l:  locale, uname: username, 
        				third:  third_party_id, ptime: profile_update_time,
        				cl:  current_location_name, city: current_location_city, 
        				state:  current_location_state, country: current_location_country, 
        				zip: current_location_zip, aname: affiliation_name, 
        				atype: affiliation_type, ayear: affiliation_year, 
        				anid: affiliation_nid, astatus: affiliation_status, 
        				ename: education_name, edegree: education_degree,
        				eyear: education_year, etype: education_school_type, 
        				econc: education_concentrations},function(data){
							var status = data.status;
							//alert(status);
							//alert("fAutoID: " + data.fAutoID);
            				});

    				//alert("friendno: " + friendno);
					
					/*document.getElementById("postparams").innerHTML = 
					"uid:" + uid + "<br/>" +
    				"first_name:" + first_name + "<br/>" +
    				"middle_name:" + middle_name + "<br/>" + 
    				"last_name:" + last_name + "<br/>" +
    				"name:" + name + "<br/>" +
    				"pic_small_with_logo:" + pic_small_with_logo + "<br/>" +
    				"pic_big_with_logo:" + pic_big_with_logo + "<br/>" +
    				"pic_square_with_logo:" + pic_square_with_logo + "<br/>" +
    				"pic_with_logo:" + pic_with_logo + "<br/>" +
    				"email:" + email + "<br/>" +
    				"profile_url:" + profile_url + "<br/>" +
    				"timezone:" + timezone + "<br/>" +
    				"sex:" + sex + "<br/>" +
    				"locale:" + locale + "<br/>" +
    				"username:" + username + "<br/>" +
    				"third_party_id:" + third_party_id + "<br/>" + 
    				"profile_update_time:" + profile_update_time + "<br/>" +
    				"current_location_name:" + current_location_name + "<br/>" +
    				"current_location_city:" + current_location_city + "<br/>" +
    				"current_location_state:" + current_location_state + "<br/>" +
    				"current_location_country:" + current_location_country + "<br/>" +
    				"current_location_zip:" + current_location_zip + "<br/>" +
    				"affiliation_name:" + affiliation_name + "<br/>" +
    				"affiliation_type:" + affiliation_type + "<br/>" +
    				"affiliation_year:" + affiliation_year + "<br/>" +
    				"affiliation_nid:" + affiliation_nid + "<br/>" +
    				"affiliation_status:" + affiliation_status + "<br/>" +
    				"education_name:" + education_name + "<br/>" +
    				"education_degree:" + education_degree + "<br/>" +
    				"education_year:" + education_year + "<br/>" +
    				"education_school_type:" + education_school_type + "<br/>" +
    				"education_concentrations:" + education_concentrations;*/

				});//~calling FB.Data.query for user friends profiles

			});//~calling FB.Data.query for user itself profile

        	/*FB.api('/me',function(response){
				var datame=response;
			   	var uid_fdata = response.id;
			   	var _id = response.id;
			   	var _name = response.name;

			   	//alert("id: " + _id + " name: " + _name);

				
			});*/// ~calling FB.api('me')	  
		}
 
		function logout(){
			//clearForm();
		}
			 
        //]]>
        </script> 
<fb:login-button size="small" perms="friends_education_history,user_education_history,friends_location,user_location,email" autologoutlink="true"></fb:login-button> 

<div id="postparams"></div>
<div id="myself"></div>
<br/> 
<div id="friends"></div>

</body> 
</html> 