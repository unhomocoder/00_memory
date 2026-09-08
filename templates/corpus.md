# {project_name} — Corpus Index

{One line: which papers this index admits, and for what.}

Canon, not memory: mutable, never sealed, loaded on demand rather than at orientation.
Terminology comes from `vocab.md` — this file applies it and adds none.

## Schema

| Column | Rule |
|---|---|
| `citekey` | `firstauthorYYYYkeyword`, lowercase, ASCII-folded. The join key |
| `id` | DOI → arXiv ID → normalized `title + year`, in that order |
| `venue` | As stated. `preprint` when none. Never asserted unverified |
| `prov` | Where it came from. One marker per source stream |
| `rel` | Relation to this project's question: `foundational` · `rival` · `method` · `context` · `contradicts` · `data` |
| `w` | `1` peripheral · `2` supporting · `3` load-bearing |
| `tier` | `1` encountered · `2` triaged · `3` read · `4` cited |
| `note` | Why this project cares. One line |

**Entry threshold.** State it explicitly and enforce it. Without one an index admits
everything encountered and stops being a filter.

**A branch's threshold or column definition may be stricter than its parent's. On
conflict the branch wins — flag it in a blockquote here, never resolve it silently.**

## Index

| citekey | id | venue | prov | rel | w | tier | note |
|---|---|---|---|---|---|---|---|

<!-- No rows yet. Written as a comment so an unseeded corpus file carries no brace
     placeholder that would survive into a real file and fail validation.

     | li2026harness | arXiv:2607.01661 | preprint | SCAN | foundational | 3 | 3 |
     Holds the evidence pool fixed by construction and says so | -->
