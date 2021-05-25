<?xml version='1.0'?>
<!--
     Copyright (c) 2021 HSD, Omikhleia
     License: MIT

     Builds a simplified JSON from the Eldamo XML source, extracting sindarin and noldorin entries.
     WARNING: Very rough quick'n'dirty stuff. Could be improved.

     How to use:
     xsltproc.exe eldamo-scrapper.xsl eldamo-data-0.x.y.xml > docs/data/eldamo-scrap.json
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
    method="text"
    encoding="utf-8" indent="no"/>

<xsl:template match="word-data">[
<xsl:apply-templates select="//word[(@l='s' or @l = 'n' or @l = 'ns')
    and @speech != 'text'
    and @speech != 'grammar'
    and @speech != 'phonetics'
    and @speech != 'phoneme'
    and @speech != 'phonetic-group'
    and @speech != 'phonetic-rule'
    and @speech != 'phrase'
    and @speech != 'root'
]"/>
]
<!-- 
  value comes from list: { '?' | 'adj' | 'adv' | 'affix' | 'article' | 'cardinal' | 'conj' | 'collective-name' | 'collective-noun' | 'family-name' | 'fem-name' | 'fraction' | 'grammar' | 'infix' | 'interj' | 'masc-name' | 'n' | 'ordinal' | 'particle' | 'phoneme' | 'phonetics' | 'phonetic-group' | 'phonetic-rule' | 'phrase' | 'place-name' | 'pref' | 'prep' | 'pron' | 'proper-name' | 'radical' | 'root' | 'text' | 'suf' | 'vb' } -->
</xsl:template>

<xsl:template match="word"> {
  "word": "<xsl:value-of select="@v"/>",
  "mark": "<xsl:value-of select="@mark"/>",
  "lang": "<xsl:value-of select="@l"/>",
  "gloss": "<xsl:value-of select="@gloss"/>",
  "speech": "<xsl:value-of select="@speech"/>",
  "page-id": "<xsl:value-of select="@page-id"/>",
  "ref": [
    <xsl:apply-templates select="ref"/>
    ]
 }<xsl:if test="position() != last()">
<xsl:text>,
</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="ref">{
      "word": "<xsl:value-of select="@v"/>",
      "source": "<xsl:value-of select="substring-before(@source,'.')"/>"
    }<xsl:if test="position() != last()">
<xsl:text>,
    </xsl:text>
</xsl:if>
</xsl:template>

</xsl:stylesheet>