---
type: risk
project: Reservoir
severity: high
likelihood: high
status: open
owner:
tags: [risk, compat, wire-protocol]
---

# Risk — Redis Streams Compat Breaks on Edge Cases

"Swap the URL" is the wedge — if redis-py or node-redis hit an edge case Reservoir handles differently (ID formats, blocking semantics, error codes), the migration story collapses.

## Mitigation Plan

- Test suite against redis-py and node-redis client libraries
- Run the official Redis Streams compat tests where applicable
- Document every divergence in a "Compatibility Notes" page

## See Also

- [[Wire Protocol — RESP3 Subset]]
- [[reservoir-spec]] §10
