---
type: spec
project: Reservoir
section: wire-protocol-resp3
spec_section: 5
tags: [spec, protocol, resp3]
---

# Wire Protocol — RESP3 Subset

We implement the Redis Streams command subset only:

- `XADD <stream> <id> <field> <value> [field value ...]`
- `XREAD [COUNT N] [BLOCK ms] STREAMS <stream> [stream...] <id> [id...]`
- `XGROUP CREATE <stream> <group> <id-or-$>`
- `XREADGROUP GROUP <group> <consumer> ...`
- `XACK <stream> <group> <id> [id...]`
- `XLEN <stream>`
- `XINFO STREAM <stream>`
- `XPENDING <stream> <group> [...]`
- `XTRIM <stream> ...`
- `XDEL <stream> <id> [id...]`

Plus our own custom verbs:

- `RSRV.SCHEMA REGISTER <stream> <subject> <type> <body>`
- `RSRV.SCHEMA GET <stream>`
- `RSRV.SCHEMA EVOLVE <stream> <new-body>`

Connection-level: `HELLO`, `PING`, `AUTH`, `CLIENT GETNAME`, `CLIENT SETNAME`.

Everything else returns `ERR unknown command`. Document this loudly.

## See Also

- [[RESP3 Protocol]]
- [[Schema Registry]]
- [[Risk — Redis Streams Compat Breaks on Edge Cases]]
- [[Open Question — Redis Non-Streams Commands Compatibility Shim]]
- [[reservoir-spec]] §5
