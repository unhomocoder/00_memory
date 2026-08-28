# Archive

Superseded governance files, retained as the record of what v3 replaced.

## v2.0.0 (retired 2026-08-29)

`Claude.md` and `Memory.md` were read **in full at every session start**, together
with a full session memory file — 826 lines of governance before a single line of
project context, and for `05_agentic_thesis` a further 411-line session file on top.

Project-level customization was expressed as declared deltas in a child directive,
reconciled against the parent every session. Nesting was forbidden: "no nesting;
there are no grandchildren." `04_nov_project` ran three levels deep in practice.

Replaced by the `iclaw` plugin — three on-demand skills plus a ~45-line per-project
`CLAUDE.md`, measured at 126 resident lines against v2.0.0's 826.

| File | Superseded by |
|---|---|
| `Claude.md` | `skills/*/SKILL.md` + `templates/CLAUDE.md` |
| `Memory.md` | `skills/project-memory/SKILL.md` |
| `directive_template.md` | Nothing. Child directives are gone — projects own their `CLAUDE.md` outright |
| `manifest_header.md` | `templates/_manifest.md` |
| `memory_template_project.md` | `templates/LONGTERM.md`, `templates/STATE.md`, `templates/session.md` |
| `shared_vocab_template.md` | `templates/vocab.md` |

See `docs/specs/2026-08-28-iclaw-protocol-v3-design.md` §9 for what was dropped and
why, and §1 for the two limitations that drove the redesign.

**These files are historical. Do not read them as operative instructions.**
