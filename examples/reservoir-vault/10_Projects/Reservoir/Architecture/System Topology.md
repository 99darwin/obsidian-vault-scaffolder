---
type: architecture
project: Reservoir
tags: [architecture, topology]
---

# System Topology

Reservoir is a single Go process. Internally it decomposes into four layers, all running in-process:

```
Clients (any Redis client) → TCP / TLS
                ↓
     ┌──────────────────────┐
     │   Connection Layer    │  RESP3 protocol parser
     └──────────┬───────────┘
                ↓
     ┌──────────────────────┐
     │   Command Dispatch    │  XADD, XREAD, XGROUP, XACK, ...
     └──────────┬───────────┘
                ↓
     ┌──────────────────────┐
     │   Stream Engine       │  Append, index, consumer offsets
     └─────┬────────┬───────┘
           ↓        ↓
    ┌──────────┐  ┌──────────────┐
    │ WAL      │  │ Schema Reg   │
    │ (mmap)   │  │ (BoltDB)     │
    └──────────┘  └──────────────┘
```

## Layers

1. **Connection layer.** RESP3 protocol parser over TCP / TLS.
2. **Command dispatch.** Routes XADD, XREAD, XGROUP, XACK, etc., to the engine.
3. **Stream engine.** Owns append, index, consumer offsets.
4. **Persistence.** WAL (mmap) for stream records, BoltDB for schema registry.

## See Also

- [[Design Principles]]
- [[Storage Engine — WAL Format]]
- [[Schema Registry]]
- [[reservoir-spec]] §2
