<?xml version='1.0'?>
<!-- Copyright (c) 2021 Omikhleia
     License: MIT

     Used to generate a markdown output from 'scripts/tei2html/abbr-def.xml'
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"
            encoding="utf-8"/>

<xsl:template match="abbr">
<xsl:text># Symbols and abbreviations

|  Symbol       | Definition  |
| ------------- | ----------- |
</xsl:text>
<xsl:for-each select="defs/mark">| _<xsl:value-of select="@id"/>_ | <xsl:value-of select="text()"/> |
</xsl:for-each>
<xsl:text>
|  Abbreviation | Definition  |
| ------------- | ----------- |
</xsl:text>
<xsl:for-each select="defs/def">
<xsl:sort select="@id"/>| _<xsl:value-of select="@id"/>_ | <xsl:value-of select="text()"/> |
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>