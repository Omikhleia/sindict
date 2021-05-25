<?xml version='1.0' encoding='utf-8'?>

<!-- Copyright (c) 2007 by Didier Willis, 2021 Omikhleia
     License: MIT

     Include file for removing accents in a word.
-->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="accents" 
     select="'âàáāäêèéēëôòóōöûùúūüîìíīïŷỳýȳÿœabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZÄËÖÜ'" />
<xsl:variable name="noaccents" 
     select="'aaaaaeeeeeooooouuuuuiiiiiyyyyyoabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzaeou'" />
<xsl:variable name="noaccentscaps" 
     select="'AAAAAEEEEEOOOOOUUUUUIiIIIYYYYYOABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZAEOU'" />

</xsl:stylesheet>
