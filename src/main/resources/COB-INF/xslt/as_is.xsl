<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
<!-- as_is.xsl:
    pass through everything to get around SAX latency issues
        
    (c) Copyright GNU General Public License (GPL)
    @author <a href="http://projectconifer.ca">art rhyno</a>
-->
    <xsl:output method="xml"/>
    <xsl:namespace-alias stylesheet-prefix="xhtml" result-prefix="xsl"/>
    <xsl:template match="/">
        <xsl:copy-of select="./*"/>
    </xsl:template>
</xsl:stylesheet>
