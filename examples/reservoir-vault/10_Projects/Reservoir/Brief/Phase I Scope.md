---
type: brief
project: Reservoir
tags: [brief, scope, mvp]
---

# Phase I Scope

What's in for the MVP:

- Single-node deployment (no clustering yet)
- Pub/sub with consumer groups
- At-least-once delivery (exactly-once via dedup window — Phase II for full EOS)
- Redis Streams wire compat on the read path
- Built-in schema registry (Protobuf only at MVP)
- Prometheus metrics endpoint
- Web dashboard for stream inspection
- Single static binary (~30MB target)

## See Also

- [[Phase I Non-Goals]]
- [[Implementation Sequence]]
- [[Phase I MVP]]
- [[reservoir-spec]] §1
