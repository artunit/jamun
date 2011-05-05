<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- gbook_info.xsl: 	
    used for building a shelf
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->
<!--
        <seth:url>http://books.google.com</seth:url>
        <seth:nvp name="id">gXwSu_MNqgsC</seth:nvp>
        <seth:nvp name="q">water</seth:nvp>
        <seth:sift>page_number</seth:sift>
-->
<xsl:include href="common.xsl" />

<xsl:param name="isbns"/>

<xsl:template match="text()"/>

<xsl:template match="/">
	<seth:execute-retrieval>
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>

        <seth:url>http://books.google.com</seth:url>
        <seth:nvp name="bibkeys"><xsl:value-of select="$isbns"/></seth:nvp>
        <seth:nvp name="jscmd">viewapi</seth:nvp>
        <seth:nvp name="callback">gbsInfo</seth:nvp>
        <seth:jsononly>TRUE</seth:jsononly>
        <seth:method>GET</seth:method>

	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
