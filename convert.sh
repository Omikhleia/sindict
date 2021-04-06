#!/bin/bash

xsltproc tei2html/tei-lite.xsl src/dict-sd-fr-de-en_2.0a5x.xml \
  | node tei2html/post-process.js \
  > build/dict-sd.html

