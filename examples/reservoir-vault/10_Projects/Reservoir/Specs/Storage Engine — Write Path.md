---
type: spec
project: Reservoir
section: storage-write-path
spec_section: 4
tags: [spec, storage, write-path]
---

# Storage Engine — Write Path

1. Producer sends XADD over RESP3
2. Command dispatch validates command and looks up stream
3. Stream engine validates message against schema (if any)
4. Engine writes record to current WAL segment via mmap
5. Engine updates in-memory tail offset
6. fsync if cadence triggers (default: 1ms tick or 4KB written)
7. ACK returned with `<segment-id>-<offset>` as message ID

## See Also

- [[Storage Engine — WAL Format]]
- [[Schema Registry]]
- [[Risk — Producer Flood Overwhelms fsync Queue]]
- [[reservoir-spec]] §4
