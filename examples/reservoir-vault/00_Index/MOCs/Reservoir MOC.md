---
type: moc
project: Reservoir
tags: [moc, map-of-content]
---

# Reservoir — Map of Content

Every Reservoir note, organized for navigation.

## Anchor

- [[Project Charter]]
- [[reservoir-spec]] — canonical spec (single source of truth)

## Brief

- [[Executive Summary]]
- [[Why It Works]]
- [[Phase I Scope]]
- [[Phase I Non-Goals]]

## Architecture

- [[System Topology]]
- [[Design Principles]]
- [[Technology Stack]]

## Specs

- [[Storage Engine — WAL Format]]
- [[Storage Engine — Write Path]]
- [[Storage Engine — Read Path]]
- [[Storage Engine — Retention]]
- [[Wire Protocol — RESP3 Subset]]
- [[Schema Registry]]
- [[Dashboard]]
- [[Operations]]

## Phases & Plans

- [[Phase I MVP]]
- [[Phase II]]
- [[Phase III]]
- [[Implementation Sequence]]
- [[Milestone 1 — Foundation]]
- [[Milestone 2 — Consumer Groups]]
- [[Milestone 3 — Schema Registry]]
- [[Milestone 4 — Dashboard]]
- [[Milestone 5 — Polish]]

## Reference

- [[Protocol Resources]]
- [[Prior Art]]

## Open Questions

- [[Open Question — Redis Non-Streams Commands Compatibility Shim]]
- [[Open Question — Cluster Mode Topology]]
- [[Open Question — On-Disk Schema Format]]
- [[Open Question — Pricing Model]]
- [[Open Question — Dashboard Auth in MVP]]
- [[Open Question — Avro Phase II vs MVP]]

## Risks

- [[Risk — WAL Corruption on Power Loss]]
- [[Risk — Producer Flood Overwhelms fsync Queue]]
- [[Risk — Schema Validation Cost Dominates Write Latency]]
- [[Risk — Redis Streams Compat Breaks on Edge Cases]]
- [[Risk — Dashboard JS Bundle Bloats Binary]]

## Technologies (Resources)

- [[Go 1.22]]
- [[BoltDB]]
- [[Prometheus]]
- [[RESP3 Protocol]]

## Sprints

- [[Milestone 1]] — Week 1 shell
