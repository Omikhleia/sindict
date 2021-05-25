<?xml version='1.0'?>

<!-- Copyright (c) 2011 by Didier Willis, 2021 Omikhleia
     License: MIT

     This style sheets numbers homographs
     (asssuming an already sorted dictionary)     
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
            doctype-system="xmldict.dtd"/>

<xsl:template match="TEI.2">
<TEI.2>
<xsl:apply-templates/>
</TEI.2>
</xsl:template>

<xsl:template match="entry">
<xsl:variable name="self" select="descendant::form[1]/descendant::orth[1]"/>
<xsl:variable name="prec" select="count( preceding-sibling::entry[position() &lt; 5][descendant::form[1]/descendant::orth[1] = $self])"/> 
<xsl:variable name="next" select="following-sibling::entry[1][descendant::form[1]/descendant::orth[1] = $self]"/>
<xsl:choose>
<xsl:when test="$prec != 0">
  <!-- <xsl:message>Numbering entry <xsl:value-of select="$self"/> (<xsl:value-of select="@id"/>) = <xsl:value-of select="$prec + 1"/></xsl:message> -->
  <entry>
   <xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
   <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
   <xsl:if test="@rend"><xsl:attribute name="rend"><xsl:value-of select="@rend"/></xsl:attribute></xsl:if>
   <xsl:attribute name="n"><xsl:value-of select="$prec + 1"/></xsl:attribute>
   <xsl:apply-templates/>
  </entry>
</xsl:when>
<xsl:when test="$next">
  <!-- <xsl:message>Numbering entry <xsl:value-of select="$self"/> (<xsl:value-of select="@id"/>) = 1</xsl:message> -->
  <entry>
   <xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
   <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
   <xsl:if test="@rend"><xsl:attribute name="rend"><xsl:value-of select="@rend"/></xsl:attribute></xsl:if>
   <xsl:attribute name="n"><xsl:value-of select="$prec + 1"/></xsl:attribute>
   <xsl:apply-templates/>
  </entry>
</xsl:when>
<xsl:otherwise>
  <entry>
   <xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
   <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
   <xsl:if test="@rend"><xsl:attribute name="rend"><xsl:value-of select="@rend"/></xsl:attribute></xsl:if>
   <xsl:apply-templates/> 
  </entry>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="@* | node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>