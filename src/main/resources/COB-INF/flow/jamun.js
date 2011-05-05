/*
 *      jamun.js - flowscript work for jamun
 *
 *              Art Rhyno (http://projectconifer.ca), Mar. 2011
 *              (c) Copyright GNU General Public License (GPL)
 *
 *              Revised: 
*/

function statusInfo(bibId, libId, callNum, location, statusObj) {
	this.bibId = bibId;
	this.libId = libId;
	this.callNum = callNum;
	this.location = location;
	//we only check for unavailability, punt to conifer for full status breakdown
	if (statusObj["1"]) 
		this.status = "checked out";
	else
		this.status = "available";
}

function sortOutConifer() {
	var rows = parseInt(cocoon.parameters["rows"]);
	var query = cocoon.parameters["query"];
	var coniferOrg = parseInt(cocoon.parameters["coniferOrg"]);
		
	var parms = new Array();
	query = query.replace(/\"/g,"")
                
	parms[0] = "{\"org_unit\":" + coniferOrg + ",\"depth\":" + 1 + ",\"limit\":" +
		rows + "\",\"offset\":" + 0 +",\"visibility_limit\":" +
		3000 + ",\"default_class\":\"keyword\"}";
	parms[1] = "\"" + query + "\"";
	parms[2] = 1;

	var osrfdata = {
		"service" : "open-ils.search",
		"method"  : "open-ils.search.biblio.multiclass.query",
		"parms"   : parms }

	try {
		var osrf = jsonify("opensrf",osrfdata)
		var response = osrf.payload[0];
		var hits = response.count;
		if (hits >= 0) 
			cocoon.sendPage("opensrf-result-" + hits);
		else
			cocoon.sendPage("opensrf-result-0");
	} catch (ex) {
			cocoon.sendPage("opensrf-result-0");
	}//try

}//sortOutConifer

function pullTogetherStatus(bibIds,coniferOrg) {
		
	var parms = new Array();
	var copyObjs = new Array();
		
	for (var i = 0; i < bibIds.length; i++) {
		parms[0] = bibIds[i];
		parms[1] = 1;
		parms[2] = 0;
		print(bibIds.length + " bibIds-> " + parms[0]);

		var osrfdata = {
			"service" : "open-ils.search",
			"method"  : "open-ils.search.biblio.copy_counts.location.summary.retrieve",
			"parms"   : parms }

		try {
			var osrf = jsonify("opensrf",osrfdata)
			var response = osrf.payload[0];
			for (var j = 0; j < response.length; j++) {
				var copyInfo = response[j];
				if (parseInt(copyInfo[0]) == 109 || parseInt(copyInfo[0]) == 122) {
				print("copyInfo: "+ copyInfo[0]);
					copyObjs[copyObjs.length] = new statusInfo(bibIds[i],
						copyInfo[0], copyInfo[1], copyInfo[2], copyInfo[3]);
				}
			}
		} catch (ex) {
			print("ex in sortOutIsbns: " + ex);
		}//try
	}//for

	return copyObjs;
}

function clearForDup(list, responseId) {
	for (var x = 0; x < list.length; x++) {
		if (list[x] == parseInt(responseId))
			return false;
	}//for
	return true;
}

function getBibIdsFromIsbns(isbnList, coniferOrg) {
		
	var bibList = new Array();
	var hits = 0;
                
	for (var i = 0; i < isbnList.length; i++) {
		var osrfdata = {
			"service" : "open-ils.search",
			"method"  : "open-ils.search.biblio.isbn",
			"parms"   : "\"" + isbnList[i] + "\"" }

		try {
			var osrf = jsonify("opensrf",osrfdata)
			var response = osrf.payload[0];
			hits = parseInt(response.count);
			if (hits > 0) {
				for (var j = 0; j < response.ids.length; j++) {
					print("start " + bibList.length); 
					if (clearForDup(bibList,response.ids[j]))
						bibList[bibList.length] = parseInt(response.ids[j]);
					//print(bibList.length + " added " + response.ids[j] + " from " + response.ids);
				}
			}//if
		
		} catch (ex) {
			print("ex in sortOutIsbns: " + ex);
			hits = 0;
		}//try
		//print("->hits: " + hits + " - " + bibId);
	}//for

	return bibList;
}
function sortOutIsbns() {
	var gbookId = cocoon.parameters["gbookId"];
	var isbns = cocoon.parameters["isbns"];
	var coniferOrg = parseInt(cocoon.parameters["coniferOrg"]);
	var query = cocoon.parameters["query"];
		
	query = query.replace(/\"/g,"")
	var isbnList = isbns.split(",");
	//print("isbns: " + isbns);
	var bibIds = getBibIdsFromIsbns(isbnList, coniferOrg);
	print("bibIds: " + bibIds.length);
	var statusList = pullTogetherStatus(bibIds, coniferOrg);

	//var gbsInfo = jsonify("http://books.google.com/books?jscmd=viewapi&bibkeys=" + isbns + "&callback=ProcessGBSBookInfo");
	print("sending gbsInfo-" + isbns);
	var gbs = jsonify("gbsInfo-" + isbns);
	var gbsInfo = gbs.gbsInfo;
	//print("gbsinfo is " + gbsInfo); 
	//print(gbsInfo + "-> " + gbsInfo[isbnList[0]].preview_url);
	var embeddable = false;
	var thumbnail_url = "";
	var gbIsbn = "";
	for (var i = 0; i < isbnList.length && gbsInfo && !embeddable; i++) {
		embeddable = gbsInfo[isbnList[i]].embeddable;
		thumbnail_url = gbsInfo[isbnList[i]].thumbnail_url;
		gbIsbn = isbnList[i];
	}
	thumbnail_url = thumbnail_url.replace(/\\u0026/g,"&")
		
	var pages = new Array();
	if (embeddable) {
		print("gbook-hlpgs-" + gbookId + "-" + query);
		var pageInfo = jsonify("gbook-hlpgs-" + gbookId + "-" + query);
		print("pgs " + pageInfo + " - " + pageInfo.pages.length);
		pages = pageInfo.pages;
	}//if
	var bibId = 0;

	if (statusList.length > 0)
		bibId = statusList[0].bibId;

	var gbInfo = {
		"gbookId" : gbookId + "",
		"isbn" : gbIsbn + "",
		"bibId" : bibId + "",
		"query" : query.replace(/\+/g," "),
		"pglen" : pages.length + "",
		"thumbnail" : thumbnail_url,
		"embed" : embeddable,
		"statuses" : statusList,
		"pages" : pages
	}
	//cocoon.sendPage("gbook-expo-" + gbookId + "-" + bibId + "-" + query);
	cocoon.sendPage("gbook-expo", gbInfo);
}//sortOutIsbns
