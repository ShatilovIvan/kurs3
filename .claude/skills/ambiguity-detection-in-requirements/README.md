# Ambiguity Detection in Requirements

A Claude Code skill that scans a requirements or spec document for ambiguity smells — weak modifiers ("fast," "user-friendly"), vague quantifiers ("etc.," "as needed"), unresolved pronouns, missing thresholds, passive voice hiding the actor, and undefined terms — and rewrites each finding into a specific, testable requirement with a documented severity and status.

Ambiguous requirements are one of the most expensive defects in software: they pass every review because they read as complete sentences, then cause a dev/QA/product disagreement the moment someone tries to write a test case or an acceptance check against them. This skill turns that disagreement into a structured, repeatable review pass performed before sign-off instead of during a heated PR conversation.

## Who it helps

- **Developers** get requirements they can actually implement against without guessing at thresholds — no more silent assumptions about what "fast" or "reasonable" means that later get relitigated in code review.
- **Tech leads** get a defensible, documented way to push back on vague specs before estimation and sprint planning, instead of discovering the ambiguity mid-sprint when it's expensive to renegotiate.
- **Managers** get a severity-tagged report that shows exactly which open questions are blocking sign-off and who owns resolving each one, so schedule risk from unclear requirements is visible instead of hidden inside a PRD everyone assumed was final.

## How it helps

- Applies a consistent 9-point ambiguity-smell checklist instead of relying on one reviewer's instinct for "something feels off here."
- Converts vague adjectives into numbers, actors, and thresholds using a testability check: could two engineers write the same automated test from this sentence alone?
- Distinguishes business-decision gaps (flag as an open question with an owner) from wording problems (rewrite directly), so nobody invents a compliance number that should have been a stakeholder decision.
- Produces a before/after ambiguity report that's easy to route back to the original author for fast confirmation.

## How to use it as a Claude Code skill

Copy the folder into your project's skills directory:

```
cp -r sdlc-requirements-skills/skills/ambiguity-detection-in-requirements .claude/skills/ambiguity-detection-in-requirements
```

Or add this repo as a plugin marketplace source and install the skill by name.

## Download just this skill (sparse checkout)

If you don't want to clone the whole repository, use git sparse-checkout to pull down only this skill's folder:

```
git clone --depth 1 --filter=blob:none --sparse https://github.com/anilamar/sdlc-requirements-skills.git
cd sdlc-requirements-skills
git sparse-checkout set skills/ambiguity-detection-in-requirements
```
