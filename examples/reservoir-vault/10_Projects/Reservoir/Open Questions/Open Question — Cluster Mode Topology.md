---
type: open-question
project: Reservoir
status: open
priority: high
needs_resolution_by: Phase II planning
owner:
tags: [open-question, clustering, architecture]
---

# Cluster mode topology — Raft vs. chain replication?

## Why It Matters

Phase II adds replication. The choice between Raft and chain replication sets the operator experience, failure-mode complexity, and write throughput for the whole life of the product.

## Options

| Option | Pros | Cons |
|---|---|---|
| Raft | Operator-friendly, well-understood, libraries exist | Slower writes, leader-bottlenecked |
| Chain replication | Faster writes, simpler steady-state | Weirder failure modes, less mature tooling |

## Path Forward

Benchmark both with a realistic workload before Phase II starts. Defer commitment.

## See Also

- [[Phase II]]
- [[reservoir-spec]] §11
