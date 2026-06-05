ok team, dumping thoughts on the new project before I forget.

Tessellate is an internal tool for visualizing service dependencies across our prod environment. The pain point: when something breaks, the on-call engineer spends 15-20 minutes piecing together which services talk to which by grepping through k8s configs, network policies, and Datadog APM. We've all done it. The tribal knowledge is concentrated in maybe four people, and one of them is on PTO half the time.

The vision is a single web app where you punch in a service name and immediately see: what calls it (with traffic volume in last hour), what it calls (same), what database/queue/cache it touches, and what SLO it's supposed to meet. Click any node, drill down. The graph should update in near real-time as services come and go.

Data sources I'm thinking about: Datadog APM (we already have service maps there but they're noisy and hard to filter), Kubernetes service definitions, Istio virtual services (we have a mix of istio and pre-istio services which is annoying), our CMDB (such as it is), and our SLO definitions which currently live in a yaml file in the platform-config repo.

Backend should be Python — we have FastAPI everywhere else, no reason to deviate. Postgres for the graph data, maybe Redis for caching the live edges. The frontend is the hard part: I want it to feel like a really good network diagram, not a Graphviz dump. React + d3 force-directed layout, probably. We've tried Cytoscape.js before and the perf wasn't great past 200 nodes; need to benchmark that again.

Key open questions: how do we handle the istio/non-istio split? Probably need two separate ingestion paths and merge in our DB. Also: real-time vs. periodic — does this need to be sub-minute fresh, or is "updated every 5 min" enough? Real-time costs a lot more infra. I think periodic is fine for v1.

Risks I can see: Datadog rate limits (we're already close on some of our existing queries). The graph layout going to hell when services have thousands of edges (probably need clustering by namespace). And maintenance — who owns this six months from now if I leave? Need at least one other engineer signed up.

Stakeholders: I'd be the primary engineer. Platform team should weigh in on the deployment story (k8s deployment with our standard helm chart). SRE team is the primary user, especially the on-call rotation. Need buy-in from them before we ship — if they don't trust the graph, they won't use it during incidents.

Phase 1 is read-only — just visualize what's there. Phase 2 is annotations: "this dependency is intentional", "this one is a smell". Phase 3 is alerting — "this service just started calling a new database, was that intentional?" but that's a long way off.

Timeline: I'd like to have a working v0.1 in 6 weeks, beta to SRE in 8 weeks, GA inside the org by end of Q3. That's tight but feasible if I'm not pulled onto other fires.

Tech stack summary: Python 3.12 + FastAPI backend, Postgres 16 + Redis 7 for storage, React 18 + d3 for frontend, hosted in our standard EKS cluster with our standard CI. Auth via our existing SSO (Okta). Metrics into our existing Datadog. No new infrastructure to operate.

That's the brief. Let me know if anything's unclear or wrong.
