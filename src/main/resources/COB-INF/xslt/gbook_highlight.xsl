<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- gbook_highlight.xsl: 	
    gbook page with highlights
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:include href="common.xsl" />

<xsl:param name="gbid"/>
<xsl:param name="query"/>
<xsl:param name="sift"/>

<xsl:template match="text()"/>

<xsl:template match="/">
	<seth:execute-retrieval>
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>

        <seth:url>http://books.google.com</seth:url>
        <seth:nvp name="id"><xsl:value-of select="$gbid"/></seth:nvp>
        <seth:sift><xsl:value-of select="$sift"/></seth:sift>

        <seth:nvp name="q">
		<xsl:choose>
			<xsl:when test="contains($query,'+')">
        			<xsl:call-template name="replaceCharsInString">
            				<xsl:with-param name="stringIn" select="$query"/>
            				<xsl:with-param name="charsIn" select="'+'"/>
            				<xsl:with-param name="charsOut" select="' '"/>
        			</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$query"/>
			</xsl:otherwise>
		</xsl:choose>
	</seth:nvp>
    <seth:method>GET</seth:method>
	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
