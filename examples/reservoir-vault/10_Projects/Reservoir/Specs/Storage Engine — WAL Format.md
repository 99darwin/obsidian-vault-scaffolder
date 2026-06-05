---
type: spec
project: Reservoir
section: storage-wal-format
spec_section: 4
tags: [spec, storage, wal]
---

# Storage Engine — WAL Format

Each stream lives in its own directory under `data/streams/<stream-name>/`. Within that directory:

- `segment-NNNNNN.wal` — append-only log files, default 256MB each
- `segment-NNNNNN.idx` — sparse index, one entry per 4KB of WAL data
- `consumers.db` — BoltDB for consumer group offsets
- `meta.json` — stream metadata (creation time, retention policy, schema ID)

## See Also

- [[Storage Engine — Write Path]]
- [[Storage Engine — Read Path]]
- [[Storage Engine — Retention]]
- [[reservoir-spec]] §4
