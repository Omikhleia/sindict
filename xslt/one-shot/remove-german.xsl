<?xml version='1.0'?>
<!--
     Copyright (c) 2021 Omikhleia
     License: MIT
     
     One-shot removal of german.
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

  <!-- Remove german translations, and kill the empty lines it leaves -->
  <xsl:template match="trans[@lang='de']"/>
  <xsl:template match="text()[following-sibling::node()[1][self::trans[@lang='de']]]" />
  <!-- Remove german notes, and kill the empty lines it leaves -->
  <xsl:template match="note[@lang='de']"/>
  <xsl:template match="text()[following-sibling::node()[1][self::note[@lang='de']]]" />
</xsl:stylesheet>