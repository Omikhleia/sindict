<?xml version='1.0'?>
<!--
     Copyright (c) 2021 Omikhleia
     License: MIT

     One-shot removal of generated tags.
     The recovered lexicon was from a processed build and had xref entries and milestones
     from an automated generation. These should be automatically constructed, and not
     present in the core source XML.
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

  <!-- Remove xref entries (cross-references), and kill the empty lines it leaves -->
  <xsl:template match="entry[@type='xref']"/>
  <xsl:template match="text()[following-sibling::node()[1][self::entry[@type='xref']]]" />
  <!-- Remove section part (alphabetic milestones), and kill the empty lines it leaves -->
  <xsl:template match="milestone"/>
  <xsl:template match="text()[following-sibling::node()[1][self::milestone]]" />
</xsl:stylesheet>
