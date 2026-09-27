# requirements-gap-analysis

A Claude Code skill that structures a rigorous comparison of current-state vs. desired-state to surface exactly which capabilities, processes, or data are missing before a project gets scoped — instead of discovering the gaps one at a time, mid-sprint, as blockers.

Most "requirements gaps" aren't discovered during requirements gathering; they're discovered during implementation, when an engineer says "we don't have that data" or "that workflow doesn't exist." This skill front-loads that discovery: it forces the current state to be verified (not assumed), categorizes each gap by type (capability, process, data, performance, compliance), and scores impact/effort so gaps get prioritized instead of tackled in the order they're found.

## Who it helps

- **Developers** get a verified, categorized list of what's actually missing before they start building, instead of surfacing "wait, this doesn't exist" as a mid-sprint surprise that derails a story's estimate.
- **Tech leads** get a tool for scoping conversations — a gap analysis table makes it easy to push back on an unscoped PRD by pointing at specific unverified assumptions, and to sequence work correctly when one gap blocks another (e.g., a data gap that must close before a capability can be built on top of it).
- **Engineering managers** get a prioritized, owned artifact for planning and stakeholder communication — "we are N gaps away from X, here they are, here's who owns each, here's what's accepted risk" is a much stronger status update than a vague completion percentage.

## How it helps

- Forces current-state claims to be verified against the real system, not recalled from memory.
- Categorizes each gap by type so the right owner (data team, process owner, compliance) gets assigned automatically.
- Scores impact and effort so gaps get worked in priority order, not discovery order.
- Surfaces dependencies between gaps so remediation is sequenced correctly instead of causing rework.
- Provides an explicit "accepted, won't fix" status so deprioritized gaps don't silently become assumed commitments.
- Produces a table that traces directly into backlog tickets/epics for full requirements traceability.

## How to use it as a Claude Code skill

Copy the folder into your project:

```
cp -r /path/to/sdlc-requirements-skills/skills/requirements-gap-analysis .claude/skills/requirements-gap-analysis
```

Or add this repo as a plugin marketplace source and install the skill by name.

## Download just this skill (sparse checkout)

```
git clone --depth 1 --filter=blob:none --sparse https://github.com/anilamar/sdlc-requirements-skills.git
cd sdlc-requirements-skills
git sparse-checkout set skills/requirements-gap-analysis
```
