/*
	opensrf.js - opensrf convenience functions
 
 	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
 
	Revised:
*/


function setUpSession(userid, password, sessionType, org, workstation)
{
	var parms = [];
	var authToken=null;
	var osrfdata;

	parms[0] = "\"" + userid +"\"";
	osrfdata = {
			"service" : "open-ils.auth",
			"method"  : "open-ils.auth.authenticate.init",
			"parms"   : parms }

	var osrf = jsonify("opensrf",osrfdata);
	print("init: " + osrf.status);

	if (parseInt(osrf.status) == 200) {		
		var md5Password = hex_md5(osrf.payload + hex_md5(password));
		print("-> " + md5Password);
		parms[0] = "{\"password\":\"" + md5Password + "\",\"type\":\"" + sessionType + "\",\"org\":" +
			"\"" + org + "\",\"username\":\"" + userid +"\",\"workstation\":\"" +
			workstation + "\"}";
		osrfdata = {
			"service" : "open-ils.auth",
			"method"  : "open-ils.auth.authenticate.complete",
			"parms"   : parms }

		osrf = jsonify("opensrf",osrfdata);
		authToken = osrf.payload[0].payload.authtoken;
	}//if

	return authToken;
}//setUpSession

/*
	sortOutVal
	
	- put value in opensrf-friendly syntax, e.g., "foo", null, "fee"
*/
function sortOutVal(theVal) {
	var newVal = theVal;
	newVal = newVal.replace (/^\s+|\s+$/g,'');
	if (newVal.length == 0)
		return null;

	return "\"" + newVal + "\"";
}//sortOutVal

function sessionDelete(authToken) {
	var parms = [];
	
	try {
		parms[0] = authToken;
		var osrfdata = {
			"service" : "open-ils.auth",
			"method"  : "open-ils.auth.session.delete",
			"parms"   : parms }
		var osrf = jsonify("opensrf",osrfdata);
		print("delete: " + osrf.status);
		if (parseInt(osrf.status) == 200)
			return true;
	} catch (ex) {
		print("problem with session delete: " + ex);
	}

	return false;
}//sessionDelete
