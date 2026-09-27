---
name: non-functional-requirements-elicitation
description: "Elicits and quantifies non-functional requirements (performance, availability, security, scalability, usability, maintainability, compliance) using an ISO 25010-style quality-attribute checklist, converting vague statements like 'fast' or 'secure' into measurable SLOs with concrete numbers. Use whenever NFRs are absent, vague, or unquestioned in a spec."
---

**Purpose:** Make sure a feature's non-functional requirements are explicit and measurable before design/build starts, instead of discovered as a production incident — by systematically asking about each quality attribute and converting every vague answer into a number someone can test against.

## When to use this

- A spec or PRD mentions "the system should be fast/secure/scalable" with no accompanying number.
- A functional spec is otherwise complete but has no performance, availability, or security section at all.
- A post-incident review reveals the system met every functional requirement but still failed users (timeout under load, data breach, accessibility complaint, unmaintainable code nobody wants to touch).
- Capacity planning, load testing, or infrastructure sizing is blocked because nobody has stated an expected concurrent user count or peak transaction volume.
- A compliance, audit, or security review is coming up and NFRs need to be traceable to a specific regulation or standard.
- Stakeholders keep answering NFR questions with adjectives ("robust," "user-friendly," "enterprise-grade") instead of numbers.

## Workflow

1. **Walk the quality-attribute tree, one characteristic at a time** (ISO/IEC 25010 categories below), rather than asking "any non-functional requirements?" as one open question — that question reliably gets "no" even when several exist unstated.
2. **For each characteristic, ask about a concrete, memorable event** rather than an abstract steady state: "tell me about your worst Black Friday," "tell me about the last outage and what broke," "walk me through the last time this failed an audit." Concrete incidents produce real numbers; abstract questions produce adjectives.
3. **Convert every adjective into a number with units, a percentile, and a measurement window.** "Fast" becomes "p95 latency under 400ms, measured over a rolling 5-minute window, under expected peak load of 1,200 requests/sec." If the stakeholder can't give a number, propose one from a comparable system or industry baseline and get them to confirm or adjust it — don't leave it blank.
4. **Identify the enforcement mechanism** for each NFR: how will this be tested (load test, penetration test, accessibility audit, chaos experiment) and where will it be monitored in production (dashboard, alert threshold)? An NFR with no way to verify it is not actually a requirement, just an aspiration.
5. **Record the trigger condition and consequence** for compliance-driven NFRs specifically: which regulation/standard, what the audit evidence looks like, and what the penalty or business risk is if unmet.
6. **Cross-check for conflicts** between NFRs (e.g., strict data-retention limits for privacy vs. long retention for audit trails) and get an explicit resolution/priority decision, don't let the conflict sit implicit until it breaks something.
7. **Attach each measurable NFR to the specific feature/epic/story it constrains**, so it travels with the requirement into the functional spec and doesn't get silently dropped.

## ISO 25010-style quality-attribute checklist

- **Performance efficiency** — response time (p50/p95/p99), throughput, resource utilization under specified load. Ask: "what's the peak concurrent load, and what latency is acceptable at that peak?"
- **Reliability / availability** — uptime target, RTO (recovery time objective), RPO (recovery point objective), MTBF/MTTR. Ask: "what uptime percentage is contractually or practically required, and what's an acceptable data-loss window if we fail over?"
- **Security** — authentication/authorization strength, data-at-rest/in-transit encryption, known threat classes to defend against (commonly framed against OWASP Top 10 categories), audit logging. Ask: "what's the most sensitive data this touches, and what happens if it leaks?"
- **Usability / accessibility** — task completion time/error rate for target users, accessibility conformance level (e.g., WCAG 2.1 AA), supported devices/browsers. Ask: "who are the least tech-savvy users of this, and what's the required accessibility standard?"
- **Compatibility / portability** — supported OS/browser/device matrix, backward compatibility window for APIs, data migration constraints. Ask: "what's the oldest client version we still have to support, and for how long?"
- **Maintainability** — code coverage expectations, mean time to implement a typical change, documentation requirements, modularity constraints. Ask: "how long does a typical bug fix take today, and what SHOULD it take?"
- **Scalability** — expected growth curve (users, data volume, transaction rate) over a defined horizon, and the point at which the current design is expected to need re-architecture. Ask: "where do we expect to be in 12/24 months, and does this design need to survive that, or just get us there?"
- **Compliance** — specific regulation/standard/contract clause, required audit evidence, retention/deletion obligations. Ask: "what would an auditor ask to see, and how would we produce it today?"

## Worked example

**Fictional system:** MedPortal, a hospital patient-records web portal.

| Category | Vague stakeholder statement | Measurable NFR |
|---|---|---|
| Performance | "The record lookup needs to be fast for the nurses." | p95 response time ≤ 500ms for patient-record lookup by MRN, measured under a peak load of 300 concurrent clinical staff sessions during shift-change hours (6-8am, 6-8pm). |
| Availability | "This can't go down during a shift." | 99.9% monthly uptime (≤ ~43 min downtime/month) for core lookup functionality; RTO of 15 minutes and RPO of 5 minutes for the patient-records database in a failover event. |
| Security | "Obviously this needs to be secure, it's patient data." | All PHI encrypted at rest (AES-256) and in transit (TLS 1.2+); role-based access control enforced per HIPAA minimum-necessary standard; every record access logged with user ID, timestamp, and record ID, retained 6 years for audit. |
| Usability | "Make sure it's easy for older nurses to use too." | New clinical-staff users complete a "look up patient and view latest vitals" task in ≤ 90 seconds with no training, per a moderated usability test with 8+ participants aged 45+; UI conforms to WCAG 2.1 AA. |
| Scalability | "We're adding two more hospitals next year." | System supports a 3x increase in concurrent sessions (to ~900) and a 2.5x increase in patient-record volume within 18 months without architectural rework beyond planned horizontal scaling of the read replicas. |
| Compliance | "This has to pass our HIPAA audit." | System produces, on demand, an access log report for any patient record covering the trailing 6 years, listing every accessing user, timestamp, and action, within 1 business day of an auditor's request. |

Conflict flagged during elicitation: the security team wanted access logs purged after 2 years (data minimization); compliance required 6 years for HIPAA audit trail. Resolution recorded: 6-year retention wins for access logs specifically (audit trail exemption), while unrelated session data is purged after 90 days.

## Common pitfalls

- **Accepting adjectives as requirements** ("fast," "secure," "scalable," "user-friendly") without converting them to numbers — these can't be designed against, tested against, or used to say "done," and every stakeholder silently assumes a different number.
- **Asking one generic "any non-functional requirements?" question** instead of walking the quality-attribute tree — stakeholders don't think in NFR categories unprompted, so this question reliably under-elicits.
- **Deriving NFRs from engineering assumptions instead of stakeholder input** ("we'll just say 99.9% uptime because that sounds standard") — this produces numbers nobody actually needs or, worse, numbers far below what the business actually requires, discovered only after an incident.
- **No enforcement/verification plan attached to the number** — an SLO with no load test, monitoring dashboard, or alert threshold behind it is decorative, not a requirement; it will silently regress.
- **Ignoring NFR conflicts until they surface as production incidents** — e.g., strict encryption-at-rest colliding with a legacy reporting tool's need for plaintext access; surfacing and resolving these during elicitation is far cheaper than during an outage.
- **Treating NFRs as a one-time exercise instead of revisiting them as scale/threat landscape changes** — an NFR set that was correct at 10,000 users is often wrong at 500,000, and compliance obligations change as regulations are updated.

## Output

This skill produces a **quality-attribute NFR table** for the feature or system under review: one row per applicable ISO 25010 category, each with the original stakeholder statement (if any), the converted measurable requirement (number, unit, percentile, measurement window), the verification method (test type or monitoring mechanism), and — where relevant — the governing regulation/standard. Flagged conflicts between NFRs are documented with their resolution. This table is designed to be inserted directly into a functional or implementation spec's non-functional requirements section.
