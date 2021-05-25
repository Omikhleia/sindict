<?xml version='1.0'?>
<!-- Copyright (c) 2007,2011 by Didier Willis, 2021 Omikhleia
     License: MIT

     NEED REVIEW
     This style-sheet is used to expand the cross-references
     in the dictionary (step 2 = related entries)
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
            encoding="utf-8"
            indent="no"
            doctype-system="xmldict.dtd"/>

<!-- Identity transformation -->
<xsl:template match="@* | node()">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
</xsl:template>

<!-- Cross-reference (xref) expansion -->
<xsl:template match="div0[@type='dictionary']">
  <div0 type="dictionary">
<!-- An xref entry is created when the following conditions are satisfied:

     The form does not contain other form
     (= its not a nesting structure)
     AND
       The form is below a related entry without correspondance
       (= There is no main entry corresponding to this form)
-->
    <xsl:for-each select="descendant::form[not(form) and ancestor::re and not(ancestor::re/@corresp)]">
      <entry id="generated-{generate-id()}-{ancestor::entry/@id}" type="xref" rend="re">
         <form>
          <xsl:apply-templates select="orth|@*"/>
          <xsl:text> </xsl:text><xsl:apply-templates select="bibl"/>
          <xsl:apply-templates select="usg[@type != 'reg']"/>
          <xsl:apply-templates select="usg[@type = 'reg']"/>
         </form>
         <xsl:choose>
         <xsl:when test="preceding-sibling::number">
           <gramGrp>
            <number><xsl:value-of select="preceding-sibling::number"/></number>
           </gramGrp>
         </xsl:when>
         <xsl:when test="preceding-sibling::tns">
           <gramGrp>
            <tns><xsl:value-of select="preceding-sibling::tns"/></tns>
           </gramGrp>
         </xsl:when>
         <xsl:when test="preceding-sibling::mood">
           <gramGrp>
            <mood><xsl:value-of select="preceding-sibling::mood"/></mood>
           </gramGrp>
         </xsl:when>
         <xsl:when test="itype">
           <xsl:copy-of select="itype"/>
         </xsl:when>
         <xsl:when test="following-sibling::gramGrp">
           <xsl:copy-of select="following-sibling::gramGrp"/>
         </xsl:when>
         </xsl:choose>
         <xsl:text> </xsl:text><xr type="see"><ptr target="{ancestor::entry/@id}"/></xr>
       </entry>
    </xsl:for-each>
    <xsl:apply-templates/>
  </div0>
</xsl:template>

</xsl:stylesheet>