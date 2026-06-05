# obsidian-vault-scaffolder

> A Claude Skill that turns a software project spec into a navigable, queryable, AI-friendly Obsidian vault — in one shot.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skill version](https://img.shields.io/badge/skill-v2-green)](SKILL.md)
[![Built for](https://img.shields.io/badge/built%20for-Claude-orange)](https://www.anthropic.com/claude)

A 1500-line spec.md is a write-once, read-never artifact. The same content split into atomic notes with queryable frontmatter and database views? Navigable, linkable, and AI-friendly. This skill captures the working layout so you go from *"here's my spec"* to *"here's a knowledge base I'll actually use"* in one command.

**Live landing page**: [obsidian-skill.nickysap.dev](https://obsidian-skill.nickysap.dev)

## What it does

You give Claude (with this skill installed) a project spec — or just a one-liner about a project you're about to start. The skill:

1. **Scaffolds a PARA-style vault** with the right folders, Obsidian Bases (database views), templates, an index, and an `AGENTS.md` briefing for future AI sessions.
2. **Atomizes your spec** into discrete notes — one note per risk, one per open question, one per architecture section. Wikilinked, with `type:` frontmatter that the Bases query against.
3. **Populates the Project Charter** from the source material so the vault opens to *"here's what this project is"*, not *"(fill in)"*.
4. **Verifies the output** — every note has a valid `type`, every Base references real notes.

## Quick demo

Give Claude a prompt like:

```
I'm starting a project called Reservoir — a queue/stream broker meant to compete
with Redpanda at the low end. The v0.1 spec is at ~/specs/reservoir.md. Set me up
an Obsidian vault for it under ~/Documents/Obsidian/Reservoir. Don't ask follow-ups.
```

You get a vault with 47 atomized notes from a 286-line spec, broken out by domain:

```
Reservoir/
├── 00_Index/
│   ├── HOME.md                       ← landing page
│   ├── AGENTS.md                     ← context for future AI sessions
│   └── MOCs/Reservoir MOC.md         ← map of content
├── 10_Projects/Reservoir/
│   ├── Project Charter.md            ← populated from the spec
│   ├── Architecture/                 ← 3 atomized arch notes
│   ├── Brief/                        ← Executive Summary, Why It Works, Scope
│   ├── Specs/                        ← canonical spec + 8 atomized sections
│   ├── Open Questions/               ← one note per question, queryable
│   ├── Risks/                        ← one note per risk, queryable
│   ├── Plans/                        ← Implementation Sequence + milestones
│   └── Phases/, Reference/, ...
├── 30_Resources/
│   └── Technologies/                 ← one note per tech in the stack
├── _Bases/                           ← Obsidian Bases (database views)
│   ├── Open Questions.base
│   ├── Project Tracker.base
│   ├── Risks.base
│   └── Signals.base
└── _Templates/                       ← frontmatter scaffolding for new notes
```

See [`examples/reservoir-vault/`](examples/reservoir-vault/) for the full output.

## Install

### As a Claude Skill (recommended)

1. Download the latest `.skill` file from [releases](https://github.com/99darwin/obsidian-vault-scaffolder/releases) — or use [`dist/obsidian-vault-scaffolder.skill`](dist/obsidian-vault-scaffolder.skill) from this repo.
2. In Claude Code (or another Claude environment that supports skills), install it:
   ```bash
   claude skill install ./obsidian-vault-scaffolder.skill
   ```
3. Open a Claude session. Ask it to set up a vault for your next project.

### From source (for development or customization)

Clone the repo, point your Claude config at this directory as a skill source:

```bash
git clone https://github.com/99darwin/obsidian-vault-scaffolder.git
# Then configure Claude to load skills from this directory
```

### Use the scaffolder script standalone

The Python scaffolder works without Claude — useful if you just want the layout:

```bash
cat > /tmp/vault.json << EOF
{
  "vault_path": "~/Documents/Obsidian/MyProject",
  "project_name": "MyProject",
  "charter_seed": "A one-line description of the project."
}
EOF

python3 scripts/scaffold_vault.py --config /tmp/vault.json
```

See [`references/config_schema.md`](references/config_schema.md) for the full config.

## Why this works

Three observations from building dozens of project vaults:

1. **Atomization beats monoliths.** Each risk, open question, and spec section gets its own file. `_Bases/Risks.base` becomes a live filterable view across every project. A 50-note vault is more navigable than a 1500-line doc.
2. **Frontmatter is the schema.** Every note has `type: risk` / `type: open-question` / `type: spec` etc. Obsidian Bases query against these. The conventions are documented in [`references/frontmatter_schema.md`](references/frontmatter_schema.md).
3. **AGENTS.md gives AI sessions a running start.** When you come back to a vault three months later with Claude, the first thing it reads is `AGENTS.md` — vault layout, conventions, how to add new notes. No re-explaining.

The full design rationale is in [`SKILL.md`](SKILL.md) and the [`references/`](references/) directory.

## Modes

The skill handles four source-material cases:

| Mode | Trigger | What happens |
|---|---|---|
| **Spec-driven** | User has a Markdown/Word/PDF spec | Full atomization. ~50 notes from a typical spec. Charter populated from Executive Context. |
| **Brief-driven** | User has a multi-paragraph brief (Slack post, transcript) | Lighter atomization (~20 notes). Charter populated from the brief. |
| **One-liner** | User has a sentence ("a self-hosted Vercel for Node services") | No atomization. Charter seeded with the description. |
| **Skeleton** | Truly no description | Empty Charter shell. Rare. |

Sharp distinction between *one-liner* and *skeleton* matters — most "I want a vault for the project I'm starting" requests are one-liner, not skeleton. Throwing away the user's own one-sentence description is wasteful.

## Benchmarks

Measured across three test cases over two iterations of the skill. See [`benchmarks/`](benchmarks/) for the raw data.

| Test case | v1 baseline | v2 (current) | Iteration improvement |
|---|---|---|---|
| **Spec-driven** (286-line spec) | 46 notes, ad-hoc layout | 55 notes, full atomization + Charter populated | Charter no longer empty |
| **One-liner** (no spec) | Defaulted to skeleton, dropped pitch | Charter seeded with user's description | Pitch preserved |
| **Existing vault** (add 2nd project) | HOME/AGENTS edited manually | Script splices HOME, rewrites AGENTS as project-agnostic | Zero manual editing |

Independent subagent reviews of v1 → v2 surfaced six explicit gaps; each was traced to a concrete change in SKILL.md or `scripts/scaffold_vault.py`. The methodology lives in [`benchmarks/iteration-2/`](benchmarks/iteration-2/).

## Examples

- [`examples/reservoir-vault/`](examples/reservoir-vault/) — Full output from a spec-driven run on a synthetic streaming-broker spec. 47 project notes, 4 Bases, 8 templates.
- [`examples/pylon-vault/`](examples/pylon-vault/) — Output from a one-liner run. Project Charter seeded; scaffolding ready for atomization once a spec exists.

## Test it yourself

```bash
# Sandbox a vault from the bundled Reservoir spec fixture
python3 scripts/scaffold_vault.py --config <(cat <<'EOF'
{
  "vault_path": "/tmp/test-vault",
  "project_name": "Reservoir",
  "charter_seed": "A queue/stream broker for the low-end Redpanda niche."
}
EOF
)

# Verify the output
python3 scripts/scaffold_vault.py verify /tmp/test-vault
```

Then point Claude (with this skill installed) at `tests/fixtures/reservoir-spec.md` and watch it atomize.

## Vault conventions (the short version)

- **Folders are numbered** (`00_Index`, `10_Projects`, `30_Resources`, `40_Archive`) so they sort predictably.
- **Frontmatter `type:` is non-negotiable** on every note — Bases break without it.
- **One concept per note.** Each risk, each open question gets its own file.
- **Filenames prefix-sorted**: `Risk — X.md`, `Open Question — X.md`.
- **The canonical spec stays canonical.** Atomized notes link back; they don't duplicate.

Full conventions in [`SKILL.md`](SKILL.md) and [`references/folder_layout.md`](references/folder_layout.md).

## Contributing

PRs welcome. Particularly interested in:

- **New atomization patterns** for source types not covered by the playbook (RFCs, ADRs, decision logs).
- **Bases additions** for new `type:` values (e.g., `decision`, `spike`, `experiment`).
- **Compat fixes** for Obsidian Bases syntax shifts across versions.
- **Examples** — drop your scaffolded vault in `examples/` (sanitized) so others can see what good looks like.

See [`tests/`](tests/) for the test methodology.

## License

MIT — see [LICENSE](LICENSE).

Built by [Nick Saponaro](https://github.com/99darwin) with Claude.
