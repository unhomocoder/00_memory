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

## Docs

- `docs/specs/2026-08-28-iclaw-protocol-v3-design.md` — the protocol
- `docs/plans/2026-08-28-iclaw-plugin-implementation.md` — build plan
- `_archive/` — superseded v2.0.0 governance corpus
