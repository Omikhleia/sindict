# (Re-)Building the dictionary

These procedures describe how to build an HTML version of the dictionary from the core source XML lexicon.

## Prerequisites

You will need the following command-line tools on your system:
- **xsltproc** - XSLT processor.

  The provided XSLT style-sheets are in XSLT 1.0 format and rely on a few EXSLT extensions. You may try
  another XSLT processor, but there is no guarantee it will work.

- **[node](https://nodejs.org/en/)** - Node.js JavaScript runtime.

  Any recent version should work. 
  It is currently only used to clean-up the HTML output from the XSLT style-sheets, using regular
  expressions to replace some patterns. You can do without it and skip that step, but the output
  will not be perfect. 

- Optional: **bash** - Shell command-line scripting.

  It is needed in order to use the provided shell scripts described below. You can do without it, but
  you will then need to adapt the commands to your operating system.

### Principles

The core source lexicon in XML is `src/dict-sd-fr-en.xml`

#### Quick conversion

To just convert the core source lexicon to HTML, the steps are the following:
1. Apply to the lexicon the `scripts/tei2html/tei-lite.xsl` XSLT style-sheet, to generate a raw HTML file.
1. Apply the Node script `scripts/tei2html/post-process.js` on that generated HTML to clean it. This step
   fixes a few issues (e.g. spacing, punctuations, blank lines, etc.) that would have been hard to manage at the
   XSLT level.

The provided `convert.sh` script applies these two steps in a row, and puts the converted
HTML in `docs/dict-sd.html`

#### Complete (post-processed) conversion

To produce a much better version of the lexicon, several additional tasks are performed.
1. Apply the (post-)processing XSLT style-sheets in order (see below), each using as input the output of
   the previous task.
1. Apply the `scripts/tei2html/tei-lite.xsl` XSLT style-sheet to the final XML, to generate a raw HTML file.
1. Apply the Node script `scripts/tei2html/post-process.js` on that generated HTML to clean it.

The provided `process.sh` script applies all the necessary steps in a row, and puts the converted
HTML in `docs/dict-sd.html`

The post-processing taks may be updated and the list below may become outdate, please check the script
in case of doubts.

But basically, for the record, the main following steps should be performed:
1. Expand cross-references from alternate and inflected forms (`scripts/process/expand-xref-pass1.xsl`): this task
   creates dictionary entries for all entry forms which are not main headwords, i.e. appear in an entry as
   alternative variants or inflected forms.
1. Expand cross-references from related forms (`scripts/process/expand-xref-pass2.xsl`): this task
   creates dictionary entries for secondary entries (a.k.a. related sub-entries) which are not
   marked as already having an existing main entry.
1. Sort the resulting lexicon in alphabetical order (`scripts/process/sort.xsl`): obviously, the previous
   tasks bluntly added new entries that won't be ordered. (And the original core source XML is not
   guaranteed, anyway, to be ordered correctly.)
1. Re-number homographs (`scripts/process/expand-renum.xsl`)
1. Add sections (`scripts/process/add-sections.xsl`): that is, insert an alphabetical section milestone when
   the first letter of entries changes.

As an illustration, assuming an original entry:

> **form1** _S._ XX/xxx (**variant1** _S._ YY/yyy, **variant2** _N._ ZZ/zzz), _pl._ **plural1** _S._ TT/ttt (**plvariant** N. UU/uuu) _n._ Some definitions - **subform** _S. MM/mmm _n. abst._

The expanded post-processed lexicon would yield to something such as:

> **F**

> **form1** _S._ XX/xxx (**variant1** _S._ YY/yyy, **variant2** _N._ ZZ/zzz), _pl._ **plural1** _S._ TT/ttt (**plvariant** N. UU/uuu) _n._ Some definitions - **subform** _S. MM/mmm _n. abst.

> **P**

> **plural1** _S._ TT/ttt _pl._ → **form1**

> **plvariant** N. UU/uuu _pl._ → **form1**

> **S**

> **subform** _S. MM/mmm _n. abst._ → **form1**
 
> **V**

> **variant1** _S._ YY/yyy → **form1**

> **variant2** _N._ ZZ/zzz → **form1**

  
