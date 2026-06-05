# Benchmarks

Quantitative tracking of skill iterations, plus the qualitative subagent reviews that drove improvements between versions.

## Methodology

Three test cases run with-skill vs. baseline, comparing output completeness, time, and tokens. Each test case is a realistic user prompt; the baseline is either "no skill" (iteration 1) or "previous version of the skill" (iteration 2).

| # | Test case | Source mode | Vault state |
|---|---|---|---|
| 1 | Reservoir streaming-broker | Spec-driven (286 lines) | New vault |
| 2 | Pylon self-hosted Vercel | One-liner | New vault |
| 3 | Tessellate service-dep tool | Brief-driven (informal) | Existing vault with 1 prior project |

Test fixtures in [`../tests/fixtures/`](../tests/fixtures/).

## Iteration 1: v1 vs. no-skill

[`iteration-1/`](iteration-1/) — first release of the skill. Surfaced six concrete gaps:

1. AGENTS.md goes stale when a second project is added to an existing vault
2. Skill's Step 1 says always-use AskUserQuestion; no escape hatch for "just do it"
3. Sprints vs. Plans vs. Week N folder roles unclear
4. Project Charter shell stays empty unless Claude knows to populate it post-atomization
5. HOME.md merge in existing-vault mode left entirely to Claude (no script support)
6. Conversational briefs need different atomization rules than formal specs

## Iteration 2: v2 vs. v1

[`iteration-2/`](iteration-2/) — every gap from iteration 1 has explicit before/after confirmation. Concrete improvements:

| Gap | v1 behavior | v2 behavior |
|---|---|---|
| No-follow-ups | "v1's SKILL.md describes a mandatory AskUserQuestion step." | "Step 1's no-follow-ups escape hatch went straight from request to config build." |
| Brief vs. skeleton | "By the letter it's brief-driven but atomize implies sub-items to split, and there's only one sentence." | "Step 1's four-mode taxonomy made the classification unambiguous." |
| Charter empty | "v1 doesn't overwrite from brief content. I had to manually rewrite Project Charter.md." | "Charter populated from brief: One-Line Pitch from charter_seed, plus 5 Why-It-Works bullets..." |
| HOME.md merge | "I had to splice it in manually with a python3 replace() patch." | "Script reported `~ HOME.md (Updated HOME.md with Tessellate)`." |
| AGENTS.md stale | "AGENTS is fundamentally single-project shaped." | "Script reported `~ AGENTS.md (rewritten as project-agnostic)`." |
| Verify too lax | "Heuristic grep — would silently miss typo `type: Risk`." | "New `verify` subcommand catches case mismatches and unknown values." |

Token cost roughly flat. The script additions amortize against the manual work they replaced. Test 3 (existing-vault) is actually slightly cheaper with v2 because the auto-splice/rewrite obviates manual HOME/AGENTS patches.

## Raw data

- [`iteration-1/benchmark.json`](iteration-1/benchmark.json) — per-run timing and token data
- [`iteration-1/benchmark.md`](iteration-1/benchmark.md) — human-readable summary

To reproduce, see [`../tests/`](../tests/).
