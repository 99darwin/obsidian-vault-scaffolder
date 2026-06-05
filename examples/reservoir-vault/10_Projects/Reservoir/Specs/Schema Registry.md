---
type: spec
project: Reservoir
section: schema-registry
spec_section: 6
tags: [spec, schema, registry]
---

# Schema Registry

## Why broker-resident?

Producers shouldn't be able to push messages that violate the schema. If the registry is a separate service, there's a race window. Co-locating it with the broker eliminates the race.

## Storage

BoltDB at `data/schemas.db`. Per-stream, schemas live keyed by `<stream>:<version>`. Latest version is the default. Old versions kept for consumer compat.

## Evolution Rules

On `RSRV.SCHEMA EVOLVE`, we check:

- **Field additions**: OK (default value required)
- **Field removals**: OK if optional
- **Type changes**: REJECT
- **Field renames**: REJECT (use add+remove)

Reject responses include the specific violating field.

## Protobuf Format

We store schemas as `.proto` text, parsed at register time. Validation uses `protoreflect`. Per-message validation cost is ~5µs at our benchmark (target: under 50µs total per XADD).

Avro support is Phase II.

## See Also

- [[BoltDB]]
- [[Risk — Schema Validation Cost Dominates Write Latency]]
- [[Open Question — On-Disk Schema Format]]
- [[Open Question — Avro Phase II vs MVP]]
- [[reservoir-spec]] §6
