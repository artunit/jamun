/*
 *      ajaxUtil.js - simple ajax wiring for jamun
 *
 *              Art Rhyno (http://projectspjournal.ca), Feb. 2011
 *              (c) Copyright GNU General Public License (GPL)
 *
 *              Revised: 

	change logic so that only middle is figured out first
*/

//constants
var COMPLETED = 4;
var MID_AVAIL_SLOTS = 10;
var RIGHT_AVAIL_SLOTS = 10;
var MID_MIN_SLOT = 2;
var RIGHT_MIN_SLOT = 4;

//locals
var xmlHttp=new Array();
var thisSearch=null;

//counters
var spbookCnt = -1;
var leddyCnt = -1;
var etdCnt = -1;
var swodaCnt = -1;
var spjournalCnt = -1;
var gbookCnt = -1;

//flags
var checkinMid = false;
var checkinRight = false;

//grid classes
var middle_grid = "grid_0";
var right_grid = "grid_0";

function ajaxRequest(div,process) {
  this.xmlHttpObj = getXmlHttpObject();
  this.div = div;
  this.process = process;
  this.complete = false;
}
                
function submitGsSearch() {
	if ((thisSearch + "").length > 0)
		document.location.href ="http://scholar.google.ca/scholar?q=" + thisSearch;
	else
		document.location.href ="http://scholar.google.ca";
}

//custom clear
function clearSearchInfo() {
	thisSearch = "";
	checkinMid = checkinRight = false;
	spbookCnt = leddyCnt = etdCnt = swodaCnt = spjournalCnt = gbookCnt = -1;

	for (i=0; i< xmlHttp.length; i++) {
		if (xmlHttp[i] && xmlHttp[i].complete) {
			document.getElementById(xmlHttp[i].div).innerHTML  = "";
		}
	}
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


function requestContent(sourceLoc,targetDiv,search,processed,inpage)
{ 
	thisSearch = search;

	if (inpage)
		xmlHttp=new Array();

	var xmlInd = xmlHttp.length;
	xmlHttp[xmlInd]= new ajaxRequest(targetDiv, processed);
	if (xmlHttp[xmlInd].xmlHttpObj == null) {
		alert ("Sorry, this browser can not be used for searching...");
		return;
	}//if 

	xmlHttp[xmlInd].xmlHttpObj.onreadystatechange=stateChanged;
	xmlHttp[xmlInd].xmlHttpObj.open("GET",sourceLoc,true);
	xmlHttp[xmlInd].xmlHttpObj.send(null);
}//requestContent

function stateChanged() 
{
 
//alert(div + " - " + process + " - " + xmlHttp[div].readyState);
	for (i=0; i< xmlHttp.length; i++) {
		if (xmlHttp[i] && !xmlHttp[i].complete) {
			if (xmlHttp[i].xmlHttpObj.readyState==COMPLETED || 
				xmlHttp[i].xmlHttpObj.readyState=="complete") 
			{ 
				xmlHttp[i].complete = true;
				var hits = 0;
				if (xmlHttp[i].xmlHttpObj.responseText.length > 0) {
					if (xmlHttp[i].process) {
						//alert( xmlHttp[i].div + ":-> " + xmlHttp[i].xmlHttpObj.responseText);
						var numHits = eval(xmlHttp[i].xmlHttpObj.responseText);
						sortOutDisplay(xmlHttp[i].div, parseInt(numHits));
					} else {
						try {
						document.getElementById(xmlHttp[i].div).innerHTML  = xmlHttp[i].xmlHttpObj.responseText;
						} catch (e) {
							alert(xmlHttp[i].div + ' error ' + e + ' - ' + i + xmlHttp[i]);
						}
					}//if
				}//if
			}//if 
		}//if
	}//for

}//stateChanged 

function sortOutDisplay(theDiv, theHits) {
				
	//results for middle display
	if (theDiv.indexOf("spbook") != -1)
		spbookCnt = theHits;
	if (theDiv.indexOf("leddy") != -1)
		leddyCnt = theHits;
	if (theDiv.indexOf("etd") != -1)
		etdCnt = theHits;
	if (theDiv.indexOf("swoda") != -1)
		swodaCnt = theHits;

	//results for right display
	if (theDiv.indexOf("spjournal") != -1)
		spjournalCnt = theHits;
	if (theDiv.indexOf("gbook") != -1)
		gbookCnt = theHits;

	if (spbookCnt + leddyCnt + etdCnt + swodaCnt + 
		spjournalCnt + gbookCnt > 0)
	{
		//we zap the class which hides the clear button
		document.getElementById('clear-button').className = "";
		document.getElementById('gs-button').className = "";
		document.getElementById('intro_display').className = "grid_0";
	}//if

	//we need the numbers to lay out the grid
	if (spbookCnt > -1 && leddyCnt > -1 && 
		etdCnt > -1 && swodaCnt > -1 && !checkinMid) 
	{
		checkinMid = true;
		if ((spbookCnt + leddyCnt + etdCnt + swodaCnt) > 0) {
			if ((spjournalCnt + gbookCnt) > 0 && !checkinMid) {
				middle_grid = "grid_4";
				right_grid = "grid_5 omega";
			} else {
				middle_grid = "grid_6 omega";
			}//if

			showMidResults();
		}//if
	}//if
	if (spjournalCnt > -1 && gbookCnt > -1 && !checkinRight)
	{
		checkinRight = true;

		if ((spjournalCnt + gbookCnt) > 0) {
			if ((spbookCnt + leddyCnt + etdCnt + swodaCnt) > 0) {
				right_grid = "grid_5 omega";
				middle_grid = "grid_4";
			} else {
				right_grid = "grid_6 omega";
			}//if

			showRightResults();
		}//if
	}//if

	if (checkinMid || checkinRight) {
		document.getElementById('mid_display').className = middle_grid;
		document.getElementById('right_display').className = right_grid;
	}
}//sortOutDisplay

function showMidResults() {
	//fill in middle 
	var left_curr_avail = MID_AVAIL_SLOTS;

	if (spbookCnt > 0) {
		var spbookNum = sortOutSlots(spbookCnt,[leddyCnt,etdCnt,swodaCnt],
			MID_MIN_SLOT, left_curr_avail);
		left_curr_avail -= spbookNum;
		requestContent('spbook-results-' + spbookNum + '-0-' + spbookCnt + '-q-' +
			thisSearch, 'spbook_results',thisSearch,false,false);
	}//if
	if (leddyCnt > 0) {
		var leddyNum = sortOutSlots(leddyCnt,[spbookCnt,etdCnt,swodaCnt],
			MID_MIN_SLOT, left_curr_avail);
		left_curr_avail -= leddyNum;
		requestContent('leddy-results-' + leddyNum + '-0-' + leddyCnt + '-q-' +
			thisSearch, 'leddy_results',thisSearch,false,false);
	}//if

	if (etdCnt > 0) {
		var etdNum = sortOutSlots(etdCnt,[spbookCnt,leddyCnt,swodaCnt],
			MID_MIN_SLOT, left_curr_avail);
		left_curr_avail -= etdNum;
		requestContent('etd-results-' + etdNum + '-0-' + etdCnt + '-q-' +
			thisSearch,'etd_results',thisSearch,false,false);
	}//if

	if (swodaCnt > 0) {
		var swodaNum = sortOutSlots(swodaCnt,[spbookCnt,leddyCnt,etdCnt],
			MID_MIN_SLOT, left_curr_avail);
		requestContent('swoda-results-' + swodaNum + '-0-' + swodaCnt + '-q-' +
			thisSearch,'swoda_results',thisSearch,false,false);
	}//if

}//showMidResults

function showRightResults() {
	//fill in right display
	var right_curr_avail = RIGHT_AVAIL_SLOTS;

	if (spjournalCnt > 0) {
		var spjournalNum = sortOutSlots(spjournalCnt,[gbookCnt],
			RIGHT_MIN_SLOT, right_curr_avail);
		right_curr_avail -= spjournalNum;
		requestContent('spjournal-results-' + spjournalNum + '-0-' + spjournalCnt + '-q-' +
			thisSearch,'spjournal_results',thisSearch,false,false);
	}//if

	if (gbookCnt > 0) {
		var gbookNum = sortOutSlots(gbookCnt,[spjournalCnt],
			RIGHT_MIN_SLOT, right_curr_avail);
		requestContent('gbook-results-' + gbookNum + '-1-' + gbookCnt + '-q-' +
			thisSearch,'gbook_results',thisSearch,false,false);
	}//if


}//showRightResults

function sortOutSlots(hitCnt,others,min,avail) {
	//if results less than min, we use result
	if (hitCnt < min)
		return hitCnt;

	var track = min;
	for (i=0; i<others.length && track < hitCnt; i++) {
		//check for spare slots
		if (others[i] < min) {
			var extra = min - others[i];
			if ((track + extra) < avail) {
				if ((track + extra) > hitCnt)
					track += ((track + extra) - hitCnt);
				else
					track += extra;
			}//if
		}//if
	}//for

	return track;
}//sortOutSlots

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
