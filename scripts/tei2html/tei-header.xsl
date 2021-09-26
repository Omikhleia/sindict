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
<div>
  <span id="forkongithub"><a href="https://github.com/Omikhleia/sindict" target="_blank">Fork me on GitHub</a><br/></span>
  <input type="checkbox" id="switch" />
  <label for="switch"></label>
  <span class="show-hide"><b><i><xsl:value-of select="//titleStmt/title"/></i></b> -
    <xsl:value-of select="//editionStmt/edition/text()"/></span>
  <div class="hide-show" >
    <xsl:apply-templates/>
  </div>
</div>
</xsl:if>
</xsl:template>

<xsl:template match="fileDesc">
    <xsl:apply-templates/>
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

<!-- Keys for clever Muenchian form counting, see below -->
<xsl:key name="orths" match="//orth" use="." />
<xsl:key name="orthDeduced" match="//orth[parent::form/@type = 'deduced']" use="." />
<xsl:key name="orthNormlzd" match="//orth[parent::form/@type = 'normalized']" use="." />

<xsl:template match="edition">
  <p>Edition <xsl:value-of select="@n"/></p>
  <p><xsl:apply-templates/></p>

  <!-- Better counters
    headwords = entry count, including cross-references to alternative forms (variants, etc.)   
    main headwords = same but without the cross-references
    word forms = orth count, so all reference words incl. variants, etc.
  -->
  <!-- Didier fix: show prevalence of deduced and normalized forms in headwords, as some users were
       once concerned with it... -->
  <p><xsl:value-of select="count(//entry)"/> headwords
    (<xsl:value-of select="count(//entry[descendant::form[1]/@type = 'deduced' or descendant::form[1]/form[1]/@type = 'deduced'])"/> deduced,
    <xsl:value-of select="count(//entry[descendant::form[1]/@type = 'normalized' or descendant::form[1]/form[1]/@type = 'normalized'])"/> normalized).</p>
  <!-- Omikhleia fix: same but withount counting the cross references -->
  <!-- REMOVED, seems too fragile -->
  <!-- <p><xsl:value-of select="count(//entry[@type != 'xref'])"/> main headwords
     (<xsl:value-of select="count(//entry[@type != 'xref'][descendant::form[1]/@type = 'deduced' or descendant::form[1]/form[1]/@type = 'deduced'])"/> deduced,
    <xsl:value-of select="count(//entry[@type != 'xref'][descendant::form[1]/@type = 'normalized' or descendant::form[1]/form[1]/@type = 'normalized'])"/> normalized).</p> -->
  <!-- Omikhleia fix: Earlier word form counters where somehow broken (not counting re tags, failing to properly count
       alternatives at the top form level...)
       Fixed by using a Muenchian method (http://www.jenitennison.com/xslt/grouping/muenchian.html)
       and operating on orth nodes directly
       For the record, the unique form count doesn't distinguish the type (deduced, normalized)
  -->
  <p><xsl:value-of select="count(//orth)"/> word forms
     (<xsl:value-of select="count(//orth[generate-id(.) = generate-id(key('orths', .)[1])])"/> unique,
      <xsl:value-of select="count(//orth[generate-id(.) = generate-id(key('orthDeduced', .)[1])])"/> deduced,
      <xsl:value-of select="count(//orth[generate-id(.) = generate-id(key('orthNormlzd', .)[1])])"/> normalized).</p>
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