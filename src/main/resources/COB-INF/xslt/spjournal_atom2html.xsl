<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:dc="http://purl.org/dc/terms"
	xmlns:sp="http://scholarsportal.info/metadata"
	xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
	xmlns:java="http://xml.apache.org/xslt/java"
>
<!-- spjournal_atom2html.xsl:
        put scholars portal atom journal result into html layout

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:include href="common.xsl" />

<xsl:param name="rows"/>
<xsl:param name="start"/>
<xsl:param name="query"/>
<xsl:param name="hits"/>
<xsl:param name="seq"/>
<xsl:param name="sphost"/>
<xsl:param name="source"/>

<xsl:template match="text()"/>

<xsl:template match="/atom:feed">
	<html>
	<head>
		<title>
		SP Journals	
		</title>
	</head>
	<body>

	<div id="lsearch_etd">
	<!-- using google styling for now -->

	<div class="gsc-control-cse">

        <a class="logo_link" target="_blank">
                <xsl:attribute name="href">
                <xsl:text>http://journals.scholarsportal.info/search-advanced.xqy?q=</xsl:text>
                <xsl:value-of select="$query"/>
                </xsl:attribute>
                <img src="spj_logo.jpg" width="134px" height="25px" alt="Scholars Portal Journals"/>
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
	<xsl:for-each select="atom:entry">

		<!-- result entry -->
		<div class="gsc-webResult gsc-result">
		<div class="gs-webResult gs-result">
			<div class="gs-title">
			<a class="gs-title" target="_blank">
			<xsl:attribute name="href">
			<xsl:value-of select="atom:id"/>
			</xsl:attribute>
			 <xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,atom:title,'b',250)"
                                disable-output-escaping="yes"/>
			</a>
			</div>

			<!-- snippet -->
			<div class="gs-snippet">

			<xsl:variable name="pubDate">
				<xsl:value-of select="atom:content/sp:result/sp:article/sp:publication-date"/> 
			</xsl:variable>

			<xsl:if test="string-length($pubDate) &gt; 0">
 				<xsl:value-of select="java:org.conifer.MyBean.sortOutDate($pubDate,'yyyy-mm-dd','MMM dd, yyyy')"/>
				<xsl:text>&#160; ... &#160;</xsl:text>
			</xsl:if>

			<xsl:variable name="journalTitle">
				<xsl:value-of select="atom:content/sp:result/sp:journal/sp:title"/>
			</xsl:variable>

			<xsl:if test="string-length($journalTitle) &gt; 0">
				<i>
 				<xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,$journalTitle,'b',250)"
                                	disable-output-escaping="yes"/>
				</i>
				<xsl:text>. </xsl:text>
			</xsl:if>

			<xsl:value-of select="atom:content/sp:result/sp:journal/sp:volume"/>

			<xsl:variable name="issue">
				<xsl:value-of select="atom:content/sp:result/sp:journal/sp:issue"/>
			</xsl:variable>

			<xsl:if test="string-length($issue)">
				<xsl:text>(</xsl:text>
				<xsl:value-of select="$issue"/>
				<xsl:text>)</xsl:text>
			</xsl:if>

			<xsl:variable name="description">
				<xsl:value-of select="atom:content/sp:result/sp:article/sp:abstract"/> 
			</xsl:variable>

			<xsl:if test="string-length($description) &gt; 0">
				<br clear="left"></br>
 				<xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,$description,'b',250)"
                                	disable-output-escaping="yes"/>
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
