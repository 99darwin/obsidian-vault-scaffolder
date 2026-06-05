---
type: open-question
project: Reservoir
status: open
priority: medium
needs_resolution_by: pre-launch
owner:
tags: [open-question, business, monetization]
---

# Pricing model if we monetize?

## Why It Matters

Open-source streaming brokers have multiple monetization patterns (Redpanda's open core + paid cluster mgmt, Confluent's cloud-only paid, Redis's tiered modules). Picking too early constrains; picking too late leaves money on the table.

## Options

| Option | Pros | Cons |
|---|---|---|
| Open-source core + paid cluster mode | Aligns paid features with operational pain | Cluster mode is Phase II — slow revenue |
| Paid dashboard features (RBAC, audit) | Easy to gate, ops teams will pay | Dashboard is MVP — fast revenue but small ARPU |
| Self-hosted only, no SaaS | Lower ops burden | Slower growth, misses cloud-buyer segment |

## Path Forward

Need market input. Defer hard decision until 5+ design partner conversations.

## See Also

- [[reservoir-spec]] §11
