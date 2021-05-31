# The Data Model

## General presentation

The core dictionary dictionary consists in a single file encoded in XML (_eXtensible Mark-up Language_) based on the
TEI (_Text Encoding Initiative_) specifications, more precisely a loose subset of the TEI P4 specifications.

### Why XML?

Despite XML was still emering in 1999 when the project was initiated, it was felt suitable both for having a clear
interchange format and a way to providing a structured high-level representation of the information. One can process
the XML description to generate readable views of it — e.g. in HTML for the Web — or event to extract selected data
and use them in a different context. It may be achieved programmatically, using standard W3C techniques (for ex.
XSLT style-sheets) or any other programming language. As part of the Sindarin dictionary project, we wrote several 
specific XSLT stylesheets for the various tasks we wanted to achieved (pre- or post-processing, conversion, etc.)

### Why TEI?

The _Text Encoding Initiative_ specifically targeted dictionaries (TEI P4, §12), with various approaches to dictionaries
being considered and discussed. Being developed by a group of experts, it tried to address a lot of use cases. The
distinction between a "lexical view" (that is, the way the underlying information structure is to be encoded, without
concern for its exact textual representation) and the "typographic and editorial" views (focussed on the typesetting and
the typographic realizations) are enlightening. So the choice was quite obvious: Rather the inventing another specific XML
"tag-set" (nowadays called a "schema") which would have to be specified and explained, a relavant subset of the TEI proposal
was felt more than appropriate.

### Further thought

These choices were not obvious when the project was started in 1999. Some people were only concerned about the final representation.
In their view, any word-processing software would have been acceptable. Others promoted using a relational database (generally
SQL-based). We still believe it would have been a poor choice, as an interchange format but also on the structural design (or
how to design a good database model for such a thing...). Years later (by 2008), some groups of people still criticized the choise of
XML compared to SQL... Anyhow, it is interesting however to note that another major other similar project (of a much larger scope)
now exists years later, **Eldamo** by Paul Strack, and uses XML as well at its core. QED.

## Encoding overview

Since this dictionary is based on TEI, we are not going to describe here every feature from the schema, but rather to summarize the
main elements.

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
  <!-- Word forms -->
  <!-- Sense (glosses or definitions)
  <!-- Optional etymology -->
  <!-- Optional notes (sources, comments) -->
  <!-- Optional related entries (secondary entries)
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
  "S." (Sindarin), "N." (Noldorin), "S., N." (both languages apply).
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
    <gramGrp>
      <!-- grammatical information -->
    </gramGrp>
    <trans lang="fr">
      <!-- Definition (French translation of the definition(s), gloss(es) and usage hint(s)) -->
    </trans>
    <trans lang="en">
      <!-- Definition (English original definition(s), gloss(es) and usage hints(s)) -->
    </trans>
  </sense>
```

Definitions TBD

### (Optional) Etymology

TBD

### (Optional) Notes (sources and comments)

TBD

### (Optional) Related entries

Related entries correspond to the concept of secondary entries under a given entry.

Each is introduced with the `<re>` element, which may have the following attributes:
- `corresp`, with the unique identifier (`id` attribute) of another entry, in the case where this
  related entry actually also has a main existing entry in the lexicon. (This attribute is
  actually used in the post-processing steps, for generating cross-reference entries
  only for related entries that do not have it).
  
The contents of a related entry can be the same as for an entry. Usually by nature they
are more concise and only contain word forms and grammatical information.

### (Optional) Cross-reference links

An `<xr>` element formatted as follows:

```xml
  <xr type="analogy"><ptr target="..."/></xr>
```
Where the pointer target is the unique identifier (`id` attribute) of another entry.
