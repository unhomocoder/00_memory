# Starting a New Project

**You copy nothing out of `00_parent`.**

Under v2.0.0 the workflow was: copy `Claude.md` from `00_parent` into the new project
folder, then adjust it. That file no longer sits at `00_parent/` — it is
`templates/CLAUDE.md` inside the plugin, and `iclaw:project-init` instantiates it. If
you are looking for a file to copy, the answer is that the skill writes it.

`00_parent` is the plugin source, not a template folder.

---

## The whole procedure

Say, anywhere:

> Start a new iclaw project called `<name>`.

`iclaw:project-init` then asks five things:

| | |
|---|---|
| **Name** | lowercase, underscores for spaces |
| **Purpose** | one paragraph — what it is, what "done" looks like |
| **Objectives** | initial ones, if you have any |
| **Canon?** | default no. Yes if the project accumulates terminology, a cast, world rules — anything you look up mid-task |
| **Profile** | `research`, `creative`, `engineering`, or `none` |

It shows you the tree, waits for your yes, then writes:

```
{nn}_{name}/
├── CLAUDE.md              from templates/CLAUDE.md, placeholders filled
├── _memory/
│   ├── LONGTERM.md        seeded with YOUR purpose and objectives, not a blank form
│   ├── STATE.md
│   ├── _index.md
│   └── sessions/          empty — the first real session creates the first log
├── _canon/vocab.md        only if you said yes
├── input/
└── output/_manifest.md
```

Then it runs the validator and reports the result.

`{nn}` is computed by scanning siblings and skipping anything prefixed `_` or `00_`.
You never pick the number.

## Branching

Same skill, branch mode:

> Branch `<project>` into a sub-project called `<name>`.

Numbering restarts at `01` inside the parent. The branch is a **complete, independent
project** — own memory, own `input/`, own `output/`, own numbering space — and the
parent's `LONGTERM.md` gains a row under `## Branches`.

By default a branch reads nothing from its parent. If you want the parent's long-term
memory read at every orientation, set `inherits: ..` in the branch's `LONGTERM.md`.

Nesting is unbounded. A container project with genre branches and novel sub-branches
under those is expressible; v2.0.0 forbade exactly this.

## Migrating an existing folder

> Migrate `<folder>` onto the iclaw protocol.

Creates only what is missing. **Never overwrites an existing `CLAUDE.md`.** Old
memory files in a pre-v3 layout are reported, not reformatted — sealed files are
read-only forever, and drift is recorded rather than repaired. Expect legacy records
to land in `_memory/legacy/` rather than `sessions/`, since their filenames and
frontmatter predate the current schema.

## Changing the defaults for all future projects

Edit `templates/CLAUDE.md` — its `## Behavior` section is the per-project starting
point, so changing it changes what every new project is born with. Existing projects
are unaffected; each owns its copy outright.

Then follow the five-step loop in `README.md` under **Changing a skill**. The version
bump is not optional: without it, every command reports success and nothing changes.

## What a project owns after birth

Everything. `CLAUDE.md` is the project's own file — edit it freely. Nothing external
reads it, no parent reconciles against it, and there are no declared deltas to
maintain. That was the point of dropping the child-directive layer.

The two things that are *not* project-owned are the protocol itself (in the skills)
and the templates (in the plugin). Both are versioned in git.

## Common per-project adjustments

Things worth changing in a new project's `CLAUDE.md`, drawn from what previous
projects actually needed:

- **Language.** The default is English every session, with an in-session toggle that
  resets. A project written in another language usually replaces this with a table:
  prose in one language, memory in English, conversation following the user.
- **Confidence scoring.** The default applies `[c: 0.00]` to factual claims. Creative
  projects exempt narrative output — a scored scene draft is noise.
- **Decision authority.** Worth naming which decisions must be surfaced before you act.
  For fiction that meant killing a character or changing POV; for research it is
  usually committing to a corpus or a design.
