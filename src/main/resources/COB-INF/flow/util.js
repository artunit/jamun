/*
 *		util.js - generic help functions
 *
 *              art rhyno (http://projectconifer.ca), Mar. 2011
 *              (c) Copyright GNU General Public License (GPL)
 *
 *              Revised:
*/

var prob1 = ", {}]}{}";
var prob2 = "{}";
var prob3 = "\",{\"url";

/*
	sleep() - the rhino implementation doesn't have a setTimeout
		function, but this is a better approach anyway since
		javascript still consumes CPU. Java has a true sleep
		function and that is what we use here.
*/

function sleep (secs)
{
	//bump up to seconds
	var theSecs = secs * 1000;
	java.lang.Thread.sleep(theSecs);
}//sleep

function trim(theStr) {
	return theStr.replace(/^\s*/, "").replace(/\s*$/, "");

}

function endsWith(theStr, theEnd) {
	var theStrEnd = theStr.substring(theStr.length - theEnd.length);
	//print("comparing " + theStrEnd + " to " + theEnd);
	if (theStrEnd == theEnd)
		return true;

	return false;
}

                
function extractAttribute(attribute, attrStr) {
	var attrVal = attrStr.replace(/\s+=/,'=') + "";
	attrVal = attrVal.replace(/=\s+/,'=');
	var attrLoc = attribute + "=";
	var attrPos = attrVal.indexOf(attrLoc);
                        
	if (attrPos != -1) {
		attrVal = attrVal.substring(attrPos +
			attrLoc.length);
		attrPos = attrVal.indexOf(",");
                                
		if (attrPos != -1) {
			attrVal = attrVal.substring(0,
				attrPos);
                                
		}//if attrPos
                        
	}//if
                        
	return attrVal;
}


function figureOutPath(theBase, theApp, theFile) {
        var fullFile = theFile;
	  var fullBase = theBase;
	  if (!endsWith(fullBase,'/'))
		fullBase = fullBase + "/";
	
        if (theFile.indexOf("/") != 0)
                fullFile = fullBase + theApp + "/" +
                        fullFile;

	 //print("returning " + fullFile);

        return fullFile;
}

function fixQuote(theVal) {
	var retVal = theVal.replace(/\'/g,"\\\'");

	return retVal;
}

function countInstances(theVal, theChar) {
  var substrings = theVal.split(theChar);
  return substrings.length - 1;
}

function fixCollection(theStr,theProb) {
	var collStr = "collection\":{";
	var newStr = theStr;

	var thispos = theStr.indexOf(collStr);

	if (thispos != -1) {
		newStr = theStr.substring(0,thispos) + "collection\":" +
			"[{" + theStr.substring(thispos+collStr.length);
	}

	thispos = newStr.indexOf(theProb);
	if (thispos != -1) 
		newStr = newStr.substring(0,thispos) + "]}]}";


	return newStr;
}

function sortOutDate(dateStr, dashed) {
	print("dateStr - " + dateStr);
	var theDate = new Date();
	if (dashed)
		dateStr.match(/(\d{4})\-(\d{2})\-(\d{2})/);
	else
		dateStr.match(/(\d{4})\.(\d{2})\.(\d{2})/);

	//print(RegExp.$1 + " - " + RegExp.$2 + " - " + RegExp.$3)
	theDate.setYear(RegExp.$1);
	theDate.setMonth(RegExp.$2);
	theDate.setDate(RegExp.$3);

	print("returning " + theDate);

	return theDate;
}//sortOutDate

function jsonEval(inStr) {
	//print("starts " + inStr + " - " + countInstances(inStr,"}") + " - " + countInstances(inStr,"{"));
	var theStr = inStr;
	if (countInstances(theStr,"}") < countInstances(theStr,"{")) {
		//theStr = theStr.substring(0,theStr.length - 1);
		theStr += "}";
		//print("modified");
	}
		
	//print("-: " + theStr);
	var evalObj = null;
	try {
        	evalObj = eval('(' + theStr + ')');
	} catch (evalProb) {
		print("jsonify can't convert: " + evalObj);
		print("jsonify can't convert - " + evalProb);
	}

        
        return evalObj; 
}

//jsonify - put results of pipeline into JSON format
function jsonify(pipeline, pipeinfo) {

        //print("json pipeline is " + pipeline);
        var stream = new java.io.ByteArrayOutputStream();
        cocoon.processPipelineTo( pipeline, pipeinfo, stream );
        var theVal = stream.toString() + "";
		
	//print("serviceVal is " + theVal);
        var checkpos = -1;
	/* 	this probably doesn't have to be in a try/catch block
		but i had a problem with one range where it was an odd
		character. 
	*/	
	try {
		checkpos = theVal.indexOf(prob1);
		if (checkpos != -1)
			theVal = fixCollection(theVal,prob1);
		checkpos = theVal.indexOf(prob2);
        	if (checkpos != -1)
                	theVal = theVal.substring(0,checkpos);
		checkpos = theVal.indexOf(prob3);
		if (checkpos != -1) {
			theVal = theVal.replace(/,\{\"url/g,'},{\"url') + "";
			theVal = theVal.replace(/\"\]/g,'\"}]');
			//print("now -> " + theVal + "<-");
		}
	} catch (problem) {
		print("nasty char issue " + problem);
	}

	var theEval = jsonEval(theVal);

	return theEval;

}//jsonify

function stringify(pipeline, pipeinfo) {

        print("stringif pipeline is " + pipeline);
        var stream = new java.io.ByteArrayOutputStream();
        cocoon.processPipelineTo( pipeline, pipeinfo, stream );
        var theVal = stream.toString() + "";
	  return theVal;

}//jsonify

//jsonify - get json results but leave in string format
function dejsonify(pipeline, pipeinfo) {

        //print("json pipeline is " + pipeline);
        var stream = new java.io.ByteArrayOutputStream();
        cocoon.processPipelineTo( pipeline, pipeinfo, stream );
        return stream.toString() + "";

}//dejsonify

//reportStatus - send message to status pipeline
function reportStatus(theReason) {
	print("thereason is " + theReason);
        var reason = {  
                "reason" : theReason
        }       
        cocoon.sendPage("wagger-status-pipeline", reason);
}//reportStatus  

function reportStatusInJson(theReason) {
	//print("sending " + theReason);
        var reason = {  
                "reason" : theReason
        }       
        cocoon.sendPage("wagger-status-pipeline-json", reason);
}//reportStatusInJson  

// n = number you want padded
// digits = length you want the final output
function zeroPad(n, digits) {
	n = n.toString();
	while (n.length < digits) {
		n = '0' + n;
	}
	return n;
}


function Mod10(ccNumb) {  // v2.0
var valid = "0123456789"  // Valid digits in a credit card number
var len = ccNumb.length;  // The length of the submitted cc number
var iCCN = parseInt(ccNumb);  // integer of ccNumb
var sCCN = ccNumb.toString();  // string of ccNumb
sCCN = sCCN.replace (/^\s+|\s+$/g,'');  // strip spaces
var iTotal = 0;  // integer total set at zero
var bNum = true;  // by default assume it is a number
var bResult = false;  // by default assume it is NOT a valid cc
var temp;  // temp variable for parsing string
var calc;  // used for calculation of each digit

// Determine if the ccNumb is in fact all numbers
for (var j=0; j<len; j++) {
  temp = "" + sCCN.substring(j, j+1);
  if (valid.indexOf(temp) == "-1"){bNum = false;}
}

// if it is NOT a number, you can either alert to the fact, or just pass a failure
if(!bNum){
  /*alert("Not a Number");*/bResult = false;
}

// Determine if it is the proper length 
if((len == 0)&&(bResult)){  // nothing, field is blank AND passed above # check
  bResult = false;
} else{  // ccNumb is a number and the proper length - let's see if it is a valid card number
  if(len == 14){  // 15 or 16 for Amex or V/MC
    for(var i=len;i>0;i--){  // LOOP throught the digits of the card
      calc = parseInt(iCCN) % 10;  // right most digit
      calc = parseInt(calc);  // assure it is an integer
      iTotal += calc;  // running total of the card number as we loop - Do Nothing to first digit
      i--;  // decrement the count - move to the next digit in the card
      iCCN = iCCN / 10;                               // subtracts right most digit from ccNumb
      calc = parseInt(iCCN) % 10 ;    // NEXT right most digit
      calc = calc *2;                                 // multiply the digit by two
      // Instead of some screwy method of converting 16 to a string and then parsing 1 and 6 and then adding them to make 7,
      // I use a simple switch statement to change the value of calc2 to 7 if 16 is the multiple.
      switch(calc){
        case 10: calc = 1; break;       //5*2=10 & 1+0 = 1
        case 12: calc = 3; break;       //6*2=12 & 1+2 = 3
        case 14: calc = 5; break;       //7*2=14 & 1+4 = 5
        case 16: calc = 7; break;       //8*2=16 & 1+6 = 7
        case 18: calc = 9; break;       //9*2=18 & 1+8 = 9
        default: calc = calc;           //4*2= 8 &   8 = 8  -same for all lower numbers
      }                                               
    iCCN = iCCN / 10;  // subtracts right most digit from ccNum
    iTotal += calc;  // running total of the card number as we loop
  }  // END OF LOOP
  if ((iTotal%10)==0){  // check to see if the sum Mod 10 is zero
    bResult = true;  // This IS (or could be) a valid credit card number.
  } else {
    bResult = false;  // This could NOT be a valid credit card number
    }
  }
}
  return bResult; // Return the results
}

function listProperties(obj) {
   var propList = "";
   for(var propName in obj) {
      if(typeof(obj[propName]) != "undefined") {
         propList += (propName + ", " + typeof(obj[propName]));
      }
   }
   print("--> " + propList);
}
