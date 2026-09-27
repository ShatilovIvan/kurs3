---
name: stakeholder-interview-guide
description: "Plans, runs, and documents structured stakeholder interviews to elicit software requirements, using stakeholder-type question banks and tacit-need-surfacing techniques, then converts raw interview notes into traceable draft requirements. Use at project kickoff, before writing a PRD or backlog, or whenever a requirement's origin or rationale is unclear."
---

**Purpose:** Turn unstructured conversations with stakeholders into a documented, traceable set of draft requirements, by asking the right questions of the right people and capturing answers in a form that survives the trip from "what someone said" to "what gets built."

## When to use this

- Kicking off a new project or major feature and there is no requirements document yet, only a one-line ask from a sponsor ("we need a self-service returns portal").
- A backlog is full of stories that contradict each other, suggesting nobody interviewed the operations/support team who actually deals with the exceptions.
- A stakeholder keeps rejecting delivered work with "that's not what I meant" — a sign the original ask was never decomposed into verifiable requirements.
- Before writing a PRD, functional spec, or set of user stories, when you need source material grounded in what stakeholders actually said (not what the team assumed).
- Compliance, security, or legal has a veto over a feature and their constraints have never been formally captured.
- Onboarding a new team member or vendor who needs the "why" behind existing requirements, not just the "what."

## Workflow

1. **Identify stakeholder types and map them to concerns.** At minimum classify each person as one of: Executive Sponsor (owns budget/strategic outcome), End User (uses the system daily), Operations/Support (handles exceptions, escalations, data cleanup), Compliance/Legal (owns regulatory or contractual constraints). The same person can wear more than one hat — capture that explicitly.
2. **Prepare a tailored question bank per stakeholder type** (see banks below). Send a short pre-read 1-2 days ahead: purpose of the interview, expected duration (45-60 min), and 2-3 questions to think about in advance. Never send the full question list — it invites rehearsed, generic answers.
3. **Set an agenda for the session**: context/purpose (5 min), open-ended exploration (20 min), targeted follow-ups using tacit-need techniques (15 min), recap and next steps (5 min). Always end by restating what you heard and asking "did I get that right?"
4. **Take notes in two columns during the interview**: left column = verbatim or near-verbatim quotes/observations, right column = your interpretation left blank until after the session. Mixing interpretation into raw notes is the single biggest cause of misremembered requirements.
5. **Apply tacit-need-surfacing techniques** during the session (see below) whenever an answer is vague, procedural ("that's just how we do it"), or emotionally charged (frustration, a sigh, "don't get me started").
6. **Within 24 hours, convert notes into draft requirement statements.** Each draft requirement must cite the stakeholder and interview date as its source. Flag conflicts between stakeholders instead of silently resolving them.
7. **Circulate the draft requirements to the interviewee for confirmation** ("Read-back") before treating them as settled. This catches transcription errors and gives the stakeholder a chance to correct scope creep in either direction.
8. **Maintain an interview log** (date, stakeholder, role, key themes, linked draft requirement IDs) so later work can trace any requirement back to its origin — this is also the seed of a requirements traceability matrix (see the `requirements-traceability-matrix` skill).

## Question banks by stakeholder type

**Executive Sponsor** — probing strategic intent and success measures:
- "If this project succeeds, what changes in the business six months from now? How will you know?"
- "What's the cost of doing nothing — what happens if we don't build this?"
- "Who else needs to say yes before this ships, and what would make them say no?"
- "What's explicitly out of scope, even if it sounds related?"
- "What's the one thing that, if we got it wrong, would make this a failure regardless of anything else we got right?"

**End User** — probing actual daily workflow, not the idealized one:
- "Walk me through the last time you did this task, step by step, exactly as it happened — including anything that went wrong."
- "What do you do today when [the system] can't handle a situation?" (surfaces workarounds)
- "What's the most annoying part of your current process, even if it seems minor?"
- "Show me, don't tell me" — ask to screen-share or demonstrate the current process live.
- "If you could wave a wand and change one thing tomorrow, what would it be?"

**Operations/Support** — probing exceptions, volume, and failure modes:
- "What are the top 3 reasons a ticket gets escalated related to this process?"
- "What percentage of cases are 'the happy path,' and what does the rest look like?"
- "What manual workaround exists today, and who maintains the spreadsheet/script that isn't supposed to exist?"
- "What's the oldest unresolved complaint about this area, and why hasn't it been fixed?"
- "If volume tripled overnight, what would break first?"

**Compliance/Legal** — probing hard constraints, not preferences:
- "What regulation, contract clause, or policy governs this process, and can you point me to the specific text?"
- "What data can we NOT store, NOT combine, or NOT retain past a certain period?"
- "What's the audit evidence a regulator or auditor would ask for regarding this feature?"
- "Is there a precedent — a past incident or finding — that shapes what you'll require here?"
- "Who has final sign-off authority, and is it a hard gate or an advisory review?"

## Techniques for surfacing tacit/unstated needs

- **Laddering ("why" chains)**: repeatedly ask "why is that important?" or "why does that matter to you?" 3-5 times to move from a stated preference ("I want a dashboard") to the underlying need ("I need to know before my VP asks me").
- **Five Whys**: same mechanism applied specifically to problems/pain points, to get from symptom to root cause rather than requirements-gathering a workaround.
- **Critical Incident Technique**: ask the stakeholder to recall one specific recent incident in vivid detail ("tell me about the last time this went wrong") rather than speaking in generalities — generalities hide requirements, specific incidents reveal them.
- **Observing workarounds**: ask what spreadsheet, sticky note, email chain, or shadow process exists alongside the "official" system — these are usually undocumented requirements the system fails to meet.
- **Contrastive questioning**: "what's different about the cases that go smoothly versus the ones that don't?" surfaces implicit business rules nobody thought to state.
- **Silence**: after asking an open question, wait. The first answer is often the rehearsed one; the second answer (after a pause) is often the real one.

## Worked example

**Fictional product:** ClaimsFlow, an insurance claims-processing system. Sponsor asked for "a faster claims intake process."

**Interview with End User (Claims Adjuster, Maria):**
> Q: "Walk me through the last claim you processed, step by step."
> Maria: "Okay, so I got an auto claim Tuesday. First I check if the policy is even active — I have to open a second system for that because it doesn't show here. Then I look for prior claims on the same VIN, because if there were three in the last year, it goes to the fraud team automatically... except the system doesn't flag that, I just know to check because I've been doing this two years. New hires miss it constantly."

Two-column notes:
| Raw note (verbatim) | Interpretation (added after) |
|---|---|
| "have to open a second system to check policy status" | Missing integration: policy status check |
| "I just know to check [prior claims] because I've been doing this two years, new hires miss it" | Undocumented business rule: 3+ prior claims on same VIN in 12 months → auto-route to fraud review. Currently tribal knowledge, not enforced by system. |

Draft requirements produced (source-tagged):
- **DR-014** (source: Maria, Claims Adjuster, interview 2026-03-02): "System shall display current policy active/inactive status inline on the claim intake screen, without requiring a separate system lookup."
- **DR-015** (source: Maria, Claims Adjuster, interview 2026-03-02): "System shall automatically flag a claim for fraud review when 3 or more claims exist against the same VIN within the trailing 12 months, rather than relying on adjuster memory."

These get circulated back to Maria for read-back confirmation, then feed into the `user-story-writing` skill to become backlog items.

## Common pitfalls

- **Interviewing only management, not end users or ops/support.** Executives describe the desired outcome; only the people doing the work know the actual failure modes and workarounds. Skipping them produces a system that looks right on a slide and fails on day one.
- **Writing requirements during the interview instead of after.** Premature formalization anchors the conversation on your phrasing instead of the stakeholder's actual meaning, and causes you to miss follow-up threads while you're busy wordsmithing.
- **Accepting the first answer to a "why" as final.** The first answer is usually a restatement of the request, not the underlying need. Stopping after one "why" bakes assumptions into requirements that no one actually validated.
- **Leading questions that presuppose a solution.** Asking "would you like a dashboard that shows X?" gets a polite "yes" regardless of actual need; ask "how do you currently find out X?" instead.
- **No read-back / confirmation step.** Without circulating draft requirements back to the source, transcription and interpretation errors silently become "requirements," and stakeholders discover the mismatch only after delivery.
- **Losing the source attribution.** If a draft requirement can't be traced back to who said it and when, it becomes nearly impossible to resolve later conflicts or to know whom to ask when the requirement seems wrong.
- **Treating compliance/legal interviews as optional or informal.** Hard regulatory constraints discovered late in a project (or after launch) are far more expensive to fix than a feature request discovered late.

## Output

This skill produces:
1. An **interview plan** per stakeholder (pre-read, tailored question list, agenda).
2. A **two-column interview notes document** per session (verbatim/observed vs. interpretation).
3. A set of **source-tagged draft requirement statements** (ID, requirement text, source stakeholder, interview date, status: draft/confirmed/conflicting), ready to be confirmed via read-back and then handed to the `user-story-writing` or `functional-spec-from-user-stories` skills.
4. An **interview log** entry (stakeholder, role, date, themes, linked draft requirement IDs) suitable as the first rows of a requirements traceability matrix.
