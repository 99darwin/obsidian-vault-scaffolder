---
type: risk
project: Reservoir
severity: medium
likelihood: medium
status: open
owner:
tags: [risk, dashboard, binary-size]
---

# Risk — Dashboard JS Bundle Bloats Binary

Target binary size is under 50MB; current React baseline is already 8MB minified. Feature creep in the dashboard could blow the binary past target, undermining the single-binary story.

## Mitigation Plan

- Hard cap dashboard bundle at 10MB
- Code-split rarely-used views (schema editor, live tail)
- Audit dependencies; replace heavy libs with vanilla where reasonable

## See Also

- [[Dashboard]]
- [[Technology Stack]]
- [[reservoir-spec]] §10
