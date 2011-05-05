/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.conifer;

import java.lang.StringBuffer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

//date support
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

//lucene
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.highlight.QueryTermExtractor;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.highlight.WeightedTerm;

public class MyBean
{

    private String message;

    public void setMessage(String message) {
        this.message = message;
    }

    public String getMessage() {
        return this.message;
    }

    //term handling
    public static String sortOutTerms(String queryString, String resultString, String tag, String strLen)
        throws org.apache.lucene.queryParser.ParseException
    {
        String startTag = "<" + tag + ">";
        String endTag = "</" + tag + ">";
        StringBuffer termBuf = new StringBuffer();
        int addToLen = startTag.length() + endTag.length();

        int resultLen = Integer.parseInt(strLen);
        String displayString = resultString;

        QueryParser luceneParser = new QueryParser("text", new StandardAnalyzer());
        QueryTermExtractor luceneTerms = new QueryTermExtractor();
        Query luceneQuery = null;
        Query query = null;
        WeightedTerm[] weightTerms = null;
        luceneQuery = luceneParser.parse(queryString);
        weightTerms = luceneTerms.getTerms(luceneQuery);

        for (int i=0; i < weightTerms.length; i++) {
                String term = weightTerms[i].getTerm();
                Pattern replace = Pattern.compile(term,Pattern.CASE_INSENSITIVE);
                Matcher matcher = replace.matcher(displayString);
                while (matcher.find()) {
                        //displayString = matcher.replaceAll(startTag + term + endTag);
                        if (termBuf.toString().indexOf(matcher.group(0)) == -1) {
                                displayString = displayString.replaceAll(matcher.group(0),
                                        startTag + matcher.group(0) + endTag);
                                resultLen += addToLen;
                        }//if
                        termBuf.append(matcher.group(0));
                        termBuf.append(",");
                }//while
        }//for

        int hlStart = displayString.indexOf(startTag);
        //System.out.println("hlStart: " + hlStart);

        if (hlStart > resultLen) {
                String tmpString = displayString.substring(0,hlStart);
                hlStart = tmpString.lastIndexOf(" ");
               displayString = "..." + displayString.substring(++hlStart);
                resultLen += 3;
        }//if

        if (displayString.length() > resultLen) {
                displayString = displayString.substring(0,resultLen);
                hlStart = displayString.lastIndexOf(startTag);
                int hlEnd = displayString.lastIndexOf(endTag);
                if (hlEnd < hlStart)
                        displayString = displayString.substring(0,--hlStart);
                displayString = displayString + "...";
        }//if

        return displayString;
    }//sortOutTerms

    public static String sortOutDate(String dateString, String formatIn, String formatOut)
        throws java.text.ParseException
    {
        SimpleDateFormat formatter = new SimpleDateFormat(formatIn); //please notice the capital M
        Date date = formatter.parse(dateString);
        formatter = new SimpleDateFormat(formatOut);

        return formatter.format(date);
    }//sortOutDat

    public static void main(String[] args) throws Exception {
        String displayString = "";

        if (args.length != 4) {
            throw new Exception("Usage: " + MyBean.class.getName() +
                " query result tag length");
        }
        int resultSize = Integer.parseInt(args[3]);
                //displayString = sortOutTerms(args[0],args[1],args[2],args[3]);
        if (resultSize > 0)
                displayString = sortOutTerms("\"river runs*\"","the red River RIVER rivering river runs from north to west", "b", "100");
        System.out.println("result: " + displayString);
        System.out.println("result: " + sortOutDate("1970-01-01T00:00:00.000Z","yyyy-mm-dd'T'hh:mm:ss.SSS'Z'","MMM dd, yyyy"));
   }
}//MyBean

