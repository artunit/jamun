<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- response2json.xsl: 	
	convert XML to JSON

	this xslt needs more work for complex xml, really
	used at this point for coordinating pipeline
	processing and status information rather
	than extensive XML output
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->

<!--
-->
<xsl:output method="json"/>

<xsl:template match="text()" />

<xsl:template match="/">
		<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="//body">
	<xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
