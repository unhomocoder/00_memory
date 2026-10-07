---
name: recap
description: Recap one conversational thread or the whole session — a one-line takeaway, the key points, and what is still open — read from the session file's Threads section in an iclaw project rather than from the scrollback. Use when the user asks for a recap, asks where things stand in this conversation, or asks what was settled on a topic.
---

# Recap

Give the user back the shape of the conversation: what was settled, what each thread
concluded, and what is still waiting. A recap reports; it adds no new claim, and anything
it cannot trace to the conversation or the session file stays out.

## What to recap

- **One thread,** when the user names a topic ("recap the chain rule part"). Match it to a
  thread by its name; if two could fit, ask which in one line.
- **The whole session,** when no topic is named.
- **An earlier session,** when the user names one by date or topic. In a project, read that
  session file; a sealed file is read, never edited.

## Where it comes from

**In an iclaw project** (a `CLAUDE.md` with a `project:` field in the working folder):

1. Read `## Threads` in the active session file (`_memory/sessions/`, the one whose status
   is not `sealed`). It holds the breadcrumb and each thread with its status: active,
   resolved with a takeaway, or parked with where it stopped. This is the primary source,
   because it survives compaction and the scrollback does not.
2. Use `## Work` in the same file for the numbers, decisions and file names behind each
   thread.
3. **If `## Threads` is empty or behind the conversation,** say so in one line, bring it up
   to date first (the Conduct rules already require it to be current), then recap from it.
   Do not recap silently from the scrollback while the file says something else.
4. Use the conversation itself only for the turns since the last update.

**Without a project folder,** there is no session file. Recap from the conversation and say
so in one line, since a compacted conversation may have lost early turns: "Recapped from the
conversation; anything before the last compaction may be missing."

## Format

**Whole session:**

```
📍 current breadcrumb, e.g. backprop › chain rule

**Takeaway** — one sentence: what this session established.

**Threads**
- **Thread name** — resolved: its one-line takeaway.
- **Thread name** — parked: where it stopped, and what it waits on.
- **Thread name** — active: where it stands now.

**Settled** — decisions and results, with their numbers and conditions (up to 5 bullets).

**Open** — what is waiting, and on whom.
```

**One thread:**

```
**Thread name** — status

**Takeaway** — one sentence.

- 3 to 5 key points, most important first, with numbers and conditions intact.

**Where it stands** — resolved / parked at … / active, next step …
```

Use the real names of threads, decisions and files, never "the second one". A recap has to
make sense to someone who did not read the conversation, including the user a week later.
Keep it short: a session recap usually fits in 120–250 words. If more threads exist than
fit, give the active and parked ones in full and list the resolved ones by name.

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

## What recap does not do

- **It does not seal or summarize for the record.** The session's `## Summary` is written at
  seal time by `iclaw:project-memory`, on the user's signal. A recap is for the user now.
- **It does not settle anything.** If the conversation left a question open, the recap says
  it is open. Writing it as settled because the discussion leaned one way is the error a
  recap is most prone to.
- **It writes nothing except `## Threads`,** and only to bring that section up to date.
