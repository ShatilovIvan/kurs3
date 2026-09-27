---
name: ambiguity-detection-in-requirements
description: "Scans a requirements or spec document for ambiguity smells (weak words, vague quantifiers, unresolved pronouns, missing thresholds, passive voice hiding the actor) and rewrites each finding as a specific, testable requirement. Use before a spec is marked 'final,' before handing requirements to QA for test-case authoring, or whenever a requirement has caused a dev/QA/product disagreement about what 'done' means."
---

**Purpose:** Find the sentences in a requirements document that sound complete but cannot be turned into a pass/fail test case, and rewrite them so they can be.

## When to use this

- A requirements or PRD document is about to be marked "final" or sent for stakeholder sign-off.
- QA is about to write test cases against a spec and keeps asking "but what does 'fast' mean here?" or "what should happen if both conditions are true?"
- A bug was filed as "not a bug, working as specified" but the spec text is genuinely open to both readings — a symptom that the requirement itself was ambiguous, not just the implementation.
- A requirement has already caused a dev/product disagreement in a standup or PR review about what the acceptance criteria actually mean.
- You're reviewing a legacy or third-party requirements document before using it as the basis for new implementation work.
- An acceptance criteria list uses words like "should," "as needed," "etc.," or "user-friendly" and nobody has pinned down what those resolve to.

## Ambiguity smell checklist

Scan every requirement sentence against these patterns:

1. **Weak/subjective modifiers** — "should," "may," "fast," "user-friendly," "appropriate," "robust," "efficient," "easy," "seamless," "modern," "intuitive," "reasonable," "reliable." These describe a feeling, not a measurable behavior.
2. **Vague quantifiers and open-ended lists** — "etc.," "and/or," "some," "several," "as needed," "as appropriate," "support multiple formats," "various." Every one of these hides an unspecified boundary.
3. **Unresolved pronouns** — "it," "they," "this," "that" where the antecedent is genuinely unclear or could refer to more than one prior noun in the sentence.
4. **Missing units, thresholds, or ranges** — "fast response" instead of "responds within 200ms at p95 under 100 concurrent users"; "large file" instead of "files up to 25MB."
5. **Passive voice hiding the actor and timing** — "the data will be validated" (by whom? client-side, server-side, both? at what point in the flow?). Passive voice is a strong predictor of an unspecified responsibility.
6. **Undefined terms and unexplained acronyms** — domain jargon or internal shorthand ("the record must be reconciled," "apply the standard markup") used without a definition anywhere in the document.
7. **Conjunction/disjunction ambiguity** — "valid if A and B or C" without parentheses; readers will disagree on whether it's `A and (B or C)` or `(A and B) or C`.
8. **Open TBD/placeholder text left in a "final" document** — "TBD," "TODO," "[confirm with legal]," "tbc" that never got resolved before sign-off.
9. **Implicit negative-space gaps** — the requirement describes the happy path only, with no stated behavior for empty input, timeout, permission denial, or concurrent edits.

## Workflow

1. **Read the document once for content, not ambiguity**, to understand overall intent before critiquing individual sentences.
2. **Second pass: tag every sentence** that matches one or more smells above. For each, record: location (section/line), the exact text, the smell category, and a severity (High = blocks writing a test case at all; Medium = test case possible but assumptions required; Low = stylistic, unlikely to cause disagreement).
3. **For every High and Medium finding, draft a rewritten version** that states actor, condition, measurable threshold, and expected outcome explicitly. Prefer a structured form such as EARS ("While `<precondition>`, when `<trigger>`, the `<system>` shall `<response>` within `<constraint>`") when the original requirement is behavioral.
4. **Apply the testability check** to every rewrite: could two independent engineers write the same automated test case from this sentence alone, with no side conversation? If not, it's still ambiguous — iterate.
5. **Flag unresolved ambiguities you can't rewrite alone** (usually because the threshold is a business decision, not a wording problem) as open questions with a named owner and due date, rather than guessing a number.
6. **Compile the ambiguity report** (see template below) and route it back to the requirement's author for confirmation before the rewrites are adopted as the new source of truth.
7. **Re-scan after edits.** A rewrite sometimes introduces a new smell (e.g., fixing "fast" with a number but leaving "the system" undefined when there are three subsystems) — one more pass catches these.

## Worked example

Fictional context: a requirements doc for **StayEasy**, a hotel booking system, "Search & Booking" section.

| # | Original text | Ambiguity type | Why it's a problem | Rewritten version |
|---|---|---|---|---|
| 1 | "The system should return search results quickly." | Weak modifier, missing threshold | "Quickly" has no measurable definition; can't write a performance test. | "The system shall return search results within 1.5 seconds at p95 for queries covering up to 500 properties." |
| 2 | "Users can filter by price, rating, and/or amenities." | Vague conjunction ("and/or") | Unclear whether filters combine with AND or OR logic when multiple are selected. | "When a user selects more than one filter category (price, rating, amenities), the system shall apply AND logic across categories and OR logic within a category's selected values (e.g., rating ≥4 AND (Wi-Fi OR Pool))." |
| 3 | "If a room becomes unavailable, it will be handled appropriately." | Weak modifier ("appropriately"), unresolved pronoun ("it") | No definition of what "handled" means or what "it" refers to (the room? the booking attempt? the user session?). | "If a room becomes unavailable between search and payment confirmation, the system shall reject the booking attempt, display 'This room was just booked by another guest,' and re-run the search with the same filters within 500ms." |
| 4 | "The booking confirmation email will be sent." | Passive voice, missing timing/actor | Doesn't say when, from what service, or what happens on failure. | "Upon successful payment capture, the Booking Service shall trigger a confirmation email via the Notification Service within 30 seconds; if delivery fails, the system shall retry twice at 5-minute intervals and log a delivery-failure event." |
| 5 | "Supported payment methods include credit card, etc." | Open-ended list ("etc.") | "Etc." leaves the actual supported set undefined — dev doesn't know if PayPal, Apple Pay, or bank transfer are in scope. | "Supported payment methods are: Visa, Mastercard, American Express, and Apple Pay. No other payment methods are supported in this release." |
| 6 | "Cancellations should be processed in a reasonable time frame." | Weak modifier, missing threshold | "Reasonable" is unenforceable and untestable. | "Cancellation requests shall be processed and refund-eligibility determined within 24 hours of submission; the refund itself shall be issued to the original payment method within 5 business days per the payment processor's SLA." |
| 7 | "The admin dashboard displays relevant booking data as needed." | Vague quantifier ("as needed"), weak modifier ("relevant") | No defined field list, no defined trigger for when data appears. | "The admin dashboard shall display, for each active booking: guest name, room number, check-in/check-out dates, payment status, and special requests, refreshed every 60 seconds." |

## Common pitfalls

- **Rewriting style without adding a measurable threshold.** Replacing "fast" with "quick" fixes nothing — the rewrite must add a number, an actor, or an explicit boundary, not just a synonym.
- **Guessing the threshold yourself instead of flagging it as an open question.** Business-critical numbers (refund windows, SLA times, retry counts) are decisions, not wording fixes — invented numbers create false confidence and can contradict a contract or legal requirement.
- **Only scanning for individual weak words and missing structural ambiguity.** Conjunction/disjunction ambiguity and unresolved pronouns often hide inside otherwise "clean" sentences with no obviously weak word present.
- **Treating a low-severity stylistic issue the same as a high-severity blocking one.** Without severity tagging, review time gets spent bikeshedding wording instead of fixing the handful of genuinely dangerous ambiguities.
- **Fixing the happy path and leaving negative-space gaps unaddressed.** A beautifully specific requirement for the success case with no stated behavior for failure/timeout/empty-input is still ambiguous in the ways that generate the most production bugs.
- **Sending the rewritten document back without traceability to the original.** If reviewers can't see original-text-versus-rewrite side by side, they can't efficiently confirm intent was preserved, and sign-off gets slower or rubber-stamped.

## Output

An **Ambiguity Report**: a table of (location, original text, ambiguity type, severity, why it's a problem, rewritten version, status: resolved/open question + owner), plus a clean rewritten version of the full requirements section incorporating all resolved rewrites, ready for re-review and sign-off.
