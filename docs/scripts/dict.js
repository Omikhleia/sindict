/*
  Copyright (c) 2021 Omikhleia
  License: MIT
*/

/* Search */

function escapeRegExp(string){
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') // $& means the whole matched string
}

function onSearch(event) {
  if (event.target && event.target.value) {
    const searched = event.target.value
    const entry = sindict && sindict.find(e => compare(searched, e.textContent) <= 0)
    if (entry) {
      entry.scrollIntoView()
    }
  }
}

/* Text under cursor */
/* Derived from https://stackoverflow.com/questions/7563169/detect-which-word-has-been-clicked-on-within-a-text */
/* MIT-licensed */

function expandTextRange(range) {
  const length = range.endContainer.length || range.endContainer.childNodes.length
  if (range.startOffset === length || range.endOffset === -1) {
    // Beyond text boundaries
    return
  }

  // Expand to include a whole word
  const matchesStart = (r) => r.toString().match(/^[\s.,?'"()]/)
  const matchesEnd = (r) => r.toString().match(/[\s.,?'"()]$/)

  // Find start of word 
  while (!matchesStart(range) && range.startOffset > 0) {
      range.setStart(range.startContainer, range.startOffset - 1)
  }
  if (matchesStart(range)) {
    range.setStart(range.startContainer, range.startOffset + 1)
  }

  // Find end of word
  while (!matchesEnd(range) && range.endOffset < length) {
      range.setEnd(range.endContainer, range.endOffset + 1)
  }
  if (matchesEnd(range) && range.endOffset > 0) {
    range.setEnd(range.endContainer, range.endOffset - 1)
  }
}

function getTextUnderCursor() {
    const sel = window.getSelection()
    const range = sel.getRangeAt(0).cloneRange()
    
    if (range.startOffset === range.endOffset) {
      expandTextRange(range)
      const text = range.toString().trim()
      if (text) {
        return text
      }
    }

    // Only return text if there's no range selection
    return undefined // range.toString()
}

/* Eldamo integration */

let eldamo
fetch('data/eldamo-scrap.json')
  .then(response => response.json())
  .then(data => eldamo = data)
  .catch(() => {
    console.error("Couldn't fetch eldamo database")
  })

function compare(o1, o2) {
  return o1.localeCompare(o2, undefined, { sensitivity: 'accent' })
}

function eldamoMatch(w, orth) {
  try {
    const eldOrth = w.word.replace(/[\u00B9\u00B2\u00B3\u00B4]/, '') // remove entry numbering
    if (eldOrth.lastIndexOf('(' ) !== -1) {
      // Handle entries with parentheses, e.g. "echui(w)"
      const altParts = eldOrth.replace(')','').split('(')
      const altOrths = [altParts[0], altParts[0]+altParts[1]]
      return !compare(altOrths[0], orth) || !compare(altOrths[1], orth)
    }
    return !compare(eldOrth, orth)
  } catch (e) {
    // console.warn(e)
  }
  return false
}

function eldamoLookUp(orth) {
  if (eldamo) {
    const directMatch = eldamo.filter(w => eldamoMatch(w, orth))
    if (directMatch.length) {
      return directMatch
    }

    // If no direct match found, try in references...
    return eldamo.filter(w => w.ref && w.ref.some(ref => eldamoMatch(ref, orth)))
  }
  return []
}

function eldamoSearch(text) {
  return eldamoLookUp(text).map(w => ({ ...w,
    lang: w.lang.toUpperCase(),
    url: `https://eldamo.org/content/words/word-${w['page-id']}.html`,
  }))
}

const templateEldamo = `<div class="rounded">
  <small>
    <i>Eldamo might have matching entries...</i>
    {{#matches}}
    <p class="elddict">
      {{mark}}<b><a href="{{url}}" target="_blank">{{word}}</a></b> <small>{{lang}}. {{speech}}.</small> {{gloss}}
        <small>{{#ref}}&#x25C7; <b>{{word}}</b> {{source}} {{/ref}}</small>
    </p>
    {{/matches}}
  </small>
</div>`

/* Global click handler */

function guessContext(element) {
  // Weak! We'd need better CSS styling etc.
  if (element.className && element.className !== 'sindict') {
    return element.className
  }
  if (element.tagName === 'B') {
    return "orth" // Weak. Could be a form/re orth or a ref/ptr
  }
  return undefined
}

const templatePopup = `<div class="rounded">
  <small>
    Entry identifier: <b>{{ id }}</b><br/>
    Selected word: {{ text }} {{ #context }}(in {{context}}) {{ /context }}<br/>
    <div>
      <svg style="vertical-align: middle" height="25" viewBox="0 0 16 16" version="1.1" width="32" aria-hidden="true"><path fill-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"></path></svg>
      <a href="{{ gh }}" target="_blank">Open issue</a>
    </div>
  </small>
</div>`

function onClick(event) {
  const text = getTextUnderCursor()
  const entry = event.target.closest && event.target.closest("[id]")
  const id = entry && entry.id
  const popupCheckbox = document.getElementById('popupChk')

  if (text && id
    && event.target.className !== 'entry') {
    const context = guessContext(event.target)
    const c = context && `[in ${context}]`
    const gh = GitHubIssueUrl({
      repository: 'https://github.com/Omikhleia/sindict',
      title: `(entry ${id}) ${text}`,
      body: `Issue on entry **${id}** (internal identifier)
"${text}" ${c ? c : ''}
...`,
    })

    const popupContainer = document.getElementById('popup')
    if (popupCheckbox && popupContainer && Mustache) {
      popupCheckbox.checked = true
      let rendered = Mustache.render(templatePopup, { text, context, id, gh })

      if (context === "orth") {
        const matches = eldamoSearch(text)
        if (matches.length) {
          const r = Mustache.render(templateEldamo, { matches })
          rendered = r + rendered
        }
      }
      popupContainer.innerHTML = rendered
    }
  } else {
    popupCheckbox.checked = false
  }
}

/* GitHub integration - open issue */
/* Derived from https://github.com/sindresorhus/new-github-issue-url/blob/main/index.js */
/* MIT-licensed */

function GitHubIssueUrl(options) {
  let repository
  if (options.repository) {
    repository = options.repository
  } else {
    throw new Error('repository not specified')
  }
  
  const url = new URL(`${repository}/issues/new`)
  const types = [
    'body',
    'title',
    'labels',
    'template',
    'milestone',
    'assignee',
    'projects'
  ]

  for (const type of types) {
    let value = options[type]
    if (value === undefined) {
      continue
    }

    if (type === 'labels' || type === 'projects') {
      if (!Array.isArray(value)) {
        throw new TypeError(`${type} must be an array`)
      }
      value = value.join(',')
    }

    url.searchParams.set(type, value)
  }

  return url
}

/* On Load bootstrapping */

let sindict
window.onload = () => {
  const dict = document.getElementsByClassName('dictionary')
  if (dict.length) {
    dict[0].addEventListener("click", onClick)
  }
  const searchBox = document.getElementById("search")
  if (searchBox) {
    searchBox.addEventListener("input", onSearch)
  }
  sindict = Array.from(document.querySelectorAll("p.sindict span.entry b:first-child"))
}
