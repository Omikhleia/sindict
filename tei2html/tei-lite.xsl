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
    method="xml"
    encoding="utf-8" indent="no"
    doctype-public = "-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

<!-- PARAMETERS
 "print" can be set to 'yes' for printable quality,
 "header" can be set to 'yes' to generate the TEI header,
 "body" can be set to 'no' to disable the dictionary (and just generate the 
        header, for instance)
 "search" can be set to some 'entry id' to output a single entry 
 
-->
<xsl:param name="print">yes</xsl:param>
<xsl:param name="header">no</xsl:param>
<xsl:param name="body">yes</xsl:param>
<xsl:param name="search"/>
<xsl:param name="language">fr</xsl:param>
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
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><xsl:value-of select="//titleStmt/title"/></title>
    <link rel="stylesheet" type="text/css" href="css/dict.css"/>
  </head>
  <body>
    <div class="global">
      <xsl:apply-templates/>
      <p class="edition"><i><xsl:value-of select="//titleStmt/title"/></i>,
           <xsl:value-of select="//publicationStmt/date"/>
          (Edition <xsl:value-of select="//editionStmt/edition/@n"/> - <xsl:value-of select="//editionStmt/edition/text()"/>)</p>
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
</xsl:if>
</xsl:template>

</xsl:stylesheet>