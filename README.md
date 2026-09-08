# iclaw

Project memory and governance protocol for Claude Code and Cowork.

Three on-demand skills replace always-resident governance Markdown. The design
premise: `CLAUDE.md` is the only file loaded on every prompt, so it stays ~45 lines
and states no protocol — it points at skills, which load only when invoked. An
off-tangent question costs zero memory tokens.

| Skill | Use when |
|---|---|
| `iclaw:project-init` | Starting a project, branching one, or migrating a folder onto the protocol |
| `iclaw:project-memory` | Session start, recording a decision, session end |
| `iclaw:project-artifacts` | Before writing any file to `output/` |

## Project shape

```
{nn}_{project_name}/
├── CLAUDE.md              ~45 lines, project-owned
├── _memory/
│   ├── LONGTERM.md        curated big picture      ─┐ read every
│   ├── STATE.md           handoff, rewritten       ─┘ session start
│   ├── _index.md          generated view
│   └── sessions/          append-only, sealed with 끝
├── _canon/                opt-in domain reference, on demand
├── input/
├── output/
└── {nn}_{branch}/         same structure, recursive
```

## The leading underscore

It carries four distinct meanings. Only the first is enforced by tooling, and an agent
that infers the second from the first will treat `_canon/` as infrastructure it may
reorganize.

| Meaning | Applies to |
|---|---|
| Excluded from `{nn}` numbering | any `_`- or `00_`-prefixed directory |
| Protocol-owned durable storage | `_memory/`, `_canon/` |
| Generated view; the filesystem is authoritative | `_index.md`, `_manifest.md` |
| Out of band, not a project | `_seed_*/`, `_archive/` |

Relative paths written inside `_memory/` and `_canon/` files resolve **against the file
they appear in**, never against the project root. `validate_project.sh` checks this.

## Validate

```bash
bash scripts/validate_project.sh <project_dir>
```

Exit 0 conforming; exit 1 with one `FAIL:` line per violation. Three severities:

| | Meaning |
|---|---|
| `FAIL` | A defect you can and should fix. Sets exit 1 |
| `NOTE` | A finding on a file the protocol forbids you to edit — sealed, or under `_memory/legacy/` — or an advisory. Report it verbatim; never act on it. Exit unaffected |
| `WARN` | A target exceeded, not a rule broken |

Checks the identity guard, `끝` sealing, filename/frontmatter agreement, unfilled
placeholders, artifact naming, view stamps, the session-start read budget, and four
contract properties: `CLAUDE.md` is self-sufficient, the `canon:` declaration agrees
with the filesystem, relative canon paths resolve against their own file, and every
branch row marked `active` names a directory that exists.

## Rebuild a session index

```bash
bash scripts/reindex.sh <project_dir>
```

`_memory/_index.md` is a view over `sessions/`, rebuilt from session frontmatter. It is
not maintained by hand and is not tied to sealing — run this whenever the view is
wanted.

## Changing a skill

**There is no live-edit shortcut.** Installed plugins run from a *cache copy*, not from
this directory, and the refresh is version-gated. Editing a `SKILL.md` here changes
nothing until all seven steps (0–6) are done. One command per line: Windows PowerShell
5.1 has no `&&`, and chaining these is a parser error there.

```bash
# 0. git status --short must be EMPTY. An untracked file is not in the package,
#    and every command below will report success without it.
git status --short
# 1. edit skills/<name>/SKILL.md
# 2. bump "version" in .claude-plugin/plugin.json   ← without this, step 4 is a no-op
# 3. commit and push — the marketplace resolves from the git remote, not this folder
git add -A
git commit -m "..."
git push
# 4. refresh Claude Code
claude plugin marketplace update 00_memory
claude plugin update iclaw@00_memory
# 5. restart the session — the skill registry binds at session start
# 6. refresh Cowork: in the Claude desktop app, open the 00_memory marketplace,
#    refresh it, then Update the plugin. Cowork mirrors plugins from the app's own
#    registry, never from the cache in step 4, and nothing re-ingests on its own.
```

**Do not remove and re-add the plugin when Update looks inactive.** Steps 4 and 6 are
the whole update path and they work — 1.8.0 installed this way, matching commit
`0546ce8`. See *Never remove the plugin in order to update it* below for why removal is
the more expensive road.

Skipping step 2 is the failure that bites hardest: every command reports success,
`claude plugin list` shows the plugin enabled, and the session silently keeps running
the previous version.

## Verify what is actually loaded

`~/.claude/plugins/installed_plugins.json` names the live copy, its version, **and the
git commit it was built from**. That is the only check that cannot lie — `claude plugin
list` reports enablement, not version, and the cache directory lists every version ever
installed.

```bash
cat ~/.claude/plugins/installed_plugins.json
```

```json
"iclaw@00_memory": [{ "version": "1.8.0",
                      "gitCommitSha": "0546ce872d6a9299d1967674bb6d43d3c4706b13" }]
```

Match that SHA against `git log -1 --format=%H`. If they agree, the running plugin is
this working tree. If they disagree, step 2 or step 3 was skipped.

## Never remove the plugin in order to update it

Updating is steps 0–6. Removing and re-adding is not a stronger version of that — it is
a different operation with its own failure mode, and it is how an afternoon gets lost.

Three registries hold this marketplace, and a removal that clears only some of them
looks successful and reverts:

| Registry | File / surface | Cleared by |
|---|---|---|
| CLI runtime | `~/.claude/plugins/known_marketplaces.json` | `claude plugin marketplace remove 00_memory` |
| CLI declarative | `~/.claude/settings.json` → `extraKnownMarketplaces` | hand-editing that file |
| Account | claude.ai → Settings → Plugins | **the web app only** |

`extraKnownMarketplaces` is declarative: Claude Code reconciles the runtime registry
against it at startup, so `marketplace remove` deletes the entry, reports success, and
the next launch re-clones it. Observed 2026-09-08 — the plugin record emptied at
15:44:28 and `marketplaces/00_memory` was re-cloned at 15:51:59, with `settings.json`
the only remaining file naming it.

The account-level entry is the one the desktop app checks when it says a plugin is
*already added*. Removing it from the desktop app has not worked here; removing it from
the **web** did.

Order, if you must remove: web first, then `extraKnownMarketplaces`, then
`marketplace remove`, then delete the on-disk copies, then restart both apps.

## Old versions in the cache are normal

`~/.claude/plugins/cache/` is additive — every installed version stays. Only the path in
`installed_plugins.json` is live; the rest are inert and safe to delete.

```bash
ls ~/.claude/plugins/cache/00_memory/iclaw/
```

One directory is **not** inert bookkeeping: `~/.claude/plugins/cache/iclaw/` holds
1.0.0–1.6.0 from before the 1.7.1 marketplace rename. That marketplace no longer exists,
so nothing can ever refresh or remove them. Delete the directory.

## Docs

- `docs/starting-a-new-project.md` — **start here.** You copy nothing out of this
  folder; `iclaw:project-init` writes the scaffold

- `docs/specs/2026-08-28-iclaw-protocol-v3-design.md` — the protocol
- `docs/plans/2026-08-28-iclaw-plugin-implementation.md` — build plan
- `_archive/` — superseded v2.0.0 governance corpus
