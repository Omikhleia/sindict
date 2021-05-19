<?xml version='1.0'?>
<!-- Copyright (c) 2007,2011 by Didier Willis, 2021 Omikhleia
     License: MIT

     NEED REVIEW
     This style-sheet is used to expand the cross-references
     in the dictionary.
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

     The form does not contain other forms + AND IS NOT BELOW A RE (RELATED ENTRY). TODO, COMPLEX EXPANSION HERE*
     (= its not a nesting structure)
     AND
       The form has preceding siblings
       (= its not the first form in that nesting structure)
       OR
       The parent form has preceding siblings 
       (= its not the first nesting structure)
       OR
       The form itself as a type='inflected' attribute (= loose nesting)
       
       *AS RE FORMS SOMETIMES HAVE DIRECT ENTRIES...
-->
    <xsl:for-each select="descendant::form[not(form) and not(ancestor::re)]">
      <xsl:if test="preceding-sibling::form[1] or parent::form[preceding-sibling::form[1]] or (@type='inflected')">
       <entry id="generated-{generate-id()}-{ancestor::entry/@id}" type="xref">
         <form>
          <xsl:apply-templates select="orth|@*"/>
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
         </xsl:choose>
         <xr type="see"><ptr target="{ancestor::entry/@id}"/></xr>
       </entry>
      </xsl:if>
    </xsl:for-each>
    <xsl:apply-templates/>
  </div0>
</xsl:template>

<!-- Ignore entries without identifier
     This was once used to ignore notably existing xref entries,
     which had no id. The core lexicon should no longer include
     any manual xref, so this rule could be removed safely...
-->
<xsl:template match="entry[not(@id)]"/>

</xsl:stylesheet>