<?xml version='1.0'?>
<!--
     Copyright (c) 2021 Omikhleia
     License: MIT
     
     One-shot attribute conversion, with output in UTF-8
     In old lexicon, entry id and ref. target attributes used y-umlaut for y-circumflex
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" 
    indent="no"
    encoding="utf-8"
    doctype-system="xmldict.dtd"
  />
  <xsl:preserve-space elements="*"/>

  <!-- Identity transformation -->
  <xsl:template match="@* | node()">
      <xsl:copy>
          <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
  </xsl:template>
  
  <!-- Rewrite id and target attributes -->
  <xsl:template match="@id">
    <xsl:attribute name="id">
       <xsl:value-of select="translate(., 'ÿ', 'ŷ')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="@target">
    <xsl:attribute name="target">
       <xsl:value-of select="translate(., 'ÿ', 'ŷ')"/>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>