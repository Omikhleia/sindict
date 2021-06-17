/*
     Copyright (c) 2021 Omikhleia
     License: MIT

     Quick and dirty reference checker.
     Takes the XML lexicon as standard input.
     Makes basic tests on references (text-search brute force).
 */
const biblrefs = require('./biblrefs.json')
const bookmap = new Map(biblrefs.map(bibl => [bibl.id, { title: bibl.title, year: bibl.year, type: bibl.type}]))

// Cases where may have XXX/xxx not being a reference.
const exceptions = [
  'Sindarin' // So far, only 'Sindarin/Noldorin' in some text ;)
]

function checkRule(rule, refs) {
  let ok
  if (rule instanceof RegExp) {
    ok = rule.test(refs)
  } else {
    ok = rule(refs)
  }
  // DEBUG
  // if (!ok) {
  //   console.warn(` Rule ${rule} failed for ${refs}`)
  // }
  return ok
}

const rules = {
  'page': /^([1-9][0-9]*|[ivx]+)$/, // Arabic or roman number
  'issue': /^[1-9][0-9]$/, // Number
  'pages': (refs) => {
    const pages = refs.split(/[,-]/) // Pages or page ranges
    return pages.every(p => checkRule(rules.page, p))
  },
  'chapters': /^(([IVX]+(:[IVX]+)?)|([A-Z](-[A-Z])?)|Index|Map)$/, // Book:Ch, App, App-App, Index, Map
  'date': /^2[0-9]{7}$/, // 2YYYMMDD
  'post': /^[1-9][0-9]*$/, // Number
  'posts': (refs) => {
    const posts = refs.split(/-/) // Post ranges
    return posts.every(p => checkRule(rules.post, p))
  },
  'issue:pages': (refs) => {
    const [issue, pages] = refs.split(':') // Errata or Issue:Pages
    const ok1 = issue && (issue == 'Errata' || checkRule(rules.issue, issue))
    const ok2 = pages ? checkRule(rules.pages, pages) : true
    return ok1 && ok2
  },
  'rule': /[A-Z]{1,2}/ // One or two capital letters
}

const chunks = []
process.stdin
.on("data", function(chunk) { chunks.push(chunk) })
.on("end", function() {
  // Search in all text, regardless of the XML structure
  const bibl = chunks.join("").match(/[A-Z][A-z]*\/[^\s<()\.]*/g)

  // Check each found reference
  bibl.forEach(b => {
    const trimmed = b.replace(/,$/, '') // Trailing comma
    const [book, refs] = trimmed.split('/')
    if (!exceptions.includes(book)) {
      if (!bookmap.has(book)) {
        console.warn(`Invalid reference: ${trimmed}`)
      } else {
        const bookSpec = bookmap.get(book)
        const rule = rules[bookSpec.type]
        if (!rule) {
          // Should not occur unless our JSON book map has an issue (or introduced new rules)
          console.warn(`Unexpected rule ${bookSpec.type} on ${book}`)
        }
        if (!checkRule(rule, refs)) {
          console.warn(`Incorrect reference ${trimmed} (rule '${bookSpec.type}')`)
        }
      }
    }
  })
})
.setEncoding("utf8")
