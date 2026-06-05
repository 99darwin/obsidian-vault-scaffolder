---
type: brief
project: Reservoir
tags: [brief, exec-summary]
---

# Executive Summary

Reservoir is a single-binary streaming broker designed to occupy the niche between Redis Streams (too lightweight, lossy under pressure) and Redpanda/Kafka (too heavy for sub-100-node deployments).

## Target User

The developer running 1–20 services who needs durable pub/sub with exactly-once semantics but doesn't want to operate a 5-node Kafka cluster.

## Positioning

- **Lighter than Redpanda/Kafka.** No ZooKeeper, no Raft cluster minimum, no separate schema registry service.
- **More durable than Redis Streams.** WAL-backed disk-first writes, configurable fsync cadence.
- **Wire-compatible with Redis Streams on the read path.** Existing Redis Streams consumers work unmodified — migration is "swap the URL".

## See Also

- [[Why It Works]]
- [[Phase I Scope]]
- [[Phase I Non-Goals]]
- [[reservoir-spec]] §1
