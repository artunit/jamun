<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- spbook.xsl: 	
	set up HTTP interaction to get around encoding problems
	with solr response from scholars portal books API
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:include href="common.xsl" />

<xsl:param name="sphost"/>
<xsl:param name="rows"/>
<xsl:param name="start"/>
<xsl:param name="hits"/>
<xsl:param name="query"/>
<xsl:param name="spfields"/>
<xsl:param name="spoptions"/>

<xsl:template match="text()"/>

<xsl:template match="/">
	<seth:execute-retrieval>
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>
        <seth:method>GET</seth:method>

        <seth:url>
		<xsl:value-of select="$sphost"/>
		<xsl:text>/SolrRequest</xsl:text>
	</seth:url>
        <seth:nvp name="raw">true</seth:nvp>
        <seth:nvp name="facet">false</seth:nvp>
        <seth:nvp name="hl">true</seth:nvp>
        <seth:nvp name="hl.snippets">1</seth:nvp>
        <seth:nvp name="hl.fragsize">100</seth:nvp>
        <seth:nvp name="hl.simple.pre"><![CDATA[<strong><em>]]></seth:nvp>
        <seth:nvp name="hl.simple.post"><![CDATA[</em></strong>]]></seth:nvp>
        <seth:nvp name="hl.fl">Title,Abstract</seth:nvp>

	<!-- dynamic options -->
        <seth:nvp name="fl"><xsl:value-of select="$spfields"/></seth:nvp>
        <seth:nvp name="start"><xsl:value-of select="$start"/></seth:nvp>
        <seth:nvp name="rows"><xsl:value-of select="$rows"/></seth:nvp>

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
        <seth:xmlonly>TRUE</seth:xmlonly>

	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
