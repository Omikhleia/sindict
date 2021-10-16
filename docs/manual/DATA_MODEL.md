# The Data Model

## General presentation

The core dictionary dictionary consists in a single file encoded in XML (_eXtensible Mark-up Language_) based on the
TEI (_Text Encoding Initiative_) specifications, more precisely a loose subset of the TEI P4 standards.

### Why XML?

Although XML was still emerging in 1999 when the project was initiated, it was felt suitable for providing a clear
interchange format and a structured high-level representation of the information. One can process
the XML description to generate readable views of it — e.g. in HTML for the Web — or even to extract selected data
and use them in a different context. It may be achieved programmatically, using standard W3C techniques (for ex.
XSLT style-sheets) or any other programming language. As part of the Sindarin dictionary project, we wrote several 
specific XSLT stylesheets for the various tasks we wanted to achieved (pre- or post-processing, conversion, etc.)

### Why TEI?

The _Text Encoding Initiative_ specifically targets dictionaries (TEI P4, §12), with various approaches being considered
and discussed. Being developed by a group of experts, it tried to address a lot of use cases. 
The distinction between a "lexical view" (that is, the way the underlying information structure is to be encoded, without
concern for its exact textual representation) and the "typographic and editorial" views (focussed on the typesetting and
the typographic realizations) are enlightening. So the choice was quite obvious: Rather the inventing another specific XML
"tag-set" (nowadays called a "schema"), which would have to be specified and explained, a relevant subset of the TEI
proposal was felt more than appropriate.

### Further thought

These choices were not obvious when the project was started in 1999. Some people were only concerned about the final representation. In their view, any word-processing software would have been acceptable.
Others promoted using a relational database (generally SQL-based).
We still believe it would have been a poor choice, as an interchange format but also regarding the structural design (or
how to design a good database model for such a thing...). Years later (by 2008), some groups of people still criticized the choise of XML compared to SQL... 
Anyhow, it is interesting however to note that another major other similar project (of a much larger scope)
now exists years later, **Eldamo** by Paul Strack, and uses XML as well at its core. QED.

## Encoding overview

Since this dictionary is based on TEI, we are not going to describe here every feature from the schema, but rather
to summarize the main elements. In other terms, this presentation is not exhaustive.

The reader is therefore expected to have a prior knowledge of XML and to refer, if need be, to the TEI specifications for elements
loosely defined hereafter.

### File structure

The dictionary has the following general structure:

```xml
<?xml version="1.0" encoding="utf-8"?>
<TEI.2>
  <teiHeader>
    <!-- Header: various general information
         (title, edition, publisher, license, introductory notes -->
  </teiHeader>
  <text>
    <body>
      <div0 type="dictionary">
        <!-- Dictionary entry -->
        <!-- ... -->
        <!-- Dictionary entry -->
      </div0>
    </body>
  </text>
</TEI.2>
```

### Entries

Each entry is encoded as an `<entry>` element which may have the following attributes:
- `id` unique identifier (within the file). It could literally be anything as long as it is unique;
  we usually just used the main headword, postfixed with some `.1`, `.2`, etc. in the case of
  homographs.
- `n` number, in the case of homographs. _This field is actually not necessary_. It will be
  automatically re-calculated and added when the file is post-processed and expanded), but 
  is often present as a mere convenience (so e.g. `<entry id="xxx.1" n="1">`) for the editor.
- `type`
  - when present in the core source lexicon, it can only (currently) take the value "affix"
    (to possibly distinguish normal word entries from suffixes, partial stems, etc.)
  - (In the post-processed lexicon (but not in the core source lexicon), it may also have
    the "xref" value, to denote a generated cross-reference.)
- (In the post-processed lexicon (but not in the core source lexicon), `rend` may also be
  used for styling hint in the HTML output. Specifics not detailed here.)
  
The general contents of an entry are shown hereafter:

```xml
<entry>
  <!-- Word forms (possibly nested) -->
  <!-- Optional grammatical information, usually they are rather provided with the sense -->
  <!-- Sense (glosses or definitions) -->
  <!-- Optional etymological notes -->
  <!-- Optional notes (sources, comments) -->
  <!-- Optional related entries (secondary entries) -->
  <!-- Optional cross-reference links to other entries (analogies or synonyms, etc.) -->
</entry>
```

### Word forms

There are two cases here. 

For entries with more than one forms (as with alternative readings) and/or with inflected 
forms, there is one first level of "nesting", using a `<form>` element
with a `type` attribute set to "regular" or "inflected". One can regard these specific
`form` top-level elements as "form groups", then containing a sequence of forms. Of course,
each recorded inflection (e.g. of a different morphological or grammatical nature) will
have its own group.

```xml
  <form type="regular">
    <!-- First word form = main headword -->
    <!-- Alternative word form -->
    <!-- ... -->   
  </form>
  <form type="inflected">
    <!-- Nature of the inflection -->
    <!-- Word form (inflected) -->
    <!-- Alternative word form (inflected) -->
    <!-- ... -->   
  </form>
  ...
```

For very simple entries, the nesting is not mandatory. It is however recommended
to always use it in the core source lexicon (but generated cross-reference entries
in the post-processed lexicon may not have it).

So whether nested or not, we eventually reach the point where actual word forms are
recorded. Each form (first main or alternative) is encoded as a `<form>` element which may
have the following attributes:
- `type`: if present, one of
  - "deduced", form that is not attested on its own, but derived from other considerations.
  - "normalized", form that is "updated" from an earlier stage of Tolkien's invented
    languagez, to fit our (current) understanding of the conceptual changes between these
    various stages.

The form must at least contain an `<orth>` element, with its textual representation.

It may additionally contain:
- A language indication, as `<usg type="lang" norm="..."/>` where the value may be
  "S." (Sindarin), "N." (Noldorin), "S., N." (both languages apply), "*S." (Neo-Sindarin).
- Bibliographic references (`<bibl>`) where this form is attested, as a comma-separated
  list of book references 
- Pronunciation (`<pron>`), in X-SAMPA (an ASCII representation format for the IPA)

```xml
    <form>
      <orth><!-- Actual word --></orth><usg type="lang" norm="..."/>
      <bibl><!-- References --></bibl>
      <pron><!-- Pronunciation --></pron>
    </form>
```

### Sense information

```xml
 <sense>
    <!-- Grammatical information -->
    <!-- Other register or category information -->
    <trans lang="fr">
      <!-- Definition (French translation of the definition(s), gloss(es) and usage hint(s)) -->
    </trans>
    <trans lang="en">
      <!-- Definition (English original definition(s), gloss(es) and usage hints(s)) -->
    </trans>
  </sense>
```

Would there be several meanings for an entry, having several sense elements is allowed.


The definitions are normally included in a `<def>` element.

Usage hints are encoded in a `<usg type="hint">...</usg>` group. NOTE: in TEI P4, this group cannot be in a definition, so one
has to close the definition, add the usage hints, and possibly open a new definition for subsequent information. We might want
to change this at some stage.

In the English definitions, bibliographic references can be mentioned with the `<bibl>` element. This should only include
references where the gloss or definition is attested (as compared to the bibliographic information on the orth. form, where
the word form is actually attested.)

So for instance:

```xml
    <trans lang="en">
      <def><bibl><!-- References --></bibl> <!-- some glosses -->,
        <bibl><!-- Ref. --></bibl> <!-- some other glosses --></def> <usg type="hint"><!-- Some hint --></usg>,
      </def><bibl><!-- Ref. --></bibl> <!-- another gloss --></def>
    </trans>
```

### Grammatical information

Grammatical information are usually provided in a `<gramGrp>` (grammatical group) element, although this
is not mandatory.

Here the full range of part-of speech markers, tense specifiers, etc. from TEI P4 may be used.
Linguistic structures not defined in TEI (e.g. mutations) are encoded with a generic `<itype>` element.

Just immediately after a grammatical group in an inflected entry, one may find a link to a base form
if needed, as an `<xr>` cross-reference of the following kind:

```xml
    <xr type="of"><ptr target="..."/></xr>
```

### Register or category information

Semantic domain:

```xml
<usg type="dom"><!-- Domain --></usg>
```

Where domains include: "Bot.", "Geol.", "Ling.", "Mil.", "Orn.", "Theo.", "Zool.",
"Astron.", "Biol.", "Phil.", "Geog.", "Cal.", "Pop.", etc. - See [abbreviations](ABBREVIATIONS.md).

Archaic or poetic word:

```xml
    <usg type="reg">Arch., Poet.</usg>
```

(Likewise, only "Arch." or "Poet.", etc.)

Prejorative register:

```xml
    <usg type="reg">Pej.</usg>
```
    
Category information (semantic field, where the attribute value is Carl Darling Buck's structured numbering for that field):

```xml
    <usg type="cat" norm="..."/>
```

### (Optional) Etymological notes

Introduced with the `<etym>` element, containing free text. NOTE: We might want to change this at
some later stage.

### (Optional) Notes (sources and comments)

The dictionnary currently supports three types of annotations.

#### Sources or quotations

```xml
  <note type="source,deduced"><mentioned><!-- Partial quotation --></mentioned> 
     <!-- Free text incl. references --></note>
```

NOTE: This encoding is somewhat historical and might not imply that the entry is "deduced". We might change to a more
adequate type at some stage (e.g. "mention").

#### Editorial comments

Editorial comments are formatted as follows:

```xml
  <note type="comment" lang="...">
    <!-- Free text with presentation and formatting elements allowed -->
  </note>
```

#### Legacy sources indication

Some entries provide bibliographic information as a specific note:

```xml
  <note type="source"><!-- References --></note>
``` 

NOTE: This is a legacy usage from earlier versions of the dictionary. This note would
ideally be split in `<bibl>` elements at the appropriate place (that is, as explained
above, in orth. forms or in definitions).

### (Optional) Related entries

Related entries correspond to the concept of secondary entries under a given entry.

Each is introduced with the `<re>` element, which may have the following attributes:
- `corresp`, with the unique identifier (`id` attribute) of another entry, in the case where this
  related entry actually also has a main existing entry in the lexicon. (This attribute is
  actually used in the post-processing steps, for generating cross-reference entries
  only for related entries that do not have it).
  
The contents of a related entry can be the same as for an entry. Usually, by nature, they
are more concise and only contain word forms and grammatical information.

NOTE: There were discussions whether to replace `corresp` by `sameAs` and leave the related
entry empty, to avoid duplicating information.

### (Optional) Cross-reference links

An `<xr>` element formatted as follows:

```xml
  <xr type="analogy"><ptr target="..."/></xr>
```
Where the pointer target is the unique identifier (`id` attribute) of another entry.
