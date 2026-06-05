---
type: project
project: Reservoir
status: active
phase: Phase I MVP
version: 0.1.0
owner:
started: 2026-06
target_launch: 2026-07
tags: [project, charter]
---

# Reservoir — Project Charter

> Reservoir is a single-binary streaming broker designed to occupy the niche between Redis Streams (too lightweight, lossy under pressure) and Redpanda/Kafka (too heavy for sub-100-node deployments). Targets developers running 1-20 services who need durable pub/sub with exactly-once semantics without operating a 5-node Kafka cluster.

## One-Line Pitch

A single-binary streaming broker for the 1–20-service developer — durable like Kafka, deployable like Redis.

## Why It Works

- **Single-binary deploy.** Drop on a Linux host, point clients at it, done. No ZooKeeper, no Raft minimum, no separate schema registry service.
- **Wire-compatible with Redis Streams (read path).** Existing Redis Streams consumers work unmodified. Migration = swap the URL.
- **Durable by default.** Every message lands on disk before ACK. WAL with mmap'd index. Configurable fsync cadence.
- **Built-in schema registry.** Protobuf schemas live alongside streams, versioned, evolution-checked on producer connect — no race window between registry and broker.
- **Backpressure is explicit.** Slow ACK + lag header surface consumer lag to producers. Never silently drop.

## Phase I Scope

- Single-node deployment (no clustering yet)
- Pub/sub with consumer groups
- At-least-once delivery (exactly-once via dedup window — Phase II for full EOS)
- Redis Streams wire compat on the read path
- Built-in schema registry (Protobuf only at MVP)
- Prometheus metrics endpoint
- Web dashboard for stream inspection
- Single static binary (~30MB target)

## Phase I Non-Goals

- Multi-node replication (Phase II)
- Kafka wire compat (Phase III, maybe never)
- Stream processing / aggregation operators (out of scope, use Flink)
- Tiered storage / cold archive (Phase II)
- Multi-tenant isolation (Phase III)

## Key Documents

- Canonical spec: [[reservoir-spec]]
- Map of Content: [[Reservoir MOC]]
- Architecture: [[System Topology]], [[Design Principles]], [[Technology Stack]]
- Roadmap: [[Implementation Sequence]], [[Phase I MVP]]
- Top risks: [[Risk — WAL Corruption on Power Loss]], [[Risk — Producer Flood Overwhelms fsync Queue]], [[Risk — Redis Streams Compat Breaks on Edge Cases]]
- Top open questions: [[Open Question — Dashboard Auth in MVP]], [[Open Question — Cluster Mode Topology]]

## Status

Pre-implementation, spec drafted June 2026. Phase I MVP targeted for ~7-week build (beta release at end of M5). No engineers yet assigned in vault metadata.
