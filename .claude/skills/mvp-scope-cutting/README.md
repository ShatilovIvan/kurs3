# mvp-scope-cutting

A Claude Code skill that turns an unbounded feature wishlist into a shippable MVP with documented, defensible cuts. It combines RICE scoring, the Kano model, and the walking-skeleton technique, then applies a hard-budgeted MoSCoW pass so "Must have" stays meaningful instead of becoming a synonym for "everything."

Most MVP scoping fails not because teams lack technique but because no one writes down *why* a feature was cut, so the same argument replays at every planning meeting. This skill produces a single artifact — a scoring table, a walking-skeleton description, and a rationale-backed cut list — that a team can point to instead of re-litigating scope from memory.

## Who it helps

- **Developers** get a scoped, sequenced backlog instead of an ambiguous "build all of this eventually" list, so they know which slice to build first and why the rest is explicitly out of scope for now.
- **Tech leads** get a walking-skeleton definition that forces the team to prove the architecture end-to-end early, surfacing integration risk before it's buried under feature work.
- **Engineering managers** get a written, stakeholder-signed cut list they can use to push back on scope creep and to show leadership that deferred features were a deliberate, revisitable decision — not an oversight.

## How it helps

- Replaces gut-feel prioritization with a repeatable RICE + Kano scoring pass.
- Forces a single, falsifiable MVP goal sentence before any feature gets cut, so decisions are judged against a real target.
- Produces a walking-skeleton slice that de-risks architecture early instead of late.
- Caps "Must have" effort at a realistic budget so the MoSCoW pass yields real trade-offs.
- Converts every cut into a "not now" with a re-consideration trigger, preserving stakeholder trust.
- Ends with a written, sign-off-ready decision document instead of a verbal agreement that evaporates later.

## How to use it as a Claude Code skill

Copy the folder into your project's skills directory:

```
cp -r sdlc-requirements-skills/skills/mvp-scope-cutting .claude/skills/mvp-scope-cutting
```

Or add this repo as a plugin marketplace source and install the skill by name.

## Download just this skill (sparse checkout)

```
git clone --depth 1 --filter=blob:none --sparse https://github.com/anilamar/sdlc-requirements-skills.git
cd sdlc-requirements-skills
git sparse-checkout set skills/mvp-scope-cutting
```
