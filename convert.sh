#!/bin/bash

xsltproc scripts/tei2html/tei-lite.xsl src/dict-sd-fr-en.xml \
  | node scripts/tei2html/post-process.js \
  > docs/dict-sd.html

