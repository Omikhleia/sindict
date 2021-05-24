<?xml version='1.0'?>
<!-- Copyright (c) 2021 Omikhleia
     License: MIT

     This style-sheet is used to refactor re entries (one-shot process)
-->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
            doctype-system="xmldict.dtd"/>

<!-- Main headwords table -->
<xsl:key name="entryOrths" match="//entry" use="descendant::orth[1]" />

<!-- Add @corresp to re entries that have a main entry (per matching orth)
     NOTE: This may lead to false positives for homographs, so one has to manually check afterwards:
-->
<xsl:template match="re">
  <xsl:variable name="entry" select="key('entryOrths', descendant::orth[1])"/>
  <xsl:choose>
    <xsl:when test="$entry">
      <xsl:message>Corresp: <xsl:value-of select="descendant::orth[1]"/> from <xsl:value-of select="parent::entry/@id"/>
        to <xsl:value-of select="$entry/@id"/>
      </xsl:message>
      <xsl:copy>
        <xsl:attribute name="corresp"><xsl:value-of select="$entry/@id"/></xsl:attribute>
        <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Identity transformation -->
<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>