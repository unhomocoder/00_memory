# `02_local_swarm` — Structure Design

**Status** approved 2026-09-03 · **Protocol** iclaw/1.0.0

Design for a new root project holding a local-model agent framework, and for the
Cowork instructions prompt that orients sessions against it.

---

## 1. Context

The request was a multi-agent framework running on local models. The workspace already
contains adjacent work: `01_agentic_thesis/02_forecast_architecture` carries an open
harness thread — a model-agnostic router, a frozen spine, a leakage pipeline — plus a
mapped hardware fleet and model-scale arms at ~7–8B / ~28–30B / frontier.

**Decision: the two are unrelated.** `02_local_swarm` is an independent root project.
The overlap is coincidental and stays uncoordinated; the thesis harness is bound to
experimental constraints (frozen prompts, leakage stack, Brier DV) that a general
framework should not inherit.

## 2. Decisions

| # | Decision | Why |
|---|---|---|
| 1 | Independent root project, `02_local_swarm` | No shared deliverable with the thesis; experimental constraints should not leak into a general tool |
| 2 | Source code lives in `src/`, a third working folder with its own git repo | A living source tree is edited in place; `output/`'s dated, versioned, append-only convention is built for artifacts and cannot express it |
| 3 | `_canon/` disabled at birth | No terminology or fleet detail worth recording yet. Added later as a plain file write if it earns its place |
| 4 | Profile `engineering` | Adds `## Interfaces` and `## Conventions` to `LONGTERM.md`; Interfaces is where the framework↔model boundary is pinned once chosen |
| 5 | Orchestration substrate and serving layer are `[TBD]`, not defaults | First work is candidate evaluation, following the precedent of `05_orchestration-candidates_v1.md` |
| 6 | No branches at birth | Branching is cheap and retroactive under iclaw. The natural branch point is after the evaluation closes |

## 3. Structure

`{nn}` = `02`: root siblings excluding `_`- and `00_`-prefixed leave `01_agentic_thesis`
as the highest.

```
02_local_swarm/
├── CLAUDE.md               profile: engineering · canon: none
├── _memory/
│   ├── LONGTERM.md
│   ├── STATE.md
│   ├── _index.md
│   └── sessions/           empty — the first real session writes the first log
├── input/
├── output/
│   └── _manifest.md
└── src/                    the framework — own git repo
    ├── .gitignore
    └── README.md
```

Validator conformance was checked against `scripts/validate_project.sh` before adopting
`src/`: the script asserts only that required paths **exist** and never rejects extras,
so a third working folder does not break validation.

Two enforced constraints shape the seeding:

- `output/*/*` filenames must match `{nn}_{slug}_v{n}[_draft|_final].{ext}`.
- `STATE.md` + `LONGTERM.md` combined must stay **≤ 100 lines** (warns above). This is a
  hard budget on how much is seeded, since both are read at every orientation.

## 4. The `src/` rule

The protocol does not define `src/`, so its rules are stated explicitly. The failure mode
being guarded against is an agent writing `src/orchestrator_v2.py` — applying the artifact
convention to a source tree, where it is wrong.

- **`src/` is the only folder edited in place.** Git owns its history. No `_v2` in a
  filename under `src/`, ever.
- **Nothing in `src/` is registered in `output/_manifest.md`.** The manifest describes
  artifacts; git describes code.
- **`output/` keeps its meaning** — design docs, candidate evaluations, benchmark results,
  dashboards. Generated once, superseded by version.
- **The join is `LONGTERM.md`.** When a design doc in `output/` becomes code in `src/`,
  the durable decision is recorded in memory. Memory records *why*; git records *what*.
  Neither substitutes for the other.

## 5. Seeding

`src/` starts as a git repo holding a README and a `.gitignore` and nothing else — correct,
because the substrate is `[open]`. The first artifacts are comparison documents.

`LONGTERM.md` `[TBD]` register at birth:

| Item | Waits on | Marker |
|---|---|---|
| Orchestration substrate | candidate evaluation | `[open]` |
| Local serving layer | fleet audit | `[open]` |
| Single-agent vs multi-agent | first working end-to-end run | `[open]` |

The `[TBD]` discipline then does the work: nothing is improvised into `src/` while those
are open.

Objectives seeded at birth are `[proposed]` — reconstructed from the design conversation,
not yet approved.

## 6. Cowork instructions prompt

Written to `docs/2026-09-03-cowork-project-instructions-02-local-swarm.md`, matching the
precedent set by the `01_agentic_thesis` instructions doc. It is the **persistent**
instructions field — resident every session — and is therefore kept short; every line
costs tokens in every session.

Delta from the `01_agentic_thesis` instructions:

- Three working folders instead of two, with the `src/` rule stated.
- No scope question, because there are no branches.
- A rule against guessing hardware and model facts — VRAM, context length, quantization,
  endpoint reachability. Wrong guesses there are silent and expensive.
- Git history rewriting added to the list of irreversible acts requiring confirmation.

### Precondition

The prompt names `iclaw:project-memory` and `iclaw:project-artifacts` without restating
what they do — the protocol lives in the skills, not the prompt. **If Cowork cannot install
the plugin, the prompt must not be pasted there.** A session without the skills will
improvise a structure that looks right and fails silently. Scaffold in Claude Code, where
the plugin is enabled, and point Cowork at the finished folder.
