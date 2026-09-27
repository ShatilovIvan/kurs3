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
2. **Spawn 1 debugger** (`Agent`, `subagent_type: debugger`; if absent from the agent list —
   `general-purpose` with «Read `.claude/agents/debugger.md` and follow it exactly»). Prompt:
   > Answer TERSE. Symptom: <verbatim error / failing test>. Lab folder: <path>.
3. **Report** the debugger's return verbatim: root cause, evidence, fix, and the
   re-run output.
4. **Route the outcome:**
   - `fixed` → record in `<Предмет>/log.md` (CLAUDE.md format): symptom, root cause,
     fix, `why_for_student` under «Решения» — the teacher may ask about it. Commit
     `fix(<scope>): <root cause>`.
   - Notebook / SQL / HTML without tests: a minimal repro script or cell in `$TMP` is
     enough — do not add a test framework to the lab.
   - `root_cause_found` (found but not fixed) or `stuck` → show the hypothesis ladder;
     the user decides the fix.
   - `cannot_reproduce` → ask the user for exact repro steps; do not guess-patch.
