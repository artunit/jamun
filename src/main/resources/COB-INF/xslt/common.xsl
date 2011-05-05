<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!-- common.xsl:
    some common functions

    (c) Copyright GNU General Public License (GPL)
    @author <a href="http://projectconifer.ca">art rhyno</a>
-->

<xsl:template name="pane_numbers">
	<xsl:param name="i" />
	<xsl:param name="count" />
	<xsl:param name="source" />
	<xsl:param name="rows" />
	<xsl:param name="hits" />
	<xsl:param name="query" />
	<xsl:param name="DEFAULT" />
    
	<xsl:if test="$i &lt;= $count">
		<xsl:choose>
			<xsl:when test="number($i) = number($DEFAULT)">
				<div class="gsc-cursor-page gsc-cursor-current-page">
					<xsl:value-of select="$i"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="gsc-cursor-page">
					<a style="text-decoration:none">
					<xsl:attribute name="onClick">
						<xsl:text>changePane('</xsl:text>
						<xsl:value-of select="$source"/>
						<xsl:text>',</xsl:text>
						<xsl:value-of select="$rows"/>
						<xsl:text>,</xsl:text>
						<!-- solr starts 0 -->
						<xsl:choose>
						<xsl:when test="contains($source,'gbook')">
						<xsl:value-of select="(($i - 1) * $rows) + 1"/>
						</xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="($i - 1) * $rows"/>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:text>,</xsl:text>
						<xsl:value-of select="$hits"/>
						<xsl:text>,'</xsl:text>
						<xsl:value-of select="$query"/>
						<xsl:text>')</xsl:text>
					</xsl:attribute> 
					<xsl:value-of select="$i"/>
					</a>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="$i &lt;= $count">
		<xsl:call-template name="pane_numbers">
			<xsl:with-param name="i" select="$i + 1"/>
			<xsl:with-param name="count" select="$count"/> 
			<xsl:with-param name="source" select="$source"/>
			<xsl:with-param name="rows" select="$rows"/>
			<xsl:with-param name="hits" select="$hits"/>
			<xsl:with-param name="query" select="$query"/>
			<xsl:with-param name="DEFAULT" select="$DEFAULT"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="replaceCharsInString">
	<xsl:param name="stringIn"/>
	<xsl:param name="charsIn"/>
	<xsl:param name="charsOut"/>

	<xsl:choose>
		<xsl:when test="contains($stringIn,$charsIn)">
			<xsl:value-of select="concat(substring-before
				($stringIn,$charsIn),
			$charsOut)"/>
			<xsl:call-template name="replaceCharsInString">
				<xsl:with-param name="stringIn" select="substring-after(
					$stringIn,$charsIn)"/>
				<xsl:with-param name="charsIn" select="$charsIn"/>
				<xsl:with-param name="charsOut" select="$charsOut"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$stringIn"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
