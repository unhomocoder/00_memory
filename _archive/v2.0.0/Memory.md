---
version: 2.0.0
supersedes: 1.0.0
last_updated: 2026-08-16
scope: D:\00_iClaw
companion: Claude.md v2.0.0
maintained_by: iclaw_administrator
---

# Memory.md — Memory Management Protocol

This file defines how agents create, read, update, and preserve memory files across
sessions within the `00_iClaw` workspace. Read it alongside `Claude.md` at the start
of every session, before taking any action.

Memory files are not logs. They are structured continuity documents — the primary
mechanism by which project context, decisions, and progress survive across sessions
and across agents. They are the workspace's system of record. `input/` and `output/`
are not; their contents may be moved or deleted freely.

Mutability classes are as defined in `Claude.md` §0.1. Unless a section declares
otherwise, everything in this file is `[INVARIANT]`.

---

## 1. File Naming Convention

Memory files live in `{projectname}_memory/` within the project folder.

| Scenario | Filename |
|---|---|
| First session on a given date | `yyyy_mm_dd_memory.md` |
| Second session on the same date | `yyyy_mm_dd_memory_2.md` |
| Third session on the same date | `yyyy_mm_dd_memory_3.md` |

- The date reflects when the file was **created**, not when the session ended.
- A session spanning midnight does not trigger a new file.
- Version suffixes increment only when a new session begins on a date that already
  has a memory file.

---

## 2. The `끝` Convention — Immutability

Any memory file whose last non-whitespace content is the marker:

```
끝
```

is **sealed** and must not be modified under any circumstances. This applies to all
agents, at all times, without exception, including the `iclaw_administrator` agent.
A sealed file is a permanent record.

A file is sealed only at the conclusion of a session, after the session summary has
been written (§5.3), and only on the user's explicit signal.

---

## 3. Memory File Structure

Each memory file is YAML frontmatter followed by four structured Markdown sections.
The format targets future Obsidian integration and must remain compatible with
standard Markdown rendering at all times.

### 3.1 YAML Frontmatter

```yaml
---
project: {projectname}
session_date: yyyy-mm-dd
session_version: 1
claude_md_version: {version of Claude.md at time of writing}
memory_md_version: {version of Memory.md at time of writing}
directive_version: {version of the child directive, or "none"}
status: active
tags: []
---
```

- `session_version` increments for same-day sessions and matches the filename suffix.
- `status` is `active` while the session is open; set to `sealed` immediately before
  appending `끝`.
- The three version fields are carried from the files as read at session start. They
  exist so that a future orientation can detect drift (`Claude.md` §9.3) rather than
  silently misinterpreting an old file under new rules.
- `tags` is reserved for Obsidian integration. Leave it empty until integration is
  confirmed.

### 3.2 Section 1 — Project Purpose

Describes the project's purpose and **must be carried forward into every memory file
for that project**. It is updated, never replaced, and must always reflect the full
history of scope and objectives.

Include:

- A high-level description of what the project is trying to accomplish.
- A breakdown of objectives with completion status:
  - `[ ]` not started
  - `[~]` in progress
  - `[x]` complete
- A reference to what the previous memory file covered, or `Initial session.` if
  this is the first.

This section may be modified only on explicit user direction. It must never be
abbreviated or condensed in a way that loses prior objective history.

### 3.3 Section 2 — Work This Session

A running log, written and updated continuously as work progresses.

Write in draft style. Preserve traces of thought, decisions taken, and directions
explored. Do not reduce this to a clean summary during the session — that is what
Section 4 is for. Intermediate thinking, discarded approaches, and pivots are all
valid content and should be kept.

### 3.4 Section 3 — Artifacts

*(New in v2.0.0.)* A running list of every file the session produced or consumed.
Append the moment a file is written, in parallel with the row appended to
`output/_manifest.md` (`Claude.md` §4.4).

```markdown
### Produced
- `output/2026_08_16/01_dataset-audit_v1.md` — first pass over the raw split
- `output/2026_08_16/02_dataset-audit_v2_draft.md` — revised after class-balance check

### Consumed
- `input/annotations_20260814.csv` — provided by user at session start
```

This section is what links the durable record to the transient folders. If an
artifact is later moved or deleted, this entry remains and still explains what once
existed and why. Do not edit it retroactively to match the filesystem.

### 3.5 Section 4 — Session Summary

Written **only at the end of the session**, after the user signals that work is
complete.

Include:

- A concise summary of what was accomplished.
- What was left open or unresolved.
- Important decisions and their rationale.
- Any change to the project's objectives or direction.
- Any change to the child directive or shared vocabulary made this session.

After this section is written, set `status: sealed` in the frontmatter, then append
`끝` as the final line. The file is then immutable.

---

## 4. Session Lifecycle

### 4.1 Start of Session

1. Navigate to `{projectname}_memory/`.
2. Find the latest file by date, then version suffix, that does not end with `끝`.
3. Read it in full to establish project context.
4. If no valid active file exists, follow `Claude.md` §2.1.
5. If a valid active file exists, create a **new** memory file for the current
   session using §1's naming convention.
6. Populate the frontmatter and Section 1, carrying forward and updating from the
   previous file as appropriate.

### 4.2 During Session

- Update Section 2 continuously.
- Append to Section 3 at the moment each file is written or read from `input/`.
- Do not modify Section 1 without explicit user direction.
- Do not append `끝` or set `status: sealed` until the user signals end of session.
- Cross-reference other memory files with Obsidian wiki-link syntax:
  `[[yyyy_mm_dd_memory]]`.

### 4.3 End of Session

The user will explicitly signal that the session is complete.

1. Write Section 4 (Session Summary).
2. Update `status` from `active` to `sealed`.
3. Append `끝` as the absolute final line, with no trailing whitespace or content
   after it.
4. The file is now permanently immutable.

### 4.4 Abandoned Sessions

If a session ends without a seal signal — the user simply stops — the file remains
`active` and is picked up by the next session's step 2. This is normal and is not
an error condition. The next session appends to Section 2 under a dated subheading
rather than starting a new file. A file is never sealed on the agent's initiative.

---

## 5. Obsidian Compatibility

Memory files are designed for future integration with Obsidian as a knowledge base
and memory visualization layer. Maintain these conventions from the outset:

- YAML frontmatter exactly as specified in §3.1.
- Consistent heading hierarchy: `##` for top-level sections, `###` for subsections.
- Wiki-link syntax for cross-references between memory files:
  `[[yyyy_mm_dd_memory]]`.
- Wiki-links may also point at manifest rows and artifacts; keep paths relative to
  the project folder.
- `tags` reserved in frontmatter but not populated until integration is confirmed.
- No Obsidian-specific plugin syntax (Dataview queries, callout blocks) until
  integration is confirmed and compatibility verified.

---

## 6. Memory File Template

```markdown
---
project: {projectname}
session_date: yyyy-mm-dd
session_version: 1
claude_md_version: {version}
memory_md_version: {version}
directive_version: {version or "none"}
status: active
tags: []
---

## Project Purpose

{High-level description of the project's objective.}

### Objectives

- [ ] {Objective 1}
- [ ] {Objective 2}

### Previous Session Reference

{Summary of what the last session covered, or "Initial session."}

---

## Work This Session

{Running notes, decisions, approaches explored — written throughout the session.}

---

## Artifacts

### Produced

- `output/{yyyy_mm_dd}/{nn}_{slug}_v{n}.{ext}` — {one line: what it is}

### Consumed

- `input/{filename}` — {one line: what it is}

---

## Session Summary

{Written at end of session only.}
```

---

## Appendix A — Changes from v1.0.0

| Change | Motivation |
|---|---|
| Added `memory_md_version` and `directive_version` to frontmatter | Only `Claude.md` drift was previously detectable. |
| Added `tags: []` reserved field | Was specified prose-only in v1.0.0; now in the template. |
| Added Section 3 — Artifacts | Links the durable record to the transient `input/`/`output/` folders. |
| Renumbered Session Summary from Section 3 to Section 4 | Consequence of the above. |
| Added §4.4 Abandoned Sessions | The v1.0.0 lifecycle assumed every session ends with an explicit signal. |
| Stated explicitly that the administrator agent is also bound by `끝` | Removes any implication that a governance agent has an exemption. |
