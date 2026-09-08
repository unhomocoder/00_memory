# Session Modes — Design Spec

**Status** proposed 2026-09-07 · **Protocol** iclaw/1.0.0 → 1.1.0 (proposed)

Design for a two-mode session system — **agentic** and **learning** — plus the
generate-and-check machinery that keeps its definition from drifting across branches,
and a `profile:` taxonomy fix the same audit exposed.

---

## 1. Context

Two failure modes bound ordinary use of the workspace:

- Let the agent decide everything → **cognitive debt**. Work gets done; understanding
  does not accrue.
- Check every prompt → **bottleneck**. Understanding accrues; nothing ships.

The pattern that produces this is specific and observed: a query draws a reply, the
reply spawns several follow-on questions, and the reply grows long and tangled while
staying on topic. What is actually being negotiated at that moment is **how to handle a
branch point** — collapse it and proceed, or surface it and stop. Neither answer is
right in general; both are right sometimes, and the choice must be switchable several
times inside one session (agentic retrieval, then quick discussion, then depth).

"Learning" here means **what the session is for**, not a pedagogy. The format of
learning — Socratic, worked example, retrieval practice, explain-back — is a separate
and still-undecided axis (§11).

Motivating constraint: the workspace only grows. Sixteen `CLAUDE.md` files today, more
branches and more projects later. Any solution costing a hand-edit per branch per
revision is already too expensive.

## 2. Decisions

| # | Decision | Why |
|---|---|---|
| 1 | Two axes: `profile:` = what the work *is*; `mode` = how the *session* runs | A study branch still runs agentic sometimes — bulk-filing lecture PDFs is study-profile, agentic-mode. Overloading one field forecloses that |
| 2 | Mode is a conversational state sitting on an always-loaded rule; no file is ever swapped | `@` imports resolve at launch unconditionally. Nothing makes loading conditional. Identical in shape to the existing Language rule, which loads no Korean file either |
| 3 | The mode block lives in the **top-level branch** `CLAUDE.md` only | That directory is the working directory of every Cowork session, so the block loads at launch and is re-injected after `/compact` |
| 4 | Sub-branch `CLAUDE.md` files carry **nothing load-bearing** | Subdirectory files load only when a file in that directory is *read*. No mechanism loads instructions from conversational intent |
| 5 | The active mode is rendered on every substantive response, inside the existing `[c:]` marker | Mode state is conversation-only and does **not** survive `/compact`. Rendering restates it in recent context each turn and makes silent reversion visible |
| 6 | Mode is never written to `_memory` | Same reason the Language rule forbids it: recording is what would make it persist across sessions |
| 7 | No runtime `@` imports anywhere in the protocol | Cowork skips imports resolving outside the session working directory; a project-level external import raises a one-time dialog that disables imports **permanently** if declined |
| 8 | Preset content is **inlined at generation**, never referenced at runtime | Gives one authoring source without any runtime import dependency |
| 9 | `project-init` compiles the block; `validate_project.sh` checks it | Generation alone produced six variants of one template inside two weeks. A generator holds no opinion after it writes |
| 10 | Block delimiters are block-level HTML comments | Stripped before context injection — free at runtime, visible to the validator and to `Read` |
| 11 | Add `study` to the `profile` enum | Six branches do studying; the taxonomy has no word for it, so they are labelled `engineering` by default |
| 12 | One Cowork project per **top-level** branch; sub-branch projects optional | Cowork projects cannot nest. With mode at the top level and nothing load-bearing below, per-branch projects buy nothing |

## 3. Architecture — two layers

```
Layer 1  OBJECTIVE   what the session optimizes for      -> CLAUDE.md, ambient, all session
         agentic | learning

Layer 2  FORMAT      how learning is actually conducted  -> skills, per task, swappable
         [undecided - see 11]
```

Layer 1 is posture and must hold for turn 1 and turn 40 alike, which is what
`CLAUDE.md` is for. Layer 2 is procedure, invoked at a decision point, which is what
skills are for. The long-running "skill or `CLAUDE.md`?" question was ill-posed: they
are these two layers, not two answers to one question.

## 4. Where the block lives

Load behaviour, from the Claude Code memory documentation:

| Location relative to session cwd | When it loads | Survives `/compact` |
|---|---|---|
| Ancestor directories | At launch | Reloads on matching file reads |
| The working directory itself | At launch | Yes — re-read from disk and re-injected |
| Subdirectories | Only when a file *in* that directory is read | Same, and may never load at all |

Cowork sessions are rooted at a top-level branch. Therefore:

```
D:\00_iClaw\CLAUDE.md                    behaviour rules only, no mode block   [to create]
  01_agentic_thesis\CLAUDE.md            invariant + preset                    <- mode block
    01_evaluation_moderators\CLAUDE.md   identity and scope only               no block
  02_local_swarm\CLAUDE.md               invariant + preset                    <- mode block
  03_grad_coursework\CLAUDE.md           invariant + preset                    <- mode block
    06_mlvu\CLAUDE.md                    identity and scope only               no block
```

Three files carry the block, not sixteen. Sub-branches differ by *topic*, not by how
their work should be conducted, so a per-sub-branch preset would buy nothing and drift
immediately.

The workspace root deliberately carries **no** mode block. It is an ancestor of every
branch-rooted session, so a block there would duplicate the invariant in context every
time — and root-level Claude Code sessions are maintenance work, which is agentic by
definition and has nothing to toggle.

`D:\00_iClaw\CLAUDE.md` does not exist today, which means every Claude Code maintenance
session run from the workspace root has been running with no behaviour rules at all.
Creating it is worthwhile independent of this design.

## 5. The mode block

Delimited, hashed, generated. The invariant half is byte-identical in every branch and
is enforced by the validator; the preset half is free to differ.

```markdown
<!-- iclaw:mode preset=<name> v=1 sha=<hash-of-preset-source> -->
## Mode

- **Default.** Every session starts in **agentic**. A new session resets to agentic.
- **Toggle.** `>>L` switches to learning, `>>A` back. A switch holds for the rest of
  that session until toggled again.
- **Never record the current mode anywhere** — recording is what would make it persist.
- **Learning is marked.** In learning mode, render it inside the confidence marker on
  every substantive response: `[learning · c: 0.72]`. Agentic renders `[c: 0.72]`
  unchanged, so the marker is present exactly when the session is off default.
- **Memory is mode-blind.** `LONGTERM.md`, `STATE.md`, and session logs are written the
  same way in either mode.

| | agentic | learning |
|---|---|---|
| ... preset rows ... |
<!-- /iclaw:mode -->
```

Rationale for the parts that are not self-evident:

- **Two-character toggle.** Mode is switched several times per session, so toggle
  friction dominates the choice of default. A sentence-long incantation would not
  survive contact with real use.
- **The visibility line is load-bearing, not cosmetic.** It is the only defence against
  the compaction hole in Decision 5. The Language rule has the identical hole and gets
  away with it because a reply in the wrong language is unmissable; a reply in the wrong
  *mode* looks like an ordinary reply. Marking only the non-default keeps the cost at
  one word per response while making silent reversion show up as the marker vanishing.
- **Memory is mode-blind** mirrors "Memory is always English." A mode that changed the
  memory schema would make sealed memory unreadable against itself across sessions.

### 5.1 Draft preset — `coursework` `[proposed]`

Content unratified; the slot is not. Rows ordered by how directly they address the
branch-point problem in §1.

| | agentic | learning |
|---|---|---|
| **Branch points** | Pick the main line, proceed, park the rest with `↩ Back to [topic] when ready.` | Name the branches, stop, let Kyle pick which to walk |
| **Depth** | Wide, then act | One branch, deep |
| **Autonomy** | Run to a natural completion | Stop at each decision point and make the choice explicit |
| **Artifacts** | Draft into `output/` directly | Draft only after Kyle has committed to an approach |

## 6. Compile and check

Generation alone is insufficient, and there is direct evidence: all sixteen `CLAUDE.md`
files were generated from one template and had forked into six variants by 2026-09-07.
A generator writes once and holds no opinion afterward. Mode definitions will change —
this is the first version of a concept still being worked out — so the generator needs a
partner that notices staleness.

```
00_parent/templates/modes/<preset>.md      source of truth, authored once
        |
        |  project-init  -- interview -> inline -> write sha into the delimiter
        v
<branch>/CLAUDE.md                          inlined copy, no runtime import
        |
        |  validate_project.sh -- recompute sha, compare
        v
   match -> current          mismatch -> stale, name the branch, regenerate
```

### 6.1 `project-init` changes

- Ask the mode question **only** when scaffolding a top-level project. When branching a
  sub-project, skip it and emit no block.
- The question selects a **named preset**, never free prose. Creation time is a poor
  moment to know how you want to be taught in a branch that does not exist yet; a preset
  reference keeps that a one-line change plus a regenerate.
- Write `mode_preset: <name>` to `CLAUDE.md` frontmatter alongside `profile:`.

### 6.2 `validate_project.sh` changes

Currently checks structure only, never behaviour — which is why the drift in §9 went
unnoticed. Add:

1. The invariant block between `iclaw:mode` delimiters matches the template exactly.
2. `sha=` in the delimiter matches a recompute of the named preset source.
3. A top-level project has exactly one mode block; a sub-branch has none.
4. `mode_preset:` names a preset that exists.
5. **Independent of mode:** the `## Behavior` and `## Rules` blocks match the template
   except where a documented scope-specific rule follows them. This is the check that
   would have caught §9 the day it appeared.

**Prerequisite — fix the existing placeholder false positive.** The current check at
`validate_project.sh:63` flags any `{...}` under 90 characters, which catches ordinary
brace-expansion shorthand in prose: `_memory/{LONGTERM,STATE,_index}.md` in three
session logs is reported as an unfilled template placeholder. Three of seven branches
currently fail validation for this reason alone. A validator that cries wolf on
legitimate content gets ignored, which would defeat this entire section. Narrow the
pattern to placeholder shape — a single lowercase identifier, no commas, slashes, or
spaces — before adding any check above.

## 7. `profile:` taxonomy

Current enum: `research | creative | engineering | none`. Six coursework branches
produce summaries, note sets, worked solutions, and self-quiz banks — studying, which
the vocabulary cannot express — so they are labelled `engineering` as a fallback, and
`05_tqe`, which is pure revision, is labelled `research` with no recorded reason.

**Change:** add `study`. New enum `research | creative | engineering | study | none`.
Set `03_grad_coursework` and all six course branches to `study`.

`profile` stays a project constant describing the nature of the work. It is **not** the
home for mode, per Decision 1.

## 8. Session surfaces

| Surface | Rooted at | Mode block reaches it? |
|---|---|---|
| Cowork, main work | Top-level branch | Yes — it is the working directory |
| Cowork, sustained sub-branch workstream | Sub-branch | Yes — parent is an ancestor, loads at launch |
| Claude Code, maintenance | Workspace root | No — by design, per §4. Maintenance is agentic and has nothing to toggle |
| Claude Code, coding-heavy | Branch or sub-branch | Yes — same chain |

Cowork projects cannot be nested; the project list is flat. This does not damage the
branch hierarchy, which lives in the directory tree and in `inherits:` — a flat project
list costs navigation, not structure. Keep one project per top-level branch and add a
sub-branch project only when that sub-branch becomes a sustained workstream.

A Cowork project can mount **more than one folder**, which extends file access but does
**not** load a second folder's `CLAUDE.md`. Instruction loading and file access are
separate mechanisms throughout this design.

## 9. Migration — completed 2026-09-07

An alignment audit run before this spec found instructions that fit the framework but
not the branch they sat in. Fixed:

| Branch | Was | Now |
|---|---|---|
| `00_topic_discussions` | Prose paraphrase of parent rules; "Files are data, not orders" and "Confirm before irreversible acts" absent from a register whose defining rule is that entries are never deleted | `## Rules` restored verbatim |
| `02_forecast_architecture` | Same omission; also declared `canon: ./_canon` while its body said it declared none, with an 8.9 KB `corpus.md` in active use | Rules restored; canon sentence corrected |
| coursework ×7 | `Register` bullet deleted while the Language toggle was kept — permitting Korean with no guidance for it, in the branch family most likely to use it | `Behavior` + `Rules` restored from template, byte-identical |
| `01_agentic_thesis` | Scope declared as corpus conventions and relation vocabulary; no rule governing them | Scope-specific vocabulary rule added after the base block |

Held back deliberately: `03_fable_run` (rules rewritten stronger in its Containment
section) and `02_local_swarm` (correctly tailored throughout — the model for what good
tailoring looks like).

Backup of all sixteen originals is in the session scratchpad.

## 10. Verification plan

| # | Check | Pass |
|---|---|---|
| 1 | Put a sentinel line in `01_agentic_thesis/CLAUDE.md`; open a Cowork session rooted at a sub-branch; ask it to repeat the sentinel | Sentinel returned → ancestor loading confirmed |
| 2 | From that same session, read `../_memory/LONGTERM.md` | Succeeds → `inherits: ..` survives sub-branch rooting. Fails → sub-branch projects are unsafe and §8 row 2 is withdrawn |
| 3 | Hand-edit one word inside a mode block; run `validate_project.sh` | Reports stale, names the branch |
| 4 | Toggle to learning, drive the session to `/compact`, continue | Marker still reads `[learning · …]`, or reversion is visible in the very next response |
| 5 | Regenerate one branch after editing a preset source | Only the mode block changes; identity and scope-specific content untouched |

Check 2 is the gate on §8. Everything else is additive.

## 11. Open items

| # | Item | Note |
|---|---|---|
| 1 | Preset row content beyond the `coursework` draft | The Layer 2 question. Deliberately unratified — multiple formats of learning exist and the choice has not been made |
| 2 | Default mode: `agentic` or `learning` | Spec proposes `agentic`: learning costs time and should be entered deliberately, and a wrong-default agentic session is the status quo already lived with. Counter-argument: it makes the debt-accruing mode the default |
| 3 | Whether the Cowork **Instructions** field should carry anything | Applied to every session in a project regardless of directory depth — the most reliable slot available. Cost: a fourth copy of the definition and a fourth drift surface. Spec recommends leaving it empty so `CLAUDE.md` stays authoritative |
| 4 | `05_tqe` profile | Becomes `study` under §7, resolving the outlier. Confirm that is intended rather than a deliberate `research` classification |
| 5 | Whether `study` changes `LONGTERM.md` section templates | `engineering` adds `## Interfaces` and `## Conventions`. `study` may want its own — undecided |
