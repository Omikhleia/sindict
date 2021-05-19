#!/bin/bash

xsltproc --novalid xslt/process/expand-xref.xsl src/dict-sd-fr-en.xml \
  | xsltproc --novalid xslt/process/sort.xsl - \
  | xsltproc --novalid xslt/process/expand-renum.xsl - \
  | xsltproc --novalid xslt/process/add-sections.xsl - \
  | xsltproc tei2html/tei-lite.xsl - \
  | node tei2html/post-process.js \
  > docs/dict-sd.html
