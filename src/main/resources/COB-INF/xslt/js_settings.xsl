<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<!-- js_settings.xsl:
        put config values into javascript syntax

        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->

<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:param name="left_min_slot"/>
<xsl:param name="mid_avail_slots"/>
<xsl:param name="mid_min_slot"/>
<xsl:param name="right_avail_slots"/>
<xsl:param name="right_min_slot"/>

<xsl:template match="/">
                
	var LEFT_MIN_SLOT = <xsl:value-of select="$left_min_slot"/>;
	var MID_AVAIL_SLOTS = <xsl:value-of select="$mid_avail_slots"/>;
	var MID_MIN_SLOT = <xsl:value-of select="$mid_min_slot"/>;
	var RIGHT_AVAIL_SLOTS = <xsl:value-of select="$right_avail_slots"/>;
	var RIGHT_MIN_SLOT = <xsl:value-of select="$right_min_slot"/>;

	<xsl:for-each select="panes/pane">
		<xsl:text>paneObjs[paneObjs.length] = new paneObj("</xsl:text>
		<xsl:value-of select="normalize-space(div)"/>
		<xsl:text>",</xsl:text>
		<xsl:value-of select="normalize-space(count)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="normalize-space(start)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="normalize-space(panel)"/>
		<xsl:text>);</xsl:text>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
