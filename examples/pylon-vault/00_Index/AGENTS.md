---
type: agents
tags: [agents, ai, context]
---

# AGENTS

Context for AI agents (Claude, etc.) working in this vault.

## What This Vault Is

A PARA-style Obsidian vault for the Pylon project.

## How To Operate Here

### When asked to update the spec
- The canonical spec lives in `10_Projects/Pylon/Specs/` (if a spec exists). It is the source of truth.
- When changing a section, update the canonical spec AND the corresponding atomized note. Do not silently diverge.

### When the user mentions something new
- **A risk** → create a note in `10_Projects/Pylon/Risks/` using `_Templates/Risk.md`. Frontmatter `type: risk` is required for the Risks Base view.
- **An open question** → `10_Projects/Pylon/Open Questions/` using `_Templates/Open Question.md`. Frontmatter `type: open-question`.
- **A market or business signal** → use `_Templates/Signal.md`. Frontmatter `type: signal`.
- **A spec change** → update the canonical spec AND the relevant atomized note.
- **A new technology to evaluate** → `30_Resources/Technologies/`.

### Frontmatter conventions
Every note should have:
- `type` — drives Bases filtering. One of: `project`, `phase`, `plan`, `spec`, `architecture`, `brief`, `contract`, `data-source`, `reference`, `risk`, `open-question`, `signal`, `person`, `sprint`, `technology`, `note`, `index`, `agents`, `moc`.
- `project` — usually `Pylon`.
- `tags` — optional, for cross-cutting search.

Risks add: `severity`, `likelihood`, `status`, `owner`.
Open Questions add: `priority`, `status`, `needs_resolution_by`, `owner`.
Signals add: `signal_type`, `direction`, `source`, `observed_at`, `confidence`.

### Folder roles inside a project
- `Plans/` — milestone definitions (the "what")
- `Sprints/` and `Week N/` — execution logs (the "doing")
- `Specs/` — canonical spec + atomized spec sections
- `Brief/`, `Architecture/`, `Reference/`, `Contracts/`, `Data Sources/`, `People/`, `Open Questions/`, `Risks/`, `Phases/` — one concept per note

### Don'ts
- Don't create new top-level folders without checking with the user.
- Don't dump multiple concepts into a single note. Atomize.
- Don't paraphrase the canonical spec into a parallel doc that drifts.

## See Also
- [[HOME]]
- [[Pylon MOC]]
