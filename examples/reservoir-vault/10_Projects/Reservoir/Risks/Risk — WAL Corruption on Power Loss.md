---
type: risk
project: Reservoir
severity: high
likelihood: medium
status: open
owner:
tags: [risk, durability, wal]
---

# Risk — WAL Corruption on Power Loss

A power loss mid-write could leave the WAL with a torn record. Without crash-recovery logic and per-record checksums, replay would silently emit a corrupted message — violating the durability promise.

## Mitigation Plan

- Per-record CRC32C checksum, verified on replay
- Crash-recovery test suite: kill -9 mid-write, restart, verify no corrupt records reach consumers
- Truncate trailing partial record on recovery

## See Also

- [[Storage Engine — WAL Format]]
- [[Storage Engine — Write Path]]
- [[reservoir-spec]] §10
