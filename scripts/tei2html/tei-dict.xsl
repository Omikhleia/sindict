<?xml version='1.0'?>
<!--
     Copyright (c) 2001-2011, HSD. 2019, 2021, Omikhleia.
     License: MIT
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- STYLE SHEET FOR TEI P4 DICTIONARY ENTRIES -->

<xsl:template match="div0[@type='dictionary']">
<div class="dictionary">
<xsl:choose>
  <!-- GENERATE A SINGLE ENTRY -->
  <xsl:when test="$search">
    <xsl:choose>
      <xsl:when test="//entry[@id=$search]">
        <xsl:apply-templates select="//entry[@id=$search]"/>
      </xsl:when>
      <xsl:otherwise>
        <p class="text">[Not found.]</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
 <!-- GENERATE ALL ENTRIES -->
<xsl:otherwise>
<xsl:apply-templates/>
</xsl:otherwise>
</xsl:choose>
</div>
</xsl:template>

<xsl:template match="milestone">
<p class="milestone {@unit}"><xsl:value-of select="@n"/></p>
</xsl:template>

<xsl:template match="entry">
<xsl:choose>
<xsl:when test="not(@type) or (@type != 'xref')">
    <p id="{@id}" class="sindict"><xsl:apply-templates/>
    </p><xsl:text>
</xsl:text>
</xsl:when>
<xsl:otherwise>
    <p id="{@id}" class="sindict xref{@rend}"><xsl:apply-templates/>
    </p><xsl:text>
</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="sense">
  <xsl:text> </xsl:text>
  <xsl:choose>
   <xsl:when test="following-sibling::sense and not(preceding-sibling::sense)"><b>1.</b> </xsl:when>
   <xsl:when test="preceding-sibling::sense">&#x25CB; <b><xsl:value-of select="count(preceding-sibling::sense) + 1"/>.</b> </xsl:when>
  </xsl:choose><xsl:apply-templates/>
</xsl:template>

<xsl:template match="def"><xsl:apply-templates/></xsl:template>

<xsl:template match="trans">
<xsl:if test="contains($translations,@lang)">
   <xsl:if test="preceding-sibling::trans"><xsl:text>&#x2014; </xsl:text></xsl:if>
   <span class="trans-lang"><xsl:value-of select="@lang"/></span><xsl:apply-templates/>
</xsl:if>
</xsl:template>

<xsl:template match="index">
<!-- NoOp -->
</xsl:template>

<xsl:template match="pos|tns|mood|per|gen|number|subc|itype|lbl">
<small><i><xsl:call-template name="translate-abbr">
      <xsl:with-param name="abbr" select="text()"/>
    </xsl:call-template></i></small>
</xsl:template>

<!-- <xsl:template match="gloss">
</xsl:template> -->

<xsl:template match="gramGrp">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="form">
<xsl:choose>
 <xsl:when test="not(form)">
  <!-- Handle punctuations arround variant forms -->
  <xsl:choose>
    <xsl:when test="preceding-sibling::form[2]">,</xsl:when>
    <xsl:when test="preceding-sibling::form[1]">(</xsl:when>
  </xsl:choose>
  <xsl:apply-templates/>
  <xsl:if test="not(following-sibling::form) and preceding-sibling::form[1]">)</xsl:if>
 </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates/>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="format-orth">
<xsl:choose>
  <xsl:when test="contains(parent::form/@type,'deduced')">#<b><xsl:apply-templates/></b></xsl:when>
  <xsl:when test="contains(parent::form/@type,'normalized')">^<b><xsl:apply-templates/></b></xsl:when>
  <xsl:when test="contains(parent::form/@type,'deleted')">&#xD7;<b><del><xsl:apply-templates/></del></b></xsl:when>
  <xsl:when test="contains(parent::form/@type,'coined')">&#x2021;<b><xsl:apply-templates/></b></xsl:when>
  <xsl:otherwise><b><xsl:apply-templates/></b></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="orth" mode="ref">
  <xsl:call-template name="format-orth"/>
</xsl:template>

<xsl:template match="orth">
<xsl:variable name="islemma" select="not(parent::form/preceding-sibling::form[1] or parent::form/parent::form/preceding-sibling::form[1])"/>
<xsl:variable name="isheadword" select="not(ancestor::re) and $islemma"/>
<xsl:variable name="class">
  <xsl:choose>
    <xsl:when test="$isheadword">entry</xsl:when>
    <xsl:otherwise>form</xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<!-- Initial letter in full, encoded with @norm -->
<!-- EXPERIMENTAL xsl:if test="@norm"><sup>(<xsl:value-of select="@norm"/>)</sup></xsl:if> -->
<!-- Trick for style handling:
     Main entries will therefore be labeled with 'entry'
     and secondary entries as 'form'. This will allow to set different
     properties for main headwords (line breaking, etc.) and secondary
     entries such as variants, references, etc.
  -->
<span class="{$class}">
  <xsl:call-template name="format-orth"/>
</span>
<!-- Numbering -->
<xsl:choose>
  <xsl:when test="$isheadword and ancestor::entry/@n"><xsl:text> </xsl:text>
     <span class="number"><xsl:number format="I" value="ancestor::entry/@n"/></span>
  </xsl:when>
  <!-- Numbering for related entries. NOT SURE WE USE IT -->
  <xsl:when test="ancestor::re/@n and $islemma"><xsl:text> </xsl:text>
     <span class="number"><xsl:number format="I" value="ancestor::re/@n"/></span>
  </xsl:when>
</xsl:choose>
<!-- Misreadings and corrections -->
<xsl:if test="corr/@sic">
<xsl:text> </xsl:text>(<small><i>corr.</i><xsl:text> </xsl:text></small><span class="corr"><xsl:value-of select="corr/@sic"/></span>)
</xsl:if>
</xsl:template>

<xsl:template match="usg[@type = 'lang']">
<!--- <xsl:apply-templates/> -->
<xsl:text> </xsl:text>
<small><i><xsl:value-of select="@norm" /></i></small>
<xsl:text> </xsl:text>
</xsl:template>

<!-- WARNING: The following rules for the <usg> tag are not general
     and only handles some of the TEI structures as used in the
     Sindarin dictionary (i.e. <usg type='gram'>as a noun</usg> some text).
  -->
<xsl:template match="usg[@type = 'gram']">
<small><i><xsl:call-template name="translate-abbr">
      <xsl:with-param name="abbr" select="text()"/>
    </xsl:call-template>,</i></small><xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="usg[@type = 'dom']|usg[@type = 'reg']">
<small><i><xsl:call-template name="translate-abbr">
      <xsl:with-param name="abbr" select="text()"/>
    </xsl:call-template></i></small>
</xsl:template>

<xsl:template match="usg[@type = 'ext']">
<small><i><xsl:call-template name="translate-abbr">
      <xsl:with-param name="abbr" select="text()"/>
    </xsl:call-template>,</i></small><xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="usg[@type = 'cat']"></xsl:template>
<!--
<xsl:template match="usg[@type = 'cat']"><small><sup><font color="darkgray"><xsl:value-of select='@norm'/></font></sup></small>
</xsl:template>
-->

<xsl:template match="bibl">
  <span class="bibl"><xsl:apply-templates/></span>
  <!-- xsl:if test="following-sibling::bibl">, </xsl:if -->
</xsl:template>

<xsl:template match="usg[@type='hint']">(<i><xsl:apply-templates/></i>)</xsl:template>

<xsl:template match="note">
  <xsl:choose>
    <xsl:when test="@type ='source'">
      &#x25C7; <span class="bibl-legacy"><xsl:apply-templates/></span></xsl:when>
    <xsl:when test="@type ='source,deduced'">
      &#x2190; <span class="bibl-mention"><xsl:apply-templates/></span></xsl:when>
    <xsl:when test="@type ='comment'">
      <xsl:if test="contains($translations,@lang)">
      &#x25C8; <span class="comment"><xsl:apply-templates/></span></xsl:if></xsl:when>
    <xsl:when test="@type ='info'">
      <!-- Used in Ladon's Breath -->
      <p class="comment"><xsl:apply-templates/></p></xsl:when>
    <xsl:otherwise>
     <!-- Used in the TEI header -->
      <p><xsl:apply-templates/></p></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="etym">
  &#x25C7; <small><xsl:apply-templates/></small>
</xsl:template>

<xsl:template match="mentioned"><i><xsl:apply-templates/></i> </xsl:template>
<xsl:template match="hi"><i><xsl:apply-templates/></i></xsl:template>

<xsl:template match="xr[@type = 'analogy']">
  &#x21D2; <small><xsl:apply-templates/></small>
</xsl:template>

<xsl:template match="xr">
  <xsl:choose>
    <xsl:when test="@type = 'see'">&#x2192; </xsl:when>
    <xsl:when test="@type = 'of'"><small><i><xsl:call-template name="translate-abbr">
      <xsl:with-param name="abbr" select="@type"/>
    </xsl:call-template></i></small><xsl:text> </xsl:text></xsl:when>
  </xsl:choose>
<xsl:apply-templates/><xsl:if test="following-sibling::sense">, </xsl:if><xsl:if test="following-sibling::trans">, </xsl:if>
</xsl:template>

<xsl:key name="entry" match="//entry" use="@id" />
<xsl:template match="ptr">
 <xsl:variable name="refEntry" select="key('entry',string(@target))"/>
 <xsl:choose>
 <xsl:when test="$refEntry/descendant::form[1]/descendant::orth[1]">
  <xsl:apply-templates select="$refEntry/descendant::form[1]/descendant::orth[1]" mode="ref"/>
  <xsl:if test="$refEntry[@n]">
  <xsl:text> </xsl:text><span class="number"><xsl:number format="I" value="$refEntry/@n"/></span>
  </xsl:if>
 </xsl:when>
 <xsl:when test="$refEntry">
  <!-- Ooops, we failed find an orth form for expanding the pointer reference -->
  <xsl:message>WARNING: Unexpected exception handling reference <xsl:value-of select="@target"/></xsl:message>
  <b style="color:red">{UNRESOLVED PTR}</b>
 </xsl:when>
 <xsl:otherwise>
  <!-- Ooops, unresolved pointer -->
  <xsl:message>WARNING: Unresolved reference <xsl:value-of select="@target"/></xsl:message>
  <b style="color:red">{UNRESOLVED PTR}</b>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="ref">
<xsl:choose>
 <xsl:when test='@n'>
  <b><xsl:apply-templates/></b><xsl:text> </xsl:text><span class="number"><xsl:number format="I" value="@n"/></span>
 </xsl:when>
 <xsl:otherwise>
  <b><xsl:apply-templates/></b>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 25AD -->
<xsl:template match="re">&#x25C8; <xsl:apply-templates/></xsl:template>

<!-- Support for multilingual dictionaries -->
<xsl:variable name="abbreviations"
              select="document('abbr-def.xml')/abbr/list[@lang=$language]/item"/>

<xsl:template name="translate-abbr">
  <xsl:param name="abbr"/>
  <xsl:choose>
  <xsl:when test="$abbreviations[@id=$abbr]">
  <xsl:value-of select="$abbreviations[@id=$abbr]"/>
  </xsl:when>
  <xsl:otherwise>
  <xsl:if test="$language != 'en'">
    <xsl:message>WARNING: undefined abbreviation <xsl:value-of select="$abbr"/></xsl:message>
  </xsl:if>
  <xsl:value-of select="$abbr"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>