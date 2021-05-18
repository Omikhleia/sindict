<?xml version='1.0'?>
<!--
     Copyright (c) 2021 Omikhleia
     License: MIT
     
     One-shot identity conversion, with output in UTF-8
     (So it will actually convert to UTF-8 if this wasn't the case)
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
</xsl:stylesheet>