---
name: paper-digest
description: In-depth study guide to one academic paper for a non-expert reader — big idea, research questions, method, evaluation, findings with exact numbers, a glossary and where to look in the PDF; skips the abstract and introduction. Use when asked to break down, explain in depth or help understand a paper. For a short summary of any source, use digest.
---

# Paper Digest

Turn a research paper into a study guide for someone who is smart but **not an expert in this
subfield** — think a strong undergraduate who has taken the foundational courses but has never
read this literature.

## The premise that shapes everything

**The reader has already read the abstract and the introduction.** They do not need those
summarized. They came here for the parts that are slow: the method, the experiments, the
evaluation, and the vocabulary that makes all three hard to parse.

This single fact is what separates a useful digest from a worthless one. A summary that opens by
restating the abstract has spent the reader's attention on something they already have. Every
section below is designed to add something the front matter did not give them.

## Getting the paper

Accepted inputs: a local PDF path, an arXiv URL or bare ID, a DOI, a publisher URL, or pasted
paper text.

**Resolving a link to something readable.** Most links point at a landing page, not the paper.

| You have | Do this |
|---|---|
| `arxiv.org/abs/2401.12345` | Rewrite to `arxiv.org/pdf/2401.12345` and read the PDF. |
| A bare arXiv ID | Same — build the `/pdf/` URL. |
| A DOI | Resolve it; if it lands on a paywall, check arXiv or the authors' page for a preprint. |
| A publisher URL | Try it. Many are paywalled and will return a teaser page that *looks* like content. |
| A PMC / PubMed Central link | Usually has full text; prefer the PDF link on the page. |

A landing page carries the title, abstract, and sometimes the references — never the method. If
that's all you can reach, you cannot write this digest. Say which paper you couldn't get and why,
and ask for a PDF. Filling the gap from the abstract produces exactly the confident-but-hollow
summary this skill exists to avoid.

**Chaining from a literature search.** A search skill typically hands back a list of papers with
links. That list is a set of candidates, not an instruction to digest all of them — each digest is
a real chunk of reading for the user and of work for you. So:

- One or two papers: just do them.
- More than that: show the list with one line each on what it is, and ask which ones they want
  digested. Volunteering "I can digest any of these" is usually the right move.
- Digesting several: keep them separate and consistently structured — the value of a batch is
  being able to compare across them. Write each to its own file (see naming, below) and give a
  short comparison at the end only if the papers genuinely bear on each other.
- **Give every paper its own working directory** for downloads and extracted text. Sharing one
  scratch directory across papers lets intermediates overwrite each other, and the resulting
  failure is nearly invisible: you read a file with the name you expect, containing a different
  paper, and write a confident digest of the wrong work. Isolate first; it costs nothing.
- Treat the search result's metadata as provisional. Titles get abbreviated, years get attached to
  the wrong version, and preprint and published versions differ. What the PDF says wins.

## Output

Write the digest **into the conversation**. Only write a `.md` file if asked — then offer it in
one line at the end ("Want this as a file?").

When a file *is* asked for, write it and reply with the one-sentence takeaway plus where it went.
Don't also paste the full digest into the chat; the reader asked for a file precisely so they
could read it somewhere other than a terminal scrollback.

**Filename, when one is written:** a slug of the paper's own title, lowercased and hyphenated —
`learning-representations-by-back-propagating-errors.md`. The title is what the reader will search
for later, so it beats an author-year code for finding things again.

**Cap the slug at about 60 characters, trimming at a word boundary.** Modern papers carry long
subtitled names, and a full slug can run past 120 characters — which on Windows can push the
total path over the 260-character limit and fail, sometimes silently. The distinctive part of a
title is nearly always at the front, so a clean truncation stays recognisable:
`continuous-improvement-and-parallel-autonomous-exploration.md` beats the full title plus
`-an-llm-agent-framework-for-searching-large-solution-spaces`. If you're working from a
search result and only have a *provisional* title, name the file from that, then rename it once
you've read the paper and know the real one — search results abbreviate and occasionally get
titles wrong. When digesting several papers into the same folder, prefix each with the year
(`1986-learning-representations-...`) so they sort chronologically.

**Length: 1000–1400 words of body for a typical 10–20 page paper. The glossary does not count.**

Be aware of how this budget works, because it is tighter than it looks. The four sections with
stated counts already sum to 750–1000, and the header, research questions and pointers add
roughly another 250. Sitting every section at the top of its band lands you at the ceiling. So
treat the section counts as typical shares, not allowances to spend — **the total governs, and
when they conflict, the total wins.**

If you're over, cut in this order:

1. Explanatory prose in Method and What They Found — the first draft always over-explains.
2. Secondary research questions.
3. Pointers, down to three.

Never cut to fit: a number, a caveat or hedge, a flagged gap, or a glossary entry. Those are the
content; the prose around them is the padding.

Scale the whole thing with the paper. A 5-page workshop paper might warrant 600 words, a dense
30-page one the full 1400. And padding a section the paper barely supports is worse than a short
digest — if a paper runs no baselines, "they ran no baselines" is the complete answer for that
part, not a prompt to write 200 words about its absence.

Use these sections, in this order.

---

### Header

Title, first author + et al., venue, year. Then **one sentence**: if the reader remembers nothing
else from this paper, what is it? Make this sentence carry real content — a specific claim, not
"this paper is about neural networks."

### The Big Idea (100–150 words)

Not a restatement of the abstract. Instead: **what was broken before this paper, and what single
conceptual move fixes it.**

Papers state their contribution in the abstract but bury the *gap* across three paragraphs of
related work. Digging that out is most of the value here. Name it concretely:

- Weak: "prior methods had limitations."
- Strong: "prior methods needed labeled data for every language, which doesn't exist for most of them."

Then the move that closes the gap, in one or two plain sentences.

### Research Questions (3–5 bullets)

The specific questions the experiments are built to answer, phrased as actual questions. Most
papers never state these outright — infer them from what the experiments vary and measure. Mark
which one is primary; the others are usually secondary or robustness checks.

### Method (250–350 words)

What the approach actually *does*, step by step. What makes this section work:

- **Walk one concrete example through the pipeline.** A single worked case builds intuition faster
  than any amount of description. If the paper has a running example, borrow it.

  If you invent the example yourself, **check it against the task definition before you use it.**
  A worked example is the one thing in the digest with no source behind it, so a reader cannot
  catch an error in it — and because it's the passage doing the most teaching, a wrong one
  propagates into everything they build on top. Verify the input really is an instance of what you
  claim (that the "asymmetric" vector is actually asymmetric), and that the arithmetic runs
  through. Borrowing the paper's own example avoids this entirely, which is why it's preferred.
- **Name each component, then say what it is _for_.** "An encoder" is a label; "an encoder, which
  compresses the sentence into a fixed-size vector so the decoder can work with variable-length
  input" is an explanation.
- **Equations only when prose genuinely can't carry the meaning.** If you include one, define every
  symbol in the same breath. An unglossed symbol is where a non-expert reader stops.
- **A worked example or an analogy — pick one, not both.** They do the same job, and running both
  is the single easiest way to blow the word budget while telling the reader the same thing twice.
  A worked example suits a mechanism that's a sequence of steps; an analogy suits one that's
  structurally unfamiliar. If you use an analogy, mark it as one and say where it breaks down — an
  analogy the reader over-extends becomes a misconception.
- **Separate what's new here from what's borrowed.** Readers routinely misattribute standard
  machinery to the paper they happen to be reading.

### How They Tested It (200–250 words)

Four labeled parts:

- **Data** — which datasets, how large, what they contain, why these.
- **Baselines** — what they compared against, and whether those are fair comparisons.
- **Metrics** — every metric named, each with a plain gloss of *what it measures and which
  direction is good*. "BLEU: overlap with a human reference translation, 0–100, higher is better."
  A non-expert cannot read a results table without this, so it is not optional.
- **Ablations / controls** — what they removed or varied to isolate cause.

Two ways this section's shape can mislead you:

- **Much of this lives in figure captions, not the body.** Hyperparameters, sweep counts, training
  set sizes and success criteria are routinely stated only in a caption. Read every caption in
  full before writing this section; a digest built from body text alone will be missing most of
  the experimental detail.
- **Not every paper has baselines or metrics.** Demonstration papers — common for a field's
  founding work — show that something is possible at all, running no competitor and reporting no
  score. Don't force the four headings to produce content. Say plainly that no baseline was run
  and no metric reported, and tell the reader how to read the claim instead: as an existence
  proof rather than a comparison. That framing is worth more to a non-expert than an invented
  evaluation narrative, because it tells them what the paper can and can't be cited for.

If the paper is theoretical with no experiments, retitle this **How They Argued It** and cover the
proof strategy, the assumptions, and what those assumptions rule out.

### What They Found (200–250 words)

- Headline results with **exact numbers, units, and the baseline beaten**: "94.2% vs. 89.7% for the
  previous best," never "significantly better." The number is the finding; a vague paraphrase of it
  isn't.
- Anything surprising, negative, or that didn't work. These are often the most informative results
  and the first thing summaries drop.
- Limitations the paper itself raises.
- Keep a visible line between **demonstrated**, **claimed**, and **speculated as future work**.
  Collapsing those three is the most common way a summary misleads.

### Vocabulary (as many terms as earn a place — up to ~30)

Terms the reader would trip on, in the order they appeared above. Each entry: a plain definition,
then **how this paper uses it specifically**.

> **Ablation study** — removing one piece of a system at a time to see how much it contributed.
> Here, they drop each of the three attention heads separately.

The second half is the part that isn't available from a search engine.

**Be generous here, and don't count this section against the word budget.** The costs are
lopsided: a term the reader already knows costs them a second to skip, or serves as a free check
that their definition matches this paper's usage — while a term you left out costs them a trip
back into the paper, which is the exact thing this digest exists to prevent. So when a term is
borderline, include it.

Generous is not indiscriminate. Terms drawn from the general vocabulary of an educated reader
("dataset", "accuracy", "training") still add nothing. The bar is whether a bright undergraduate
outside this subfield would pause on it — if they would, it belongs.

### Where to Actually Look (3–5 pointers)

The reader's goal is speed, and the fastest read is a good digest *plus* knowing which 90 seconds
of the PDF deserve their own eyes. Point at specific figures, tables, or sections with page numbers
and a one-line reason:

> - **Figure 3 (p. 6)** — the architecture diagram; 30 seconds here clarifies all of §3.2.
> - **Table 2 (p. 8)** — main results; the last two columns are the ones that matter.
> - **§5.3 (p. 10)** — failure analysis, more candid than the conclusion.

**Cite the page numbers printed on the page, not PDF page indices.** These often differ, sometimes
wildly — in the 1986 backprop paper, PDF page 1 is printed page 533. The reader is looking at the
page itself, so the printed number is the one they can act on. If a PDF has no printed numbers,
say you're citing PDF pages so they know which to count.

Short papers and older journal letters often have **no section numbers at all** — just running
prose. Anchor on whatever the reader can actually find by eye: a figure, a numbered equation, a
named subsection, or a position ("the last two paragraphs before the references, p. 536"). An
anchor the reader can't locate is worse than no anchor, so check that each one names something
visible on the page you cite.

---

## Voice

Write for that bright undergraduate. Concretely:

1. Gloss any term outside a general undergraduate curriculum **at first use**, inline. Don't defer
   everything to the glossary — a reader who has to jump down and back loses the thread.
2. Never use notation without naming every symbol.
3. Keep sentences under ~25 words on average. Split any sentence carrying two or more technical
   terms; that's where comprehension breaks.
4. Active voice with named actors: "the authors trained the network on 10,000 examples," not "the
   network was trained."
5. Avoid *novel*, *leverage*, *utilize*, *state-of-the-art*, *significantly*, *robust* unless you
   immediately say against what and by how much. They feel informative and aren't.
6. Never let a section become a re-listing of the paper's own headings.

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

## The accuracy guardrail

**Simplify the language, never the claim.**

The dangerous failure here isn't a digest that's too hard — it's one that's smooth, confident, and
subtly wrong. A reader who knows they're confused will go check. A reader who's been misled won't.

- Quote numbers exactly, with units and comparison point.
- Preserve hedges the authors meant: "on this benchmark," "for English only," "under their
  assumptions." Those qualifiers are load-bearing.
- **When the paper is genuinely unclear, say so.** "The paper doesn't specify how the threshold was
  chosen" is a useful sentence. Smoothing over a gap hands the reader false confidence about
  something the authors themselves left open.
- If a simplification costs real precision, keep the simplification and add a one-clause caveat.

**Never reconstruct a paper from memory.** This is the sharpest edge of the guardrail, because it
bites hardest exactly where it's least visible. Famous papers are the ones most likely to be
scanned, badly OCR'd, or paywalled — *and* the ones you can most easily produce a fluent summary of
without reading anything. A digest written from recall will look completely normal and be
unfalsifiable by the reader, who came to you precisely because they haven't read it yet.

So if ingestion failed, say it failed. "I can't get text out of this PDF — it's a scan and the page
extractor didn't recover it. Can you send another copy?" is a good answer. A confident digest built
on recall is not, no matter how well you think you know the paper.

## Process

1. **Ingest — cheap path first.** For a PDF, just `Read` the whole file with no `pages` argument.
   This renders every page and works even on scans with no text layer, which is what most
   pre-2000 landmark papers are. Start here; it is one call and it usually just works.

   Two things can go wrong, and it's worth knowing which is which:

   - **A page-ranged read fails** (`pdftoppm is not installed`). Only the `pages` argument needs
     that renderer — the whole-file read does not. So this failure is not a reason to go hunting
     for another method. Drop the `pages` argument and read the file.
   - **The whole-file read genuinely fails**, or the paper is long enough that you need page
     ranges. Then use the bundled extractor:

     ```bash
     python <this skill's directory>/scripts/pdf_extract.py <paper.pdf> --outdir <somewhere>
     ```

     The path is relative to this skill's own folder, not your working directory. It writes the
     extracted text to a file and prints that file's path — read the file rather than piping the
     text through your context. Pass absolute paths for the PDF and `--outdir`: on Windows, Git
     Bash refuses to operate in deeply nested directories ("path longer than allowed for a Win32
     working directory"), so `cd`-ing to a scratch folder first can fail outright.

     It prints the text if there's a text layer, and otherwise writes one PNG per page and lists
     them, in page order, for you to read. (Needs `pypdf`; scans also need `pillow`.)

   Resist the urge to build your own extraction pipeline. Decoding a scanned PDF by hand costs
   many minutes and a great deal of context, and on this paper it turned out to be entirely
   unnecessary. Try the plain read, then the script, and only then improvise.

   Then note page count, where your paper actually starts and ends, figures and tables.

   **Check that the title you extracted is the paper you were asked for.** One line, before you
   write anything. Downloads land on stale paths, intermediates get overwritten, a link redirects,
   a shared scratch directory hands you someone else's file — and the result reads perfectly:
   a fluent, accurate, fully-verified digest of the wrong paper. Nothing downstream catches it,
   because every number checks out against the document you actually read. The title is the only
   cheap place to catch this.
2. **Read the abstract and intro anyway.** You won't summarize them, but they tell you what the
   paper thinks it's doing, which is what you'll check the rest against.
3. **Find the real sections.** Method, setup, results, discussion. Papers vary wildly in headings;
   don't assume a standard layout.
4. **Extract before drafting.** Pull a scratch list of claims, numbers, datasets, baselines,
   metrics, and jargon terms straight from the text. Getting a number wrong is the worst failure
   this skill can produce, and it happens when numbers are recalled during drafting rather than
   copied during reading.
5. **Draft** in section order.
6. **Check before sending.** Is every number traceable to a specific place in the paper? Is every
   glossary term actually used above? Does the Big Idea say something the abstract didn't? Would an
   undergraduate stall anywhere?

## Situations worth handling well

- **Paywalled or unreachable.** Say so and ask for the PDF. Never build a digest from the abstract
  alone and present it as the full thing.
- **Survey paper.** Flag it up front; the Method section becomes the taxonomy the authors use to
  organize the field.
- **Very short paper (under ~6 pages).** Compress proportionally. Older landmark papers are often
  4 pages and dense — the glossary and worked example matter more here, not less.
- **Bad OCR or scanned PDF.** Run `scripts/pdf_extract.py` to recover page images and read them
  visually. If a passage is still illegible, name it as illegible rather than reconstructing it.
  Guessing at a mangled equation is how invented content gets in.

- **A journal page holding more than one paper.** Older journals — *Nature* "Letters to Nature" in
  particular — run articles continuously, so the first page of your paper often carries the tail of
  an unrelated one. Find where your paper actually starts before you read, and don't let a
  neighbouring article's references or acknowledgements leak into the digest.
- **Long thesis or dissertation (100+ pages).** Out of scope for this skill. Say so and offer a
  chapter-by-chapter approach instead.

## In an iclaw project

When the working folder has a `CLAUDE.md` with a `project:` field, the digest also leaves a
record. Without one, skip this section; the skill works as described above.

- **The project's own rules come first.** `## This project only` in `CLAUDE.md` overrides
  this skill.
- **Session log.** If an `iclaw:project-memory` session is open, add the paper under
  `## Files Touched → Consumed`; if none is open, invoke `iclaw:project-memory` to orient
  first, unless the user asked for a one-off answer.
- **Corpus row.** If the project has `_canon/corpus.md`, add or update the paper's row under
  that file's schema and entry threshold, with tier `3 read`. Without `_canon/`, say so in one
  line and ask whether to enable it.
- **A file, if asked for,** is named and registered by `iclaw:project-artifacts`, whose naming
  replaces the title-slug filename rule above.
