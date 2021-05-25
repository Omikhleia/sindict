<?xml version='1.0'?>
<!-- Copyright (c) 2007 by Didier Willis, 2021 Omikhleia
     License: MIT

     This style-sheet is used to add alphabetic section parts in the dictionary.
-->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="include-noaccent.xsl"/>
<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
            doctype-system="xmldict.dtd"/>

<!-- Section insertion when previous entry starts with a different letter
     than the current one (case and accent insensitive).
-->
<xsl:template match="entry">
  <xsl:variable name="prev" select="preceding-sibling::entry[1]/descendant::orth[1]"/>
  <xsl:variable name="self" select="descendant::orth[1]"/>
  <xsl:variable name="p" select="translate(substring($prev, 1, 1), $accents, $noaccents)"/>
  <xsl:variable name="s" select="translate(substring($self, 1, 1), $accents, $noaccents)"/>
  <xsl:if test="$p != $s">
    <milestone n="{translate($s, $lowercase, $uppercase)}" unit="part"/>
  </xsl:if>
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<!-- Identity transformation -->
<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>