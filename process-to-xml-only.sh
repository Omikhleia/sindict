#!/bin/bash

xsltproc --novalid scripts/process/expand-xref-pass1.xsl src/dict-sd-fr-en.xml \
  | xsltproc --novalid scripts/process/expand-xref-pass2.xsl - \
  | xsltproc --novalid scripts/process/sort.xsl - \
  | xsltproc --novalid scripts/process/expand-renum.xsl - \
  | xsltproc --novalid scripts/process/add-sections.xsl - \
  > docs/dict-sd.xml
