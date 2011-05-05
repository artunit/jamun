<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- opensrf2json.xsl:
    pass hits in json syntax

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->


<xsl:param name="hits"/>

<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:template match="/">
	<xsl:text>{hits:"</xsl:text>
	<xsl:value-of select="$hits"/>
	<xsl:text>"}</xsl:text>
</xsl:template>

</xsl:stylesheet>
