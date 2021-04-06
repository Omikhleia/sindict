<?xml version='1.0'?>
<!--
     Copyright (c) 2001-2019 HSD, Omikhleia
     License: MIT
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- STYLE SHEET FOR THE TEI HEADER -->

<xsl:template match="teiHeader">
<xsl:if test="$header = 'yes'">
<div id="teiHeader">
<small>
  <xsl:apply-templates/>
  <br/>
</small>
</div>
</xsl:if>
</xsl:template>

<xsl:template match="fileDesc">
  <!-- fieldset class="framed">
    <legend>Description</legend -->
    <xsl:apply-templates/>
  <!-- /fieldset -->
</xsl:template>

<xsl:template match="titleStmt">
  <fieldset class="boxed">
    <legend>Title</legend>
    <xsl:apply-templates/>
  </fieldset>
</xsl:template>

<xsl:template match="editor">
  <fieldset class="boxed">
    <legend>Title</legend>
    <p><b>Editor:</b> <xsl:apply-templates/>.</p>
  </fieldset>
</xsl:template>

<xsl:template match="author">
  <fieldset class="boxed">
    <legend>Title</legend>
    <p><b>Author:</b> <xsl:apply-templates/>.</p>
  </fieldset>
</xsl:template>

<xsl:template match="title">
  <p><b><em><xsl:apply-templates/></em></b></p>
</xsl:template>

<xsl:template match="respStmt">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="resp">
  <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="publicationStmt">
  <fieldset class="boxed">
    <legend>Publication</legend>
    <p><xsl:value-of select="date"/>, <xsl:value-of select="publisher"/></p>
  </fieldset>    
  <xsl:apply-templates select="availability"/>
</xsl:template>

<xsl:template match="availability">
  <fieldset class="boxed">
    <legend>Availability</legend>
    <p><b>Status: </b><xsl:value-of select="@status"/>.</p>
    <xsl:apply-templates/>
  </fieldset>
</xsl:template>

<xsl:template match="editionStmt">
  <fieldset class="boxed">
    <legend>Edition</legend>
    <xsl:apply-templates/>
  </fieldset>
</xsl:template>

<xsl:template match="edition">
  <p>Edition <xsl:value-of select="@n"/></p>
  <p><xsl:apply-templates/></p>
  <xsl:choose>
  <xsl:when test="$xref != 'no'">
    <xsl:choose>
    <xsl:when test="count(//entry[@type='xref']) = 0">
      <p><xsl:value-of select="count(//entry)"/> entries.</p>
    </xsl:when>
    <xsl:otherwise>
      <p><xsl:value-of select="count(//entry)"/> entries 
         (<xsl:value-of select="count(//entry) - count(//entry[@type='xref'])"/> unique entries).</p>
    </xsl:otherwise>     
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <p><xsl:value-of select="count(//entry) - count(//entry[@type='xref'])"/> entries.</p>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="count(//entry) != count(//orth[not(ancestor::re) and (ancestor::entry[not(@type)] or ancestor::entry[@type != 'xref'])])">
      <!-- This does not work well with reversed lexicons (indices), so we only add it if applicable -->
      <p>~ <xsl:value-of select="count(//form[not(form)][not(ancestor::re) and (ancestor::entry[not(@type)] or ancestor::entry[@type != 'xref'])])"/> word forms
         (<xsl:value-of select="count(//form[not(ancestor::re) and (ancestor::entry[not(@type)] or ancestor::entry[@type != 'xref']) and contains( @type, 'deduced' )])"/> deduced,
         <xsl:value-of select="count(//form[not(ancestor::re) and (ancestor::entry[not(@type)] or ancestor::entry[@type != 'xref']) and contains( @type, 'normalized' )])"/> normalized,
         <xsl:value-of select="count(//form[not(ancestor::re) and (ancestor::entry[not(@type)] or ancestor::entry[@type != 'xref']) and contains( @type, 'coined' )])"/> coined).
         </p>
  </xsl:if>
</xsl:template>

<xsl:template match="sourceDesc">
  <fieldset class="boxed">
    <legend>Source</legend>
    <xsl:apply-templates/>
  </fieldset>
</xsl:template>

<xsl:template match="notesStmt">
  <fieldset class="boxed">
    <legend>Notes</legend>
    <xsl:for-each select="note">
      <p><xsl:apply-templates/></p>
    </xsl:for-each>
  </fieldset>
</xsl:template>

<xsl:template match="name">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="encodingDesc">
<!-- IGNORE -->
</xsl:template>

<xsl:template match="p">
  <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="profileDesc">
<!-- IGNORE -->
</xsl:template>

</xsl:stylesheet>