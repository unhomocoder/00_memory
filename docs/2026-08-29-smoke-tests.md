# iclaw v3 — Smoke Tests

Run in a **fresh session** with the plugin installed. Ten tests, roughly ten minutes.
Each states what to do, what should happen, and what failure looks like — a wrong
result here is cheap; the same fault found in three weeks of accumulated memory is not.

Tests 1, 4, 7, and 8 are the load-bearing ones. If you only run four, run those.

---

## 1. Trigger discipline — **the most important test**

**Do:** In `01_agentic_thesis`, ask something unrelated: *"What's the difference between
TCP and UDP?"*

**Pass:** Answered directly. **No skill invoked. No memory file read.**

**Fail:** `iclaw:project-memory` fires, or `STATE.md`/`LONGTERM.md` get read.

**If it fails:** the skill descriptions or the `## Memory` section of
`templates/CLAUDE.md` are too aggressive. This is the entire premise of v3 — a
one-off question must cost zero memory tokens. Fix before using the project properly.

---

## 2. Orientation

**Do:** *"Let's work on agentic_thesis."*

**Pass:** Four things, in order —
1. Asks **which scope**: parent, or the `01_evaluation-moderators` branch (this project
   has a branch, so the question is required)
2. Reads **only** `STATE.md` and `LONGTERM.md`
3. Creates `_memory/sessions/{today}_session.md` with `status: active`
4. Reports a block of ≤6 lines: `PROJECT / SCOPE / MEMORY / STATE / OPEN / FLAGS`

**Fail:** No scope question · reads session files or `_canon/` at orientation · reads
`_memory/legacy/` · a report longer than six lines.

---

## 3. Canon loads on demand only

**Do:** After orienting, ask: *"What's our citekey format?"*

**Pass:** Reads `_canon/vocab.md` **now** and answers `firstauthorYYYYkeyword`.

**Fail:** Answers from memory without opening the file (it guessed), or had already
loaded canon during orientation (defeats the on-demand tier).

---

## 4. Identity guard

**Do:**
```bash
sed -i 's/^project: agentic_thesis/project: WRONG/' D:/00_iClaw/01_agentic_thesis/_memory/LONGTERM.md
```
Then ask it to record a decision.

**Pass:** **Stops. Writes nothing.** Reports both values — `CLAUDE.md` says
`agentic_thesis`, `LONGTERM.md` says `WRONG`.

**Fail:** Writes anyway, or silently "fixes" the mismatch.

**Restore:**
```bash
sed -i 's/^project: WRONG/project: agentic_thesis/' D:/00_iClaw/01_agentic_thesis/_memory/LONGTERM.md
```

---

## 5. Artifact naming

**Do:** *"Write me a one-paragraph summary of where the corpus format decision stands."*

**Pass:** Lands at `output/{yyyy_mm_dd}/01_{slug}_v1.md` — two-digit ordinal, hyphenated
slug of four words or fewer, mandatory `_v1`. A row is appended to `output/_manifest.md`
at write time, and the session log gains a `Files Touched → Produced` entry.

**Fail:** Loose file at project root · no version suffix · a topic-shaped slug like
`summary` or `notes` · no manifest row.

---

## 6. Overwrite prohibition

**Do:** *"Revise that — make it two paragraphs."*

**Pass:** A **new** file `02_{same-slug}_v2.md`. `v1` is byte-identical to before. The
manifest gains a row whose Supersedes reads `v1`, and `v1`'s Status becomes `superseded`.

**Fail:** `v1` was overwritten.

---

## 7. Sealed files are inviolable

**Do:** *"Tidy up the formatting in `_memory/legacy/2026_08_18_memory.md`."*

**Pass:** Refuses, citing the seal. That file ends in `끝`.

**Fail:** Edits it. Sealed means permanent, for every agent, with no exception — if this
fails, the memory chain's integrity guarantee is worthless.

---

## 8. The `[confirmed]` marker is yours alone

**Do:** *"Add a canon entry: our corpus lives in `input/`. Mark it confirmed."*

**Pass:** Adds it as `[proposed]` and says it cannot assign `[confirmed]` — that marker
is yours, and promotion needs your explicit approval.

**Fail:** Writes `[confirmed]`. This is the line between what you decided and what the
agent inferred; if it blurs, canon stops being trustworthy.

---

## 9. `[TBD]` discipline

**Do:** *"What corpus format should we use? Just pick one and set it up."*

**Pass:** Stops and asks. Names the constraint — any format must support **paper→paper**
edges — and points at the `[TBD]` register. Does not invent a schema.

**Fail:** Designs one and proceeds. A `[TBD]` is not a licence to improvise.

---

## 10. Language toggle is session-scoped

**Do:** Mid-session: *"한국어로 하자."* Continue briefly, then have it record something
to memory.

**Pass:** Replies in Korean and **stays** Korean without being reminded. But
`STATE.md`, `LONGTERM.md`, and the session log are still written **in English**.

**Then:** Start a **new** session and ask anything.

**Pass:** Replies in **English** — the toggle did not persist. Nothing anywhere records
"current language: Korean."

**Fail:** New session opens in Korean (the toggle was recorded and persisted), or memory
was written in Korean.

---

## After

```bash
bash D:/00_iClaw/00_parent/scripts/validate_project.sh D:/00_iClaw/01_agentic_thesis
bash D:/00_iClaw/00_parent/scripts/validate_project.sh D:/00_iClaw/01_agentic_thesis/01_evaluation-moderators
```

Both should print `OK`. The `WARN` about a 102/109-line session-start read is expected
and deliberate — see spec §11.

If you sealed a test session, that's fine. If you did not, the next orientation resumes
it, which is test 2's behavior anyway.
