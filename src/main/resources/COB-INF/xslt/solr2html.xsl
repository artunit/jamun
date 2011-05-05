<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:java="http://xml.apache.org/xslt/java"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!-- solr2html.xsl:
        put solr result into html

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:include href="common.xsl" />

<xsl:param name="rows"/>
<xsl:param name="start"/>
<xsl:param name="query"/>
<xsl:param name="hits"/>
<xsl:param name="seq"/>
<xsl:param name="source"/>

<xsl:template match="text()"/>

<xsl:template match="response/result">
	<html>
	<head>
		<title>
		<xsl:value-of select="$source"/> 
		<xsl:text>Titles</xsl:text>
		</title>
	</head>
	<body>

	<div id="lsearch_etd">
	<!-- using google styling for now -->

	<div class="gsc-control-cse">
	<!--
	<div id="etd_caption">Titles from <xsl:value-of select="$source"/>
	-->
		<xsl:choose>
			<xsl:when test="contains($source,'conifer')">
				<a class="logo_link" target="_blank"> 
					<xsl:attribute name="href">
					<xsl:text>http://windsor.concat.ca/opac/en-CA/skin/uwin/xml/rresult.xml</xsl:text>
					<xsl:text>?rt=keyword&amp;tp=keyword&amp;t=</xsl:text>
					<xsl:value-of select="$query"/>
					</xsl:attribute>
					<img src="conifer_logo.jpg" width="100px" height="25px" alt="U. of Windsor catalogue"/>
					<xsl:text> more &gt;&gt;</xsl:text>
				</a>
			</xsl:when> 
			<xsl:otherwise>
				<a class="logo_link" target="_blank"> 
					<xsl:attribute name="href">
					<xsl:text>http://winspace.uwindsor.ca/wintheses/results?q=</xsl:text>
					<xsl:value-of select="$query"/>
					</xsl:attribute>
					<img src="etd_logo.jpg" width="62px" height="25px" alt="winspace ETD repository"/>
					<xsl:text> more »</xsl:text>
				</a>
			</xsl:otherwise>
		</xsl:choose>
<!--
	</div>
-->
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
					<xsl:value-of select="arr[@name='url']/str"/>
				</xsl:attribute>
			
				<xsl:if test="contains($source,'etd')">
					<xsl:text>E-Thesis (read online) »</xsl:text>
				</xsl:if>
			</a>
			</div>
			<div></div>

			<!-- snippet -->
			<div class="gs-snippet">
			<xsl:variable name="description">
				<xsl:value-of select="str[@name='description']"/>
			</xsl:variable>

			<xsl:if test="contains($source,'etd')">
				<i>
				<xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,str[@name='title'],'b',250)"
                                	disable-output-escaping="yes"/>
				</i>
				<xsl:if test="string-length($description) &gt; 0">
					<xsl:text>&#160; - &#160;</xsl:text>
					<xsl:value-of select="java:org.conifer.MyBean.sortOutTerms($query,$description,'b',250)"
                                		disable-output-escaping="yes"/>
				</xsl:if>
			</xsl:if>
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
