---
type: brief
project: Reservoir
tags: [brief, why-it-works]
---

# Why It Works

Four claims underpin the Reservoir thesis:

## 1. Single-binary deploy

Drop on a Linux host, point clients at it, done. No ZooKeeper, no Raft cluster minimum, no schema registry as a separate service. systemd-friendly. Container-friendly.

## 2. Wire-compatible with Redis Streams (read path)

Existing Redis Streams consumers work unmodified against a Reservoir broker. Migration story is "swap the URL". Lowers the activation cost for teams already using Redis Streams.

## 3. Durable by default

Every message lands on disk before ACK. WAL with mmap'd index. Configurable fsync cadence (default: every 1ms or every 4KB written, whichever first). Closes the Redis Streams gap where in-memory replication can drop messages under pressure.

## 4. Built-in schema registry

Protobuf and Avro schemas live alongside streams, versioned, evolution-checked on producer connect. Eliminates the race window where a producer pushes a message that violates a schema stored in a separate registry.

## See Also

- [[Executive Summary]]
- [[Schema Registry]]
- [[reservoir-spec]] §1
