---
type: open-question
project: Reservoir
status: open
priority: medium
needs_resolution_by: M3
owner:
tags: [open-question, schema, scope]
---

# Avro Phase II vs. MVP?

## Why It Matters

Some serialization-heavy teams (esp. Confluent-heritage shops) will hard-block on Protobuf-only. Avro support is currently Phase II. If the MVP design-partner pool skews heavily Avro, we have to bring it forward.

## Options

| Option | Pros | Cons |
|---|---|---|
| Avro in MVP | Larger TAM, no hard blockers | Adds 1-2 weeks, larger surface area |
| Avro Phase II (current plan) | Tighter MVP scope | Loses Avro-shop adopters |

## Path Forward

Gauge from design partners. Bring forward only if 2+ committed adopters block on it.

## See Also

- [[Schema Registry]]
- [[Phase II]]
- [[reservoir-spec]] §11
