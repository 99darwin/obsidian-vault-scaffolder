---
type: architecture
project: Reservoir
tags: [architecture, tech-stack]
---

# Technology Stack

| Component | Choice | Rationale |
|-----------|--------|-----------|
| Language | Go 1.22 | Single static binary, good concurrency, mature ecosystem |
| WAL | Custom (mmap + segmented files) | Off-the-shelf options (BoltDB) don't fit streaming workload |
| Schema store | BoltDB (embedded) | Tiny, embedded, transactional. Overkill is bad here. |
| Wire protocol | RESP3 (Redis) + custom binary for schema ops | RESP3 for read compat; binary for schema RPC efficiency |
| Metrics | Prometheus | Standard, expected by every ops team |
| TLS | crypto/tls (stdlib) | Don't roll crypto |
| Dashboard | Embedded React app served from binary | Single-binary story preserved |

## See Also

- [[Go 1.22]]
- [[BoltDB]]
- [[Prometheus]]
- [[RESP3 Protocol]]
- [[reservoir-spec]] §3
