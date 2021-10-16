# Changes

## Edition 2.1 - Oct. 16, 2021

_Release_ 

Target: take into account _the Nature of Middle-earth_

- Lexicon content update:
  - Added entries from NM
  - Fixed some more PE/17 and Ety entries on the way
- Lexicon structure overhaul:
  - Removed numbering on sense tags (useless, as it is generated in the ouput)
- Tooling:
  - PDF output improvements:
    - The list of abbreviations and references are now included.
    - The document layout has been improved (better margins, culs-de-lampe, etc.)

## Edition 2.0 (lexicon 1.0) - Sept. 26, 2021

_Release_

The dictionary had not seen a nice PDF version since the early 2000s... It was more
than time to fix that, and roll out a final 2.0 release, don't you think?

Target: make it typographically sound

- Lexicon content update:
  - Several fixes for issues reported on 2.0-RC2.
- Lexicon structure overhaul:
  - Several typographical improvements (spacing, typographical apostrophes and quote marks)
  - More consistency regarding element ordering in entries
  - More consistency regarding bibliographic references (all marked as "bibl" tags in the XML, even in notes, etc.)
- Tooling:
  - PDF generation (in a dedicated repository, see build instructions)

## Edition 2.0-RC2 (lexicon 1.0-RC) - May 25, 2021

_Release Candidate_

Target: clean-up the toolchain

- Lexicon structure overhaul:
  - Clean-up and improve source XML readability.
- Layout:
  - Styles improvement
  - Search box
- Tooling:
  - Processing scripts clean-up
  - Oe-ligature sorted as "oe" for convenience
  - Expansion of related (secondary) entries
  - Better expansion of cross-reference pointers

## Edition 2.0-RC (lexicon 1.0-RC) - May 19, 2021

_Release Candidate_

Target: repair the post-processing steps.

- Lexicon content updates:
  - Several bunches of updates from PE/17 and other minor fixes
- Lexicon structure overhaul:
  - Removal of old generated elements (artifacts from the recovered lexicon)
  - Switch to UTF8 encoding and LF end-of-lines
  - Removal of the outdated German translation and notes
- Tooling:
  - Recovered post-processing scripts, so expansion of cross-references,
    entry sorting, homograph (re-)numbering, sectioning are all back into
    action.

## Edition 2.0-a6 (lexicon 1.0-alpha9) - May 16, 2021

_Pre-Release_

Target: make it look nice again.

Additionally, the project now has a "live version" via "GitHub Pages".

- Lexicon content updates (with apologies to those involved... sometimes years ago):
  - Several bunches of updates from PE/17.
    For the record, it represents around 60-70% of the old so-called "C0421" notes (with great thanks
    to whom it concerns - efforts from around 2014 or later).
    Support for PE/17 is still fairly incomplete.
  - Several other fixes and updates (special thanks to Gabor L., feedback from around 2011-2012).
  - And more fixes and updates here and there.
- Layout: previous version was mostly focussed on re-assembling a working version, but the generated output was somehow ugly...
  - Improved HTML5/CSS3 layout.
  - Repaired project information (header, with toggle).
  - Clickable words:
    - GitHub integration for easier issue reporting
    - Eldamo integration, just because.

## Edition 2.0-a5x (lexicon 1.0-alpha5) - April, 10 2021

_Pre-Release_

Target: assemble a working lexicon again (from 2019 source recovery)

- Entries from PE/17 are *very* partially taken into account.
  We have not checked how far we went in the 2011-2014 effort, and how much of this work could be recollected.
- Entries from PE/18 to PE/22, and up to VT/50 (incl.) are expected to all have been taken into account, and should also have been checked for completeness.
- Some old entries were fixed, with the inputs from the abovementioned sources.
- Some old fixes reported on the (now defunct) sindarin dictionary mailing list were included.
  At this point, it was assumed that the backlog of former reports (on the list or by mail to the former editor) was processed.
- Many entries use a newer and better reference scheme (with "bibl" tags in words and in defitinions, rather than a single "sources" note
  collated at the end of an entry) - though this is not complete. Hence the colors in the default output.
- French translations were added accordingly for all new or corrected entries, though unrevised. 
  The German translations however were only sparingly touched and are best avoided. (They are excluded from the default output.)

## Older

The last public version of the _Hiswelokë's Sindarin Dictionary_ on which this work is based was edition 1.9.1 (lexicon 0.9952) in May 2008.

Older revisions history:
- May 2008 (edition 1.9, lexicon 0.995) quickly superseded by edition 1.9.1.
- April 2007 (edition 1.8-rc1, lexicon 0.99499), there was no 'final' 1.8 beyond that release candidate, as the work on 1.9 immediately started.
- June 2006 (edition 1.8-beta, lexicon 0.9949) - introduced German and French translations.
- June 2005 (edition 1.8-alpha, lexicon 0.994821).
- July 2004 (edition 1.7, lexicon 0.994) - on the occasion of the release of the Hesperides application.
- December 2003 (edition 1.6, lexicon 0.993) - on the occasion of the release of Dragon Flame 2.0.
- December 2002 (edition 1.6-alpha, lexicon 0.99).
- June 2002 (edition 1.5, lexicon 0.98).
- May 2002 (edition 1.4, lexicon 0.97) - XML TEI P3 format.
- August? 2001 (edition 1.3, lexicon 0.96) - perhaps unreleased.
- February 2001 (edition 1.2, lexicon 0.95) - first public PDF version (a.k.a "Cabor" release).
- January 2001 - Preliminary PDF version (a.k.a. "Mellon" release)
- Earlier history from Oct. 1999 to Dec. 2000 - details not recovered.
