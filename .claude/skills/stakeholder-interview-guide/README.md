# Stakeholder Interview Guide

A Claude Code skill that plans, runs, and documents structured stakeholder interviews for eliciting software requirements. It supplies question banks tailored to four common stakeholder types (executive sponsor, end user, operations/support, compliance/legal), techniques for surfacing needs stakeholders don't naturally articulate (laddering, five whys, critical incident technique, workaround observation), and a repeatable process for converting raw interview notes into source-tagged draft requirements.

Most requirements gaps trace back to an interview that never happened, or one that only asked leading questions of the loudest person in the room. This skill exists to make requirements elicitation a deliberate, repeatable practice instead of an improvised conversation — so the resulting requirements are grounded in what stakeholders actually said, and traceable back to them when questions come up later.

## Who it helps

- **Developers** get requirements with a documented rationale attached, so when a spec seems to conflict with an obvious technical shortcut, they can see *why* a rule exists (e.g., "adjuster said new hires miss this fraud check") instead of guessing whether it's safe to simplify.
- **Tech leads** get a defensible source of truth to point to during scope debates — instead of "the PM said so," they can cite a specific stakeholder, quote, and date, which shortens arguments about what was actually asked for.
- **Engineering managers** get an auditable trail from business need to backlog item, which is invaluable when a stakeholder disputes priorities, when planning capacity around compliance-mandated work, or when onboarding new team members who need the "why" behind long-standing requirements.

## How it helps

- Prevents "requirements" that are really just one executive's guess at what users need, by structurally requiring end-user and ops/support interviews.
- Surfaces tribal-knowledge business rules (workarounds, undocumented exception handling) before they become production incidents.
- Produces requirements with built-in source attribution, which is the first input to a requirements traceability matrix.
- Reduces re-work caused by "that's not what I meant," via a mandatory read-back/confirmation step.
- Gives less-experienced interviewers a concrete question bank and technique list instead of starting from a blank page.

## How to use it as a Claude Code skill

Copy the folder into your project's skills directory:

```
cp -r sdlc-requirements-skills/skills/stakeholder-interview-guide .claude/skills/stakeholder-interview-guide
```

Or add this repo as a plugin marketplace source and install the skill by name.

## Download just this skill (sparse checkout)

If you don't want to clone the whole repository, use git sparse-checkout to pull down only this skill's folder:

```
git clone --depth 1 --filter=blob:none --sparse https://github.com/anilamar/sdlc-requirements-skills.git
cd sdlc-requirements-skills
git sparse-checkout set skills/stakeholder-interview-guide
```
