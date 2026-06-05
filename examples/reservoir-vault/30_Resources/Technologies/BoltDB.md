---
type: technology
category: data
tags: [technology, embedded-db, boltdb]
---

# BoltDB

Tiny, embedded, transactional key-value store. Used by Reservoir for two things:

1. **Consumer group offsets** — `data/streams/<stream>/consumers.db`
2. **Schema registry** — `data/schemas.db`

Chosen over alternatives (LevelDB, BadgerDB, SQLite) because it's the simplest thing that gives us transactional writes for small, low-write-volume data. Stream records do NOT go through BoltDB — they use the custom WAL.

## See Also

- [[Schema Registry]]
- [[Storage Engine — WAL Format]]
- [[Technology Stack]]
