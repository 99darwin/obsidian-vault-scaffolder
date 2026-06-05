# Tests

How the skill is tested, and how to run the tests yourself.

## What's here

```
tests/
├── README.md                    (this file)
├── fixtures/
│   ├── reservoir-spec.md        (286-line synthetic technical spec)
│   └── tessellate-brief.md      (10-paragraph Slack-style brief)
└── run_smoke_tests.sh           (validates the scaffolder script standalone)
```

The fixtures are synthetic — they describe plausible-sounding software projects (a streaming broker, a service-dependency visualizer) without leaking any real-world information.

## Running the scaffolder smoke tests

```bash
./run_smoke_tests.sh
```

This exercises `scripts/scaffold_vault.py` against several configurations — new vault, existing vault, charter seeding, verify subcommand — and confirms output structure. No Claude required.

## Running the full skill test (requires Claude)

The skill's primary test is "give a real prompt to a Claude session with this skill installed". The three reference prompts:

### Test 1 — Spec-driven

> I'm starting a project called Reservoir — a queue/stream broker meant to compete with Redpanda at the low end. The v0.1 spec is at `tests/fixtures/reservoir-spec.md`. Set me up an Obsidian vault for it under `/tmp/test/Reservoir`. Don't ask follow-ups.

Expected: ~50 atomized notes, populated Project Charter, every note with valid `type:` frontmatter.

### Test 2 — One-liner

> I'm about to start sketching out a project — a self-hosted alternative to Vercel called Pylon, focused on long-running Node services. Drop a vault at `/tmp/test/Pylon`. Don't ask follow-ups.

Expected: Scaffold only. Project Charter seeded with the description. No atomization (nothing to atomize).

### Test 3 — Existing vault, brief-driven

> Add a new project to my existing Obsidian vault at `/tmp/test/ExistingVault`. The project is called Tessellate. Brief is at `tests/fixtures/tessellate-brief.md`. Don't touch the existing projects.

(First create the existing vault by running the scaffolder with project name `Predecessor`.)

Expected: New `10_Projects/Tessellate/` with ~25 atomized notes. HOME.md spliced to include Tessellate. AGENTS.md auto-rewritten as project-agnostic. Predecessor untouched.

## Quantitative benchmarks

See [`../benchmarks/`](../benchmarks/) for the actual run data from iterations 1 and 2.

## Contributing test cases

Useful additions:

- **A non-software project spec** — does the playbook generalize to research projects, books, business plans?
- **A non-English spec** — does atomization work for Markdown specs in other languages?
- **A massive spec** (~3000+ lines) — at what size does atomization break down?
- **A spec with embedded ADRs / decision records** — should those become their own `type: decision` notes?

Drop new fixtures here with a one-paragraph description of what they're testing.
