---
version: 1.0.0
last_updated: 2026-04-29
---

# Memory.md — Memory Management Protocol

This file defines how agents create, read, update, and preserve memory files across sessions within the `00_iClaw` workspace. Read this file alongside `Claude.md` at the start of every session, before taking any action.

Memory files are not logs. They are structured continuity documents — the primary mechanism by which project context, decisions, and progress are preserved across sessions and across agents.

---

## 1. File Naming Convention

Memory files are stored inside `{projectname}_memory/` within the project folder.

| Scenario | Filename |
|---|---|
| First session on a given date | `yyyy_mm_dd_memory.md` |
| Second session on the same date | `yyyy_mm_dd_memory_2.md` |
| Third session on the same date | `yyyy_mm_dd_memory_3.md` |

- The date reflects when the file was **created**, not when the session ended.
- A session that spans midnight does not trigger a new file.
- Version suffixes (`_2`, `_3`, ...) increment only when a new session begins on a date where a memory file already exists.

---

## 2. The `끝` Convention — Immutability

Any memory file whose last non-whitespace content is the marker:

```
끝
```

is **sealed** and must not be modified under any circumstances. This rule applies to all agents, at all times, without exception. A sealed file is a permanent record.

A file is sealed by appending `끝` as the final line at the conclusion of a session, after the session summary has been written (see Section 5).

---

## 3. Memory File Structure

Each memory file uses YAML frontmatter followed by three structured Markdown sections. This format is designed with future Obsidian integration in mind and must remain compatible with standard Markdown rendering at all times.

### 3.1 YAML Frontmatter

```yaml
---
project: {projectname}
session_date: yyyy-mm-dd
session_version: 1
claude_md_version: {version string from Claude.md at time of writing}
status: active
---
```

- `session_version` increments for same-day sessions (matches the filename suffix).
- `status` is `active` while the session is open; updated to `sealed` before appending `끝`.
- `claude_md_version` is carried from the version header of `Claude.md` at the time the file is created. This enables version drift detection during future orientation sequences.

### 3.2 Section 1 — Project Purpose

This section describes the main purpose of the project and **must be carried forward into every memory file for that project**. It is updated — not replaced — as the project evolves. It must always reflect the full history of the project's scope and objectives.

Include:
- A high-level description of what the project is trying to accomplish.
- A breakdown of objectives, each marked with a completion status:
  - `[ ]` — not started
  - `[~]` — in progress
  - `[x]` — complete
- A reference to what the previous memory file covered, or `Initial session.` if this is the first.

This section may only be modified with explicit user direction. It must never be abbreviated or condensed in a way that loses prior objective history.

### 3.3 Section 2 — Work This Session

A running log of what was worked on during this session. This section is written and updated throughout the session as work progresses.

Write in draft style — preserve traces of thought processes, decisions made, and directions explored. Do not reduce this to a clean summary during the session; that is what Section 3 is for. Intermediate thinking, discarded approaches, and pivots are all valid content here.

### 3.4 Section 3 — Session Summary

Written **only at the end of the session**, after the user signals that work is complete.

Include:
- A concise summary of what was accomplished.
- What was left open or unresolved.
- Any important decisions made and their rationale.
- Any changes to the project's objectives or direction.

After this section is written, update the `status` field in the YAML frontmatter to `sealed`, then append `끝` as the final line. The file is then immutable.

---

## 4. Session Lifecycle

### 4.1 Start of Session

1. Navigate to `{projectname}_memory/`.
2. Find the latest file (by date, then version suffix) that does not end with `끝`.
3. Read it in full to establish project context.
4. If no valid active file exists, follow the edge case protocol defined in `Claude.md` Section 1.1.
5. If a valid active file exists, create a **new** memory file for the current session using the naming convention in Section 1.
6. In the new file, populate the YAML frontmatter and Section 1 (carrying forward and updating from the previous file as appropriate).

### 4.2 During Session

- Update Section 2 continuously as work progresses.
- Do not modify Section 1 without explicit user direction.
- Do not append `끝` or update `status` to `sealed` until the user signals end of session.
- Cross-references to other memory files use relative paths: `[[yyyy_mm_dd_memory]]` (Obsidian-compatible link syntax).

### 4.3 End of Session

The user will explicitly signal that the session is complete.

1. Write Section 3 (Session Summary).
2. Update `status` in the YAML frontmatter from `active` to `sealed`.
3. Append `끝` as the absolute final line of the file, with no trailing whitespace or content after it.
4. The file is now sealed and permanently immutable.

---

## 5. Obsidian Compatibility

Memory files are designed for future integration with Obsidian as a knowledge base and memory visualization layer. Maintain the following conventions from the outset to ensure zero-friction migration:

- All files use YAML frontmatter as specified in Section 3.1.
- Headings follow a consistent hierarchy: `##` for top-level sections, `###` for subsections.
- Cross-references between memory files use Obsidian wiki-link syntax: `[[yyyy_mm_dd_memory]]`.
- Tags may be added to frontmatter in the future (e.g., `tags: [project, session, active]`) — reserve the field but do not populate it until integration is confirmed.
- Do not use Obsidian-specific plugins or non-standard syntax (e.g., Dataview queries, callout blocks) until integration is confirmed and compatibility is verified.

---

## 6. Memory File Template

Use the following as the base template when creating a new memory file:

```markdown
---
project: {projectname}
session_date: yyyy-mm-dd
session_version: 1
claude_md_version: {version}
status: active
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

## Session Summary

{Written at end of session only.}
```
