---
type: technology
category: backend
tags: [technology, protocol, resp3]
---

# RESP3 Protocol

Redis's wire protocol (v3). Reservoir implements a subset focused on Redis Streams commands plus custom `RSRV.SCHEMA` verbs.

## Why RESP3

Compat with existing Redis client libraries — "swap the URL" migration story for Redis Streams users.

## See Also

- [[Wire Protocol — RESP3 Subset]]
- [[Protocol Resources]]
- [[Risk — Redis Streams Compat Breaks on Edge Cases]]
