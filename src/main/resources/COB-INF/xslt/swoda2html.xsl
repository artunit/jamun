<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!-- swoda2html.xsl:
        put sowda result into html

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
<xsl:param name="solr"/>
<xsl:param name="swoda"/>
<xsl:param name="source"/>

<xsl:template match="text()"/>

<xsl:template match="response/result">
	<html>
	<head>
		<title>
		SWODA Titles
		</title>
	</head>
	<body>

	<div id="lsearch_etd">
	<!-- using google styling for now -->

	<div class="gsc-control-cse">
        <a class="logo_link" target="_blank">
                <xsl:attribute name="href">
                <xsl:text>http://ink.ourontario.ca/search/results</xsl:text>
                <xsl:text>?publisher=efp&amp;sort=score+desc&amp;q=</xsl:text>
                <xsl:value-of select="$query"/>
                </xsl:attribute>
                <img src="swoda_logo.jpg" width="100px" height="25px" alt="SWODA Collection"/>
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
				<xsl:value-of select="str[@name='url']"/>
			</xsl:variable>
			<xsl:variable name="selectTitle">
				<xsl:value-of select="str[@name='title']"/>
			</xsl:variable>
			<xsl:variable name="displayTitle">
				<xsl:choose>
					<xsl:when test="contains($selectTitle,'. ')">
						<xsl:value-of select="substring-after($selectTitle,'. ')"/>
					</xsl:when>
					<xsl:when test="string-length($selectTitle) &gt; 40">
						<xsl:value-of select="substring($selectTitle,1,40)"/>
						<xsl:text>...</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$selectTitle"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="gs-title">
			<a class="gs-title" target="_blank">
			<xsl:attribute name="href">
			<xsl:value-of select="$swoda"/>
			<xsl:value-of select="$id"/>
			<xsl:text>?query=</xsl:text>
			<xsl:value-of select="$query"/>
			</xsl:attribute>
			
			<xsl:value-of select="$displayTitle" disable-output-escaping="yes"/>
			</a>
			</div>
			<div></div>

			<!-- snippet -->
			<div class="gs-snippet">
				<img>
				<xsl:attribute name="src">
				<xsl:value-of select="$swoda"/>
				<xsl:value-of select="substring-before($id,'-')"/>
				<xsl:text>/hlRouter-</xsl:text>
				<xsl:choose>
				<xsl:when test="contains($id,'x0')">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>100</xsl:text>
				</xsl:otherwise>
				</xsl:choose>
				<xsl:text>?query=</xsl:text>
				<xsl:value-of select="$query"/>
				<xsl:text>&amp;width=</xsl:text>
				<xsl:value-of select="$width"/>
				<xsl:text>&amp;height=</xsl:text>
				<xsl:value-of select="$height"/>
				</xsl:attribute> 
				</img>
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
