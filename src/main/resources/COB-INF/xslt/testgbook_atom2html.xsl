<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:dc="http://purl.org/dc/terms"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:opensearch="http://a9.com/-/spec/opensearchrss/1.0/"
>
<!-- testgbook_atom2html.xsl:
        put result into html layout

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:include href="common.xsl" />

<xsl:variable name="isoFormat">
	<xsl:text>
	<![CDATA[yyyy-mm-dd'T'hh:mm:ss.SSS'Z']]>
	</xsl:text>
</xsl:variable>


<xsl:param name="rows"/>
<xsl:param name="start"/>
<xsl:param name="query"/>
<xsl:param name="hits"/>
<xsl:param name="seq"/>
<xsl:param name="ghost"/>
<xsl:param name="source"/>
<xsl:param name="userid"/>
<xsl:param name="libraryshelf"/>

<xsl:template match="text()"/>

<xsl:template match="/atom:feed">
	<html>
	<head>
		<title>
		GBook Titles
		</title>
	</head>
	<body>

	<div id="lsearch_etd">
	<!-- using google styling for now -->

	<div class="gsc-control-cse">
        <a class="logo_link" target="_blank">
                <xsl:attribute name="href">
		<xsl:value-of select="$ghost"/>
                <xsl:text>/books?uid=</xsl:text>
                <xsl:value-of select="$userid"/>
                <xsl:text>&amp;as_coll=</xsl:text>
                <xsl:value-of select="$libraryshelf"/>
                <xsl:text>&amp;q=</xsl:text>
                <xsl:value-of select="$query"/>
                </xsl:attribute>
                <img src="gb_logo.jpg" width="112px" height="25px" alt="Google Books - Leddy Shelf"/>
                <xsl:text> more »</xsl:text>
        </a>

	<div class="gsc-wrapper">
	<div class="gsc-resultsbox-visible" style="visibility: visible;">
	<div class="gsc-resultsRoot gsc-tabData gsc-tabdActive">

	<div class="gsc-results gsc-webResult" style="display: block;">
	<xsl:for-each select="atom:entry">

		<!-- result entry -->
		<div class="gsc-webResult gsc-result">
		<div class="gs-webResult gs-result">
			<xsl:variable name="isbnList">
				<xsl:for-each select="dc:identifier[contains(.,'ISBN:')]">
					<xsl:value-of select="substring-after(.,'ISBN:')"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<div class="gs-title">
			<a class="gs-title" target="_blank">
			<xsl:attribute name="href">
			<xsl:choose>
				<xsl:when test="string-length($isbnList) &gt; 0">
				<xsl:text>gbook-detail-</xsl:text>
				<xsl:value-of select="dc:identifier[not(contains(.,'ISBN'))]"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="$isbnList"/>
				<xsl:text>-</xsl:text>
				</xsl:when>
				<xsl:otherwise>
				<xsl:value-of select="$ghost"/>
				<xsl:text>/books?id=</xsl:text>
				<xsl:value-of select="dc:identifier"/>
				<xsl:text>&amp;q=</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$query"/>
			</xsl:attribute>
			<xsl:text>Look inside the book at Leddy »</xsl:text>
			</a>
			</div>

			<!-- snippet -->
			<div class="gs-snippet">

			<xsl:variable name="pubDate">
				<xsl:value-of select="dc:date"/>
			</xsl:variable>


			<xsl:if test="string-length($pubDate) &gt; 0">
				<xsl:choose>
					<xsl:when test="contains($pubDate,'-')">
						<xsl:value-of select="substring-before($pubDate,'-')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$pubDate"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>&#160; ... &#160;</xsl:text>
			</xsl:if>
			<i>
			<xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,atom:title,'b',250)" 
				disable-output-escaping="yes"/>
			</i>
			<br clear="left"></br>

			<xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,dc:description,'b',250)" 
				disable-output-escaping="yes"/> 
			<!--
			<div class="gs-visibleUrl gs-visibleUrl-short">winspace.uwindsor.ca</div>
			-->
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
