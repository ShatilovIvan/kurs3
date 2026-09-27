---
name: debug
description: Find the root cause of a bug, failing test, or broken notebook cell in a lab solution. Spawns 1 debugger subagent that reproduces, ladders hypotheses, isolates with evidence, and applies the minimal fix. Use when a test fails, code throws, or "X stopped working". Does NOT design features.
---

# Skill: /debug

ORCHESTRATOR. One debugger subagent. It diagnoses before it touches anything.

## Invocation
`/debug "<error text / failing test / what broke>"`

## Steps
1. **Gather the symptom**: error / stack trace / failing test name / notebook cell, and which
   lab it belongs to (`<Subject>/solution/...`).
2. **Spawn 1 debugger** (`Agent`, `general-purpose`). Prompt:
   > Answer TERSE. Read `.claude/agents/debugger.md` and follow it exactly.
   > Symptom: <verbatim error / failing test>. Lab folder: <path>.
3. **Report** the debugger's return verbatim: root cause, evidence, fix, and the
   re-run output.
4. **Route the outcome:**
   - `fixed` → done; offer to explain the cause (student must be able to defend it).
   - `root_cause_found` (found but not fixed) or `stuck` → show the hypothesis ladder;
     the user decides the fix.
   - `cannot_reproduce` → ask the user for exact repro steps; do not guess-patch.
