---
type: phase
project: Reservoir
phase: Phase II
status: deferred
tags: [phase, future]
---

# Phase II

Items explicitly deferred from MVP:

- **Multi-node replication.** Cluster topology TBD — Raft vs. chain replication is an open question.
- **Exactly-once semantics (EOS).** MVP ships with at-least-once + dedup window. Full EOS deferred.
- **Tiered storage / cold archive.** Move warm-but-aged segments to object storage.
- **Avro schema support.** MVP is Protobuf only.
- **`BACKUP` admin command** for BoltDB consumer offsets.

## See Also

- [[Phase I MVP]]
- [[Open Question — Cluster Mode Topology]]
- [[Open Question — Avro Phase II vs MVP]]
- [[reservoir-spec]] §1
