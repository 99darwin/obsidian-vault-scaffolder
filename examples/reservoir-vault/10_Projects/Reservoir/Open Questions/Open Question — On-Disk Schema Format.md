---
type: open-question
project: Reservoir
status: open
priority: medium
needs_resolution_by: M3
owner:
tags: [open-question, schema, storage]
---

# What's the on-disk schema format?

## Why It Matters

We need to store Protobuf schemas somewhere. `.proto` text is human-readable but parsing is slow. Binary `FileDescriptorProto` is fast but opaque. The choice affects cold-start time, debuggability, and the cost of `RSRV.SCHEMA GET`.

## Options

| Option | Pros | Cons |
|---|---|---|
| `.proto` text | Human-readable, easy to inspect | Slow parse, larger storage |
| Binary FileDescriptorProto | Fast, compact | Opaque to humans |
| Hybrid (store both) | Fast load + readable | Double storage, sync risk |

## Path Forward

Lean toward hybrid: parse `.proto` at register, cache binary FileDescriptor alongside, serve text on GET. Validate parse cost is acceptable.

## See Also

- [[Schema Registry]]
- [[Risk — Schema Validation Cost Dominates Write Latency]]
- [[reservoir-spec]] §11
