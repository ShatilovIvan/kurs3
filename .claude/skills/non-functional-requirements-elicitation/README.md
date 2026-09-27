# Non-Functional Requirements Elicitation

A Claude Code skill that elicits and quantifies non-functional requirements — performance, availability, security, scalability, usability, maintainability, compatibility, and compliance — using an ISO/IEC 25010-style quality-attribute checklist. It converts vague stakeholder statements like "fast" or "secure" into measurable SLOs with real numbers, percentiles, units, and a verification method.

Functional requirements describe what a system does; non-functional requirements describe whether it survives contact with real load, real attackers, and real audits. NFRs are the requirements most often skipped during elicitation because nobody asks about them directly — this skill makes asking about every quality attribute a deliberate, repeatable step instead of an afterthought discovered during an incident review.

## Who it helps

- **Developers** get a concrete performance/availability/security target to design against instead of an unstated assumption they have to guess and later defend during a post-incident review.
- **Tech leads** get a structured way to surface NFR conflicts (e.g., data-retention limits for privacy vs. audit-trail retention requirements) and force an explicit, documented resolution before implementation starts.
- **Managers** get NFRs attached to specific features/epics with a stated verification method, so capacity planning, load-testing schedules, and compliance audits can be planned against real numbers instead of discovered as unplanned work later.

## How it helps

- Walks all eight ISO/IEC 25010 quality-attribute categories systematically, instead of asking one open-ended "any non-functional requirements?" question that reliably gets "no."
- Uses concrete-incident questions ("tell me about your worst Black Friday," "tell me about the last outage") to extract real numbers instead of adjectives.
- Forces every NFR to state an enforcement/verification mechanism (load test, penetration test, accessibility audit, monitoring alert) — an NFR nobody can verify isn't really a requirement.
- Surfaces and documents conflicts between NFRs with an explicit resolution and priority, rather than letting the conflict stay implicit until it causes an outage or audit failure.

## How to use it as a Claude Code skill

Copy the folder into your project's skills directory:

```
cp -r sdlc-requirements-skills/skills/non-functional-requirements-elicitation .claude/skills/non-functional-requirements-elicitation
```

Or add this repo as a plugin marketplace source and install the skill by name.

## Download just this skill (sparse checkout)

If you don't want to clone the whole repository, use git sparse-checkout to pull down only this skill's folder:

```
git clone --depth 1 --filter=blob:none --sparse https://github.com/anilamar/sdlc-requirements-skills.git
cd sdlc-requirements-skills
git sparse-checkout set skills/non-functional-requirements-elicitation
```
