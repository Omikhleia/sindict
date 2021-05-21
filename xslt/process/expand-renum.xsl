<?xml version='1.0'?>

<!-- Copyright (c) 2011 by Didier Willis, 2021 Omikhleia
     License: MIT

     NEEDS REVIEW
     This style sheets numbers homographs (and expand related entries = NO, MESSY, COMMENTED OUT)
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
   <!-- xsl:call-template name="relate"/-->
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
   <!-- xsl:call-template name="relate"/ -->
  </entry>
</xsl:when>
<xsl:otherwise>
  <entry>
   <xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
   <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
   <xsl:if test="@rend"><xsl:attribute name="rend"><xsl:value-of select="@rend"/></xsl:attribute></xsl:if>
   <!-- xsl:call-template name="relate"/-->
   <xsl:apply-templates/> 
  </entry>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- <xsl:template match="re" --><!-- IGNORE PREVIOUS RELATIONS --><!-- /xsl:template> -->

<xsl:template match="@* | node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

<xsl:key name="re" match="xr[@type = 'of']/ptr" use="@target"/>

<xsl:template name="relate">
<xsl:variable name="related" select="key( 're', string(@id) )"/>
  <xsl:for-each select="$related">
  <xsl:variable name="refentry" select="ancestor::entry"/>
  <re>
  <xsl:choose>
  <xsl:when test="$refentry/descendant::form[1]/form[1][orth]">
   <xsl:for-each select="$refentry/descendant::form[1]/form[1]">
   <xsl:copy xml:space="preserve">
     <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="orth|usg|itype"/>
   </xsl:copy>
   </xsl:for-each>
   <xsl:copy-of select="$refentry/descendant::gramGrp[1]" />
  </xsl:when>
  <xsl:when test="$refentry/descendant::form[1][orth]">
   <xsl:for-each select="$refentry/descendant::form[1]">
   <xsl:copy xml:space="preserve">
     <xsl:apply-templates select="@*"/>
     <xsl:apply-templates select="orth|usg|itype"/>
   </xsl:copy>
   </xsl:for-each>
   <xsl:copy-of select="$refentry/descendant::gramGrp[1]" />
  </xsl:when>
  <xsl:otherwise>{UNRESOLVED RE}
    <xsl:message>Unresolved related entry <xsl:value-of select="$refentry/@id"/></xsl:message>
  </xsl:otherwise>
  </xsl:choose>
  </re>   
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>