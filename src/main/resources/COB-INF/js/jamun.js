/*
 *      ajaxUtil.js - simple ajax wiring for jamun
 *
 *              Art Rhyno (http://projectconifer.ca), Feb. 2011
 *              (c) Copyright GNU General Public License (GPL)
 *
 *              Revised: 
 *              	Mar. 2011 - change logic so that only middle is figured out first
*/

//completed state for an ajax request 
var COMPLETED = 4;

//variables for ajax interactions
var xmlHttp=new Array();
var thisSearch=null;
var checkinLeft = false;
var checkinMid = false;
var checkinRight = false;

var leftLayoutSlot = LEFT_MIN_SLOT;

//grid classes
var middle_grid = "grid_0";
var right_grid = "grid_0";

function ajaxRequest(process) {
  this.xmlHttpObj = getXmlHttpObject();
  this.hits = -1;
  this.process = process;
  this.complete = false;
}
                
function clearCSESearch() {
	customSearchControl.clearAllResults();
	document.getElementById('custom_logo').className = "clear-it";
	for (x=0; x< paneObjs.length; x++) {
		if (paneObjs[x].panel == LEFT) {
			checkinLeft = false;	
			leftLayoutSlot = 2 * LEFT_MIN_SLOT;
			sortOutDisplay(paneObjs[x].div);
			leftLayoutSlot = LEFT_MIN_SLOT;
		}//if
	}//for
}//clearSearch

function submitGsSearch() {
	if ((thisSearch + "").length > 0) 
		window.open("http://scholar.google.ca/scholar?q=" + thisSearch);
	else 
		window.open(document.location.href ="http://scholar.google.ca");
}//submitGsSearch

function clearPane(divName) {
	if (xmlHttp[divName + '_results'].complete) {
		xmlHttp[divName + '_results'].hits = 0;
		for (x=0; x< paneObjs.length; x++) {
			if (paneObjs[x].div == divName) {
				document.getElementById(divName + '_results').innerHTML  = "";
				xmlHttp[divName + '_results'].hits = 0;
				xmlHttp[divName + '_results'].complete = false;
				if (paneObjs[x].panel == LEFT) {
					checkinLeft = true;
					customSearchControl.setResultSetSize(google.search.Search.LARGE_RESULTSET);
					customSearchControl.execute(thisSearch);
				}//if
				if (paneObjs[x].panel == MIDDLE)
					checkinMid = false;
				if (paneObjs[x].panel == RIGHT)
					checkinRight = false;
				x = paneObjs.length;
				
				sortOutDisplay(divName);
			}//if
		}//for
	}//if
}

//custom clear
function clearSearchInfo() {
	thisSearch = "";
	checkinLeft = checkinMid = checkinRight = false;
	for (i=0; i< paneObjs.length; i++) {
		if (xmlHttp[paneObjs[i].div + '_results'].complete) {
			document.getElementById(paneObjs[i].div + '_results').innerHTML  = "";
		}//if
	}//for
	changeSearchDiv("99%");
	customSearchControl.clearAllResults();
	document.getElementById("jamun_intro").style.visibility = 'visible';
	document.getElementById('mid_display').className = "grid_0";
	document.getElementById('right_display').className = "grid_0";
	document.getElementById('clear-button').className = "clear-it";
	document.getElementById('gs-button').className = "clear-it";
	document.getElementById('intro_display').className = "grid_7 column-shading-left omega";
	requestContent('intro', 'intro_display','',false,true);
}//clearSearchInfo


function clearRequests() {
		xmlHttp=new Array();
}

function requestContent(sourceLoc,targetDiv,search,processed,inpage)
{ 
	thisSearch = search;
	var thisHits = -1;

	if (inpage)
		xmlHttp=new Array();

	if (xmlHttp[targetDiv])
		thisHits = xmlHttp[targetDiv].hits;
	xmlHttp[targetDiv]= new ajaxRequest(processed);
	xmlHttp[targetDiv].hits = thisHits;
	if (xmlHttp[targetDiv].xmlHttpObj == null) {
		alert ("Sorry, this browser can not be used for searching...");
		return;
	}//if 

	xmlHttp[targetDiv].xmlHttpObj.onreadystatechange= function() {
		stateChanged(targetDiv);
	}

	xmlHttp[targetDiv].xmlHttpObj.open("GET",sourceLoc,true);
	xmlHttp[targetDiv].xmlHttpObj.send(null);
}//requestContent

function stateChanged(theDiv) 
{
	//alert(theDiv + " check for " + xmlHttp[theDiv].hits + " - " + xmlHttp[theDiv].xmlHttpObj.readyState);
	if (xmlHttp[theDiv] && !xmlHttp[theDiv].complete) {
		if (xmlHttp[theDiv].xmlHttpObj.readyState==COMPLETED || 
			xmlHttp[theDiv].xmlHttpObj.readyState=="complete") 
		{
			//alert(xmlHttp[theDiv].complete);
			xmlHttp[theDiv].complete = true;
			if (xmlHttp[theDiv].xmlHttpObj.responseText.length > 0) {
				if (xmlHttp[theDiv].process) {
					var numHits = eval(xmlHttp[theDiv].xmlHttpObj.responseText);
					xmlHttp[theDiv].hits = parseInt(numHits);
					sortOutDisplay(theDiv);
				} else {
					try {
						document.getElementById(theDiv).innerHTML  = xmlHttp[theDiv].xmlHttpObj.responseText;
					} catch (e) {
						alert(' error ' + e);
                                                	
					}//try
				}//if
			}//if
		}//if
	}//if
}//stateChanged 

function resultsAvailable(panelNo) {
	for (i=0; i< paneObjs.length; i++) {
		//alert(i + "-> " + paneObjs[i].div);
		if (paneObjs[i].panel == panelNo || panelNo == ALL) {
			if (xmlHttp[paneObjs[i].div + '_results'].hits > -1)
				return true;
		}//if
	}//for

	return false;
}//resultsAvailable

function panelReady(panelNo) {
	//make results are all available for panel
	for (i=0; i< paneObjs.length; i++) {
		if (paneObjs[i].panel == panelNo && 
			xmlHttp[paneObjs[i].div + '_results'].hits == -1) 
		{
			return false; 
		}//if
	}//for

	return true;	
}//layOutPanel

function getResults(panelNo) {
	//make results are all available for panel
	var results = -1;
	for (i=0; i< paneObjs.length; i++) {
		if (paneObjs[i].panel == panelNo && xmlHttp[paneObjs[i].div + '_results'].hits > 0) {
			requestContent('./' + paneObjs[i].div + '-results-' + 
				paneObjs[i].count + '-' + paneObjs[i].start + '-' + 
				xmlHttp[paneObjs[i].div + '_results'].hits + 
				'-q-' + thisSearch, paneObjs[i].div + '_results',
				thisSearch,false,false);
			results += xmlHttp[paneObjs[i].div + '_results'].hits;
		}//if
	}//for

	if (results > -1)
		return true;	

	return false;
}//getResults

function calcSlots(paneDiv,panelNo,hitCnt,min,avail) {
	//if results less than min, we use result
	if (hitCnt < min)
		return hitCnt;

	var track = min;
	for (x=0; x<paneObjs.length && track < hitCnt; x++) {
		//check for spare slots
		if(paneObjs[x].panel == panelNo && paneObjs[x].div != paneDiv) {
			var currHits = xmlHttp[paneObjs[x].div + '_results'].hits;
			if (currHits < min) {
				var extra = min - currHits;
				if ((track + extra) <= avail) {
					if ((track + extra) > hitCnt)
						track += ((track + extra) - hitCnt);
					else
						track += extra;
				}//if track
			}//if currHits
		}//if paneObj
	}//for

	return track;
}//calcSlots

function showResults(panelNo,panelSlots,minSlot) {
	var curr_avail = panelSlots;
	var slot_num = 0;

	for (i=0; i< paneObjs.length; i++) {
		if (paneObjs[i].panel == panelNo) {
			var curr_div = paneObjs[i].div + '_results';
			var calc_slot = calcSlots(curr_div,
				panelNo,
				xmlHttp[curr_div].hits,
				minSlot, curr_avail);
			//alert("calc " + curr_div + " - " + calc_slot);
			paneObjs[i].count = calc_slot;
			curr_avail -= calc_slot;
		}//if
	}//for

	getResults(panelNo);
}//showResults

function sortOutDisplay(theDiv) {
				
	if (resultsAvailable(ALL)) {
		//we zap the class which hides the clear button
		document.getElementById('clear-button').className = "";
		document.getElementById('gs-button').className = "";
		document.getElementById('intro_display').className = "grid_0";
	}//if

	//left doesn't change grid alignment
	if (panelReady(LEFT) && !checkinLeft) {
		checkinLeft = true;
		//getResults(LEFT);
		showResults(LEFT, LEFT_MIN_SLOT, leftLayoutSlot);
	}

	if (panelReady(MIDDLE) && !checkinMid) {
		checkinMid = true;
		if (resultsAvailable(RIGHT)) {
			middle_grid = "grid_4";
			right_grid = "grid_5 omega";
		} else {
			middle_grid = "grid_6 omega";
		}//if

		showResults(MIDDLE, MID_AVAIL_SLOTS, MID_MIN_SLOT);
	}//if

	if (panelReady(RIGHT) && !checkinRight) {
		checkinRight = true;
		if (resultsAvailable(MIDDLE)) {
			middle_grid = "grid_4";
			right_grid = "grid_5 omega";
		} else {
			middle_grid = "grid_6 omega";
		}//if

		showResults(RIGHT, RIGHT_AVAIL_SLOTS, RIGHT_MIN_SLOT);
	}//if

	if (checkinMid || checkinRight) {
		if (middle_grid.indexOf("_0") == -1)
			document.getElementById('mid_display').className = middle_grid;
		if (right_grid.indexOf("_0") == -1)
			document.getElementById('right_display').className = right_grid;
		//alert(checkinMid + " - " + checkinRight + ": " + middle_grid + " - " + right_grid);
	}
}//sortOutDisplay


function getXmlHttpObject()
{ 
	var objXMLHttp=null;
	if (window.XMLHttpRequest) {
		objXMLHttp=new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP");
	}//if
	return objXMLHttp;
}//getXmlHttpObject
