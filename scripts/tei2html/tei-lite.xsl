<?xml version='1.0'?>
<!--
     Copyright (c) 2001-2011, HSD. 2019, 2021, Omikhleia.
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
 "header" can be set to 'yes' to generate the TEI header,
 "body" can be set to 'no' to disable the dictionary (and just generate the
        header, for instance)
 "search" can be set to some 'entry id' to output a single entry
 "language" sets the language for abbreviations, parts of speech etc. ('en', 'fr' or 'de')
            as well as, overall, the main language (for selecting headers and content
            to include outside the dictionary body)
 "translations" is a list of included languages in the dictionary body. Defaults to 'fr,en'.
-->
<xsl:param name="header">yes</xsl:param>
<xsl:param name="body">yes</xsl:param>
<xsl:param name="search"/>
<xsl:param name="language">en</xsl:param>
<xsl:param name="translations">fr,en</xsl:param>

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
      <div class="buttons">
        <a href="index.html" target="_blank">
        <svg xmlns="http://www.w3.org/2000/svg" height="40px" width="40px" viewBox="0 0 24 24"><title id="info-id">Information</title><path d="M0 0h24v24H0z" fill="white"></path><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17h-2v-2h2v2zm2.07-7.75l-.9.92C13.45 12.9 13 13.5 13 15h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H8c0-2.21 1.79-4 4-4s4 1.79 4 4c0 .88-.36 1.68-.93 2.25z"></path></svg>
        </a>
      </div>
      <div class="toggle-popup">
        <form class="search-box" onsubmit="return false;">
          <input type="text" required="required" spellcheck="false" autocomplete="off" placeholder="Search entry..." id="search"/>
          <button class="close-icon" type="reset">×</button>
        </form>
        <input type="checkbox" id="popupChk"/>
        <label for="popupChk"></label>
        <div id="popup" class="fixed-popup hide-show">
          <div class="rounded">Click a word...</div>
        </div>
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