<?xml version='1.0'?>
<!--
     Copyright (c) 2001-2019 HSD, Omikhleia
     License: MIT

     This style-sheets converts phonetics in X-SAMPA to Unicode.
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sampa="http://www.jrrvf.com/hisweloke/sindar/sampa"
                extension-element-prefixes="sampa">

<xsl:template match="pron">
<xsl:choose>
<xsl:when test="function-available('sampa:unicode')">[<xsl:value-of select="sampa:unicode(.)"/>]</xsl:when>
<xsl:otherwise>[<xsl:call-template name="xslsampa"><xsl:with-param name="string" select="text()"/></xsl:call-template>]</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- FALLBACK STRATEGY:
     When we do not have the sampa:unicode() extension function, 
     use a native XSLT implementation. 
     WARNING: 
     This is not a complete X-SAMPA conversion, only a small
     subset of characters used for the Sindarin dictionary are available.
-->
<xsl:template name="xslsampa">
<xsl:param name="string"/>
<xsl:call-template name="SpecialReplace">
<xsl:with-param name="stringIn" select="translate( $string,
  'A{6QE@3IO29&amp;U}VYBCDGLJNRSTHZ?WK:=,&quot;%',
  '&#x0251;&#x00E6;&#x0250;&#x0252;&#x025B;&#x0259;&#x025C;&#x026A;&#x0254;&#x00F8;&#x0153;&#x0276;&#x028A;&#x0289;&#x028C;&#x028F;&#x03B2;&#x00E7;&#x00F0;&#x0263;&#x028E;&#x0272;&#x014B;&#x0281;&#x0283;&#x03B8;&#x0265;&#x0292;&#x0294;&#x028D;&#x026C;&#x02D0;&#x0329;&#x0321;&#x02C8;&#x02CC;'
  )"/>
</xsl:call-template>
</xsl:template>

<xsl:template name="SpecialReplace">
  <xsl:param name="stringIn"/>
  <xsl:choose>
  <xsl:when test="contains($stringIn,'r\_0' )">
    <xsl:value-of select="concat(substring-before($stringIn,'r\_0'), '&#x0279;&#x0325;')"/>
    <xsl:call-template name="SpecialReplace">
    <xsl:with-param name="stringIn" select="substring-after($stringIn,'r\_0')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$stringIn"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
