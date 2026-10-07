---
name: walkthrough
description: Walk one concrete input through an algorithm or process step by step, showing the full state after every step, with the example checked by actually running it. Use when asked to walk through, trace, step through or show how an algorithm, data structure operation, protocol or computation proceeds on an example. In an iclaw project, the walkthrough is also saved to output/.
---

# Walkthrough

Take one specific input and carry it through every step of an algorithm or process, so the
user can watch the state change rather than read a description of it. Seeing `i`, `j` and
the array after each swap teaches quicksort's partition in a way the pseudocode does not.

## Choose the input

- **The user's input, if they gave one.** Use it exactly.
- **Otherwise, the smallest input that shows the interesting behaviour.** Too small and the
  key case never happens (a sort on an already-sorted array; a hash table with no
  collision); too large and the user drowns. Aim for a trace of 5–15 steps. Say in one line
  why this input: "Five elements, with the pivot landing in the middle, so both partitions
  are non-empty."
- **Check the input fits the problem.** If the algorithm needs a sorted array, a connected
  graph, a positive-definite matrix or a well-formed request, confirm the example is one.
  An invented example is the one part of a walkthrough with no source behind it.

## Set up before stepping

State, in a few lines:

1. **What the algorithm or process does,** in one sentence.
2. **The state you will track:** the variables, data structure contents, registers, queues
   or messages whose values define where the process is. These become the columns of the
   trace. Track only what changes or decides something; omit the rest.
3. **The starting state.**

## The trace

One entry per step, in order:

```
Step 3 — compare a[j] = 2 with pivot 4; 2 < 4, so i advances and a[i], a[j] swap.
| i | j | a               |
| 1 | 2 | [3, 2, 7, 5, 4] |      ← a[1] and a[2] swapped
```

- **What happens and why**, in one line: the rule that fired and the value that made it fire.
- **The state after the step,** in the same shape every time: a table row or a snapshot.
- **Mark what changed.** The eye should go straight to the difference.
- **Loops:** show the first one or two iterations in full and the last one in full. Compress
  identical middle iterations into one line that says how many were skipped and what they
  did ("iterations 3–6: j advances, no swaps, since every element exceeds the pivot").
  Never compress the step where the interesting thing happens.
- **Branches:** when the process could have gone another way, say which condition decided it.
  If both branches matter, choose the input so the trace takes each one at least once.

Close with:

- **The result,** and how it relates to the input ("pivot 4 is now at index 2, its final
  sorted position").
- **What the trace showed,** in one or two sentences: the invariant or mechanism the user
  should take away ("everything at or left of i is below the pivot at every step").
- **One variation to try,** with what would change ("with the pivot as the smallest element,
  one partition is empty; if that happens at every level, the recursion depth becomes n").

## Verify it

A wrong trace teaches the wrong algorithm with full confidence, and the user cannot catch it,
since they asked for the trace precisely because they cannot yet run it in their head.

- **When a shell is available, run it.** Implement the algorithm (or use the user's code) with
  the same input, print the tracked state at each step, and compare every row of your trace
  against the output. Fix the trace where they disagree, not the code to match the trace.
- **When the walkthrough is of the user's own code,** run their code, instrumented, rather than
  a reimplementation; the point is what *their* code does.
- **When nothing can be run** (a network protocol, a hardware pipeline, a proof), check each
  step against the source definition and say so.
- End with one line saying which: `Verified: ran a Python implementation on this input; all
  12 states match.` or `Not run: checked by hand against the RFC's state diagram.`

If running it shows that the algorithm as the user described it, or as an earlier reply
described it, does something different from what was claimed, say so plainly first. That
is a correction, and it matters more than the trace.

<!-- iclaw:reader-rules sha=d0297cb46c86 -->
## Reader rules

These apply to everything this skill writes for the user to read.

- **Idea first, then the name.** Say what a thing does or means in plain words, then give
  its real term. Skip the explanation for a term already listed in the project's
  `_canon/vocab.md`.
- **Plain wording, same claim.** Make the sentence easier, never the statement weaker,
  stronger or broader. If plainer wording would lose precision, keep it plain and add a
  short caveat.
- **Keep what carries weight.** Every number with its unit and comparison point, every
  threshold, every scoped condition ("for English only", "on this benchmark") and every
  warning survives. Cut explanation before you cut any of these.
- **One technical term per sentence.** A sentence carrying two or more is split.
- **Nothing the source does not say.** Your own inference is marked in the sentence
  itself ("this suggests", "I'd guess"). Where the source is unclear or silent, say so
  rather than filling the gap.
- **Never from memory.** If the source cannot be read, say which part failed and ask for
  another copy. A fluent summary of something not actually read is the worst outcome.
<!-- /iclaw:reader-rules -->

## In an iclaw project

When the working folder has a `CLAUDE.md` with a `project:` field, the walkthrough is kept.
Without one, show it in the conversation and offer a file in one line; nothing else changes.

1. **The project's own rules come first.** `## This project only` in `CLAUDE.md` overrides
   this skill.
2. **Use the project's material.** Prefer an algorithm, input or code from the course or
   project (a lab's program, a lecture's example) over an invented one, and say where it came
   from.
3. **Save it.** Write the walkthrough as Markdown to `output/` through
   `iclaw:project-artifacts`, which owns the name, version and manifest row. If verification
   used a script, save the script beside it as part of the same artifact set, so the trace can
   be re-run. Show the walkthrough in the conversation as well, and give the file path.
4. **Session log.** If an `iclaw:project-memory` session is open, the file goes under
   `## Files Touched → Produced` (the artifacts skill does this with the manifest row). Do not
   open a session just for this.
