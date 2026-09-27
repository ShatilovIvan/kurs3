---
name: mvp-scope-cutting
description: "Trims an oversized feature wishlist down to a shippable MVP using MoSCoW, Kano, walking-skeleton, and RICE scoring, and produces a documented cut list with rationale. Use when a stakeholder hands over a 20-item wishlist for a v1 release, when a kickoff deck has no ship date because scope keeps growing, or when a team needs a defensible, written reason for what got cut and what got kept."
---

**Purpose:** Take an unconstrained feature wishlist for a new product or release and cut it down to the smallest set of features that is genuinely shippable and valuable, with every cut documented and defensible.

## When to use this

- A stakeholder or product sponsor hands you a feature list for "v1" that would obviously take two quarters, but the deadline is six weeks away.
- A kickoff or planning meeting produces a backlog with no prioritization, and everyone in the room privately believes their own feature is non-negotiable.
- You're asked to write the first PRD or scope document for a brand-new product and need a repeatable method instead of gut feel.
- A previous MVP attempt shipped late because "MVP" quietly became "full product," and leadership wants a documented scope-cutting exercise this time.
- You need to reopen a scope conversation mid-project because velocity data shows the current commitment won't land on time.
- A stakeholder says "we can't cut anything, it's all critical" and you need a structured way to break that deadlock rather than an argument.

## Workflow

1. **Inventory the full wishlist.** Collect every requested feature/capability from all sources (sales, support, exec asks, user research) into one flat list. Do not pre-filter yet — a feature that seems obviously cut-able sometimes turns out to be a Must once scored.
2. **Define the MVP's single goal.** Write one sentence: what decision or behavior must this release prove or enable (e.g., "prove that a solo bookkeeper will replace their spreadsheet with this tool for weekly expense entry"). Every scoring decision below is judged against this sentence, not against "would be nice."
3. **Score with RICE** (Reach × Impact × Confidence ÷ Effort) for a first-pass ranked list:
   - Reach: how many users/accounts touch this per period.
   - Impact: 3 = massive, 2 = high, 1 = medium, 0.5 = low, 0.25 = minimal.
   - Confidence: 100%/80%/50% based on evidence quality.
   - Effort: person-weeks, including test and rollout effort.
4. **Classify with Kano** to catch what RICE alone misses:
   - *Basic/threshold*: absence causes rejection even though presence isn't praised (e.g., login working). These are non-negotiable regardless of RICE score.
   - *Performance*: more is linearly better (e.g., faster report generation). Trade off against effort.
   - *Delighters*: unexpected, differentiating, but skippable in v1.
5. **Draw the walking skeleton.** Identify the thinnest possible slice that exercises every architectural layer end-to-end (UI → API → data store → back out) for the single most important user journey. Anything not needed to keep that skeleton walking is a candidate for a later phase, even if it scored well — sequencing matters as much as value.
6. **Apply MoSCoW to the RICE/Kano-ranked list**, using a hard budget: Musts should not exceed roughly 60% of available effort/capacity, forcing genuine trade-offs rather than a list where everything is a Must (see the companion skill `requirements-prioritization-moscow` for the full facilitation technique).
7. **Draft the cut list with rationale.** For every feature not in the MVP, write one line: what tier it moved to (Should/Could/Won't-this-time), why, and — if applicable — what release or trigger condition would bring it back.
8. **Negotiate with stakeholders using "not now," never "no."** Present cuts framed as sequencing decisions on a visible roadmap, not rejections. Bring the walking-skeleton diagram and the RICE table as evidence, not opinion.
9. **Get explicit sign-off** from the requesting stakeholder(s) on the final MVP list and the cut list, in writing (PRD comment, email, or ticket), before development starts.
10. **Revisit at the next milestone.** Scope cutting isn't one-and-done; re-run steps 3–7 lightly whenever new information (usage data, a slipped deadline, a new competitor move) changes the inputs.

## Worked example

**Product:** *LedgerLite*, a mobile expense-tracking app for solo freelancers. Target ship date: 6 weeks. Wishlist collected from founder, two beta users, and a sales prospect call:

| # | Feature | Reach | Impact | Confidence | Effort (wk) | RICE | Kano |
|---|---|---|---|---|---|---|---|
| 1 | Manual expense entry (amount, category, date) | 10 | 3 | 100% | 1 | 30.0 | Basic |
| 2 | Photo receipt capture | 8 | 2 | 80% | 2 | 6.4 | Performance |
| 3 | Bank account auto-sync (Plaid) | 6 | 3 | 50% | 4 | 2.25 | Delighter |
| 4 | CSV export | 9 | 2 | 100% | 0.5 | 36.0 | Basic |
| 5 | Multi-currency support | 2 | 1 | 50% | 3 | 0.33 | Performance |
| 6 | Custom category creation | 7 | 1 | 80% | 1 | 5.6 | Performance |
| 7 | Recurring expense templates | 4 | 1 | 50% | 2 | 1.0 | Delighter |
| 8 | Team/multi-user accounts | 1 | 2 | 50% | 5 | 0.2 | Delighter |
| 9 | Push notifications for unlogged days | 6 | 1 | 50% | 1 | 3.0 | Performance |
| 10 | Tax-category auto-suggestion (ML) | 5 | 2 | 30% | 6 | 0.5 | Delighter |
| 11 | Dark mode | 5 | 0.5 | 100% | 0.5 | 5.0 | Delighter |
| 12 | PDF monthly report | 4 | 1 | 80% | 1.5 | 2.1 | Performance |
| 13 | Login / account creation | 10 | 3 | 100% | 1 | 30.0 | Basic |
| 14 | Password reset flow | 10 | 3 | 100% | 0.5 | 60.0 | Basic |

**MVP goal:** *Prove a solo freelancer will log expenses in LedgerLite daily for one full month instead of a spreadsheet.*

**Walking skeleton for that goal:** account creation → manual entry → CSV export (so the accountant workflow is still satisfied) → password reset (support-load safety net). That is items 13, 14, 1, 4.

**Cut decisions (effort budget: 6 weeks, Musts capped at ~60% = 3.6 weeks):**

| Feature | Decision | Rationale |
|---|---|---|
| Login / password reset | **Must** | Basic/threshold — app is unusable and unsafe (support burden) without it. |
| Manual expense entry | **Must** | Basic/threshold and the core walking-skeleton action. |
| CSV export | **Must** | Basic (accountants require it) and cheap (0.5 wk) for high impact. |
| Photo receipt capture | **Should** | Performance feature, high reach, but not required to validate the core loop; added if the Must budget (3.6 wk) leaves room — it does (used 2.5 of 3.6). |
| Custom categories | **Could** | Nice, cheap, but users can work with defaults for a 4-week trial. |
| Push notifications | **Could** | Improves retention but not needed to prove the core hypothesis. |
| Dark mode | **Won't (this release)** | Delighter, zero effect on the MVP goal; revisit once retention is proven. |
| Bank auto-sync | **Won't (this release)** | High potential impact but low confidence and high effort (4 wk) — blows the budget; flagged for v1.1 pending user demand signal from the MVP trial. |
| Multi-currency | **Won't (this release)** | Reach is too low (2) for target segment (freelancers, mostly single-currency). |
| Recurring templates | **Won't (this release)** | Delighter, defer until core loop validated. |
| Team accounts | **Won't (indefinitely for solo-user product)** | Out of product vision for this segment; not a sequencing cut, a scope cut. |
| Tax-category ML suggestion | **Won't (this release)** | Low confidence (30%), high effort (6 wk) — worst RICE score in the list. |
| PDF monthly report | **Could, deferred to v1.1** | Redundant with CSV export for MVP goal. |

**Result:** MVP = items 1, 4, 13, 14 (Musts, ~3 wk) + item 2 (Should, 2 wk) = 5 wk of a 6-wk budget, 1 wk buffer for QA/rollout. Cut list circulated to the founder and sales prospect with the table above; bank auto-sync explicitly flagged as "v1.1 candidate, contingent on MVP retention data."

## Common pitfalls

- **Scoring in isolation instead of against the MVP goal.** RICE numbers without a written single-sentence goal turn into a popularity contest; the highest-reach feature isn't always the one that proves the hypothesis.
- **Treating "Must" as "whatever the loudest stakeholder wants."** Without a hard effort cap on Musts, every requirement drifts into that bucket and the exercise produces no actual cuts.
- **Confusing a Kano basic feature with a Kano delighter because it's technically impressive.** Auto-sync feels delightful to build but if its absence doesn't cause outright rejection, it isn't a Must for v1.
- **Saying "no" instead of "not now."** A flat rejection makes stakeholders fight harder next time or route around the process; a dated/conditioned deferral preserves trust and gets easier buy-in.
- **Skipping written sign-off.** Verbal agreement on cuts evaporates the moment the sponsor sees a competitor ship the cut feature; a documented, dated cut list is your evidence the decision was made deliberately.
- **Building the skeleton's layers out of order.** Teams often build the most interesting layer first (e.g., the ML suggestion engine) instead of the thinnest full-stack slice, which delays proving the actual walking skeleton and hides integration risk until late.
- **Never revisiting scope.** Treating the first cut list as permanent even after velocity or usage data changes the picture wastes the entire point of an iterative MVP.

## Output

A single **MVP Scope Decision Document** containing: (1) the one-sentence MVP goal, (2) the full RICE/Kano-scored feature table, (3) the walking-skeleton diagram or description, (4) the final MoSCoW split with effort totals against budget, (5) a cut list with one-line rationale and re-consideration trigger per cut item, and (6) a sign-off block (name, role, date) from the requesting stakeholder(s).
