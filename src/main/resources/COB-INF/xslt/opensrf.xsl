<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- opensrf.xsl
	set up HTTP interaction with evergreen
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->

<xsl:param name="osrfHost"/>

<xsl:template match="text()"/>

<xsl:template match="/opensrf">
	<seth:execute-retrieval>

	<!-- use specific User Agent -->
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>

	<!-- where to go -->
	<seth:url><xsl:value-of select="$osrfHost"/></seth:url>

	<seth:nvp name="method"><xsl:value-of select="method"/></seth:nvp>
	<seth:nvp name="service"><xsl:value-of select="service"/></seth:nvp>
	<xsl:for-each select="parms/parm">
		<seth:nvp name="param" jsspace="true"><xsl:value-of select="."/></seth:nvp>
	</xsl:for-each>
	<seth:method>POST</seth:method>

	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
