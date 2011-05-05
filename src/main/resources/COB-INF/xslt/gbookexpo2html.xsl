<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!-- gbookexpo2html.xsl:
        placeholder for google books

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->

<xsl:include href="common.xsl" />

<xsl:param name="googleId"/>
<xsl:param name="coniferId"/>
<xsl:param name="query"/>

<xsl:template match="text()"/>

<xsl:template match="/">
	<html>
	<head>
		<title>
		Google Book Placeholder
		</title>
		<link rel="stylesheet" href="reset.css" />
		<link rel="stylesheet" href="text.css" />
		<link rel="stylesheet" href="960.css" />
		<link rel="stylesheet" href="greensky.css"/>
		<link rel="stylesheet" href="jamun.css" />

	</head>
	<body>
	<div class="container_16">
        <div class="grid_16">

        <div id="custom_header">
                <img src="jamun.jpg" class="logo" align="left"/>
                jamun - just another modified uber notion
        </div>

	<br clear="left"/>
	<div id="lsearch_etd">

	<h3>This is a placeholder</h3>

	<ul>
	<li>
	<xsl:text>The google book link which shows the pages containing </xsl:text>	
	<a target="_blank">
		<xsl:attribute name="href">
		<xsl:text>http://books.google.com/books?id=</xsl:text>
		<xsl:value-of select="$googleId"/>
		<xsl:text>&amp;q=</xsl:text>
		<xsl:value-of select="$query"/>
		</xsl:attribute> 
		<xsl:text>the query terms is here</xsl:text>
	</a>
	</li>

	<li>
	<xsl:text>The corresponding conifer record </xsl:text>	
	<a target="_blank">
		<xsl:attribute name="href">
		<xsl:text>http://windsor.concat.ca/opac/en-CA/skin/uwin/xml/rdetail.xml</xsl:text>
		<xsl:text>?l=106&amp;d=1&amp;hc=1&amp;rt=tcn&amp;r=</xsl:text>
		<xsl:value-of select="$coniferId"/>
		<xsl:text>&amp;adv=</xsl:text>
		<xsl:value-of select="$coniferId"/>
		</xsl:attribute>
		<xsl:text>should be here</xsl:text>
	</a>
	</li>
	</ul>

	<xsl:text>
	We look up the ISBNs from the Google Book info to get the Bib Id, the idea is to display
	the status information of the book in the collection and link to the Google Book entry
	for the page references. Soon...
	</xsl:text>


	</div><!-- end lsearch block -->
	</div><!-- end grid class -->
	</div><!-- end grid -->
	
	</body>
	</html>
</xsl:template>

</xsl:stylesheet>
