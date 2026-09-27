# Estimation from Requirements

A Claude Code skill that derives effort and time estimates directly from a requirements document — decomposing it into estimable units, applying a consistent estimation technique, and explicitly surfacing uncertainty, hidden work, and assumptions instead of producing a single confident-sounding number.

A gut-feel estimate given in a meeting has a way of becoming a promise, regardless of how many caveats surrounded it verbally. This skill exists to make estimates traceable back to specific requirements and stated assumptions, so when reality diverges, it's clear exactly which assumption broke rather than a vague "estimates are always wrong."

## Who it helps

- **Developers** get an estimation process that captures hidden work (testing, review, deployment) that's otherwise silently absorbed as unpaid overtime when it's left out of "the feature" estimate.
- **Tech leads** get a decomposed, assumption-tagged estimate they can defend and revise when a stakeholder pushes on the date, instead of a single number with no visible reasoning behind it.
- **Engineering managers** get comparable, range-based estimates across requirement sets for roadmap sequencing and capacity planning, plus a documented re-estimation trigger when requirements change.

## How it helps

- Forces requirements to be decomposable and clear before they're estimated, catching vague requirements before they produce a vague number.
- Presents estimates as ranges tied to confidence classification, resisting the false precision of a single point number.
- Separates effort uncertainty from calendar-affecting dependencies, so a blocked third-party access request isn't confused with the engineering work itself taking longer.
- Links directly to `requirement-change-impact-analysis` to keep estimates current as scope changes, instead of letting them quietly go stale.

## How to use it as a Claude Code skill

Copy the folder into your project's skills directory:

```
cp -r sdlc-requirements-skills/skills/estimation-from-requirements .claude/skills/estimation-from-requirements
```

Or add this repo as a plugin marketplace source and install the skill by name.

## Download just this skill (sparse checkout)

If you don't want to clone the whole repository, use git sparse-checkout to pull down only this skill's folder:

```
git clone --depth 1 --filter=blob:none --sparse https://github.com/anilamar/sdlc-requirements-skills.git
cd sdlc-requirements-skills
git sparse-checkout set skills/estimation-from-requirements
```
