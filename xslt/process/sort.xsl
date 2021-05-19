<?xml version='1.0'?>
<!-- Copyright (c) 2007 by Didier Willis, 2021 Omikhleia
     License: MIT

     This style-sheet is used to sort the dictionary.
-->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="include-noaccent.xsl"/>

<xsl:output method="xml" encoding="utf-8" indent="yes"
     doctype-system="xmldict.dtd"/>

<!-- Sorting -->
<xsl:template match="div0[@type='dictionary']">
<div0 type='dictionary'>
<xsl:apply-templates select="entry">
   <xsl:sort data-type="text" select="translate( 
        descendant::form[1]/descendant::orth[1],
        $accents, 
        $noaccents )"/>
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