---
type: architecture
project: Reservoir
tags: [architecture, design-principles]
---

# Design Principles

Five non-negotiable principles shape every design decision:

## 1. Single binary, single process

No external dependencies. systemd-friendly. Container-friendly. If a feature requires a sidecar, it's not in MVP.

## 2. Disk-first, memory-cached

Every write hits the WAL before ACK. Reads use the OS page cache. Don't reinvent OS-level caching.

## 3. Wire compat is a feature, not a constraint

Redis Streams compat lets users adopt without rewriting client code. Don't compromise broker design to chase compat — instead, document where we diverge.

## 4. Backpressure is explicit

When consumers fall behind, producers see it (slow ACK + explicit lag header). Never silently drop.

## 5. Schemas are first-class

Streams have a schema or they're flagged as "unstructured". Schema validation happens at the broker, not the client.

## See Also

- [[System Topology]]
- [[Schema Registry]]
- [[reservoir-spec]] §2
