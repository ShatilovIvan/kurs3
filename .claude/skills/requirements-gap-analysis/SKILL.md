---
name: requirements-gap-analysis
description: "Structures a comparison of current-state vs. desired-state to surface missing capabilities, process gaps, and data gaps before they become mid-sprint surprises. Use when a requirements doc reads as a wish list without grounding in what the system, process, or data actually does today."
---

**Purpose:** Systematically compare what a system/process does today against what stakeholders want it to do, and produce a categorized, prioritized list of the gaps in between — instead of discovering them one at a time during implementation.

## When to use this

- A PRD describes desired functionality but was written without anyone checking what the current system actually supports.
- Engineering pushes back mid-sprint with "we don't have that data" or "that API doesn't exist" — a sign gap analysis should have happened during requirements, not during coding.
- A team is scoping a migration (legacy system to new platform) and needs to know exactly what functionality would be lost or need rebuilding.
- Two stakeholders describe the "current state" differently and the disagreement is stalling a planning meeting.
- An audit, compliance review, or new regulation requires proving a system meets a defined standard, and someone needs to show precisely where it falls short.
- A new feature request implicitly assumes upstream data or process steps exist that no one has confirmed are actually there.
- Leadership asks "how far are we from X" and needs a concrete, itemized answer rather than a vague estimate.

## Workflow

1. **Define the desired end state precisely.** Write it as a set of discrete, testable capability statements (not a paragraph of aspiration). E.g., not "better reporting" but "user can export a filtered order report as CSV within 5 seconds for datasets up to 100k rows."

2. **Document the current state factually, not from memory.** Verify against the actual system: read the code/config, run the existing report, interview the process owner, or check the data schema. Do not let "I think we already do that" substitute for verification — this is the single most common source of a bad gap analysis.

3. **Categorize gaps by type**, since each type needs a different owner and remediation path:
   - **Capability gap** — a feature or function that doesn't exist at all.
   - **Process gap** — the capability exists but the workflow/ownership/approval process to use it doesn't.
   - **Data gap** — the underlying data doesn't exist, isn't captured, isn't accurate, or isn't accessible in the needed form.
   - **Performance/scale gap** — the capability exists but doesn't meet a non-functional requirement (speed, volume, uptime).
   - **Compliance/policy gap** — the capability exists but violates or doesn't address a regulatory/policy requirement.

4. **Score each gap on impact and effort.** Use a simple scale (High/Medium/Low for each) so gaps can be prioritized rather than tackled in discovery order.

5. **Identify dependencies between gaps.** Some gaps block others (e.g., a data gap must close before a capability gap can be built on top of it). Sequence remediation accordingly.

6. **Assign an owner and a remediation type to each gap** — build, buy, process change, policy exception, or explicitly "accepted, will not fix" (with sign-off from whoever owns the risk).

7. **Validate the table with both business and technical stakeholders.** The business side confirms the desired state is complete and correctly prioritized; the technical side confirms the current-state entries are accurate.

8. **Feed high-priority gaps into the backlog as scoped requirements or epics**, each traceable back to its row in the gap analysis so nothing gets lost in translation.

9. **Re-run the analysis at major milestones** (not just once) — new gaps surface as the desired state evolves or as remediation of one gap reveals another underneath it.

## Example: worked gap analysis

**Context:** Fictional company "Ledgerly" wants its order-management SaaS to support automated tax-exempt order handling for B2B customers.

| # | Desired capability | Current state (verified) | Gap type | Impact | Effort | Owner | Remediation |
|---|---|---|---|---|---|---|---|
| 1 | System auto-detects tax-exempt customers at checkout using stored exemption certificates | No `tax_exempt_status` field exists on customer record; exemption certs are emailed manually to finance | Data gap | High | Medium | Data/Platform team | Add `tax_exempt_status` + `exemption_cert_id` fields; migrate existing certs into system |
| 2 | Exemption certificates auto-expire and trigger re-verification workflow | No expiration tracking; finance manually re-checks annually via spreadsheet | Process gap | Medium | Low | Finance Ops | Define expiration workflow; build reminder automation once field exists (depends on #1) |
| 3 | Checkout applies correct tax rule per state/exemption combo in real time | Tax engine (Avalara integration) exists and supports this once exemption flag is present | Capability gap (partial — blocked by data gap) | High | Low (once #1 done) | Checkout Platform | No new build needed beyond passing the new field to existing Avalara call |
| 4 | Exemption handling must meet SOC 2 audit trail requirement (who approved, when, evidence retained) | No audit log for exemption approval; certs stored in shared email inbox, no access control | Compliance gap | High | Medium | Security/Compliance | Build approval audit log; migrate cert storage to access-controlled document store |
| 5 | Report showing all tax-exempt orders processed per quarter for finance reconciliation | No report exists; finance currently reconstructs manually from raw order exports | Capability gap | Medium | Medium | Reporting team | New scheduled report; depends on #1 and #4 for complete/auditable data |

**Sequencing note:** #1 (data gap) blocks #2 and #3; #4 (compliance) should land before or alongside #1 since certs will start flowing through the system as soon as the field exists — storing them without an audit trail would create a new compliance gap rather than closing one.

## Common pitfalls

- **Documenting current state from memory instead of verification.** Assumptions about "what we already support" are wrong often enough that unverified current-state rows undermine the whole analysis.
- **Writing desired state as vague aspiration.** "Improve the reporting experience" cannot be gap-analyzed; it must be broken into testable capability statements first.
- **Treating all gaps as the same type.** A data gap and a process gap need completely different owners and timelines; lumping them together as "backlog items" loses that signal.
- **No impact/effort scoring, so gaps get worked in discovery order** rather than priority order — teams end up fixing a low-value gap first simply because it was found first.
- **Missing dependency sequencing.** Building a feature on top of a data gap that hasn't closed yet produces rework once the real data shows up in a different shape than assumed.
- **No explicit "accepted, won't fix" option.** Without it, every gap silently becomes an open commitment, and stakeholders later assume all gaps are being addressed when some were consciously deprioritized.
- **One-time analysis, never revisited.** Desired state shifts as a project proceeds; a gap analysis done once at kickoff goes stale and stops reflecting reality by the time implementation starts.

## Output

A **Requirements Gap Analysis table** (as above) with columns: desired capability, verified current state, gap type (capability/process/data/performance/compliance), impact, effort, owner, and remediation path, plus a short dependency/sequencing note. High-priority rows should be turned into linked backlog items (epics/tickets) that reference their gap-analysis row number for traceability.
