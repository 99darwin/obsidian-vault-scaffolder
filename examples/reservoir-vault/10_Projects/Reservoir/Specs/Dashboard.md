---
type: spec
project: Reservoir
section: dashboard
spec_section: 7
tags: [spec, dashboard, ui]
---

# Dashboard

Embedded React app, served from `/dashboard/` on the binary's HTTP port (default 8080).

## Views

- **Streams list** with throughput sparklines (last 60s)
- **Stream detail**: schema, retention config, recent messages, consumer groups, lag per group
- **Consumer group detail**: members, individual consumer lag, pending PEL
- **Schema editor** for register/evolve operations
- **Live tail** (server-sent events for last N messages, paused-by-default)

## Auth (or lack thereof)

No auth in MVP — assumes broker is on a private network. KYC for auth is Phase II.

## See Also

- [[Risk — Dashboard JS Bundle Bloats Binary]]
- [[Open Question — Dashboard Auth in MVP]]
- [[reservoir-spec]] §7
