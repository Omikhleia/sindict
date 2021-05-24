#!/bin/bash

xsltproc --novalid scripts/process/expand-xref.xsl src/dict-sd-fr-en.xml \
  | xsltproc --novalid scripts/process/expand-xref-2.xsl - \
  | xsltproc --novalid scripts/process/sort.xsl - \
  | xsltproc --novalid scripts/process/expand-renum.xsl - \
  | xsltproc --novalid scripts/process/add-sections.xsl - \
  | xsltproc scripts/tei2html/tei-lite.xsl - \
  | node scripts/tei2html/post-process.js \
  > docs/dict-sd.html
