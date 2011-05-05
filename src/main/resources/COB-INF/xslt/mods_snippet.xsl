<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:mods="http://www.loc.gov/mods/"
 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!-- mods_snippet.xsl:
    put mods record into html
       
        (c) Copyright GNU General Public License (GPL)
        @author <a href="http://projectconifer.ca">art rhyno</a>
-->

  <xsl:template match="text()"/>

  <xsl:template match="mods:mods">
	<div class="leftspace">
	<span class="maintitle">
	<xsl:value-of select="mods:titleInfo/mods:nonSort"/>
	<xsl:value-of select="mods:titleInfo/mods:title"/>
	</span>
	<span class="subtitle">
	<xsl:value-of select="mods:titleInfo/mods:subTitle"/>
	</span>
	<div class="bibdetails">
	<xsl:value-of select="mods:name/mods:namePart"/>
	</div>
	<div class="bibdetails">
	<xsl:variable name="place">
		<xsl:value-of select="mods:originInfo/mods:place/mods:text"/>
	</xsl:variable>
	<xsl:if test="string-length($place) &gt; 0">
		<xsl:value-of select="$place"/>
	</xsl:if>
	<xsl:variable name="publisher">
		<xsl:value-of select="mods:originInfo/mods:publisher"/>
	</xsl:variable>
	<xsl:if test="string-length($publisher) &gt; 0">
		<xsl:text> : </xsl:text>
		<xsl:value-of select="$publisher"/>
	</xsl:if>
	<xsl:variable name="issued">
		<xsl:value-of select="mods:originInfo/mods:dateIssued"/>
	</xsl:variable>
	<xsl:if test="string-length($issued) &gt; 0">
		<xsl:text>, </xsl:text>
		<xsl:value-of select="$issued"/>
	</xsl:if>
	</div>
	</div>
  </xsl:template>

</xsl:stylesheet>
