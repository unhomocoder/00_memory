# Memory kinds, marker removal, Conduct and threads — plugin 1.9.0

Status: decided 2026-10-07 by the user, in the session that ran the audit below.

## Why

A read-only audit of all 16 projects under `00_iClaw` (2026-10-07) found:

- **`[proposed]` was never promoted after the session that wrote it.** About 60 items
  carried it, the oldest 39 days old. Every promotion on record happened in the same
  session, when the user decided in chat. `01_evaluation_moderators` held seven decisions
  the user ratified in chat on 2026-09-04 and still marked `[proposed]`, because the agent
  was forbidden to assign `[confirmed]`.
- **`[confirmed]` was assigned by agents anyway** ("Kyle decided this session"), and
  `project-init` wrote it while `project-memory` forbade it.
- **The marker set drifted:** `[provisional]`, `[open]`, `closed`, split markers, and
  markers on objectives, open threads and `[TBD]` rows.
- **STATE.md had become a second LONGTERM in research scopes** (up to 103 lines, with
  results, server instructions and 15-item Do Not Repeat lists), while finished courses
  carried a STATE with nothing ongoing to hand off.
- **Findings sat in LONGTERM**, read every session, and were the main reason research
  scopes exceeded the 200-line read target.

## Decisions

1. **Markers are removed.** No `[proposed]`, `[confirmed]`, `[provisional]`, `[open]`,
   `[deprecated]` in any live memory or canon file. The `Marker` columns go.
   `## Durable Decisions` holds **only what the user decided**, so it needs no marker.
   An agent inference is never recorded as a decision; it goes to STATE `## Open Threads`
   as a question for the user.
2. **Existing items keep their content; only the markers are stripped.** Every item that
   carried any marker stays as it was, without the marker. (An earlier answer in the same
   session chose to drop every `[proposed]` item; the user corrected it to strip only the
   marker.) Which rows were once `[proposed]` is visible in the pre-migration snapshot.
3. **Sealed session logs and `output/` artifacts are never edited.** Old markers in them
   are history.
4. **Two memory files stay separate.** Merging saves nothing at session start (both are
   read in full) and removes the only point where memory forgets on purpose: STATE is
   rewritten at seal, LONGTERM is appended to.
5. **Three kinds of project, selected by `profile:`:**

   | Profile | Use | Files | Profile sections in LONGTERM |
   |---|---|---|---|
   | `research` | Open-ended research | STATE + LONGTERM; `_canon/` usually on | `## Corpus Conventions` |
   | `course` | A course being taken, or an exam being prepared | STATE + LONGTERM; `_canon/` on with `vocab.md` and `corpus.md` | `## Course`, `## Deliverables`, `## Conventions` |
   | `reference` | A finished course kept for review | LONGTERM only, **no STATE**; `_canon/vocab.md` optional | `## Material Map`; no `## Objectives` |

   `engineering`, `creative` and `none` are unchanged.
6. **Do Not Repeat moves from STATE to LONGTERM.** It is durable, and STATE's full
   rewrite at seal put it at risk of being lost or never pruned. Standing facts that were
   filed there ("HuggingFace is unreachable") belong under `## Constraints`.
7. **STATE targets 30 lines:** 2–4 sentences of current state, live open threads, blocked.
8. **Own results go to `_canon/findings.md`**, loaded on demand, labelled **sourced**,
   **derived** or **open**. Findings about a paper stay in that paper's `corpus.md` row.
   LONGTERM keeps a one-line pointer.
9. **`_canon/vocab.md` entries carry no marker.** An entry's presence means the term is
   shared between user and agent. An obsolete term says so in words and names its
   successor.
10. **Conduct and threads.** `templates/CLAUDE.md` gets the new Conduct section
    (answer first, reader, real names, certainty, threads). `templates/session.md` gets an
    empty `## Threads` section. At seal: resolved threads stay in the session file, open or
    parked threads go to STATE `## Open Threads` (in a `reference` project, to the session
    summary), rejected approaches to LONGTERM `## Do Not Repeat`, settled terms to
    `_canon/vocab.md`.

## Migration of existing projects

1. Seal the three unsealed sessions (`07_mms` 2026-09-24, `03_cfs_2` 2026-10-04,
   `04_data_management_1` 2026-09-24) with the user's approval.
2. Snapshot every scope's `CLAUDE.md`, `_memory/` and `_canon/` into
   `D:\00_iClaw\_archive\2026-10-07_pre-1.9.0\`. The workspace is not a git repository.
3. Per scope, in a maintenance session logged in that scope: strip markers, move Do Not Repeat, trim STATE, move findings, set `profile:`, and
   replace the `CLAUDE.md` Conduct section. Run the validator.
4. Assignments: `research` — the six thesis branches; `course` — `03_cfs_2`,
   `04_data_management_1`, `05_tqe`, and the new `07_cont_engineering`; `reference` —
   `01_mldl_1`, `02_cfs_1`, `06_mlvu`. Hubs (`01_agentic_thesis`, `03_grad_coursework`)
   and `02_local_swarm` keep their profile.
