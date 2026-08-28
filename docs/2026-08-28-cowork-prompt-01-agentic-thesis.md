# Cowork Project Prompts — `01_agentic_thesis`

> **Status: executed 2026-08-29 in Claude Code.** `01_agentic_thesis` and its
> `01_evaluation-moderators` branch exist and validate; Step C is done. Kept as the
> record of what was seeded and why. Re-run only to rebuild from scratch.

**Two prompts, used once each, in order.** Neither is an orientation prompt — orientation
runs automatically every session via `iclaw:project-memory` and needs no input from you.

| | Paste | Creates |
|---|---|---|
| **Prompt A** | When you first create the project | `01_agentic_thesis` — the reusable research instrument |
| **Prompt B** | Immediately after A completes | `01_agentic_thesis/01_evaluation-moderators` — this thesis instance |
| **Step C** | After B | Copies 29 staged files into place |

The split follows the project's own framing, recovered from its sealed record: artifacts
divide into **system-level** (portable to any future thesis) and **instance-level** (this
thesis's topics and corpus). The deadline, the candidate titles, and the empirical findings
are all instance-level and belong in the branch, not the root.

Markers: `[confirmed]` = decided by Kyle, recovered from the record. `[proposed]` =
reconstructed during migration, **not yet approved**. `[open]` = needs a decision.

---

## Precondition — check before pasting anything

**These prompts require the `iclaw` plugin.** They name three skills —
`iclaw:project-init`, `iclaw:project-memory`, `iclaw:project-artifacts` — and
deliberately do not restate what those skills do. The protocol lives in the skills,
not here.

**Verify first.** Ask the session: *"Do you have the `iclaw:project-init` skill?"*

| Answer | Action |
|---|---|
| Yes | Paste Prompt A |
| No | **Stop. Do not paste.** |

Pasting without the skill is the failure mode worth guarding against: the session
will improvise a structure that looks right — a memory folder, some markdown, a
sensible-seeming layout — but is not the protocol. Nothing will error, and the
divergence surfaces weeks later as memory that quietly does not work.

**If the plugin cannot be installed in Cowork** — most likely because the repo is
private and Cowork cannot authenticate — then create the project in **Claude Code**,
where the plugin is installed and enabled, and point Cowork at the finished folder
afterward. The project is plain files on disk; only the scaffolding step needs the
skill, and nothing downstream cares which client produced it.

---
---

# PROMPT A — the root project

**First: if you do not have the `iclaw:project-init` skill, stop and tell me so. Do
not improvise a project structure — an approximation of this protocol is worse than
nothing, because it fails silently.**

Create a new iclaw project using `iclaw:project-init`.

**Identity**
- Number and name: `01_agentic_thesis`
- Location: workspace root
- Profile: `research`
- Canon: enabled (`_canon/`)
- Protocol: `iclaw/1.0.0`

This is a **re-creation**. Its predecessor ran 2026-08-02 to 2026-08-25 under the retired
v2.0.0 architecture and was deleted after its record was mined. Seed `LONGTERM.md` and
`_canon/vocab.md` from the content below rather than from an empty template. Do not create
a session log — I will start work separately.

## Purpose

A **reusable research instrument**: a systematic method for augmenting LLM use to
*generate* and *develop* candidate thesis topics across varied subject matter. The method
outlives any single thesis. `[confirmed]`

- The graduation thesis is the **first instance** run through the system, not the system's
  purpose. It lives in a branch, not here. `[confirmed]`
- Subject is fixed: **evaluation**. `[confirmed]`
- Artifacts divide into **system-level** — rules, templates, relation vocabulary, rubrics,
  ingestion config, portable to any future thesis — and **instance-level**, which belongs
  to a branch. This project holds only the former. `[confirmed]`
- Mechanism: a **root layer** — ongoing discussion of the field plus one shared corpus —
  with **topic branches** spun off as candidate directions emerge. `[confirmed]`

## Objectives — system-level only

- [x] Define the paper→topic linkage convention: typed, weighted edges over a central corpus
- [x] Define the topic-branch pattern
- [ ] **Decide the corpus format** — how a paper is stored, indexed, and cited. Constrained
      by the 2026-08-08 graph discussion: any format must support **paper→paper** edges,
      which the six-column edge record does not. Open six sessions; corpus still empty
- [ ] Design the **ingestion mechanism** — a recurring literature sweep. Escalated
      2026-08-08 to the most costly open item. **Nothing is scheduled. Do not schedule
      anything without direction.**
- [ ] Define the summarization rubric. Kyle: undecided, future work. **Do not invent one**
- [ ] Write the generator script for source views and diagnostics — blocked on corpus format
- [ ] Extend `_canon/vocab.md` beyond the migrated seed

Two predecessor objectives are void: *two-tier memory routing* (iclaw v3 resolves it — scope
is asked only for branched projects, and session logs never split) and *migrate
`03_grad_thesis` in as a topic branch* (`03_grad_thesis` was deleted 2026-08-28).

## Durable decisions — system-level only

| Date | Decision | Marker |
|---|---|---|
| 2026-08-02 | Subject fixed: evaluation. Topic left open | `[confirmed]` |
| 2026-08-25 | **The recurring method, named:** *a published null is a marginal over a moderator nobody conditioned on.* Four independent instances identified — this is Kyle's method, not coincidence | `[confirmed]` |
| 2026-08-02 | Synthesis is organized **by claim, not by paper**. Each section is a proposition the field holds; papers attach as citekeys. A paper agreeing with an existing claim adds a citation, not a paragraph — growth stays sublinear and the document reads as an argument | `[confirmed]` |

## `[TBD]` register

| Item | Waits on | Marker |
|---|---|---|
| Corpus format — must support paper→paper edges | Kyle's corpus-format discussion | `[open]` |
| Summarization rubric | Kyle; flagged as future work | `[open]` |
| Ingestion mechanism and cadence | Field scope decision | `[open]` |
| Generator script | Corpus format existing | `[open]` |

## `_canon/vocab.md` seed

All `[confirmed]` unless noted — these were settled conventions.

**Citekey** — `firstauthorYYYYkeyword`, lowercase, ASCII-folded, no punctuation. The join
key across every corpus record. Example: `li2026harness`.

**Paper identity** — resolves in strict order: DOI → arXiv ID → normalized `title + year`.

**Provenance markers** — `[ADV]` from the advisor's stream, where any date shown is the
**send date**, not publication date · `[SCAN]` from the project's own sweep · `★` priority read.

**Metadata authority** — metadata read directly off a paper is primary source; metadata
resolved by search is marked `[resolved]`. Preprints are provisional unless a venue is
stated. **Never assert a venue, author list, or identifier that was not verified.**

**Relation vocabulary** (paper ↔ topic, closed set) — `foundational` (topic builds on it;
removing it changes the topic) · `rival` (may already occupy this ground — novelty threat) ·
`method` (technique borrowed, findings irrelevant) · `context` (situates, not load-bearing) ·
`contradicts` (cuts against a claim the topic makes) · `data` (source of a dataset or benchmark).

**Edge weight** — `1` peripheral · `2` supporting · `3` load-bearing.

**Promotion tiers** — `1 encountered` (index row only) · `2 triaged` (+ ≥1 edge) · `3 read`
(+ reading notes) · `4 cited` (+ BibTeX entry).

**Corpus diagnostics** `[provisional]` — two topics sharing >60% of their weight-3 papers
flag for merge review; a paper with edges to ≥3 topics is auto-promoted to must-read. Both
are **diagnostics to surface, not actions to take** — report and let Kyle decide.

## Where the corpus lives `[proposed]` — confirm or replace

The predecessor used a dedicated `_library/` with `pdf/`, `txt/`, `notes/`. That folder
scheme was retired; iclaw v3 gives each scope only `input/` and `output/`.

- **PDFs and raw papers → `input/`.** User-owned, never deleted by the agent, and papers
  are user-supplied. This matches `input/`'s actual semantics.
- **Extracted plaintext → `output/`,** under the artifact naming convention. Agent-produced
  and regenerable.
- **Index and edge graph → `_canon/`.** Canonical records, looked up mid-task, authoritative
  when they disagree with general knowledge.

The unresolved constraint stands regardless of folder choice: the format must support
**paper→paper** edges.

## Behavior

Start from the iclaw skeleton, then apply:

- **Language.** Every session starts in **English**. If I toggle to Korean, hold Korean for
  the rest of that session until I toggle again. A new session resets to English. **Do not
  record the current language anywhere** — recording it is what would make it persist.
- **Memory is always English** — `LONGTERM.md`, `STATE.md`, and session logs, regardless of
  what language the session ran in. `_canon/` follows the domain's own language.
- **`[TBD]` discipline.** Corpus format, summarization rubric, and ingestion are
  deliberately deferred. **Stop and ask. Do not infer the missing rule and proceed.**
- **Agent-derived claims are `[proposed]`.** Never mark anything `[confirmed]` — that
  marker is mine alone.
- **Confidence scoring** on factual claims, recommendations, and inferences. Scope the
  score when a response mixes analysis with drafting.

Show me the tree and the seeded `LONGTERM.md` before doing any work.

---
---

# PROMPT B — the thesis branch

Run only after Prompt A completes.

**If you do not have the `iclaw:project-init` skill, stop and tell me so. Do not
improvise the branch structure.**

Using `iclaw:project-init` in **branch** mode, create a branch inside `01_agentic_thesis`.

**Identity**
- Number and name: `01_evaluation-moderators` `[open]` — provisional. This is the first
  instance run through the instrument. I am holding two candidate titles that share no
  corpus, code, or literature; rename this branch once I choose.
- Profile: `research`
- Canon: **disabled** — the root's canon governs. Do not create a second vocabulary file.

Seed `LONGTERM.md` and `STATE.md` from below.

## Purpose

The graduation thesis: the first instance run through the `01_agentic_thesis` instrument.
Subject is evaluation; the specific title is not yet fixed.

## Objectives

- [x] Screen candidate topics against the three criteria — 14 screened, shortlist of four fixed 2026-08-16
- [x] Produce the crossover map — seven recombinations
- [x] Write X1 + X2 as a single experiment
- [x] Gate G1 — corpus audit. **Passed with a finding**
- [x] Gate G2 — decision legibility. **Passed on a code read**; the full contingency is already recorded, so no instrumentation is needed
- [~] Choose between the two candidate titles
- [ ] Close the fork: candidate A as thesis, or as a boundary chapter
- [ ] Clear the verification debts
- [ ] Commit to 31 October or 30 November

## Durable decisions

| Date | Decision | Marker |
|---|---|---|
| 2026-08-25 | Deadline window **October–November 2026** | `[confirmed]` |
| 2026-08-25 | Bubble topic revived and **reframed as forecasting** — prediction has ground truth, it merely arrives later, which repairs the original kill | `[confirmed]` |
| 2026-08-25 | **Two titles held simultaneously**, with the caveat that they share no corpus, code, or literature and cannot be worked concurrently | `[confirmed]` |
| 2026-08-25 | Corpus finding becomes Chapter 0 plus a standalone short paper — later qualified, since it goes off-domain if the thesis topic moves | `[provisional]` |

### Results in hand

Three findings produced 2026-08-25, each requiring no additional inference:

1. **The corpus confound.** SRA-Bench gold skills state when they apply 7.7% of the time;
   distractors 39.9%. Six topic-free surface features separate the classes at AUC 0.905.
   The wrong skills advertise applicability and the right ones do not — an alternative
   explanation for the paper's headline behavioural finding, which the paper does not address.
2. **SDT decomposition of the published table.** Seven of eight models sit in a null band on
   sensitivity (|d′| < 0.16) while criterion spans −0.76 to +1.259. The field's statistic
   manufactures differences where none exist and is blind to the axis carrying the variation.
3. **Engagement/selection decomposition.** `P(gold|load)` = 0.827 but recall = 0.305, with
   63.1% of needed instances receiving nothing. Selection is largely solved; engagement is not.

### Corrections to the record — carry these forward

- **The re-ranking prediction was wrong.** A low Kendall τ was predicted between Δ-load and
  sensitivity orderings; computed τ = **0.837**. The re-ranking argument is demoted; the
  criterion decomposition replaces it as the headline.
- **The cost estimate was overstated.** Recomputed from token counts, the full grid runs
  **$30–60 on a small model**. The expense was never the topic — it was the assumption that
  frontier models were required.

## Current state — seed `STATE.md` from this

Predecessor sealed 2026-08-25. The project has stopped generating candidates and started
producing results. Two candidate titles are specified in enough detail to take to the
advisor; Kyle is reading five orientation papers before choosing.

**Open threads**

1. **31 October or 30 November** — Variant B kills the bubble corpus, Variant A keeps it.
   Highest-value open decision. `[open]`
2. **Which title is the thesis** — pending the five orientation papers. `[open]`
3. **The fork** — candidate A as thesis versus as a boundary chapter. Not closed. `[open]`
4. **Verification debts** — read SRA §4–§5 directly; confirm `Gold Load` semantics against
   the 23% multi-gold instances; **confirm the paper does not already discuss the style
   confound — the novelty claim rests on this one.** `[open]`

**Do not repeat**

- Do not re-run occupancy-checking as a route to results. Three sessions spent on it
  produced nothing; the three findings above came from a different approach entirely.
- Do not revive the re-ranking argument. It was tested and demoted (τ = 0.837).
- Do not assume frontier models are required for the prediction grid.

---
---

# STEP C — stage the files in

29 files are held at `D:\00_iClaw\_seed_agentic_thesis\`. Copy them in after both projects
exist. None of this can be carried by a prompt.

| From | To | Count | Note |
|---|---|---|---|
| `output\` | `01_agentic_thesis\01_evaluation-moderators\output\` | 18 | Instance-level research. Keep date folders and `_manifest.md` intact; the naming already matches iclaw v3 |
| `discussions\` | `01_agentic_thesis\output\2026_08_02\` and `...\2026_08_05\` | 6 | Field-level, pre-topic. Re-slug to `{nn}_discussion-{topic}_v1.md` and add manifest rows |
| `legacy_memory\` | `01_agentic_thesis\_memory\legacy\` | 4 | **Not `sessions/`.** Their filenames are `{date}_memory.md` and their frontmatter predates `protocol`/`n`, so they fail the session naming check — and they are `끝`-sealed, so renaming or reformatting them to fit is exactly the repair the drift rule forbids. They sit beside `sessions/`, intact |
| `LEGACY_directive_v0.2.0.md` | `01_agentic_thesis\output\2026_08_02\` | 1 | The predecessor's own directive, kept as a record of what v3 replaced |

`03_corpus-audit-script_v1.py` reproduces every number in the corpus audit and takes an
SR-Agents clone as its argument — the most reusable artifact in the set.

After copying, run:

```bash
bash D:/00_iClaw/00_parent/scripts/validate_project.sh D:/00_iClaw/01_agentic_thesis
bash D:/00_iClaw/00_parent/scripts/validate_project.sh D:/00_iClaw/01_agentic_thesis/01_evaluation-moderators
```

Both must report `OK`. Then confirm nothing is marked `[confirmed]` that these prompts did
not already mark that way.
