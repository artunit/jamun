<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- result2json.xsl: 	
        put result into json syntax
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:param name="rows"/>

<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:template match="//result">
    <xsl:variable name="hits">
	<xsl:choose>
		<!-- try to catch odd low results in etd index -->
		<xsl:when test="count(//doc) &lt; number($rows)">
    			<xsl:value-of select="count(//doc)"/>
		</xsl:when>
		<xsl:otherwise>
    			<xsl:value-of select="@numFound"/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:variable>
 
    <xsl:text>{hits:"</xsl:text>
    <xsl:value-of select="$hits"/>
    <xsl:text>"}</xsl:text>
</xsl:template>

</xsl:stylesheet>
