---
name: project-artifacts
description: Name, version, and register files written to an iclaw project's output/ folder. Use before writing any artifact file, and when regenerating a previous artifact.
---

# Project Artifacts

Every file you create in a project goes in `output/`. Writing a loose `.md`, `.csv`,
`.html`, or script to the project root, to `_memory/`, or into `input/` is a
protocol violation.

## Path

```
output/{yyyy_mm_dd}/{nn}_{slug}_v{n}[_status].{ext}
```

```
output/2026_08_29/03_dataset-audit_v2_draft.md
```

| Element | Rule |
|---|---|
| `{yyyy_mm_dd}` | Date the file was created. One folder per date on which output was produced. A session crossing midnight keeps the folder it started in |
| `{nn}` | Two-digit creation ordinal within that date folder, from `01`. **Never reused, never renumbered** — even if earlier files are deleted |
| `{slug}` | Lowercase, hyphen-separated, four words maximum. Names *what the artifact is*. No dates, no version numbers, no status words |
| `_v{n}` | Revision counter, mandatory from `v1`. Continues across date folders for the same slug |
| `_status` | Optional: `_draft` or `_final`. Absence means "working copy, status unstated" |
| `.{ext}` | The true file type. Never `.md` for HTML content |

## The overwrite prohibition

**Never overwrite an existing file in `output/`.** To regenerate an artifact,
increment `_v{n}` and write a new file.

This is the single rule that prevents the "which copy is which" problem: if nothing
is ever overwritten, version order is total and recoverable from the filesystem
alone. A regeneration in a later session gets a new ordinal in the new date folder
but keeps its slug and continues its version sequence — so
`2026_08_29/03_layering-spec_v2.md` may be succeeded by
`2026_09_02/01_layering-spec_v3.md`.

## Slug discipline

Slugs are the primary human index. Two rules keep them useful.

**Distinguish artifacts, not topics.** In a project about drone detection, `report`
and `analysis` are useless slugs. `augmentation-ablation`, `dataset-audit`, and
`eval-protocol` are useful.

**Reuse a slug only for the same artifact.** A different artifact gets a different
slug even in the same subject area. Slug identity is what makes the version sequence
mean anything.

## Registration

| What happened | `output/_manifest.md` row | Session `## Files Touched` |
|---|---|---|
| File written to `output/` | yes | yes — under **Produced** |
| Source file edited in place | **no** | yes — under **Modified** |
| File read from `input/` | **no** | yes — under **Consumed** |

Source files edited in place get no manifest row. The manifest registers *output
artifacts*, cumulatively across sessions; the session log records *everything
touched*, within one session. Different questions, so the overlap is one line, not a
second bookkeeping system.

Append the manifest row **at the moment the file is written**, not at session end:

```
| {date_folder}/{filename} | {yyyy-mm-dd} | {why it exists} | {v(n-1) or —} | {session filename} | {draft|final|superseded} |
```

Refresh the `generated:` stamp at the head of the manifest when you append.

When a new version supersedes an older one, mark the older row's Status column
`superseded`. Do not delete it.

## The manifest is a view

The filesystem is authoritative; the manifest is commentary. **Never add information
to it that is not in a session file or on disk.**

At orientation, reconcile it against the directory and report drift:

- Rows whose files are missing — the user moved or deleted them. **Never recreate
  the file. Never delete the row.** Mark it `relocated/removed` once the user
  confirms.
- Files with no row — produced outside protocol. Report them; do not delete.

## Before writing

1. Determine today's date folder; create it if absent.
2. List existing files in that folder to find the next `{nn}`.
3. Check whether this artifact already exists under the same slug anywhere in
   `output/`. If it does, this is a new version — take the highest `v{n}` and add 1.
4. Write the file.
5. Append the manifest row and the session `Produced` entry.
