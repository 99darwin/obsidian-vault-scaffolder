---
type: plan
project: Reservoir
phase: Phase I
status: pre-implementation
tags: [plan, milestones, roadmap]
---

# Implementation Sequence

Five milestones cover Phase I, weeks 1-7.

| Milestone | Weeks | Focus |
|-----------|-------|-------|
| [[Milestone 1 — Foundation]] | 1–2 | Repo, CI, RESP3 parser, WAL, XADD/XLEN/XREAD (no groups) |
| [[Milestone 2 — Consumer Groups]] | 2–4 | BoltDB offsets, XGROUP/XREADGROUP/XACK, PEL, XPENDING/XCLAIM |
| [[Milestone 3 — Schema Registry]] | 4–5 | schemas.db, RSRV.SCHEMA verbs, Protobuf validation, evolution |
| [[Milestone 4 — Dashboard]] | 5–6 | Embedded React, streams/group/schema views |
| [[Milestone 5 — Polish]] | 6–7 | Prometheus complete, mkdocs site, load test (100K XADD/sec), beta release |

## See Also

- [[Phase I MVP]]
- [[reservoir-spec]] §9
