---
type: spec
project: Reservoir
section: storage-retention
spec_section: 4
tags: [spec, storage, retention]
---

# Storage Engine — Retention

Default: time-based (7 days) + size-based (10GB per stream). Whichever triggers first. Configurable per-stream.

Compaction is offline — old segments are deleted in their entirety, no per-record TTL.

## See Also

- [[Storage Engine — WAL Format]]
- [[reservoir-spec]] §4
