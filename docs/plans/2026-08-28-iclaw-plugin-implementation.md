# iclaw v3 Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `iclaw` plugin — three skills, six templates, and a validator — so that project memory and behavior load on demand instead of resident in every prompt, and so the same source serves Claude Code and Cowork.

**Architecture:** `D:\00_iClaw\00_parent\` becomes a single-plugin marketplace repo. Three skills (`project-init`, `project-memory`, `project-artifacts`) carry all protocol; each project owns a ~45-line `CLAUDE.md` that points at them. A POSIX validator script checks any project directory against the protocol, giving real red-green cycles for work that is otherwise all Markdown.

**Tech Stack:** Markdown + YAML frontmatter, JSON plugin manifests, Bash (Git Bash on Windows) for the validator, PowerShell for filesystem operations.

**Spec:** `docs/specs/2026-08-28-iclaw-protocol-v3-design.md` (revision 2). Section references below (`spec §N`) point there.

## Global Constraints

- Protocol version string is exactly `iclaw/1.0.0` in every frontmatter block.
- Memory folder name is exactly `_memory/`. Never `.memory/` — Obsidian does not index dot-directories.
- Folders prefixed `_` or `00_` are infrastructure and are **excluded** from `{nn}` numbering. Branch numbering restarts at `01`.
- **Never overwrite a file in `output/`.** Regeneration increments `_v{n}`.
- **A session file ending in `끝` is sealed and must never be modified**, by any agent, without exception.
- **The agent may never assign the `[confirmed]` marker.** Agent-derived claims are `[proposed]` until the user approves them.
- Generated views (`_memory/_index.md`, `output/_manifest.md`) carry a head line: `generated: {yyyy-mm-dd} · method: manual`.
- Session-start read (`STATE.md` + `LONGTERM.md`) targets ≤100 lines combined. `CLAUDE.md` ~45 lines, counted separately.
- All files UTF-8. The character `끝` (U+B05D) must survive round-trips — verify on Windows.
- Filename `n:` and the session frontmatter `n:` always agree; `n: 1` carries **no** suffix.
- **Do not run `git commit` or `git push` unless the user explicitly asks.** Task 8 is gated on that.

---

### Task 1: Plugin scaffold and install pipeline

Proves the distribution mechanism works before any real content exists.

**Files:**
- Create: `D:\00_iClaw\00_parent\.claude-plugin\plugin.json`
- Create: `D:\00_iClaw\00_parent\.claude-plugin\marketplace.json`
- Create: `D:\00_iClaw\00_parent\README.md`
- Create: `D:\00_iClaw\00_parent\skills\project-artifacts\SKILL.md` (stub, replaced in Task 5)

**Interfaces:**
- Consumes: nothing.
- Produces: an installable marketplace at path `D:\00_iClaw\00_parent`, plugin name `iclaw`, skill namespace `iclaw:*`.

- [ ] **Step 1: Verify the local-path marketplace source format**

Spec §13 lists this as unverified. Resolve it now by reading how an installed marketplace records its source.

```bash
cat "$HOME/.claude/plugins/known_marketplaces.json"
```

Expected: each entry has `source.source` = `"github"` with a `repo` field. A local directory uses `source.source` = `"directory"` with a `path` field. If `claude plugin marketplace add <path>` is available, prefer letting the CLI write the entry rather than hand-editing.

- [ ] **Step 2: Write `plugin.json`**

```json
{
  "name": "iclaw",
  "description": "Project memory and governance protocol: on-demand skills for scaffolding projects, maintaining layered memory (LONGTERM/STATE/sessions/canon), and naming versioned output artifacts",
  "version": "1.0.0",
  "author": { "name": "Kyle" },
  "license": "MIT",
  "keywords": ["memory", "project-management", "governance", "obsidian"]
}
```

- [ ] **Step 3: Write `marketplace.json`**

```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "iclaw",
  "description": "Kyle's project memory and governance protocol",
  "owner": { "name": "Kyle" },
  "plugins": [
    {
      "name": "iclaw",
      "source": "./",
      "description": "Project memory and governance protocol: on-demand skills for scaffolding projects, maintaining layered memory, and naming versioned output artifacts"
    }
  ]
}
```

- [ ] **Step 4: Write the stub skill so the pipeline has something to show**

`skills/project-artifacts/SKILL.md`:

```markdown
---
name: project-artifacts
description: Name, version, and register files written to a project's output/ folder. Use before writing any artifact file.
---

# Project Artifacts

Stub. Replaced in Task 5.
```

- [ ] **Step 5: Write `README.md`**

```markdown
# iclaw

Project memory and governance protocol for Claude Code and Cowork.

Three on-demand skills replace always-resident governance Markdown:

| Skill | Use when |
|---|---|
| `iclaw:project-init` | Starting a project, branching one, or migrating a folder onto the protocol |
| `iclaw:project-memory` | Session start, recording a decision, session end |
| `iclaw:project-artifacts` | Before writing any file to `output/` |

Each project owns a ~45-line `CLAUDE.md` that points at these skills. See
`docs/specs/2026-08-28-iclaw-protocol-v3-design.md` for the full protocol.

## Install

Add this directory as a marketplace, then install the plugin user-scoped so it
is live in every project.
```

- [ ] **Step 6: Install and verify the skills appear**

Add the marketplace from the local path and install `iclaw` user-scoped, then confirm `iclaw:project-artifacts` is listed as an available skill.

Expected: the skill appears in the skill listing. If it does not, the plugin is not being discovered — check that `.claude-plugin/` sits at the marketplace root and that `source` is `"./"`.

- [ ] **Step 7: Commit — SKIP unless the user has asked for commits**

Per Global Constraints. If not asked, leave the working tree dirty and note it.

---

### Task 2: Templates and the validator

The validator is the test harness for Tasks 3–6. Written first so later tasks have red-green cycles.

**Files:**
- Create: `templates/CLAUDE.md`, `templates/LONGTERM.md`, `templates/STATE.md`, `templates/session.md`, `templates/_index.md`, `templates/_manifest.md`, `templates/vocab.md`
- Create: `scripts/validate_project.sh`

**Interfaces:**
- Consumes: nothing.
- Produces: `scripts/validate_project.sh <project_dir>` → exit 0 on conformance, exit 1 with one `FAIL: <reason>` line per violation on stdout. Tasks 3–6 call this.

- [ ] **Step 1: Write the failing validator test**

Create a deliberately broken fixture and confirm the validator rejects it.

```bash
mkdir -p /tmp/iclaw_fixture_bad/_memory/sessions
echo "no frontmatter here" > /tmp/iclaw_fixture_bad/CLAUDE.md
bash scripts/validate_project.sh /tmp/iclaw_fixture_bad
```

Expected before implementation: `bash: scripts/validate_project.sh: No such file or directory`

- [ ] **Step 2: Write `scripts/validate_project.sh`**

```bash
#!/usr/bin/env bash
# Validate a directory against the iclaw v3 protocol.
# Usage: validate_project.sh <project_dir>   → exit 0 conforming, 1 otherwise
set -u
D="${1:?usage: validate_project.sh <project_dir>}"
fails=0
fail() { echo "FAIL: $*"; fails=$((fails+1)); }

# --- required structure -----------------------------------------------------
[ -f "$D/CLAUDE.md" ]            || fail "missing CLAUDE.md"
[ -d "$D/_memory" ]              || fail "missing _memory/"
[ -f "$D/_memory/LONGTERM.md" ]  || fail "missing _memory/LONGTERM.md"
[ -f "$D/_memory/STATE.md" ]     || fail "missing _memory/STATE.md"
[ -d "$D/_memory/sessions" ]     || fail "missing _memory/sessions/"
[ -d "$D/input" ]                || fail "missing input/"
[ -d "$D/output" ]               || fail "missing output/"
[ -d "$D/.memory" ]              && fail ".memory/ present — must be _memory/ (Obsidian ignores dot-dirs)"

# --- frontmatter helper -----------------------------------------------------
fm() { sed -n '/^---$/,/^---$/p' "$1" 2>/dev/null | sed -n "s/^$2: *//p" | head -1; }

# --- identity guard ---------------------------------------------------------
if [ -f "$D/CLAUDE.md" ] && [ -f "$D/_memory/LONGTERM.md" ]; then
  pc=$(fm "$D/CLAUDE.md" project)
  pl=$(fm "$D/_memory/LONGTERM.md" project)
  [ -n "$pc" ] || fail "CLAUDE.md has no project: field"
  [ "$pc" = "$pl" ] || fail "identity guard: CLAUDE.md project='$pc' != LONGTERM.md project='$pl'"
fi

# --- protocol version -------------------------------------------------------
for f in "$D/CLAUDE.md" "$D/_memory/LONGTERM.md" "$D/_memory/STATE.md"; do
  [ -f "$f" ] || continue
  v=$(fm "$f" protocol)
  [ "$v" = "iclaw/1.0.0" ] || fail "$(basename "$f"): protocol='$v', expected iclaw/1.0.0"
done

# --- session files ----------------------------------------------------------
for s in "$D"/_memory/sessions/*.md; do
  [ -e "$s" ] || continue
  b=$(basename "$s" .md); n=$(fm "$s" n); st=$(fm "$s" status)
  case "$b" in
    *_session)    exp=1 ;;
    *_session_*)  exp="${b##*_}" ;;
    *)            fail "$b: filename must end _session or _session_<n>"; continue ;;
  esac
  [ "$n" = "$exp" ] || fail "$b: frontmatter n='$n' disagrees with filename (expected $exp)"
  last=$(tr -d '[:space:]' < "$s" | tail -c 3)
  if [ "$st" = "sealed" ]; then
    [ "$last" = "끝" ] || fail "$b: status sealed but does not end with 끝"
  else
    [ "$last" = "끝" ] && fail "$b: ends with 끝 but status='$st' (must be sealed)"
  fi
done

# --- generated views stamped ------------------------------------------------
for v in "$D/_memory/_index.md" "$D/output/_manifest.md"; do
  [ -f "$v" ] || continue
  grep -q '^generated: .* · method: ' "$v" || fail "$(basename "$v"): missing 'generated: … · method: …' stamp"
done

# --- output artifact naming -------------------------------------------------
for f in "$D"/output/*/*; do
  [ -f "$f" ] || continue
  bn=$(basename "$f")
  echo "$bn" | grep -Eq '^[0-9]{2}_[a-z0-9-]+_v[0-9]+(_draft|_final)?\.[A-Za-z0-9]+$' \
    || fail "output/$(basename "$(dirname "$f")")/$bn: does not match {nn}_{slug}_v{n}[_status].{ext}"
done

# --- session-start read budget ----------------------------------------------
if [ -f "$D/_memory/STATE.md" ] && [ -f "$D/_memory/LONGTERM.md" ]; then
  lines=$(cat "$D/_memory/STATE.md" "$D/_memory/LONGTERM.md" | wc -l)
  [ "$lines" -le 100 ] || echo "WARN: session-start read is $lines lines (target <=100)"
fi

if [ "$fails" -eq 0 ]; then echo "OK: $D conforms to iclaw/1.0.0"; exit 0; fi
echo "$fails failure(s)"; exit 1
```

- [ ] **Step 3: Run the validator against the broken fixture**

```bash
bash scripts/validate_project.sh /tmp/iclaw_fixture_bad; echo "exit=$?"
```

Expected: several `FAIL:` lines (missing `_memory/LONGTERM.md`, missing `input/`, `CLAUDE.md` has no `project:` field) and `exit=1`.

- [ ] **Step 4: Write the seven templates**

`templates/CLAUDE.md` — copy spec §9 verbatim.

`templates/LONGTERM.md`:

```markdown
---
project: {project_name}
created: {yyyy-mm-dd}
status: active
inherits: none
profile: none
protocol: iclaw/1.0.0
---

# {project_name} — Long-Term Memory

## What This Project Is

{One paragraph. What it is, and what "done" looks like.}

## Objectives

- [ ] {not started}   [~] in progress   [x] complete

## Durable Decisions

| Date | Decision | Why | Marker | Supersedes |
|---|---|---|---|---|

## [TBD] Register

Deliberately undecided. **A [TBD] is not a licence to improvise — stop and ask.**

| Item | Waits on | Marker |
|---|---|---|

## Constraints

## Branches

_None._
```

`templates/STATE.md`:

```markdown
---
project: {project_name}
updated: {yyyy-mm-dd}
last_session: {filename or none}
scope: {project_name}
reconstructed: false
protocol: iclaw/1.0.0
---

# Current State

{2–4 sentences: where we are, what just happened.}

## Open Threads

- [ ] {thing} → next step: {what}

## Blocked

- {thing} — waiting on {what}

## Do Not Repeat

- {approach} — rejected because {why}
```

`templates/session.md`:

```markdown
---
project: {project_name}
scope: {project_name}
date: {yyyy-mm-dd}
n: 1
status: active
protocol: iclaw/1.0.0
---

## Work

### {yyyy-mm-dd}

{Running log. Drafts, decisions, pivots, discarded approaches — kept, not cleaned up.}

## Files Touched

### Produced

- `output/{yyyy_mm_dd}/{nn}_{slug}_v{n}.{ext}` — {what it is}

### Modified

- `{path}` — {what changed and why}

### Consumed

- `input/{filename}` — {what it is}

## Summary

{Written at end of session only.}
```

`templates/_index.md`:

```markdown
# Session Index — {project_name}

generated: {yyyy-mm-dd} · method: manual

View over `sessions/`. Session files are the source. Never add information here
that is not in a session file.

| Session | Date | Scope | Focus | Artifacts | Sealed |
|---|---|---|---|---|---|
```

`templates/_manifest.md`:

```markdown
# Output Manifest — {project_name}

generated: {yyyy-mm-dd} · method: manual

View over files in `output/`. The filesystem is authoritative. Rows are appended
at write time. Missing files are marked, never recreated.

| File | Created | Purpose | Supersedes | Session | Status |
|---|---|---|---|---|---|
```

`templates/vocab.md`:

```markdown
# {project_name} — Vocabulary

Canonical terminology. These definitions override general-knowledge defaults.
Never sealed; the `끝` convention does not apply. Entries are never removed —
mark obsolete terms `[deprecated]` and name the replacement.

A branch's vocabulary overrides its parent's. **On conflict, flag it — never
resolve silently.**

## Markers

| Marker | Meaning |
|---|---|
| `[confirmed]` | The user decided it. **The agent may never assign this marker.** |
| `[provisional]` | Direction given, details fluid |
| `[proposed]` | Agent's inference. Not canon until the user approves it |
| `[open]` | Needs discussion. Flag any draft that depends on it |
| `[deprecated]` | Replaced; successor named alongside |

---

**{Term}** — `[marker]` {definition}. {What it is not, where confusion is plausible.}
```

- [ ] **Step 5: Build a conforming fixture and verify the validator passes it**

```bash
rm -rf /tmp/iclaw_fixture_ok && mkdir -p /tmp/iclaw_fixture_ok/_memory/sessions /tmp/iclaw_fixture_ok/input /tmp/iclaw_fixture_ok/output
cd /d/00_iClaw/00_parent
for pair in "CLAUDE.md:/tmp/iclaw_fixture_ok/CLAUDE.md" "LONGTERM.md:/tmp/iclaw_fixture_ok/_memory/LONGTERM.md" "STATE.md:/tmp/iclaw_fixture_ok/_memory/STATE.md"; do
  sed 's/{project_name}/fixture/g; s/{yyyy-mm-dd}/2026-08-28/g' "templates/${pair%%:*}" > "${pair##*:}"
done
bash scripts/validate_project.sh /tmp/iclaw_fixture_ok; echo "exit=$?"
```

Expected: `OK: /tmp/iclaw_fixture_ok conforms to iclaw/1.0.0` and `exit=0`.

- [ ] **Step 6: Verify `끝` survives a Windows round-trip**

```bash
printf -- '---\nstatus: sealed\n---\n\n## Work\n\n끝\n' > /tmp/iclaw_seal_test.md
tr -d '[:space:]' < /tmp/iclaw_seal_test.md | tail -c 3 | xxd | head -1
```

Expected: bytes `eb 81 9d` — UTF-8 for U+B05D. If this shows mojibake, the writing tool is not emitting UTF-8 and every template write must be redirected through a UTF-8-explicit path.

---

### Task 3: `iclaw:project-init`

**Files:**
- Create: `skills/project-init/SKILL.md`

**Interfaces:**
- Consumes: `templates/*` from Task 2; `scripts/validate_project.sh` for self-check.
- Produces: a conforming project directory. Later skills assume `_memory/LONGTERM.md`, `_memory/STATE.md`, `_memory/sessions/`, `input/`, `output/_manifest.md` all exist, and that `CLAUDE.md` frontmatter carries `project`, `memory_root`, `canon`, `profile`, `protocol`.

- [ ] **Step 1: Write the failing test**

```bash
bash scripts/validate_project.sh /tmp/iclaw_init_test; echo "exit=$?"
```

Expected: `FAIL: missing CLAUDE.md` and `exit=1` — the directory does not exist yet.

- [ ] **Step 2: Write `skills/project-init/SKILL.md`**

Frontmatter exactly:

```markdown
---
name: project-init
description: Scaffold a new iclaw project, branch an existing project into a sub-project, or migrate an existing folder onto the iclaw protocol. Use when starting a new project, adding a nested sub-project or topic branch, or bringing an unmanaged folder under iclaw memory.
---
```

Body must contain, in order:

1. **Mode selection** — `new` (workspace root), `branch` (inside an existing project), `migrate` (existing unmanaged folder).
2. **Numbering** — list sibling directories, exclude any whose name starts with `_` or `00_`, take the highest `{nn}` prefix, add 1, zero-pad to two digits. Branch mode restarts at `01`.
3. **Questions to ask before writing** — name; one-paragraph purpose; initial objectives; enable `_canon/`?; profile (`research` / `creative` / `engineering` / `none`).
4. **Confirmation gate**, stated as a hard requirement:

   > Print the full tree you are about to create and wait for explicit
   > confirmation. Create nothing before the user says yes.

5. **Write order** — `CLAUDE.md`, `_memory/LONGTERM.md`, `_memory/STATE.md`, `_memory/_index.md`, `_memory/sessions/` (empty), `input/`, `output/_manifest.md`, and `_canon/vocab.md` when canon is enabled.
6. **Seeding rule:**

   > Seed `LONGTERM.md` with the purpose and objectives gathered above. Never
   > write an unfilled template. Set every `{placeholder}`.

7. **Branch mode extra step** — append a row to the parent's `LONGTERM.md` `## Branches` section: `| {nn}_{name} | {date} | {one-line purpose} |`.
8. **Migrate mode rule:**

   > Create only what is missing. **Never overwrite an existing `CLAUDE.md`.**
   > Report what was already present and what you added.

9. **Profile blocks** appended to `LONGTERM.md` after the core sections:
   - `research` — `## Corpus Conventions`
   - `creative` — `## Cast`, `## World Rules` (durable facts only; discarded ideas stay in session logs)
   - `engineering` — `## Interfaces`, `## Conventions`
   - `none` — nothing appended
10. **Self-check** — run `scripts/validate_project.sh` on the new directory and report the result.

- [ ] **Step 3: Run the skill against a scratch target**

Invoke `iclaw:project-init` in `new` mode, name `inittest`, purpose one sentence, two objectives, canon enabled, profile `research`, targeting the scratchpad directory.

- [ ] **Step 4: Verify**

```bash
bash scripts/validate_project.sh "<scratchpad>/01_inittest"; echo "exit=$?"
grep -c '{' "<scratchpad>/01_inittest/_memory/LONGTERM.md"
```

Expected: `OK: … conforms to iclaw/1.0.0`, `exit=0`, and a `{` count of `0` — no unfilled placeholders survived.

- [ ] **Step 5: Verify branch mode**

Invoke `iclaw:project-init` in `branch` mode inside `01_inittest`, name `subtest`.

```bash
ls -d "<scratchpad>/01_inittest/01_subtest"
bash scripts/validate_project.sh "<scratchpad>/01_inittest/01_subtest"; echo "exit=$?"
grep -A3 '## Branches' "<scratchpad>/01_inittest/_memory/LONGTERM.md"
```

Expected: the branch directory exists and numbers `01` (restarted, not `02`); it validates; the parent's `## Branches` section contains a row for `01_subtest`.

---

### Task 4: `iclaw:project-memory`

**Files:**
- Create: `skills/project-memory/SKILL.md`

**Interfaces:**
- Consumes: project structure from Task 3.
- Produces: session files matching `templates/session.md`; a rewritten `STATE.md`; appended rows in `_memory/_index.md`.

- [ ] **Step 1: Write the failing test**

```bash
ls "<scratchpad>/01_inittest/_memory/sessions/"
```

Expected: empty — no session file exists yet.

- [ ] **Step 2: Write `skills/project-memory/SKILL.md`**

Frontmatter exactly:

```markdown
---
name: project-memory
description: Read, update, and seal iclaw project memory — STATE, LONGTERM, canon, and the session log. Use at the start of substantive project work, when recording a decision or a rejected approach, and at session end when the user signals to seal.
---
```

Body sections:

**§ Scope resolution** — copy spec §5.1 verbatim as a numbered procedure. State the guard as a stop condition:

> If `_memory/LONGTERM.md` `project:` does not equal `CLAUDE.md` `project:`,
> **stop. Write nothing.** Report both values and wait.

**§ Routing** — copy spec §5.2. Ask the scope question **only** if the project directory contains at least one `{nn}_`-prefixed child. Flat projects are never asked.

**§ ORIENT** — the five-step procedure from spec §8.2, ending in the report block:

```
PROJECT  {nn}_{name}
SCOPE    {active scope, or "flat"}
MEMORY   STATE {date} · session {filename} ({new|resumed})
STATE    {2–3 sentences}
OPEN     {open threads, or none}
FLAGS    {protocol drift · guard mismatch · unregistered input/ files · view drift · none}
```

Rule: read `STATE.md` and `LONGTERM.md` only. Parent `LONGTERM.md` additionally, and only if `inherits:` is declared. **Never** read session files, `_index.md`, or `_canon/` at orientation.

**§ RECORD** — routing table for what goes where:

| Event | Destination |
|---|---|
| Any work, thinking, pivot, discarded approach | session `## Work` |
| File written to `output/` | session `## Files Touched → Produced` **and** a `_manifest.md` row |
| Source file edited in place | session `## Files Touched → Modified` only |
| File read from `input/` | session `## Files Touched → Consumed` only |
| Durable decision | `LONGTERM.md ## Durable Decisions` with a marker |
| Approach tried and rejected | `STATE.md ## Do Not Repeat` |
| New domain term or fact | `_canon/` — marked `[proposed]` unless the user confirmed it |
| Decision deliberately deferred | `LONGTERM.md ## [TBD] Register` |

**§ SEAL** — on the user's explicit signal only:

1. Write session `## Summary`.
2. Rewrite `STATE.md` in full.
3. Update `LONGTERM.md` objective checkboxes.
4. Append a row to `_memory/_index.md` and refresh its `generated:` stamp.
5. Set `status: sealed`, then append `끝` as the final line with nothing after it.

**§ Invariants** — stated as hard rules:

> - Never seal on your own initiative. Only on the user's explicit signal.
> - Never modify a file that ends with `끝`.
> - Never assign `[confirmed]`. That marker is the user's alone.
> - Never edit `_index.md` or `_manifest.md` to add information not in a session file.

**§ Edge cases** — copy the table from spec §8.2 verbatim.

- [ ] **Step 3: Run ORIENT**

Invoke `iclaw:project-memory` in `01_inittest`.

Expected: the six-line report block; a new file `_memory/sessions/2026_08_28_session.md` with `status: active`; no scope question asked before the branch existed, and after Task 3 Step 5 the scope question **is** asked.

- [ ] **Step 4: Run RECORD and SEAL, then verify**

Record one decision and one rejected approach, then signal seal.

```bash
P="<scratchpad>/01_inittest"
bash scripts/validate_project.sh "$P"; echo "exit=$?"
grep -c 'Do Not Repeat' "$P/_memory/STATE.md"
tail -c 10 "$P/_memory/sessions/2026_08_28_session.md" | xxd | head -1
grep '^generated:' "$P/_memory/_index.md"
```

Expected: validator passes; `STATE.md` has the `Do Not Repeat` heading; the session file's final bytes are `eb 81 9d` (`끝`) with no trailing content; `_index.md` carries a refreshed stamp.

- [ ] **Step 5: Verify the identity guard fires**

```bash
P="<scratchpad>/01_inittest"
sed -i 's/^project: inittest/project: WRONGNAME/' "$P/_memory/LONGTERM.md"
bash scripts/validate_project.sh "$P"; echo "exit=$?"
```

Expected: `FAIL: identity guard: CLAUDE.md project='inittest' != LONGTERM.md project='WRONGNAME'` and `exit=1`. Then invoke `iclaw:project-memory` and confirm it **refuses to write** and reports both values. Restore afterward:

```bash
sed -i 's/^project: WRONGNAME/project: inittest/' "$P/_memory/LONGTERM.md"
```

- [ ] **Step 6: Verify the resume path**

Create a second unsealed session file by hand, then invoke ORIENT.

Expected: the skill **resumes** the unsealed file under a dated subheading rather than creating a third. It must never auto-seal.

---

### Task 5: `iclaw:project-artifacts`

Replaces the Task 1 stub.

**Files:**
- Modify: `skills/project-artifacts/SKILL.md` (full replacement)

**Interfaces:**
- Consumes: `output/_manifest.md` from Task 3.
- Produces: paths matching `output/{yyyy_mm_dd}/{nn}_{slug}_v{n}[_status].{ext}`.

- [ ] **Step 1: Write the failing test**

```bash
mkdir -p "<scratchpad>/01_inittest/output/2026_08_28"
echo "x" > "<scratchpad>/01_inittest/output/2026_08_28/report.md"
bash scripts/validate_project.sh "<scratchpad>/01_inittest"; echo "exit=$?"
```

Expected: `FAIL: output/2026_08_28/report.md: does not match {nn}_{slug}_v{n}[_status].{ext}` and `exit=1`. Delete the bad file before continuing.

- [ ] **Step 2: Write the real `SKILL.md`**

Frontmatter exactly:

```markdown
---
name: project-artifacts
description: Name, version, and register files written to an iclaw project's output/ folder. Use before writing any artifact file, and when regenerating a previous artifact.
---
```

Body:

**§ Path** — `output/{yyyy_mm_dd}/{nn}_{slug}_v{n}[_status].{ext}`

| Element | Rule |
|---|---|
| `{yyyy_mm_dd}` | Creation date. One folder per date. A session crossing midnight keeps the folder it started in |
| `{nn}` | Two-digit ordinal within that date folder, from `01`. **Never reused, never renumbered**, even if earlier files are deleted |
| `{slug}` | Lowercase, hyphenated, ≤4 words. Names *what the artifact is*, not its topic. No dates, versions, or status words |
| `_v{n}` | Mandatory from `v1`. Continues across date folders for the same slug |
| `_status` | `_draft`, `_final`, or omitted |
| `.{ext}` | True file type. Never `.md` for HTML |

**§ The overwrite prohibition:**

> **Never overwrite an existing file in `output/`.** To regenerate an artifact,
> increment `_v{n}` and write a new file. Version order must be recoverable from
> the filesystem alone.

**§ Slug discipline** — distinguish artifacts, not topics. `report` and `analysis` are useless; `dataset-audit`, `eval-protocol`, `augmentation-ablation` are useful. Reuse a slug only for the same artifact.

**§ Registration** — copy the three-row table from spec §8.3. State explicitly that source files edited in place get **no** manifest row.

**§ Manifest row format:**

`| {date_folder}/{filename} | {yyyy-mm-dd} | {why it exists} | {v(n-1) or —} | {session filename} | {draft/final/superseded} |`

Append at write time, not at session end. Refresh the `generated:` stamp.

- [ ] **Step 3: Exercise it**

Ask for a short artifact to be written into `01_inittest`.

- [ ] **Step 4: Verify**

```bash
P="<scratchpad>/01_inittest"
ls "$P/output/2026_08_28/"
bash scripts/validate_project.sh "$P"; echo "exit=$?"
grep -c '^|' "$P/output/_manifest.md"
```

Expected: a file matching `01_{slug}_v1.md`; validator passes; the manifest has a header row plus one data row.

- [ ] **Step 5: Verify the overwrite prohibition**

Ask for the same artifact to be regenerated.

Expected: a **new** file `_v2` appears; `_v1` is untouched; the manifest gains a row whose `Supersedes` column reads `v1`.

---

### Task 6: Integration verification

**Files:** none created. This task only runs and reports.

**Interfaces:**
- Consumes: everything from Tasks 1–5.
- Produces: a go/no-go for publishing.

- [ ] **Step 1: Full lifecycle on a clean project**

Scaffold `02_lifecycle` in the scratchpad, orient, record two decisions, produce two artifacts (one regenerated to `v2`), branch it, work in the branch, seal both scopes.

- [ ] **Step 2: Validate every scope**

```bash
for d in "<scratchpad>/02_lifecycle" "<scratchpad>/02_lifecycle/01_branch"; do
  echo "--- $d"; bash scripts/validate_project.sh "$d"
done
```

Expected: `OK` for both, exit 0 each.

- [ ] **Step 3: Measure the session-start read**

```bash
P="<scratchpad>/02_lifecycle"
echo "STATE+LONGTERM: $(cat "$P/_memory/STATE.md" "$P/_memory/LONGTERM.md" | wc -l) lines"
echo "CLAUDE.md:      $(wc -l < "$P/CLAUDE.md") lines"
```

Expected: STATE+LONGTERM ≤ 100; `CLAUDE.md` ≈ 45. If STATE+LONGTERM exceeds 100 on a project this young, the templates are too verbose — trim them, since the whole design rests on this number.

- [ ] **Step 4: Confirm the off-tangent path costs nothing**

In `02_lifecycle`, ask a question unrelated to the project ("what's the difference between TCP and UDP?").

Expected: answered directly. **No skill invoked, no memory file read.** If a skill fires here, the `CLAUDE.md` trigger wording in spec §9 is too aggressive and must be narrowed.

- [ ] **Step 5: Confirm sealed files are inviolable**

Ask for an edit to a sealed session file.

Expected: refusal, with the `끝` rule cited.

---

### Task 7: Archive the superseded `00_parent` corpus

**Files:**
- Create: `_archive/v2.0.0/` containing the retired files
- Move: `Claude.md`, `Memory.md`, `templates/directive_template.md`, `templates/manifest_header.md`, `templates/memory_template_project.md`, `templates/shared_vocab_template.md`
- Create: `_archive/README.md`

**Interfaces:**
- Consumes: Task 6 go/no-go. **Do not start until Task 6 passes** — these files are the only remaining copy of the v2.0.0 protocol.

- [ ] **Step 1: Move, do not delete**

```powershell
$dst = 'D:\00_iClaw\00_parent\_archive\v2.0.0'
New-Item -ItemType Directory -Force -Path $dst | Out-Null
foreach ($f in @('Claude.md','Memory.md')) {
  $p = Join-Path 'D:\00_iClaw\00_parent' $f
  if (Test-Path -LiteralPath $p) { Move-Item -LiteralPath $p -Destination $dst }
}
Get-ChildItem 'D:\00_iClaw\00_parent\templates' -Filter '*_template*.md' | Move-Item -Destination $dst
Get-ChildItem 'D:\00_iClaw\00_parent\templates' -Filter 'manifest_header.md' | Move-Item -Destination $dst
Get-ChildItem $dst | Select-Object Name
```

Expected: six files listed under `_archive\v2.0.0`.

- [ ] **Step 2: Write `_archive/README.md`**

```markdown
# Archive

Superseded governance files, retained as the record of what v3 replaced.

## v2.0.0 (retired 2026-08-28)

`Claude.md` (551 lines) and `Memory.md` (277 lines) were read in full at every
session start, together with a full session memory file. Project-level
customization was expressed as declared deltas in a child directive reconciled
against the parent each session.

Replaced by the `iclaw` plugin: three on-demand skills plus a ~45-line
per-project `CLAUDE.md`. See `docs/specs/2026-08-28-iclaw-protocol-v3-design.md`.
```

- [ ] **Step 3: Confirm no live path still points at the moved files**

```bash
cd /d/00_iClaw/00_parent
grep -rn "00_parent/Claude.md\|00_parent/Memory.md" --include='*.md' skills templates docs 2>/dev/null | grep -v '_archive' | grep -v 'docs/specs'
```

Expected: no output. Matches inside `docs/specs/` are historical references and are fine.

- [ ] **Step 4: Remove the review scratch**

```powershell
Remove-Item -LiteralPath 'D:\00_iClaw\_review' -Recurse -Force
Get-ChildItem 'D:\00_iClaw' | Select-Object Name
```

Expected: `_review` gone. Remaining: `00_parent`, `01_MLVU_project`, `anaconda_projects`, `notebook.ipynb`, `.claude`, `.ipynb_checkpoints`.

---

### Task 8: Publish — GATED ON USER INSTRUCTION

**Do not begin this task until the user explicitly asks for a commit and a push.** Per Global Constraints.

**Files:**
- Create: `.gitignore`

**Interfaces:**
- Consumes: a passing Task 6 and a completed Task 7.
- Produces: a remote the Cowork install can resolve.

- [ ] **Step 1: Ask the user for the two open decisions**

Repo name, and visibility (public or private). Spec §13 lists both as user decisions. Do not choose either yourself.

- [ ] **Step 2: Write `.gitignore`**

```gitignore
# Scratch and OS noise
.DS_Store
Thumbs.db
*.tmp

# Nothing else is ignored: templates, skills, specs and plans are all tracked.
```

- [ ] **Step 3: Initialize and commit**

```bash
cd /d/00_iClaw/00_parent
git init
git add -A
git status --short
```

Review the file list before committing. Expected: manifests, three skills, seven templates, the validator, docs, `_archive/`. Then commit with a message ending in the required trailer.

- [ ] **Step 4: Create the remote and push**

Use `gh repo create` with the name and visibility from Step 1, then push.

- [ ] **Step 5: Verify the round trip**

Re-add the marketplace from the GitHub source in a scratch location and confirm all three skills resolve. Expected: `iclaw:project-init`, `iclaw:project-memory`, `iclaw:project-artifacts` all listed.

- [ ] **Step 6: Install in Cowork and verify**

Install the plugin in Cowork and run `iclaw:project-init`. This is the first real test of the cross-platform claim in spec §D1, and it closes the last item in spec §13 — whether Cowork needs a packaged `.plugin` file in addition to the marketplace install. Record the answer in the spec.

- [ ] **Step 7: Create `01_agentic_thesis`**

Paste `docs/2026-08-28-cowork-prompt-01-agentic-thesis.md` into Cowork. Then validate the result:

```bash
bash scripts/validate_project.sh "D:/00_iClaw/01_agentic_thesis"
```

Expected: `OK`. Confirm `_canon/vocab.md` carries the migrated corpus vocabulary, that `STATE.md` lists the six open threads, and that **nothing is marked `[confirmed]` that the prompt did not already mark that way.**

---

## Self-Review

**Spec coverage.** §4.1 → Task 1. §4.2, §10 → Task 2. §4.3, §4.4 → Tasks 2, 4, 6. §5.1 → Tasks 2, 4. §5.2, §5.3 → Tasks 3, 4. §6 → Tasks 2, 3, 4. §7 → Tasks 2, 4, 5. §8.1 → Task 3. §8.2 → Task 4. §8.3 → Task 5. §9 → Tasks 2, 3. §11 → Task 7. §12 → Task 6. §13 → Tasks 1, 8.

**Known gap, deliberately left:** spec §13's `01_MLVU_project` review has no task. It is unrelated to the plugin and blocked on the user, not on this plan.

**Type consistency.** `scripts/validate_project.sh <project_dir>` → exit 0/1 is used identically in Tasks 2, 3, 4, 5, 6, 8. Skill names are `project-init`, `project-memory`, `project-artifacts` throughout, invoked as `iclaw:*`. Template filenames in Task 2 Step 4 match the writes in Task 3 Step 2. The `generated: … · method: …` stamp string is identical in the validator, both view templates, and the seal procedure.

**Ordering risk.** Task 7 destroys the only remaining copy of the v2.0.0 protocol and the `_review` corpus. It is explicitly gated on Task 6 passing.
