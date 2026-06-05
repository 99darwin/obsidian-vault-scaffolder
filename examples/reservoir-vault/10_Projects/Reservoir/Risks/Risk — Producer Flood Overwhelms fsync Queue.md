---
type: risk
project: Reservoir
severity: high
likelihood: high
status: open
owner:
tags: [risk, backpressure, fsync]
---

# Risk — Producer Flood Overwhelms fsync Queue

Under high write pressure the fsync queue depth can balloon, increasing tail latency and consuming memory. Without explicit backpressure, producers see unbounded ACK delay.

## Mitigation Plan

- Bounded fsync queue with high-water mark
- When queue depth exceeds threshold, return slow ACK + lag header to producer
- Document expected throughput ceiling per disk class

## See Also

- [[Design Principles]] (#4 Backpressure is explicit)
- [[Storage Engine — Write Path]]
- [[reservoir-spec]] §10
