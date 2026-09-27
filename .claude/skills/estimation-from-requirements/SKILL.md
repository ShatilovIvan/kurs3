---
name: estimation-from-requirements
description: "Derives effort and time estimates directly from a requirements document by decomposing it into estimable units, applying a consistent estimation technique, and explicitly surfacing uncertainty and assumptions — rather than producing a single confident-sounding number from a gut feel. Use once requirements are detailed enough to decompose, before committing to a timeline."
---

**Purpose:** Produce an estimate that's traceable back to specific requirements and stated assumptions, so "how long will this take?" has a defensible, revisable answer instead of a number someone said in a meeting that later gets treated as a promise.

## When to use this

- A requirements or functional spec document is complete enough to plan against, and a timeline or cost estimate is needed for stakeholders.
- A previous estimate turned out to be badly wrong, and the team needs a repeatable, inspectable process instead of another single gut-feel number.
- Comparing the cost of two requirement options (e.g., MVP scope vs. full scope, see `mvp-scope-cutting`) requires estimates for each to make an informed tradeoff.
- A stakeholder is pushing for a date before requirements are fully decomposed, and engineering needs to show what's driving the estimate's uncertainty.
- Capacity planning across a roadmap needs estimates for multiple requirement sets to sequence work realistically.

## Workflow

1. **Confirm requirements are decomposable before estimating.** A requirement too vague to estimate ("improve performance") needs to go back through `ambiguity-detection-in-requirements` first — estimating vague requirements produces a vague, unreliable number dressed up as precision.
2. **Break the requirements document into estimable units** — typically at the level of a user story or a functional-spec behavior, small enough that a single person can reason about its effort in one sitting, large enough not to drown in overhead.
3. **Classify each unit's estimation confidence** based on how well-understood it is: known pattern (done this exact thing before), similar pattern (done something close), or novel (first time, real unknowns) — confidence class should drive both the estimate and how much padding/spike work it needs.
4. **Apply a consistent estimation technique across all units** — relative sizing (story points via planning poker), or absolute time-based estimation with a stated technique (three-point/PERT: optimistic, likely, pessimistic) — consistency across units is what makes totals meaningful; mixing techniques ad hoc produces incomparable numbers.
5. **Identify and separately estimate hidden work**: testing, code review, documentation, deployment/migration work, and cross-team coordination overhead — these are routinely left out of "the feature" estimate and are a common source of systematic underestimation.
6. **List every assumption the estimate depends on explicitly** — "assumes the existing payment API supports partial refunds without changes" — so that when an assumption turns out false, the estimate's invalidity is traceable to a specific, named cause rather than a general "estimates are always wrong."
7. **Surface uncertainty as a range, not a point number**, wider for novel/unknown units and narrower for known-pattern ones — a single number invites false confidence and gets remembered as a commitment regardless of how many caveats surrounded it verbally.
8. **Flag dependencies and blockers that affect timeline but not effort** — waiting on a third-party API key, a security review, another team's unrelated deliverable — since these affect the calendar date even when they don't add engineering hours.
9. **Re-estimate when requirements change**, linking the updated estimate to the specific change via `requirement-change-impact-analysis`, rather than letting the original estimate quietly go stale while scope grows.
10. **Present the estimate with its decomposition and assumptions attached**, not just a final number — stakeholders can then see what to interrogate if the date needs to move, and which specific unknowns would most reduce the range if resolved first.

## Worked example

**Fictional feature:** Adding subscription pause/resume to NovaCRM's billing module, estimated using three-point (PERT) per unit.

| Unit (from functional spec) | Confidence | Optimistic | Likely | Pessimistic | PERT estimate |
|---|---|---|---|---|---|
| Pause subscription API + state transition | Known pattern (similar to existing cancel flow) | 1d | 2d | 3d | 2d |
| Resume subscription API + proration logic | Novel (first time prorating a partial period) | 2d | 4d | 9d | 4.5d |
| Billing provider webhook handling for pause events | Similar pattern (existing webhook infra, new event type) | 1d | 2d | 4d | 2.2d |
| Admin dashboard UI for pause/resume | Known pattern | 1d | 1.5d | 2d | 1.5d |
| Testing (unit + integration, all above) | — | 2d | 3d | 5d | 3.2d |
| Migration: handle subscriptions already mid-cycle at launch | Novel | 1d | 3d | 6d | 3.2d |
| **Total** | | | | | **~16.6d** |

**Assumptions listed**: billing provider's API supports mid-cycle proration natively (unverified — if false, resume-logic estimate could double); no legal review required for pause/resume terms (confirmed with legal, low risk).

**Dependencies flagged**: billing provider sandbox access needed before webhook work can start — currently pending, adds unknown calendar delay independent of the 16.6d effort figure.

**Presented as**: "13-22 person-days of engineering effort, most likely ~17d, contingent on billing-provider proration API behavior (highest-uncertainty assumption) and sandbox access timing (calendar risk, not effort risk)."

## Common pitfalls

- **Estimating requirements that are too vague to decompose**, producing a number that looks precise but is actually a guess wearing a costume — fix the requirement's clarity first.
- **Presenting a single point estimate instead of a range**, which gets remembered and repeated as a commitment regardless of the uncertainty that actually existed behind it.
- **Forgetting hidden work** (testing, review, deployment, coordination) that isn't "the feature" but is real time the team will spend — a frequent, systematic source of estimates coming in low.
- **Not stating assumptions explicitly**, so when one turns out false, the estimate's failure looks like a general estimation problem instead of a traceable, specific cause that could have been checked earlier.
- **Mixing estimation techniques inconsistently across units** (some in story points, some in days, with no stated conversion), producing a total that looks additive but isn't meaningfully comparable.
- **Re-using a stale estimate after requirements changed**, instead of explicitly re-estimating the changed units and linking the new number to the specific change that invalidated the old one.

## Output

This skill produces an **estimate document**: the requirements decomposed into estimable units, each with a confidence classification and a three-point (or equivalent) estimate, a total presented as a range rather than a single number, an explicit assumptions list, a hidden-work breakdown (testing, review, deployment), and flagged calendar-affecting dependencies separate from effort — traceable back to the specific requirements document version it was derived from.
