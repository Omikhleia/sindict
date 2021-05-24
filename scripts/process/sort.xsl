<?xml version='1.0'?>
<!-- Copyright (c) 2007 by Didier Willis, 2021 Omikhleia
     License: MIT

     This style-sheet is used to sort the dictionary.
     IMPORTANT: Using EXSLT extension to handle the oe-ligature as oe in sorting.
-->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns:my="http://github.com/Omikhleia/sindict"
                extension-element-prefixes="func">

<xsl:import href="include-noaccent.xsl"/>

<xsl:output method="xml" encoding="utf-8" indent="no"
     doctype-system="xmldict.dtd"/>

<xsl:template name="OeReplace">
  <xsl:param name="stringIn"/>
  <xsl:choose>
  <xsl:when test="contains($stringIn,'œ' )">
    <xsl:value-of select="concat(substring-before($stringIn,'œ'), 'oe')"/>
    <xsl:call-template name="OeReplace">
    <xsl:with-param name="stringIn" select="substring-after($stringIn,'œ')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$stringIn"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<func:function name="my:ordering">
  <xsl:param name="s" select="''"/>
  <xsl:variable name="expanded"><xsl:call-template name="OeReplace">
    <xsl:with-param name="stringIn" select="$s"/>
  </xsl:call-template></xsl:variable>
  <func:result select="translate(
    $expanded,
    $accents,
    $noaccents)"/>
</func:function>

<!-- Sorting -->
<xsl:template match="div0[@type='dictionary']">
<div0 type='dictionary'>
<xsl:apply-templates select="entry">
  <xsl:sort data-type="text" select="my:ordering(  descendant::form[1]/descendant::orth[1])"/>
</xsl:apply-templates>
</div0>
</xsl:template>

<!-- Identity transformation -->
<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>