---
project: {projectname}
directive_version: 0.1.0
parent_claude_version: 2.0.0
overrides: []      # [DEFAULT] clause numbers this file replaces, e.g. ["5.1", "5.4"]
enables: []        # [OPT-IN] section numbers this file activates, e.g. ["8"]
---

# {projectname} — Child Directive

Deltas from `00_parent/Claude.md` only. Anything not declared above is inherited
verbatim. Do not restate inherited behavior. Do not attempt to override an
`[INVARIANT]`.

Delete every block below that you are not actually using, and keep `overrides` /
`enables` in exact agreement with the blocks that remain — a mismatch is a malformed
directive and will be reported at orientation rather than guessed at.

---

### §{n.n} {Clause name} [OVERRIDE]

{The replacement behavior, stated completely. This text replaces the parent clause;
it is not additive to it.}

**Rationale:** {one or two sentences — why this project needs different behavior}

---

### §{n} {Section name} [ENABLE]

{Any project-specific configuration the opt-in subsystem requires. If none, state
"Enabled with parent defaults."}

**Rationale:** {one or two sentences}
