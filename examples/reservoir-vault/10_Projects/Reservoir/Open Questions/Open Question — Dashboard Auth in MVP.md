---
type: open-question
project: Reservoir
status: open
priority: high
needs_resolution_by: M4
owner:
tags: [open-question, dashboard, security]
---

# Dashboard auth in MVP — really skip?

## Why It Matters

The spec says "no auth in MVP — assumes broker is on a private network". Even so, a single HTTP basic gate may be table-stakes for any team that runs Reservoir behind a corporate LAN. The cost is small (~50 lines of Go), the risk of cutting it is real.

## Options

| Option | Pros | Cons |
|---|---|---|
| No auth | Minimal MVP, ship fast | Won't pass any security review |
| HTTP basic gate | ~50 LOC, blocks casual access | Not real RBAC |
| Full RBAC | Production-grade | Months of work, not MVP-scope |

## Path Forward

Lean: ship HTTP basic in MVP. Document RBAC as Phase II.

## See Also

- [[Dashboard]]
- [[reservoir-spec]] §11
