---
type: risk
project: Reservoir
severity: medium
likelihood: medium
status: open
owner:
tags: [risk, schema, performance]
---

# Risk — Schema Validation Cost Dominates Write Latency

5µs schema-validation target is based on a synthetic benchmark. Deeply nested Protobuf schemas may push validation cost past the 50µs total write budget, undermining the "durable but fast" pitch.

## Mitigation Plan

- Benchmark with realistic customer schemas (deeply nested, repeated fields, oneof)
- Cache parsed FileDescriptor at register time
- Reject schemas above a size/depth threshold with a clear error

## See Also

- [[Schema Registry]]
- [[Open Question — On-Disk Schema Format]]
- [[reservoir-spec]] §10
