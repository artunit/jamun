<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
>

<!-- spjournal_atom2json.xsl: 	
    scholars portal journal results into json

	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->

<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:template match="/atom:feed">
    <xsl:text>{hits:"</xsl:text>
    <xsl:value-of select="opensearch:totalResults"/>
    <xsl:text>"}</xsl:text>
</xsl:template>

</xsl:stylesheet>
