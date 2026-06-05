---
type: spec
project: Reservoir
section: operations
spec_section: 8
tags: [spec, operations, deployment]
---

# Operations

## Deployment

- Single binary, supports `systemd`, `docker`, `kubernetes` (Deployment + PVC)
- Default config via env vars (`RSRV_*`)
- TLS: BYO cert at startup, no Let's Encrypt integration

## Backup

- WAL files are append-only; `rsync` is sufficient
- BoltDB consumer offsets need a `BACKUP` admin command (Phase II)

## Observability

- Prometheus metrics at `/metrics`: write QPS, read QPS, fsync latency, schema validation latency, per-stream lag
- Structured JSON logs to stdout
- pprof endpoint at `/debug/pprof/` (default-off)

## See Also

- [[Prometheus]]
- [[reservoir-spec]] §8
