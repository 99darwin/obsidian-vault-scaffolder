---
type: reference
project: Reservoir
tags: [reference, competitive, prior-art]
---

# Prior Art / Inspirations

Adjacent products in the streaming-broker space. Reservoir sits between Redis Streams and Redpanda; these are the reference points.

| Product | Niche | Relationship to Reservoir |
|---------|-------|---------------------------|
| **Redpanda** | Full Kafka-compat single-binary | Different niche (heavier, Kafka-shaped) |
| **RedisStack** | Closest on wire-compat axis | Lossy under load — the gap we fill |
| **NATS JetStream** | Similar single-binary deploy | Different protocol, different developer audience |

## See Also

- [[Executive Summary]]
- [[Why It Works]]
- [[reservoir-spec]] §12
