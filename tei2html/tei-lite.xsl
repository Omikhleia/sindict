<?xml version='1.0'?>
<!--
     Copyright (c) 2001-2019 HSD, Omikhleia
     License: MIT
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="tei-header.xsl"/>
<xsl:import href="tei-ipa.xsl"/>
<xsl:import href="tei-dict.xsl"/>

<!-- XHTML 1.0 output, UTF-8 -->
<xsl:output
    method="html" version="5"
    encoding="utf-8" indent="no"
/>

<!-- PARAMETERS
 "print" can be set to 'yes' for printable quality,
 "header" can be set to 'yes' to generate the TEI header,
 "body" can be set to 'no' to disable the dictionary (and just generate the 
        header, for instance)
 "search" can be set to some 'entry id' to output a single entry 
 "language" sets the language for abbreviations, parts of speech etc. ('en', 'fr' or 'de')
 "translations" is a list of included languages. Defaults to 'fr,en' with 'de' left out.
 "xref" can be set to 'yes' or 'no', whether entries marked as cross-reference links should
        be included or not.
-->
<xsl:param name="print">yes</xsl:param>
<xsl:param name="header">yes</xsl:param>
<xsl:param name="body">yes</xsl:param>
<xsl:param name="search"/>
<xsl:param name="language">en</xsl:param>
<xsl:param name="translations">fr,en</xsl:param>
<xsl:param name="xref">no</xsl:param>

<!-- SPACES 
     Handling correct spacing can't be done easily in XSLT, as the
     input XML file was entered manually. We will need an extra pass
     on the document to fix the spacing after the conversion. For some
     tags, we can however let XSLT prepare the job for us...
  -->
<xsl:strip-space elements="TEI.2 text body div0 teiHeader re"/>

<!-- CONVERSION RULES -->

<xsl:template match="TEI.2">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><xsl:value-of select="//titleStmt/title"/></title>
    <link rel="stylesheet" type="text/css" href="css/dict.css"/>
    <script src="https://unpkg.com/mustache@latest"></script>
  </head>
  <body>
    <div class="global">
      <div class="toggle-popup">
        <input type="checkbox" id="popupChk" />
        <label for="popupChk"></label>
        <div id="popup" class="fixed-popup hide-show"></div>
      </div>
      <xsl:apply-templates/>
    </div>
  </body>
</html>
</xsl:template>

<xsl:template match="p">
  <p class="text"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="body">
<xsl:if test="$body != 'no'">
  <xsl:apply-templates/>
  <script src="scripts/dict.js"></script>
</xsl:if>
</xsl:template>

</xsl:stylesheet>