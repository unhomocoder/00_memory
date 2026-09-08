# Cowork Project Instructions — generic bootstrap

Paste everything below the rule into the *instructions* field of **every** iclaw Cowork
project — root projects and branch projects alike.

It is **byte-identical for every project**. It carries no project identity, no protocol
text, and no conduct rules, so a change to `templates/CLAUDE.md` or to a skill never
obliges a re-paste. That is its entire reason for existing: releases 1.5.0, 1.6.0 and
1.7.0 each shipped with "re-paste the Cowork project instructions field" as a required
migration step, because the per-project instruction docs were a second copy of rules
whose source of truth is `CLAUDE.md`.

**Precondition.** In the project, ask *"Do you have the `iclaw:project-memory` skill?"*
before relying on this. If the answer is no, stop — a session without the skills
improvises a structure that looks right and fails silently. Scaffold in Claude Code and
point Cowork at the finished folder.

---

## Bootstrap

This folder is an `iclaw` project, or a branch of one (plugin `iclaw@00_memory`). A branch
is a complete, independent project: its own `CLAUDE.md`, its own `_memory/`, its own
`input/` and `output/`. Nesting changes nothing below.

**The `CLAUDE.md` in this folder is authoritative** — this folder's own, not a parent's.
Read it at the start of every session and follow it. What this project is, its working
folders, its conduct rules and any rule specific to it are all stated there and are
deliberately not repeated here. If you compact, read it again.

**Do not walk up the tree on your own initiative.** Whether a parent's `LONGTERM.md` is
read at orientation is decided by `inherits:` in this folder's memory, and
`iclaw:project-memory` resolves that — along with scope and any parent/branch canon
conflict. Most branches here declare `inherits: none` deliberately. Reading a parent
because it looked relevant defeats that.

**Relative paths inside `_memory/` and `_canon/` files resolve against the file they
appear in, not against the project root.** A `../../_canon/vocab.md` written in
`_memory/LONGTERM.md` means two levels up from `_memory/`.

Report and stop before doing project work if any of these is true:

- `CLAUDE.md` is absent from this folder, or its frontmatter has no `protocol:` line.
- `iclaw:project-memory` or `iclaw:project-artifacts` is unavailable to you.
- This folder's `CLAUDE.md` defers a rule to a parent instead of stating it. That file
  is supposed to be self-sufficient; say which section defers, and ask before
  proceeding.

Name which one failed. Do not improvise the protocol and do not hand-write `_memory/` —
the file formats have rules stated nowhere in this field, and a plausible approximation
fails silently.

## Session shape

- **Substantive project work** → invoke `iclaw:project-memory` before answering.
- **One-off or off-tangent question** → answer directly. Load nothing.
- **Before writing any file** → invoke `iclaw:project-artifacts`.
- **Creating a branch** → `iclaw:project-init` in branch mode.
