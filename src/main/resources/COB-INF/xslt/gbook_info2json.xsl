<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- result2json.xsl: 	
        put result into json syntax
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->

<xsl:output method="json"/>

<xsl:template match="text()"/>

<!--
<xsl:template match="/sethtarget/retrieval-results">
-->
<xsl:template match="/json">
    <xsl:variable name="jsonInfo">
	<xsl:value-of select="substring-after(.,'gbsInfo(')"/>
    </xsl:variable>
    <xsl:text>{"gbsInfo":</xsl:text>
    <xsl:value-of select="substring-before($jsonInfo,');')"/>
    <xsl:text>}</xsl:text>
</xsl:template>

</xsl:stylesheet>
