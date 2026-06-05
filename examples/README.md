# Examples

Real vaults produced by the skill. Browse them in Obsidian to see what good looks like.

## `reservoir-vault/`

**Source mode**: spec-driven (286-line streaming-broker spec)

55 markdown files. Demonstrates the high-leverage case — a substantial technical spec atomized into navigable notes.

Highlights:

- `10_Projects/Reservoir/Specs/` — canonical spec + 8 atomized sections (Shadeform Integration → here is "Wire Protocol", "Storage Engine", etc.)
- `10_Projects/Reservoir/Open Questions/` — 6 atomized open questions, one per file, each queryable via `_Bases/Open Questions.base`
- `10_Projects/Reservoir/Risks/` — 5 atomized risks with `severity` / `likelihood` frontmatter
- `10_Projects/Reservoir/Project Charter.md` — populated from the spec's Executive Context with One-Line Pitch, Why It Works (5 bullets), Phase I Scope/Non-Goals, Key Documents

To open in Obsidian: `Open Vault as folder` → point at `examples/reservoir-vault/`.

The source spec is in [`../tests/fixtures/reservoir-spec.md`](../tests/fixtures/reservoir-spec.md) — useful for seeing the before/after.

## `pylon-vault/`

**Source mode**: one-liner ("a self-hosted alternative to Vercel called Pylon, focused on long-running Node services")

17 files (just the scaffold). Demonstrates the lightweight case — no spec, just a one-sentence description. The Project Charter is seeded with the user's description; everything else is empty scaffolding ready for the user to populate as they go.

The contrast with `reservoir-vault/` shows the skill scales from "I have a spec" to "I'm starting fresh" without forcing either to look like the other.
