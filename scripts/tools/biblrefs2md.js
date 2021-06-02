/*
     Copyright (c) 2021 Omikhleia
     License: MIT

     Markdown export of the bibliographic references
 */
const biblrefs = require('./biblrefs.json')

console.log(`# References

| Acronym       | Reference   |
| ------------- | ----------- |`)

biblrefs.forEach(bibl => {
  if (bibl.year) {
    console.log(`| ${bibl.id} | ${bibl.title}, ${bibl.year}. |`)
  } else {
    console.log(`| ${bibl.id} | ${bibl.title}. |`)
  }
})
