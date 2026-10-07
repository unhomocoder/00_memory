---
name: digest
description: Condense outside material — a paper, lecture slides, a transcript, an article — into a short faithful summary: a one-line TL;DR, 3–7 key points, action items if the source has any, open questions. Use when asked to digest, summarize or give the gist of a source. For an in-depth breakdown of one paper, use paper-digest.
---

# Digest

Turn one source into something the user can absorb in a minute: what it says, the few
points that matter, what it asks of them, and what it leaves unanswered. The digest adds
nothing. Every claim in it can be found in the source.

## Getting the source

Accepted: a local file (PDF, slides, Markdown, text, a transcript), a URL, or pasted text.

- **PDF.** Read the whole file first, with no page range. If that fails, or the file is too
  long to read whole, run this plugin's extractor with absolute paths:
  `python <plugin_dir>/skills/paper-digest/scripts/pdf_extract.py <file.pdf> --outdir <dir>`.
  It writes the text, or one image per page for a scan, and prints where.
- **A link to a landing page** (an arXiv abstract page, a publisher page) carries no body
  text. Find the full text (for arXiv, the `/pdf/` URL) or ask for a copy.
- **Very long sources** (a few hundred pages, such as an aggregated slide deck): say how long
  it is and ask whether to digest all of it or a named part, before reading. Reading the
  whole thing costs the user time and you context, and they may only need one lecture.
- **Check the title before writing.** One line: is this the source the user meant? A wrong
  file produces a perfectly accurate digest of the wrong thing.

## Format

```
**TL;DR** — one sentence carrying the source's main point, specific enough to be false.

**Key points**
- 3 to 7 bullets, most important first. One idea per bullet, with its numbers and conditions.

**Action items**            ← only if the source asks something of the reader:
- deadlines, assignments, required reading, steps to take. Otherwise omit the heading.

**Open questions**
- What the source leaves unclear, unsupported or unanswered; where it contradicts itself.
- "None found" is a valid answer; do not invent questions to fill the section.
```

Then one line naming the source: title, author or course, date, and length.

**Length.** As short as the source allows; roughly 150–350 words. Fewer key points beats
padded ones: three solid bullets is a complete digest of a thin source. A source with more
than seven important points gets the seven that matter most in full, and one closing line
naming what was left out, offered on request.

**Key points are not a table of contents.** "Lecture 3 covers caching" lists a heading;
"Caching cuts read latency from ~100 ns to ~1 ns when the working set fits in L1" says
something. Write the second kind.

**Slides and transcripts.** Slides compress; a bullet on a slide is often a fragment whose
meaning came from the lecture. Report what the slide supports and mark the gap ("the slide
lists X without explaining it") instead of supplying the explanation yourself. Inconsistencies
inside the source (two different dates for one event, a total that doesn't add up) go under
Open questions.

<!-- iclaw:reader-rules sha=d0297cb46c86 -->
## Reader rules

These apply to everything this skill writes for the user to read.

- **Idea first, then the name.** Say what a thing does or means in plain words, then give
  its real term. Skip the explanation for a term already listed in the project's
  `_canon/vocab.md`.
- **Plain wording, same claim.** Make the sentence easier, never the statement weaker,
  stronger or broader. If plainer wording would lose precision, keep it plain and add a
  short caveat.
- **Keep what carries weight.** Every number with its unit and comparison point, every
  threshold, every scoped condition ("for English only", "on this benchmark") and every
  warning survives. Cut explanation before you cut any of these.
- **One technical term per sentence.** A sentence carrying two or more is split.
- **Nothing the source does not say.** Your own inference is marked in the sentence
  itself ("this suggests", "I'd guess"). Where the source is unclear or silent, say so
  rather than filling the gap.
- **Never from memory.** If the source cannot be read, say which part failed and ask for
  another copy. A fluent summary of something not actually read is the worst outcome.
<!-- /iclaw:reader-rules -->

## Output

Write the digest in the conversation. Write a file only when asked; then reply with the
TL;DR and where the file went, not the whole digest again.

## In an iclaw project

When the working folder has a `CLAUDE.md` with a `project:` field, the digest also
leaves a record. Without one, skip this section entirely; the skill works the same.

1. **Respect the project's own rules first.** `## This project only` in `CLAUDE.md` may limit
   what an agent processes (for example, a course whose slides are not to be read whole).
   It overrides this skill.
2. **Session log.** If an `iclaw:project-memory` session is open, add the source under
   `## Files Touched → Consumed`. If none is open, invoke `iclaw:project-memory` to orient
   first, unless the user asked for a one-off answer.
3. **Corpus row.** If the project has `_canon/corpus.md`, add one row for the source,
   following that file's own schema and entry threshold. For a non-paper source, use a
   short slug as the citekey, the file path as the id, and the kind of source (lecture,
   transcript, article) as the venue. If the project has no `_canon/`, say so in one line
   and ask whether to enable it; do not create it unasked.
4. **A file, if asked for,** goes through `iclaw:project-artifacts` like any other output.
