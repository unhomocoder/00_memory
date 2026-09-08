# Cowork Instructions — one bootstrap, not one per project

**Status** proposed 2026-09-08 · artifact: `templates/COWORK_INSTRUCTIONS.md`

## The question

Every new Cowork project needs something in its *instructions* field. Does each project
need its own text? Does each branch?

**No to both.** Per-project instruction text is a second copy of rules whose source of
truth is `CLAUDE.md`, and the cost of that copy is already on the record: releases 1.5.0
and 1.6.0 each list "**re-paste the Cowork project instructions field**" as a required
migration step. Two of the last three releases. The count only grows — 15 `CLAUDE.md`
files today, one Cowork project per top-level branch under Decision 12 of the
session-modes spec, more later.

What actually varies per project — identity, scope, working folders, scope-specific
rules — already varies in `CLAUDE.md`, which the project owns outright. What does *not*
vary is everything the instructions field was being used for.

So: one bootstrap, identical bytes everywhere, whose only job is to point at
`CLAUDE.md` and refuse to proceed without the skills. Paste once per project, never
again.

## Why one file works at any depth

Checked, not assumed: **all 15 `CLAUDE.md` files carry a full `## Behavior` and
`## Rules` block**, sub-branches included. A branch-rooted Cowork session reading only
the `CLAUDE.md` in its own folder loses nothing — that file is self-sufficient.

Everything else a branch needs is owned by `iclaw:project-memory`, not by the
instructions field:

| Concern | Who resolves it |
|---|---|
| Scope question | Skill — asked only if the folder has `{nn}_` children; a leaf proceeds silently |
| Parent `LONGTERM.md` at orientation | Skill — iff the active scope declares `inherits: ..` |
| Parent vs branch canon conflict | Skill — branch wins, conflict flagged never silently resolved |

So the bootstrap says nothing about any of them. What it *does* say is **do not walk up
the tree on your own initiative** — because 12 of 15 branches declare `inherits: none`,
`03_grad_coursework` recorded that as a `[confirmed]` decision to keep per-course
sessions lean, and a session that helpfully reads the parent anyway defeats it silently.

Note for the session-modes spec: §4's tree annotates sub-branches as "identity and scope
only," which is shorthand for "no mode block." Read literally it is wrong — they carry
the full behaviour block, as §9's own migration row for the coursework branches records.
Worth tightening before that spec is implemented against.

## What this is not

It is **not** "the first session reads `CLAUDE.md` and rewrites the instructions."

Two reasons. First, no tool can write that field — it is UI, pasted by hand, so a
session could only ever *propose* text for a human to paste. Second, and worse: a
session that generated per-project instruction text would manufacture exactly the drift
surface this removes, and would do it with a generator that "holds no opinion after it
writes" (session-modes spec §6). One template forked into six variants in two weeks
under precisely that arrangement.

Realignment happens **by reference, on every launch** — the session reads the current
`CLAUDE.md` — not by rewriting anything. The bootstrap adds a refusal gate so a session
that cannot see `CLAUDE.md` or the skills says so instead of improvising.

## Open — does Cowork load `CLAUDE.md` from disk?

The two most recent documents in this repo contradict each other, and this has never
been tested.

| Source | Date | Claim |
|---|---|---|
| `CHANGELOG.md`, rows 1.5.0 and 1.6.0 | 09-04, 09-07 | "Cowork reads that field, not `CLAUDE.md` on disk, so it does not inherit this" |
| `docs/specs/2026-09-07-session-modes-design.md` §4, §8 | 09-07 | Cowork sessions are rooted at the top-level branch, so its `CLAUDE.md` loads at launch and is re-injected after `/compact` |

The spec's own §10 check 1 is the resolving test — sentinel line into a branch
`CLAUDE.md`, open a Cowork session, ask it to repeat the sentinel — and no session log
records it being run.

**The bootstrap is written to hold either way.** It instructs an explicit read of
`CLAUDE.md` rather than assuming an injection. If Cowork auto-loads, the read is a cheap
redundant file read. If it does not, the read is what puts the rules in context at all.

But the answer matters well beyond this file. If the CHANGELOG row is right, then the
1.6.0 in-place patch of all 15 `CLAUDE.md` files reached Claude Code sessions only, and
every Cowork session since has been running whatever text was last pasted — including
the six coursework branches whose `Register` rule was restored in 1.5.0. Run the
sentinel test before trusting that those fixes landed.

## Adoption

1. Paste `templates/COWORK_INSTRUCTIONS.md` (everything below its rule) into each Cowork
   project's instructions field, replacing what is there.
2. Run the sentinel test above. Record the result in `_memory`.
3. Leave `docs/2026-08-29-cowork-project-instructions-01-agentic-thesis.md` and
   `docs/2026-09-03-cowork-project-instructions-02-local-swarm.md` in place until step 2
   resolves. If Cowork does not load `CLAUDE.md`, they are still the fallback; if it
   does, mark them superseded then.

## Follow-ups, not done here

- **Fold the four standing constraints into `templates/CLAUDE.md`.** `Nothing is
  scheduled`, `never modify 끝`, `do not seal unprompted`, and `you may never assign
  [confirmed]` live only in Cowork instruction text today. Moving them makes the
  bootstrap pure delegation and removes the last reason it would ever change — at the
  cost of a version bump and a patch across 15 files.
- **Have `project-init` hand the file over.** One line at the end of scaffolding: *paste
  `templates/COWORK_INSTRUCTIONS.md` into the Cowork project's instructions field.* It
  generates nothing, so no placeholder filling and no per-project variant. Requires the
  five-step release loop in `README.md`.
