---
type: technology
category: infrastructure
tags: [technology, observability, metrics]
---

# Prometheus

Metrics exposition format. Reservoir serves a `/metrics` endpoint with:

- write QPS, read QPS
- fsync latency
- schema validation latency
- per-stream lag

## Why

Standard, expected by every ops team. No competing format adds value at this scope.

## See Also

- [[Operations]]
- [[Technology Stack]]
