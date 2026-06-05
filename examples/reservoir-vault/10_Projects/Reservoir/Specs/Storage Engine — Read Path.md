---
type: spec
project: Reservoir
section: storage-read-path
spec_section: 4
tags: [spec, storage, read-path]
---

# Storage Engine — Read Path

1. Consumer sends XREAD with consumer group + last-seen ID
2. Dispatch looks up group offset from BoltDB
3. Engine seeks to (segment-id, offset), reads forward
4. Records returned, group offset advanced in memory (persisted via XACK)

## See Also

- [[Storage Engine — WAL Format]]
- [[Wire Protocol — RESP3 Subset]]
- [[reservoir-spec]] §4
