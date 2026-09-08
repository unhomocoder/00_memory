---
name: project-init
description: Scaffold a new iclaw project, branch an existing project into a sub-project, or migrate an existing folder onto the iclaw protocol. Use when starting a new project, adding a nested sub-project or topic branch, or bringing an unmanaged folder under iclaw memory.
---

# Project Init

Creates the iclaw project structure. Templates live in this plugin's `templates/`
directory; copy and fill them rather than composing files from scratch.

## Modes

| Mode | When | Numbering |
|---|---|---|
| `new` | A project at the workspace root | Next `{nn}` among root siblings |
| `branch` | A sub-project inside an existing project | **Restarts at `01`** among that project's children |
| `migrate` | An existing unmanaged folder | Keeps its current name |

Ask which mode applies if it is not obvious from the request.

## Numbering

List sibling directories. **Exclude any whose name begins with `_` or `00_`** —
those are infrastructure, not projects. Take the highest two-digit prefix among
what remains, add 1, zero-pad to two digits. If none remain, use `01`.

In `branch` mode the scan is over the *parent project's* children, so a branch in a
project that has none is `01` regardless of the parent's own number.

## What to ask before writing

1. Project name (lowercase, underscores for spaces).
2. One paragraph: what this project is, and what "done" looks like.
3. Initial objectives, if any.
4. Enable `_canon/`? Default no. Enable it when the project will accumulate domain
   reference that must be looked up mid-task. Ask **which shape**, since canon holds
   more than terminology: `vocab.md` for terms whose exact form is the point of
   recording them, `corpus.md` for a domain index — one row per source, with a stated
   entry threshold. Either, both, or neither.
5. Profile: `research`, `creative`, `engineering`, or `none`.

Ask these together, in one message. This is scaffolding, not discovery.

## Confirmation gate

**Print the full tree you are about to create and wait for explicit confirmation.
Create nothing before the user says yes.**

## What to write

In this order:

```
{nn}_{project_name}/
├── CLAUDE.md                  from templates/CLAUDE.md
├── _memory/
│   ├── LONGTERM.md            from templates/LONGTERM.md
│   ├── STATE.md               from templates/STATE.md
│   ├── _index.md              from templates/_index.md
│   └── sessions/              empty
├── _canon/                    only if enabled
│   ├── vocab.md               from templates/vocab.md    ← if terminology
│   └── corpus.md              from templates/corpus.md   ← if a domain index
├── input/                     empty
└── output/
    └── _manifest.md           from templates/_manifest.md
```

Replace every `{placeholder}` — `{project_name}`, `{nn}`, `{yyyy-mm-dd}`. A file
that still contains `{` after writing is a defect.

Set `CLAUDE.md` frontmatter: `project`, `memory_root: ./_memory`, `canon` (`none`
or `./_canon`), `profile`, `protocol: iclaw/1.0.0`.

**Do not create a session log.** That is `iclaw:project-memory`'s job, on the first
real session.

## Seeding

**Seed `LONGTERM.md` from the answers gathered above. Never leave an unfilled
template.** Write the purpose paragraph into `## What This Project Is` and each
objective as a `- [ ]` line. If the user supplied durable decisions, constraints, or
deferred items during the conversation, write those into their sections too.

An empty scaffold is a failure of this skill, not a neutral starting point — the
next session reads `LONGTERM.md` expecting to learn what the project is.

## Profile blocks

Append to `LONGTERM.md` after `## Constraints`:

| Profile | Sections |
|---|---|
| `research` | `## Corpus Conventions` |
| `creative` | `## Cast`, `## World Rules` |
| `engineering` | `## Interfaces`, `## Conventions` |
| `none` | nothing |

These hold **durable facts only**. Discarded ideas stay in session logs and never
graduate here — long-term memory is read every session and must stay lean.

## Branch mode — one extra step

Append a row to the **parent's** `LONGTERM.md` under `## Branches of this project`,
replacing the `_None._` placeholder on first use:

```
| Branch | Created | Status | Purpose |
|---|---|---|---|
| {nn}_{branch_name} | {yyyy-mm-dd} | active | {one-line purpose} |
```

The `Status` column is mandatory. `validate_project.sh` fails a row without one, and
fails an `active` row naming a directory that does not exist.

The branch is otherwise a complete, independent project. It gets its own memory,
its own `input/` and `output/`, and its own numbering space.

**Inheritance is opt-in and off by default.** Set `inherits: ..` in the branch's
`LONGTERM.md` frontmatter only if the user asks for the parent's long-term memory
to be read at every orientation.

**Canon in a branch:** default to disabled. The parent's `_canon/` already governs.
Create a branch `_canon/` only when the branch has terminology genuinely its own —
and note that on conflict the branch's canon wins, and the conflict must be flagged
rather than silently resolved.

## Retire mode — the counterpart to branch

A branch that is finished, abandoned, or folded into another does **not** lose its row.
The row is history, on the same argument as the manifest's never-delete rule.

1. Set the row's `Status` to `retired {yyyy-mm-dd}` in the parent's `LONGTERM.md`.
2. Extend its `Purpose` cell with where the work went — a successor branch, an `output/`
   artifact, or "abandoned, nothing carried forward". A retired row that does not say
   what happened is worse than no row.
3. Set `status: archived` in the branch's own `LONGTERM.md` frontmatter.
4. **Never delete the directory** without explicit confirmation, and never as part of
   this operation. Retiring a branch is a bookkeeping act; removing its files is a
   separate decision the user makes.

If the directory is already gone when you find the row, say so and date the retirement
to the day you audited it, not to a date you inferred.

## Migrate mode

**Create only what is missing. Never overwrite an existing `CLAUDE.md`.**

Report what was already present and what you added. If the folder has an older
memory convention (a `{name}_memory/` folder, dated memory files, a
`{name}_shared_vocab.md`), do not reformat or move anything — report what you found
and ask. Old sealed files are read-only forever.

## Self-check

Run the validator and report its output verbatim:

```bash
bash <plugin_dir>/scripts/validate_project.sh <project_dir>
```

Expected: `OK: <dir> conforms to iclaw/1.0.0`.

**Fix every `FAIL` before telling the user the project is ready.** Report every `NOTE`
verbatim and act on none — a `NOTE` names a file the protocol forbids you to edit, such
as a sealed session log; there is no compliant fix and you must not attempt one. `WARN`
is a target exceeded, not a rule broken: report it and continue. Do not report success
on an unverified scaffold.
