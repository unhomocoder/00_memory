---
name: handoff
description: Write a self-contained block the user can paste into a new chat — another session, claude.ai, another model — so it can continue the work without this conversation or the project files. Built from STATE, LONGTERM and the session's threads in an iclaw project. Use when the user asks for a handoff, a context block, or something to paste into a new chat.
---

# Handoff

Write one block of text that lets a fresh chat pick up the work correctly. The reader has
nothing else: no scrollback, possibly no access to the project files, possibly a different
model. Everything it needs to avoid redoing settled work, retrying rejected approaches, or
improvising undecided questions has to be inside the block.

## Scope

Ask nothing if the request makes it clear; otherwise one line: the whole project, one
thread, or a specific task for the new chat? A handoff for one task carries less than a
handoff for the whole project, and is better for it.

If the new chat is for a **different project or branch** (for example, seeding a sibling
branch), include only what that destination needs, and say in the block where it came from.

## Sources

**In an iclaw project** (a `CLAUDE.md` with a `project:` field in the working folder):

1. **Bring the record up to date first.** If an `iclaw:project-memory` session is open and
   its `## Threads` is behind the conversation, update it. The handoff is built from the
   record, so the record must be current.
2. Read, in this order:
   - `LONGTERM.md`: what the project is, objectives, durable decisions, the [TBD] register,
     Do Not Repeat, constraints.
   - `STATE.md`: where things stand, open threads, blocked. A `reference` project has none.
   - The active session's `## Threads` and `## Work`: what this session added.
   - `_canon/` files only where the scope needs them: a vocabulary entry the new chat must
     use exactly, a finding the next task depends on.
3. The conversation, for anything since the last write to the session file.

**Without a project folder,** build it from the conversation, and say in the block that it
was reconstructed from a conversation rather than from records.

## The block

One fenced block, plain Markdown, in this order. Leave out any section that would be empty.

```
# Handoff — <project or topic> — <yyyy-mm-dd>

## Goal
What the work is for and what "done" looks like. Two to four sentences.

## Where things stand
The current state, concretely: what exists, what was last done, what is in progress.

## Settled — do not reopen
Decisions already made, each with its date and a short reason.

## Rejected — do not retry
Approaches tried and set aside, each with why.

## Undecided — ask, do not choose
Open questions that belong to the user. The new chat must stop and ask, not pick a
plausible answer.

## Constraints and facts
Environment, tools, hardware, deadlines, terms with fixed meanings. Numbers exact.

## Next
The first task for the new chat, specific enough to start on. Then what follows, if known.

## How to work
Only what differs from the new chat's defaults and matters here: language, register, a
rule such as "do not read the slides whole". Omit if nothing applies.

## Source files
Paths to the files this was built from, for a reader that can open them.
```

## Rules for the block

- **Self-contained.** No "as discussed", no "the second option", no reference to anything
  the reader cannot see. Name things by their real names. A path is a pointer, never a
  substitute for the fact it holds.
- **Faithful.** Every line traces to the sources. Settled means the user decided it; an
  inference of yours goes under Undecided as a question, or is marked as yours. Never
  promote an open question to Settled because the discussion leaned one way.
- **Absolute dates,** never "yesterday" or "last week".
- **Short enough to paste.** Usually 300–900 words. If the full picture is larger, keep
  Settled, Rejected, Undecided and Next complete and compress Where things stand; the
  first three are what prevent damage.
- **Nothing private that the task does not need.** Leave out credentials, tokens and
  personal contact details. Mention that something exists ("the instructor's email is in
  LONGTERM") rather than copying it, unless the next task needs it.

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

## After writing

Show the block in the conversation, ready to copy, and nothing else besides one line on its
scope and size. Write it to a file only when asked; in a project, a file goes through
`iclaw:project-artifacts`.

A handoff writes no memory beyond bringing `## Threads` up to date. It does not seal the
session; sealing is the user's call through `iclaw:project-memory`.
