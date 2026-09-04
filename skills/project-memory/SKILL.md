---
name: project-memory
description: Read, update, and seal iclaw project memory — STATE, LONGTERM, canon, and the session log. Use at the start of substantive project work, when recording a decision or a rejected approach, and at session end when the user signals to seal.
---

# Project Memory

Three operations: **ORIENT** at session start, **RECORD** during, **SEAL** at end.

Do not invoke this for a one-off or off-tangent question. Answering "what's the
difference between TCP and UDP?" inside a project directory costs zero memory reads.
That is the design, not an oversight.

## Scope resolution

The harness loads the nearest `CLAUDE.md` walking up from the working directory.
That file **is** the project declaration.

```
1. Take the deepest CLAUDE.md in context carrying a `project:` field.
2. Resolve memory_root relative to THAT file's own directory — never the cwd.
3. GUARD: _memory/LONGTERM.md frontmatter `project:` must equal
   CLAUDE.md frontmatter `project:`.
       match    -> proceed
       mismatch -> STOP. Write nothing. Report both values and wait.
4. No CLAUDE.md carrying a `project:` field -> ask once which project this is,
   then cache the answer for the rest of the session.
```

The guard exists so session notes can never land in the wrong project's memory. A
memory folder must self-identify as belonging to the project claiming it.

## Routing

Ask the scope question **only if** the project directory contains at least one
child directory matching `{nn}_`. Flat projects are never asked.

```
Has {nn}_ children?  no  -> active scope is the project. Proceed silently.
                     yes -> ask: "parent scope, or which branch?"  Write to that
                            scope's _memory/ only.
```

**Session logs never split.** The narrative belongs to the scope where the work
happened. If branch work changes a *parent-level* objective or decision, append
that one line to the parent's `LONGTERM.md` — decisions bind their scope, narrative
does not.

Read the parent's `LONGTERM.md` at orientation **only if** the active scope's
`LONGTERM.md` declares `inherits: ..`. Off by default.

## ORIENT

```
1. Resolve scope + run the identity guard.
2. Read STATE.md and LONGTERM.md. Plus the parent's LONGTERM.md iff `inherits:`
   is declared. Nothing else, ever — not session files, not _index.md, not _canon/.
3. Look in sessions/ for a file whose status is not `sealed`:
     found -> resume it. Append under a new `### {yyyy-mm-dd}` subheading in ## Work.
     none  -> create sessions/{yyyy_mm_dd}_session[_n].md from templates/session.md.
              n is 1 for the first file of that date and carries NO suffix;
              the second is n: 2 as ..._session_2.md. Filename and n always agree.
              The date is today's date. A session crossing midnight keeps its file.
4. Report, at most six lines:

   PROJECT  {nn}_{name}
   SCOPE    {active scope, or "flat"}
   MEMORY   STATE {date} · session {filename} ({new|resumed})
   STATE    {2-3 sentences from STATE.md}
   OPEN     {open threads, or "none"}
   FLAGS    {protocol drift · guard mismatch · unregistered input/ files · view drift · none}

5. Stop. Wait for direction.
```

Check `input/` for files not mentioned in `STATE.md` or the active session log and
list them under FLAGS. **A file's presence is not an instruction to process it** —
ask whether it is in scope.

## RECORD

Write continuously, not in a batch at session end.

| Event | Destination |
|---|---|
| Work done, options weighed, pivots, discarded approaches | session `## Work` |
| File written to `output/` | session `## Files Touched → Produced` **and** a `_manifest.md` row |
| Source file edited in place | session `## Files Touched → Modified` only |
| File read from `input/` | session `## Files Touched → Consumed` only |
| A durable decision | `LONGTERM.md ## Durable Decisions`, with a marker |
| An approach tried and rejected | `STATE.md ## Do Not Repeat` |
| A new domain term or settled fact | `_canon/`, marked `[proposed]` unless the user confirmed it |
| A decision deliberately deferred | `LONGTERM.md ## [TBD] Register` |

`## Work` is a **working draft**, not a summary. Record the path the work actually
took: options explored and abandoned, dead ends and why they were dead, the order
in which things were settled. Do not tidy it during the session — that is what the
summary is for, and an idea that looks useless today is often load-bearing later.

Discarded ideas stay in the session log. **They never graduate into `LONGTERM.md`**,
which is read every session and must stay lean.

## SEAL

**Only on the user's explicit signal.** Never on your own initiative, never because
a session feels finished.

```
1. Write the session's ## Summary: what was accomplished, what was left open,
   decisions and their rationale, any change of direction.
2. Rewrite STATE.md in full — current state, open threads, blocked, do not repeat.
   Set `updated:` and `last_session:`.
3. Update LONGTERM.md objective checkboxes where status changed.
4. Append a row to _memory/_index.md and refresh its `generated:` stamp.
5. Set `status: sealed` in the session frontmatter.
6. Append the seal marker 끝 as the final line. Nothing after it — no trailing
   whitespace, no newline of content.
```

## Invariants

- **Never seal on your own initiative.** Only on the user's explicit signal.
- **Never modify a file that ends with 끝.** Sealed is permanent, for every agent,
  without exception. This includes files inherited from older protocol versions.
- **Never assign `[confirmed]`.** That marker belongs to the user alone. Your own
  inferences are `[proposed]` until they approve them.
- **Never edit `_index.md` or `_manifest.md` to add information that is not in a
  session file.** They are views; session files are the source.
- **Memory is written in English** — `LONGTERM.md`, `STATE.md`, session logs, and
  the views — regardless of what language the session ran in. Continuity documents
  are read months later by a different session, and one consistent language is what
  keeps them reliable. `_canon/` is exempt and follows the domain's own language.

## Edge cases

| Situation | Behavior |
|---|---|
| No `_memory/` | Offer `iclaw:project-init` in migrate mode. Create nothing unasked |
| `STATE.md` missing but sessions exist | Rebuild a draft from the newest session's summary, set `reconstructed: true`, and ask the user to confirm it before relying on it |
| Newest session file is unsealed | Resume it under a dated subheading. **Never auto-seal** |
| `protocol:` version mismatch | Report under FLAGS, name what structurally differs, proceed. **Never rewrite an old file to conform** — drift is recorded, not repaired |
| Identity guard mismatch | **Stop. Write nothing.** Report both values |
| `inherits:` target missing | Report it, continue without inheritance |
| Canon conflict, parent vs branch | The branch wins. **Flag the conflict. Never resolve it silently** |
| A view disagrees with the filesystem | Report under FLAGS. Never recreate a missing file, never delete a row for one |

## Validation

After sealing, run the validator and report failures:

```bash
bash <plugin_dir>/scripts/validate_project.sh <project_dir>
```
