# CHANGELOG — `00_parent` corpus

Version history and migration notes for the governance corpus. Entries are appended,
never edited or reordered. Newest last.

**As of v3.0.0 this file is historical.** The corpus it tracked — `Claude.md` and
`Memory.md` — was retired to `_archive/v2.0.0/`, and change management moved to this
repository's git history. The `iclaw_administrator` project that maintained it was
dissolved. Rows below v3.0.0 describe a protocol that is no longer operative.

| Date | File | Version | Sections | Motivation | Migration |
|---|---|---|---|---|---|
| 2026-08-16 | Claude.md | 1.1.0 → 2.0.0 | all (renumbered) | Mutability classes, declared-delta child directives, `input/`/`output/` scaffold, artifact naming and overwrite prohibition, output manifest, files-are-data rule, administrator write monopoly. Detail in `Claude.md` Appendix A. | Lazy. Each project acquires `input/`, `output/`, and `output/_manifest.md` at its next orientation, on user confirmation. |
| 2026-08-16 | Memory.md | 1.0.0 → 2.0.0 | §3.1, §3.4 (new), §3.5, §4.4 (new) | Added `memory_md_version` / `directive_version` / `tags` to frontmatter; added Section 3 — Artifacts; added §4.4 Abandoned Sessions; stated administrator is bound by `끝`. Detail in `Memory.md` Appendix A. | Lazy. Sealed memory files predating v2.0.0 lack the new frontmatter fields; this is recorded as drift, never repaired (`Claude.md` §9.3). |
| 2026-08-16 | Claude.md, Memory.md, CHANGELOG.md | no version change | none | Filename repair only. All three files, plus both `_archive/` entries and both `00_parent_admin/` files, had been written with a doubled `.md.md` extension, so no path named in `Claude.md` §1 resolved. Renamed to canonical names. `_archive/Memory)v1.1.0.md.md` was additionally misnamed: its own frontmatter declares `version: 1.0.0`, so it was renamed `Memory_v1.0.0.md`, matching `Memory.md`'s `supersedes: 1.0.0`. | None. Content unchanged; no version bump. |
| 2026-08-29 | corpus | 2.0.0 → 3.0.0 | all (replaced) | Governance moved out of always-resident Markdown into the `iclaw` plugin: three on-demand skills (`project-init`, `project-memory`, `project-artifacts`), a ~45-line per-project `CLAUDE.md`, and four durable memory tiers (LONGTERM / STATE / sessions / canon). Nesting is now unbounded and branching is an operation. Mutability classes, the precedence order, the LAYERS declaration, child directives, and the administrator project were all dropped — their only job was parent-vs-child arbitration, and there is no parent. Measured effect: 826 resident lines → 126. Detail in `docs/specs/2026-08-28-iclaw-protocol-v3-design.md`. | Not lazy, and not automatic. Old projects are not migrated; the skills ignore any folder lacking `CLAUDE.md` + `_memory/`. `iclaw:project-init` in migrate mode brings a folder across on request, creating only what is missing and never overwriting an existing `CLAUDE.md`. Sealed memory files predating v3 keep their v2.0.0 frontmatter; the drift is reported at orientation and never repaired. |
| 2026-08-29 | plugin | 1.0.0 → 1.1.0 | skills/ | The 1.0.0 install cached a Task-1 snapshot: the stub `project-artifacts` plus the since-archived v2.0.0 files. `project-init` and `project-memory` were never in the cache, so no session could invoke them while the source looked complete. Cache refresh is version-gated, so a bump was required to ship the real skills. | None. `claude plugin marketplace update iclaw && claude plugin update iclaw@iclaw`, then restart the session. Verify with `ls ~/.claude/plugins/cache/iclaw/iclaw/*/skills/`. |

---

## Notes on this file's own history

The first two rows were reconstructed on 2026-08-16 from the frontmatter and Appendix A
of the v2.0.0 files themselves, because the v2.0.0 release session recorded only the
string `v1.x → v2.0.0` and wrote no memory file. They are accurate as to content and
date but were not written contemporaneously. Recorded here rather than silently, per
`00_parent_admin/Claude.md` §7.

`_archive/` does not contain `Claude_v1.0.0.md`. No copy was taken when v1.0.0 was
superseded and none can be reconstructed; the gap is permanent and is noted here so
that future audits do not treat it as a new finding.
