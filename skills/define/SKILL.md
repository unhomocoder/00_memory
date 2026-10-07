---
name: define
description: Explain one term in plain words — the idea first, then the real name — and, in an iclaw project, record it in _canon/vocab.md so later replies can use it without explaining it again. Use when the user asks to define a term, asks what a term means, or says "define X".
---

# Define

Explain one term so the user can use it from now on. The order matters: the idea first, in
words the user already has, and only then the term that names it. A definition that opens
with the term and then leans on two more terms has explained nothing.

## One term at a time

If the user names several terms, define the one they asked about first and list the others
in one line, offering them next. If a term means different things in different fields
("kernel" in operating systems, in statistics, in convolution), ask which one, or pick the
one their project or course makes obvious and say which you picked.

## The explanation

Keep it short: usually 80–200 words. In this order:

1. **The idea, without the term.** One to three sentences on what it is or does, using only
   words the user already has. If the idea needs another technical term, either that term is
   already known (common, or listed in `_canon/vocab.md`) or you explain it in a clause.
2. **The name.** "This is called **term**." Then the precise definition, in one or two
   sentences, as a careful source would state it. Precision lives here; plainness lives in
   step 1. Both say the same thing.
3. **One example.** Concrete, from the user's own course or project when there is one. If it
   involves numbers or code, check them.
4. **What it is not.** The term it is most often confused with, and the difference in one
   sentence. Skip this only when no confusion is plausible.

If the user's material uses the term in a narrower or unusual sense, say so after step 4:
"In your CFS 2 slides it means specifically …".

Not: a history of the term, a list of every variant, or a paragraph of related terms. Those
are what the user can ask for next.

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

When the working folder has a `CLAUDE.md` with a `project:` field, the definition is also
recorded, so that later replies can use the term without explaining it. Without a project
folder, skip this section; the explanation is the whole job.

1. **Check what is already recorded.** Read `_canon/vocab.md` in this project and, if the
   project is a branch, the parent's (`../_canon/vocab.md`) when it exists.
   - **Already there, same meaning:** show the recorded entry instead of writing a new one.
     Add to it only if the user asks.
   - **There with a different meaning:** show both and ask which holds. A branch's entry
     wins over its parent's, but the conflict is flagged, never resolved silently.
2. **Record it.** Asking for a definition is the user's agreement to record it. Append one
   entry to `_canon/vocab.md`, in the form the file already uses, normally:

   ```
   **Term** — the precise definition from step 2, in one or two sentences. Not the
   confusable term: the one-sentence difference.
   ```

   No status marker; an entry's presence means the term is shared. Write the term in the
   form the domain uses. `_canon/` follows the domain's language, not the English-only rule
   for `_memory/`. If the file is organized under headings, put the entry under the one it
   belongs to; otherwise append it at the end. Then tell the user in one line that it was
   recorded and that they can ask to change or remove it.
3. **No `_canon/vocab.md`?** Say so in one line and ask whether to create it (from the
   plugin's `templates/vocab.md`, with `canon: ./_canon` set in `CLAUDE.md`). Do not create
   it unasked.
4. **Session log.** If an `iclaw:project-memory` session is open, note the term under
   `## Work` ("Defined *term*; recorded in vocab"). Do not open a session just for this.
