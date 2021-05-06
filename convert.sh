#!/bin/bash

xsltproc tei2html/tei-lite.xsl src/dict-sd-fr-en.xml \
  | node tei2html/post-process.js \
  > docs/dict-sd.html

