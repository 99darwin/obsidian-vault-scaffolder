---
type: spec
project: Reservoir
section: canonical-spec
status: draft
version: 0.1.0
phase: Phase I MVP
date: 2026-06
author: Reservoir team
tags: [spec, canonical]
---

# Reservoir — Technical Specification

**Codename**: Reservoir
**Version**: 0.1.0 — Phase I MVP
**Date**: June 2026
**Status**: Draft — Pre-Implementation

---

## 1. Executive Context

### What We're Building

Reservoir is a single-binary streaming broker designed to occupy the niche between Redis Streams (too lightweight, lossy under pressure) and Redpanda/Kafka (too heavy for sub-100-node deployments). It targets the developer running 1–20 services who needs durable pub/sub with exactly-once semantics but doesn't want to operate a 5-node Kafka cluster.

### Why It Works

- **Single-binary deploy.** Drop on a Linux host, point clients at it, done. No ZooKeeper, no Raft cluster minimum, no schema registry as a separate service.
- **Wire-compatible with Redis Streams (read path).** Existing Redis Streams consumers work unmodified against a Reservoir broker. Migration story is "swap the URL".
- **Durable by default.** Every message lands on disk before ACK. WAL with mmap'd index. Configurable fsync cadence (default: every 1ms or every 4KB written, whichever first).
- **Built-in schema registry.** Protobuf and Avro schemas live alongside streams, versioned, evolution-checked on producer connect.

### Phase I Scope (MVP)

- Single-node deployment (no clustering yet)
- Pub/sub with consumer groups
- At-least-once delivery (exactly-once via dedup window — Phase II for full EOS)
- Redis Streams wire compat on the read path
- Built-in schema registry (Protobuf only at MVP)
- Prometheus metrics endpoint
- Web dashboard for stream inspection
- Single static binary (~30MB target)

### Phase I Non-Goals

- Multi-node replication (Phase II)
- Kafka wire compat (Phase III, maybe never)
- Stream processing / aggregation operators (out of scope, use Flink)
- Tiered storage / cold archive (Phase II)
- Multi-tenant isolation (Phase III)

---

## 2. System Architecture

### High-Level Topology

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

### Design Principles

1. **Single binary, single process.** No external dependencies. systemd-friendly. Container-friendly.
2. **Disk-first, memory-cached.** Every write hits the WAL before ACK. Reads use page cache. Don't reinvent OS-level caching.
3. **Wire compat is a feature, not a constraint.** Redis Streams compat lets users adopt without rewriting client code. Don't compromise broker design to chase compat; instead, document where we diverge.
4. **Backpressure is explicit.** When consumers fall behind, producers see it (slow ACK + explicit lag header). Never silently drop.
5. **Schemas are first-class.** Streams have a schema or they're flagged as "unstructured". Schema validation happens at the broker, not the client.

---

## 3. Technology Stack

| Component | Choice | Rationale |
|-----------|--------|-----------|
| Language | Go 1.22 | Single static binary, good concurrency, mature ecosystem |
| WAL | Custom (mmap + segmented files) | Off-the-shelf options (BoltDB) don't fit streaming workload |
| Schema store | BoltDB (embedded) | Tiny, embedded, transactional. Overkill is bad here. |
| Wire protocol | RESP3 (Redis) + custom binary for schema ops | RESP3 for read compat; binary for schema RPC efficiency |
| Metrics | Prometheus | Standard, expected by every ops team |
| TLS | crypto/tls (stdlib) | Don't roll crypto |
| Dashboard | Embedded React app served from binary | Single-binary story preserved |

---

## 4. Storage Engine

### WAL Format

Each stream lives in its own directory under `data/streams/<stream-name>/`. Within that directory:

- `segment-NNNNNN.wal` — append-only log files, default 256MB each
- `segment-NNNNNN.idx` — sparse index, one entry per 4KB of WAL data
- `consumers.db` — BoltDB for consumer group offsets
- `meta.json` — stream metadata (creation time, retention policy, schema ID)

### Write Path

1. Producer sends XADD over RESP3
2. Command dispatch validates command and looks up stream
3. Stream engine validates message against schema (if any)
4. Engine writes record to current WAL segment via mmap
5. Engine updates in-memory tail offset
6. fsync if cadence triggers (default: 1ms tick or 4KB written)
7. ACK returned with `<segment-id>-<offset>` as message ID

### Read Path

1. Consumer sends XREAD with consumer group + last-seen ID
2. Dispatch looks up group offset from BoltDB
3. Engine seeks to (segment-id, offset), reads forward
4. Records returned, group offset advanced in memory (persisted via XACK)

### Retention

Default: time-based (7 days) + size-based (10GB per stream). Whichever triggers first. Configurable per-stream. Compaction is offline — old segments are deleted in their entirety, no per-record TTL.

---

## 5. Wire Protocol — RESP3 Subset

We implement the Redis Streams command subset only:

- `XADD <stream> <id> <field> <value> [field value ...]`
- `XREAD [COUNT N] [BLOCK ms] STREAMS <stream> [stream...] <id> [id...]`
- `XGROUP CREATE <stream> <group> <id-or-$>`
- `XREADGROUP GROUP <group> <consumer> ...`
- `XACK <stream> <group> <id> [id...]`
- `XLEN <stream>`
- `XINFO STREAM <stream>`
- `XPENDING <stream> <group> [...]`
- `XTRIM <stream> ...`
- `XDEL <stream> <id> [id...]`

Plus our own:

- `RSRV.SCHEMA REGISTER <stream> <subject> <type> <body>`
- `RSRV.SCHEMA GET <stream>`
- `RSRV.SCHEMA EVOLVE <stream> <new-body>`

Connection-level: `HELLO`, `PING`, `AUTH`, `CLIENT GETNAME`, `CLIENT SETNAME`.

Everything else returns `ERR unknown command`. Document this loudly.

---

## 6. Schema Registry

### Why broker-resident?

Producers shouldn't be able to push messages that violate the schema. If the registry is a separate service, there's a race window. Co-locating it with the broker eliminates the race.

### Storage

BoltDB at `data/schemas.db`. Per-stream, schemas live keyed by `<stream>:<version>`. Latest version is the default. Old versions kept for consumer compat.

### Evolution Rules

On `RSRV.SCHEMA EVOLVE`, we check:

- Field additions: OK (default value required)
- Field removals: OK if optional
- Type changes: REJECT
- Field renames: REJECT (use add+remove)

Reject responses include the specific violating field.

### Protobuf Format

We store schemas as `.proto` text, parsed at register time. Validation uses `protoreflect`. Per-message validation cost is ~5µs at our benchmark (target: under 50µs total per XADD).

Avro support is Phase II.

---

## 7. Dashboard

Embedded React app, served from `/dashboard/` on the binary's HTTP port (default 8080). Views:

- **Streams list** with throughput sparklines (last 60s)
- **Stream detail**: schema, retention config, recent messages, consumer groups, lag per group
- **Consumer group detail**: members, individual consumer lag, pending PEL
- **Schema editor** for register/evolve operations
- **Live tail** (server-sent events for last N messages, paused-by-default)

No auth in MVP — assumes broker is on a private network. KYC for auth is Phase II.

---

## 8. Operations

### Deployment
- Single binary, supports `systemd`, `docker`, `kubernetes` (Deployment + PVC)
- Default config via env vars (`RSRV_*`)
- TLS: BYO cert at startup, no Let's Encrypt integration

### Backup
- WAL files are append-only; `rsync` is sufficient
- BoltDB consumer offsets need a `BACKUP` admin command (Phase II)

### Observability
- Prometheus metrics at `/metrics`: write QPS, read QPS, fsync latency, schema validation latency, per-stream lag
- Structured JSON logs to stdout
- pprof endpoint at `/debug/pprof/` (default-off)

---

## 9. Implementation Sequence

### Milestone 1 (Weeks 1–2) — Foundation
- Repo, CI, single static binary build
- RESP3 parser and command dispatch skeleton
- WAL segment management (append, segment rollover)
- XADD / XLEN / XREAD without consumer groups

### Milestone 2 (Weeks 2–4) — Consumer Groups
- BoltDB consumer offset store
- XGROUP / XREADGROUP / XACK
- Pending entries list (PEL)
- XPENDING / XCLAIM

### Milestone 3 (Weeks 4–5) — Schema Registry
- BoltDB schemas.db
- RSRV.SCHEMA REGISTER / GET / EVOLVE
- Protobuf validation on XADD path
- Evolution rule enforcement

### Milestone 4 (Weeks 5–6) — Dashboard
- Embedded React app build
- Streams list + detail views
- Consumer group views
- Schema editor

### Milestone 5 (Weeks 6–7) — Polish
- Prometheus metrics complete
- Documentation site (mkdocs)
- Load testing: target 100K XADD/sec on a single node
- Beta release

---

## 10. Risks

These need active mitigation through Phase I:

- **WAL corruption on power loss.** Need crash-recovery tests and checksums on every record.
- **Producer flood overwhelms fsync queue.** Need backpressure to producer when fsync queue depth exceeds threshold.
- **Schema validation cost dominates write latency.** 5µs target — needs measurement under realistic schemas (deeply nested protobufs).
- **Redis Streams compat breaks on edge cases.** Need test suite against the redis-py and node-redis client libraries.
- **Dashboard JS bundle bloats binary.** Target binary under 50MB; current React baseline is 8MB minified.

---

## 11. Open Questions

1. **Should we support Redis non-streams commands (GET/SET/HSET) as a compatibility shim?** It would let some users replace Redis entirely. But it's a slippery slope into being a full Redis reimplementation. Lean: no.

2. **Cluster mode topology.** When Phase II adds replication, do we use Raft (operator-friendly, slower) or chain replication (faster, weirder failure modes)? Need to benchmark.

3. **What's the on-disk schema format?** `.proto` text is human-readable but parsing is slow. Binary FileDescriptorProto is faster but opaque. Hybrid?

4. **Pricing model if we monetize.** Open-source core + paid cluster mode? Paid dashboard features? Self-hosted only? Need market input.

5. **Dashboard auth in MVP — really skip?** Even with private-network assumption, a single auth gate (HTTP basic) might be table-stakes. The cost is ~50 lines of Go.

6. **Avro Phase II vs. MVP.** Some serialization-heavy teams will hard-block on Protobuf-only. Need to gauge.

---

## 12. Reference

### Protocol Resources
- RESP3 spec: https://github.com/antirez/RESP3/blob/master/spec.md
- Redis Streams docs: https://redis.io/docs/data-types/streams/

### Inspirations / Prior Art
- **Redpanda**: Single-binary streaming. Different niche (full Kafka compat).
- **RedisStack**: Closest competitor on the wire-compat axis. Lossy under load.
- **NATS JetStream**: Similar single-binary deploy but different protocol.
