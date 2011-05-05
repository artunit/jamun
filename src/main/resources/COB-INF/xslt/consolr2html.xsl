<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!-- consolr2html.xsl:
        put solr result from conifer into html layout

        TODO: this is windsor-specific, need to make generic

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:include href="common.xsl" />

<xsl:param name="rows"/>
<xsl:param name="start"/>
<xsl:param name="query"/>
<xsl:param name="hits"/>
<xsl:param name="width"/>
<xsl:param name="height"/>
<xsl:param name="seq"/>
<xsl:param name="source"/>

<xsl:template match="text()"/>

<xsl:template match="response/result">
	<html>
	<head>
		<title>
		Conifer Titles
		</title>
	</head>
	<body>

	<div id="lsearch_etd">
	<!-- using google styling for now -->

	<div class="gsc-control-cse">
	<a class="logo_link" target="_blank">
                <xsl:attribute name="href">
                <xsl:text>http://windsor.concat.ca/opac/en-CA/skin/uwin/xml/rresult.xml</xsl:text>
                <xsl:text>?rt=keyword&amp;tp=keyword&amp;l=106&amp;t=</xsl:text>
                <xsl:value-of select="$query"/>
                </xsl:attribute>
                <img src="conifer_logo.jpg" width="100px" height="25px" alt="U. of Windsor catalogue"/>
		<xsl:text> more »</xsl:text>
	</a>
        <input class="close-button" name="close" type="button" value="x">
		<xsl:attribute name="onclick">
			<xsl:text>javascript:clearPane("</xsl:text>
			<xsl:value-of select="$source"/>
			<xsl:text>")</xsl:text>
		</xsl:attribute>
	</input>


	<div class="gsc-wrapper">
	<div class="gsc-resultsbox-visible" style="visibility: visible;">
	<div class="gsc-resultsRoot gsc-tabData gsc-tabdActive">

	<div class="gsc-results gsc-webResult" style="display: block;">
	<xsl:for-each select="doc">

		<!-- result entry -->
		<div class="gsc-webResult gsc-result">
		<div class="gs-webResult gs-result">
			<xsl:variable name="id">
				<xsl:value-of select="str[@name='id']"/>
			</xsl:variable>

			<div class="gs-title">
                        <a class="gs-title" target="_blank">
                        <xsl:attribute name="href">
                        <xsl:text>http://windsor.concat.ca/opac/en-CA/skin/uwin/xml/rdetail.xml</xsl:text>
                        <xsl:text>?l=106&amp;d=1&amp;hc=1&amp;rt=tcn&amp;r=</xsl:text>
                        <xsl:value-of select="$id"/>
                        <xsl:text>&amp;adv=</xsl:text>
                        <xsl:value-of select="$id"/>
                        </xsl:attribute>
                        <xsl:text>From the catalogue »</xsl:text>
                        </a>
			</div>
			<div></div>

			<!-- snippet -->
			<div class="gs-snippet">

			<xsl:variable name="displayTitle">
				<xsl:value-of select="str[@name='title_display']"/>
				<xsl:if test="count(str[@name='subtitle_display']) &gt; 0">
					<xsl:text>: </xsl:text>
					<xsl:value-of select="str[@name='subtitle_display']"/>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="pubDate">
				<xsl:value-of select="arr[@name='pub_date']/str"/>
			</xsl:variable>
				
			<xsl:if test="string-length($pubDate) &gt; 0">
				<xsl:value-of select="$pubDate"/>
				<xsl:text>&#160; ... &#160;</xsl:text>
			</xsl:if>
                        
			<i>
                        <xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,$displayTitle,'b',250)"
                                disable-output-escaping="yes"/>
                        </i>

			<br clear="left"></br>
			<xsl:variable name="author">
				<xsl:value-of select="str[@name='author_display']"/>
			</xsl:variable>
			<xsl:if test="string-length($author) &gt; 0">
				<xsl:value-of select="$author"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:if test="count(arr[@name='published_display']) &gt; 0">
				<xsl:value-of select="arr[@name='published_display']/str"/>
				<xsl:text>&#160;  &#160;</xsl:text>
			</xsl:if>
			<xsl:if test="count(arr[@name='format']) &gt; 0">
				<xsl:value-of select="arr[@name='format']/str"/>
				<xsl:text>&#160;  &#160;</xsl:text>
			</xsl:if>
			
			</div>
		</div>
		</div>
	</xsl:for-each>

	<xsl:variable name="pagecount">
		<xsl:choose>
			<xsl:when test="number($hits) &lt; number($rows)">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:when test="round(number($hits) div number($rows)) &gt; number($seq)">
				<xsl:value-of select="$seq"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="round(number($hits) div number($rows))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

        <xsl:variable name="pageselect">
                <xsl:choose>
                        <xsl:when test="$start &gt; 0">
                                <xsl:value-of select="round($start div $rows) + 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:text>1</xsl:text>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:variable>

        <div class="gsc-cursor-box">
        <xsl:call-template name="pane_numbers">
                <xsl:with-param name="i" select="1"/>
                <xsl:with-param name="count" select="number($pagecount)"/>
                <xsl:with-param name="source" select="$source"/>
                <xsl:with-param name="rows" select="$rows"/>
                <xsl:with-param name="hits" select="$hits"/>
                <xsl:with-param name="query" select="$query"/>
                <xsl:with-param name="DEFAULT" select="$pageselect"/>
        </xsl:call-template>
        </div>

	</div><!-- end entry styling -->

	</div>
	</div>
	</div>
	</div><!-- end google block styling -->

	</div><!-- end lsearch block -->
	
	</body>
	</html>
</xsl:template>

</xsl:stylesheet>
