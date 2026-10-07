---
name: rerender
description: Re-render the previous reply in another form without changing what it claims — simpler, deeper, example, or tldr. Use ONLY when the user asks for it by name ("rerender simpler", "rerender example", /rerender) or uses one of those four words to ask for the last answer again.
---

# Rerender

Say the last reply again in a different form. The user is not asking a new question; they
are telling you the answer did not land, or landed at the wrong depth. The claims stay
fixed. Only the form changes.

## Which reply

The most recent reply you gave, unless the user names a part of it ("rerender simpler the
part about the chain rule") or an earlier reply by its topic. Re-render that part only. If
which part is meant is genuinely ambiguous, ask in one line.

If no mode is given, ask which one, listing the four in one line. Do not guess.

## Before you write: list the claims

Write down, for yourself, every claim the original reply made: each fact, number, condition,
warning and conclusion. This list is the contract for every mode. A re-render that drops a
claim, adds one, or shifts one ("usually" becoming "always") has failed, however readable it
is.

## The four modes

### simpler

**Same claims, less load per sentence.** Concretely:

1. **Every claim on the list survives,** with its numbers, conditions and warnings. Nothing
   new is asserted.
2. **At most one new term per sentence.** A term is new if it is not in common use, not in
   the project's `_canon/vocab.md`, and not already explained earlier in this re-render.
3. **Idea before term.** Explain what the thing does or means first, then give its name.
   Never drop the real name; the user needs it to read anything else on the topic.
4. **One concrete example,** drawn from the user's own context where possible (their course,
   their project), and checked: if it involves a calculation or code, the numbers must work.
5. **End with one line naming what was simplified away**, so the user can ask for it back:
   `Simplified away: the matrix notation and the derivation of the update rule.`

What may be simplified away is **form, never content**: notation, derivation steps (the
result stays), synonyms and jargon beyond the one real name, tangents that carried no claim.

**Simpler is not:**
- **Fewer facts.** If the original had six claims, the re-render has six claims.
- **A different claim.** Softening a hedge, rounding a number, or widening a scope changes
  the claim. "Converges for convex losses" does not become "converges".
- **A childish analogy.** No "imagine a little robot". If an analogy helps, it is between
  things an adult already understands, it is marked as an analogy, and it says where it stops
  holding.
- **Shorter, necessarily.** Explaining ideas before terms often makes it longer. That is fine.

### deeper

**Same answer, with the reasoning shown.** The user wants to follow, not just accept.

- Keep the original conclusion, and lay out the chain that gets there: each step, why it
  holds, and what it assumes.
- Add the conditions under which it stops being true, and the edge cases.
- Name the real terms and, where it helps, the source a reader would check.
- Brevity is off for this reply, but structure is not: short blocks, one step per block.
- New claims are allowed here only as supporting reasoning, and each is marked as yours
  ("this follows from", "I'd expect") unless it comes from a source.

### example

**One worked example of the reply's main claim,** carried through every step.

- Use a concrete input and show the state after each step.
- Prefer an example from the user's own material when one exists.
- **Verify it.** Do the arithmetic; if it is code, run it when a shell is available, and say
  so if it was not run. A wrong example teaches the wrong thing with full confidence, and the
  user has no way to catch it.
- If the example exposes a case where the original reply was wrong or incomplete, say so
  plainly. That is a correction, not a re-render, and the user needs to know.

### tldr

**The answer in one sentence,** standing alone. Then at most three bullets for anything the
sentence could not carry that the user must not lose: a number, a condition, a warning. If
nothing qualifies, the sentence is the whole reply.

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

When the working folder has a `CLAUDE.md` with a `project:` field:

- **Read `_canon/vocab.md` if it exists** before a `simpler` or `deeper` re-render. Terms
  listed there are known to the user: use them without explaining them.
- **Use the reader background** stated under `## This project only` in `CLAUDE.md`, if any,
  to decide what counts as a new term.
- Write nothing to memory. A re-render changes form only, so there is nothing new to record.

Without a project folder, skip this section; the skill works the same.
