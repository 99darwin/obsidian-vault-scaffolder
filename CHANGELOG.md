# Changelog

## v2 (2026-06-05)

Iteration on the original v1 release, driven by six gaps surfaced via independent subagent reviews. Full methodology in [`benchmarks/iteration-2/`](benchmarks/iteration-2/).

### SKILL.md

- **Four-mode source taxonomy** (spec / brief / one-liner / skeleton) replaces the fuzzy three-mode split. The previous "brief" mode collapsed both multi-paragraph briefs and one-sentence descriptions; the new taxonomy distinguishes them.
- **No-follow-ups escape hatch** in Step 1 — when the user says "just do it", skip the AskUserQuestion call and infer everything from the message.
- **"Populating the Project Charter"** subsection in Step 4. The Charter is no longer left as an empty shell after atomization.
- **Folder roles clarified** — `Plans/` is the *what* (milestone definitions), `Sprints/` and `Week N/` are the *doing* (execution logs).
- **`charter_seed` scope clarified** — only for one-liner mode. Spec and brief modes overwrite the Charter in Step 4, so seeding it is wasted work.

### scripts/scaffold_vault.py

- **New `verify` subcommand** — checks every note has a `type:` value in the canonical set, not just present. Catches `type: Risk` typos (capital R) that silently break Bases.
- **Auto-rewrites AGENTS.md as project-agnostic** when adding a 2nd+ project to an existing vault. The first project's AGENTS.md bakes the project name into the body; once you have multiple projects, that becomes stale.
- **Idempotent HOME.md splice** for existing-vault mode — inserts the new project under `## Active Projects` and `## Maps of Content` without touching the rest.
- **`charter_seed` config field** — drops a one-line description into the Project Charter's blockquote and One-Line Pitch section. Use for one-liner mode.
- **Sprint template gets `{{sprint}}` and `{{milestone}}` placeholders** for cleaner cloning.

### references/atomization_playbook.md

- New section on **atomizing informal sources** (Slack-style briefs, transcripts) — drop section-number back-references, scan for implicit lists ("key open questions:", "risks I can see:"), be more aggressive about Charter population.

## v1 (2026-06-04)

Initial release.

- PARA-style folder scaffold via `scripts/scaffold_vault.py`
- 4 Obsidian Bases (Open Questions, Project Tracker, Risks, Signals)
- 8 note templates (Project, Open Question, Risk, Spec Section, Person, Sprint, Signal, Note)
- 6 reference docs (atomization playbook, frontmatter schema, Bases YAML, folder layout, config schema, memory entries)
- Three-mode source taxonomy (spec / brief / skeleton)
