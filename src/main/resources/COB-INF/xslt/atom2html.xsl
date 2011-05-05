<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
>
<!-- atom2html.xsl:
        put atom result into html layout

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:include href="common.xsl" />


<xsl:param name="rows"/>
<xsl:param name="start"/>
<xsl:param name="query"/>
<xsl:param name="hits"/>
<xsl:param name="seq"/>

<xsl:template match="text()"/>

<xsl:template match="/atom:feed">
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
	<div id="etd_caption">Search inside the book (Google Books)</div>
	<div class="gsc-wrapper">
	<div class="gsc-resultsbox-visible" style="visibility: visible;">
	<div class="gsc-resultsRoot gsc-tabData gsc-tabdActive">

	<div class="gsc-results gsc-webResult" style="display: block;">
	<xsl:for-each select="atom:entry">

		<!-- result entry -->
		<div class="gsc-webResult gsc-result">
		<div class="gs-webResult gs-result">
			<xsl:variable name="id">
				<xsl:value-of select="atom:id[contains(.,'tag')]"/>
			</xsl:variable>
			<div class="gs-title">
			<a class="gs-title" target="_blank">
			<xsl:attribute name="href">
			<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:choose>
			<xsl:when test="string-length(atom:title) &gt; 40">
				<xsl:value-of select="substring(atom:title,1,40)"/>
				<xsl:text>...</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="atom:title"/>
			</xsl:otherwise>
			</xsl:choose>
			</a>
			</div>

			<!-- snippet -->
			<div class="gs-snippet">
			<xsl:variable name="description">
				<xsl:value-of select="atom:summary"/>
			</xsl:variable>

			<xsl:choose>
			<xsl:when test="string-length($description) &lt; 250">
				<xsl:text>...</xsl:text>
				<xsl:value-of select="$description"/> 
				<xsl:text>...</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($description,1,250)"/>
				<xsl:if test="string-length($description) &gt; 250">
					<xsl:text>...</xsl:text>
				</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
			<div class="gs-visibleUrl gs-visibleUrl-short">winspace.uwindsor.ca</div>
			</div>
		</div>
		</div>
	</xsl:for-each>

	<xsl:variable name="pagecount">
		<xsl:choose>
			<xsl:when test="number($hits) &lt; number($rows)">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:when test="round(number($hits) div number($rows)) &lt; number($seq)">
				<xsl:value-of select="round(number($hits) div number($rows))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$seq"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
		
	<div class="gsc-cursor-box">
        <xsl:call-template name="pane_numbers">
                <xsl:with-param name="i" select="1"/>
                <xsl:with-param name="count" select="number($pagecount)"/>
                <xsl:with-param name="source" select="$source"/>
                <xsl:with-param name="seq" select="$seq"/>
                <xsl:with-param name="hits" select="$hits"/>
                <xsl:with-param name="query" select="$query"/>
                <xsl:with-param name="DEFAULT" select="number($start)"/>
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
