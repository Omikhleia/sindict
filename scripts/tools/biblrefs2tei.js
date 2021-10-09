/*
     Copyright (c) 2021 Omikhleia
     License: MIT

     TEI export of the bibliographic references
 */
const biblrefs = require('./biblrefs.json')

biblrefs.forEach(bibl => {
  const title = bibl.title.replace(/_([^_]+)_/g, '<hi>$1</hi>')
  if (bibl.year) {
    console.log(`<bibl n="${bibl.id}">${title}, ${bibl.year}.</bibl>`)
  } else {
    console.log(`<bibl n="${bibl.id}">${title}.</bibl>`)
  }
})
