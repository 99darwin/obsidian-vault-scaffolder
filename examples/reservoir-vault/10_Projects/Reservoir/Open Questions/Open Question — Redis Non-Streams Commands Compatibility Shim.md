---
type: open-question
project: Reservoir
status: open
priority: medium
needs_resolution_by: M1
owner:
tags: [open-question, scope, compat]
---

# Should we support Redis non-streams commands (GET/SET/HSET) as a compatibility shim?

## Why It Matters

Supporting GET/SET/HSET would let some users replace Redis entirely with Reservoir — bigger replacement story. But it's a slippery slope: once you add GET, users will ask for pub/sub channels, then sorted sets, then EVAL. At that point you're a Redis reimplementation, not a streaming broker.

## Options

| Option | Pros | Cons |
|---|---|---|
| Support a small subset | Bigger TAM, full-replace story | Slippery slope to maintaining a Redis fork |
| Streams only (current lean) | Focused, defensible scope | Some users won't migrate |

## Path Forward

Lean: **no**. Stay streams-only. Revisit if customer interviews show non-streams compat is a hard adoption blocker.

## See Also

- [[Wire Protocol — RESP3 Subset]]
- [[reservoir-spec]] §11
