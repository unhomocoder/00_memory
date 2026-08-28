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

## Validate

```bash
bash scripts/validate_project.sh <project_dir>
```

Exit 0 conforming; exit 1 with one `FAIL:` line per violation. Checks the identity
guard, `끝` sealing, filename/frontmatter agreement, artifact naming, view stamps,
and the session-start read budget.

## Changing a skill

**There is no live-edit shortcut.** Installed plugins run from a *cache copy*, not from
this directory, and the refresh is version-gated. Editing a `SKILL.md` here changes
nothing until all five steps are done:

```bash
# 1. edit skills/<name>/SKILL.md
# 2. bump "version" in .claude-plugin/plugin.json   ← without this, step 4 is a no-op
# 3. commit and push — the marketplace resolves from the git remote, not this folder
git add -A && git commit -m "..." && git push
# 4. refresh
claude plugin marketplace update iclaw && claude plugin update iclaw@iclaw
# 5. restart the session — the skill registry binds at session start
```

Skipping step 2 is the failure that bites hardest: every command reports success,
`claude plugin list` shows the plugin enabled, and the session silently keeps running
the previous version.

Verify what is actually loaded:

```bash
ls ~/.claude/plugins/cache/iclaw/iclaw/*/skills/
```

## Docs

- `docs/specs/2026-08-28-iclaw-protocol-v3-design.md` — the protocol
- `docs/plans/2026-08-28-iclaw-plugin-implementation.md` — build plan
- `_archive/` — superseded v2.0.0 governance corpus
