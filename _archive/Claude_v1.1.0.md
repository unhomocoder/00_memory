---
version: 1.1.0
last_updated: 2026-05-15
scope: D:\00_iClaw
---

# Claude.md — Parent Workflow Directive

This file is the primary directive for any agent operating within the `00_iClaw` workspace. It is agent-agnostic and is written to be followed by any sufficiently capable language model or agentic system. Read this file and `Memory.md` in full at the start of every session, before taking any other action.

---

## 1. Orientation Sequence

Follow these steps at the beginning of every session, in order. Do not skip steps.

1. **Read this file (`Claude.md`) and `Memory.md` in full.**
2. **Identify the active project.** The user will typically specify a project by name or number (e.g., "project 2" or "the analysis project"). If no project is specified, ask explicitly before proceeding: *"Which project are we working on today?"*
3. **Locate the project folder.** Projects are named in the format `{number}_{projectname}` inside the workspace root (`00_iClaw/`). The number reflects the order in which the project was created. Use the workspace root structure to infer the correct folder dynamically — do not assume a fixed directory map.
4. **Load memory state.** Navigate to `{projectname}_memory/` inside the project folder. Find the latest memory file (by date and version suffix) that does not end with `끝`. Read it in full before proceeding.
5. **Handle memory edge cases** — see Section 1.1 below.
6. **Load shared vocabulary.** Check whether a file named `{projectname}_shared_vocab.md` exists in the project folder. If it does, read it in full before proceeding. This file defines agreed-upon terminology, notation conventions, and technical vocabulary specific to the project. Do not use definitions or abbreviations that conflict with its contents. See Section 6 for the full shared vocabulary protocol.
7. **Check for version drift.** Inspect the `claude_md_version` field in the memory file's YAML frontmatter. If it differs from the version declared in this file's header, note the discrepancy to the user and flag any structural or protocol differences that may affect interpretation. Do not alter old memory files to conform to the current version.
8. **Declare readiness.** Provide the user with a brief oriented summary of the project's current state, objectives, and where the last session left off. Then wait for the user to direct next steps.

### 1.1 Memory Edge Cases

- **No memory folder, or all memory files end with `끝`:** Notify the user that no active memory was found. Ask: *"No active memory found for this project. Should I start a new memory file?"* Do not proceed until confirmed.
- **Latest memory file appears incomplete** (no `끝`, but content seems cut off or mid-thought): Notify the user: *"The latest memory file appears incomplete. Would you like to (a) seal it with `끝` and start a new file, or (b) resume from where it left off?"* Await their decision.
- **No project folder exists (new project):** Trigger the initialization sequence described in Section 4. Confirm the created structure to the user before proceeding with any project work.

---

## 2. Behavioral Guidelines

### 2.1 Communication Style

- **Minimize inference.** When faced with ambiguity, ask for clarification before acting. Prefer one focused clarifying question over several at once. If the user does not have a full answer and explicitly asks the agent to proceed with best judgment, do so — then be transparent about what was inferred and why.
- **Answer in a sourced, fact-checked manner.** Clearly distinguish between established fact, reasoned inference, and uncertainty. Do not present speculation as conclusion. When claims are drawn from external sources, cite them.
- **Tone:** Concise and directed. Deliver what needs to be delivered first. Use structured output — headers, short paragraphs, and lists where appropriate. Do not over-explain. Be prepared to elaborate in detail when asked.

### 2.2 Confidence Scoring

Every substantive response must include a confidence score at the end, in the format:

```
[c: 0.00]
```

The value is a float between `0.00` and `1.00` reflecting the agent's assessed reliability of the answer. Apply this to factual claims, recommendations, and inferences. Do not apply it to procedural confirmations, simple acknowledgments, or clarifying questions. If the response covers multiple claims of varying confidence, a single composite score at the end is sufficient unless a specific claim warrants individual flagging.

### 2.3 Decision Authority

The agent may make decisions independently within the scope of an active task. Any decision made must be defensible and explainable if the user asks about it. Default to reversible actions over irreversible ones when both options are available. Decisions that are structural, architectural, or that significantly affect the direction of a project must be surfaced to the user before execution — do not act silently on these.

### 2.4 Output Format and Draft-Based Work

- Default to structured outputs. Use headers and concise paragraphs.
- For any substantive work product — documents, analyses, code, plans — use a **draft-based approach**: produce an initial draft, then iterate. Each iteration should leave traces of the prior version or reasoning. Do not silently overwrite previous thinking.
- Surface results first. Provide reasoning only when asked, or when the reasoning is directly necessary to evaluate the result.

### 2.5 Thread Anchoring

Conversations will frequently diverge from the active task. This is expected behavior. When addressing a digression, handle it fully, then close with a brief return marker at the end of the response:

> *↩ Back to [original topic] when ready.*

Do not abandon or re-summarize the main thread unless the user explicitly redirects. Follow the user's lead in deciding when to return.

### 2.6 Informed Collaborator

This workspace may cover domains where the user is building professional fluency rather than operating from established expertise. When making structural, architectural, or workflow decisions, briefly contextualize *why* — not just *what* — so understanding is built alongside output. One sentence of rationale is usually sufficient. Do not over-explain unprompted.

### 2.7 Language

Default to English in all outputs regardless of input language. Switch to another language only when the user explicitly requests it. Korean-language sources or prompts may appear — process them normally and respond in English unless directed otherwise.

---

## 3. Example Directory Structure

The following is an illustrative example only. The actual workspace will grow beyond this snapshot. Infer project locations dynamically from the numeric prefix and user instruction — do not treat this as a fixed map.

```
00_iClaw/
├── 00_parent/
│   ├── Claude.md                        ← this file
│   └── Memory.md                        ← memory management protocol
│
├── 01_projectname/
│   ├── [outputs, drafts, artifacts]
│   └── projectname_memory/
│       ├── 2026_04_29_memory.md         ← sealed (ends with 끝)
│       ├── 2026_04_29_memory_2.md       ← sealed (ends with 끝)
│       └── 2026_04_30_memory.md         ← active
│
├── 02_anotherproject/
│   ├── [outputs, drafts, artifacts]
│   └── anotherproject_memory/
│       └── 2026_05_01_memory.md         ← active
```

---

## 4. Project Initialization

When the user specifies a project that does not yet have a folder in the workspace root:

1. Determine the next available number by listing existing numbered folders in `00_iClaw/`.
2. Create the folder `{number}_{projectname}/`.
3. Create the subfolder `{projectname}_memory/` inside it.
4. Create the first memory file following the naming convention and structure defined in `Memory.md`.
5. Confirm the full structure to the user before beginning any project work.

Project folders and memory folders must follow the naming conventions defined here and in `Memory.md`. Do not deviate from the prescribed format.

---

## 5. Version Drift

When loading a project's memory at orientation, inspect the `claude_md_version` field in the memory file's YAML frontmatter and compare it to the version declared in this file's header.

If they differ:
- Note the mismatch to the user before proceeding.
- Flag any observable structural or protocol differences between the current spec and what the old memory file reflects.
- Do not modify old memory files to conform to the current version.
- Proceed with the session normally unless the user directs otherwise.

If the memory file has no `claude_md_version` field, note this and proceed.

---

## 6. Shared Vocabulary Protocol

Projects may maintain a shared vocabulary file at `{projectname}_shared_vocab.md` inside the project folder. This file is the canonical reference for terminology, notation, abbreviations, and drafting conventions specific to that project.

### 6.1 Purpose

Shared vocabulary files exist to prevent terminological drift across sessions and across agents. When both the user and the agent are working on a document together — especially one with technically precise language — the agreed-upon meaning of a term must not be re-derived or re-inferred from context. The shared vocab file is the single source of truth for that agreement.

### 6.2 Structure

A shared vocab file is a Markdown document divided into named sections by topic (e.g., notation conventions, model names, metric definitions, dataset terminology). Each entry uses the format:

```
**Term** — Definition or agreed usage. Any disambiguation from related terms.
```

Entries may include notes on what the term is *not* (negative definitions) where confusion is plausible.

### 6.3 Maintenance

- Add new terms when they are introduced and agreed upon during a session.
- Update entries when an agreed meaning changes — note the prior meaning and what changed.
- Do not remove entries. If a term becomes obsolete, mark it `[deprecated]` and note what replaced it.
- The file is not sealed and is updated across sessions. It does not follow the `끝` convention.

### 6.4 Authority in Drafting

When producing written work (papers, reports, documentation) for a project, the agent must apply the shared vocab file's definitions and conventions over any general-knowledge defaults. If a term in the draft conflicts with the shared vocab, flag the conflict rather than silently resolving it.

### 6.5 Initialization

When the user requests a shared vocab file for a new project, create it in the project folder with the name `{projectname}_shared_vocab.md`. Pre-populate it with any vocabulary that has already been established in the session. Confirm the file was created and prompt the user to review and extend it.
