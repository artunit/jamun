<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- gbook_highlight2json.xsl:
        put highlight pages into json format

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->


<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:template match="/retrieval-results">
    <xsl:text>{"pages":[</xsl:text>
    <xsl:for-each select="pages/page">
    	<xsl:text>"</xsl:text>
    	<xsl:value-of select="."/>
    	<xsl:text>"</xsl:text>
	<xsl:if test="not(position() = last())">
		<xsl:text>,</xsl:text>
	</xsl:if>
    </xsl:for-each>
    <xsl:text>]}</xsl:text>
</xsl:template>

</xsl:stylesheet>
