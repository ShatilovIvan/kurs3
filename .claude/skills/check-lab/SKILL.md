---
name: check-lab
description: Skeptic check of a lab by a fresh-context agent. Mode `plan` attacks «Карта ЛР N» before work starts (missing requirements, wrong sources, invented scope, ambiguity, traps). Mode `solution` checks the finished lab before status `готова` (acceptance criteria, correctness by running it, course fit, formatting, defense pre-mortem). Use on /check-lab, before starting a lab, before marking it `готова`, or when the user asks "проверь ЛР", "готова ли к сдаче", "что спросят на защите".
---

# /check-lab

ORCHESTRATOR. One skeptic subagent with fresh context — it did not do the work, so it
does not share the worker's blind spots.

## Invocation
```
/check-lab <Предмет> <N>            # mode auto: no solution/labN yet → plan, else solution
/check-lab <Предмет> <N> plan
/check-lab <Предмет> <N> solution
```
`<Предмет>` — folder name (ProgPractice, SE, DBMS, WebDev, …), case-insensitive.

## Steps
1. **Resolve** folder, N, mode. Precondition: `progress.md` has block «Карта ЛР N».
   Missing → build it first (CLAUDE.md «Материалы», rule 2), then continue.
2. **Spawn 1 agent** (`Agent`, `general-purpose`, foreground). Prompt:
   > Answer in Russian, TERSE. Read `.claude/agents/lab-skeptic.md` and follow it exactly.
   > Subject folder: `<Предмет>/`. Lab: N. Mode: <mode>.
   Pass nothing else from this conversation (except the previous findings on a re-run) —
   the fresh view is the point.
3. **Report** to the user: verdict, HIGH findings first, then MED; defense questions
   without answers; `questions_to_user`. LOW — count only unless asked.
4. **Record** (one log entry = one commit, per CLAUDE.md):
   - `progress.md`: block «Проверка ЛР N (<mode>, <date>)» — verdict + unresolved
     HIGH/MED as checkboxes; `questions_to_user` → «Открытые вопросы».
   - `log.md`: entry «ЛР N: проверка скептиком (<mode>)» — verdict, counts, top findings.
   - Commit `docs(<scope>): skeptic check lab N (<mode>): <verdict>`.
5. **Route:**
   - `сдавать` / `начинать` → solution: status may go to `готова`; plan: start work.
   - `доработать` → fix findings, then re-run `/check-lab` (same mode).
   - `блок` → do not proceed; show the blocking finding, ask the user.

## Rules
- The skeptic's verdict is gating for status `готова`: no `сдавать` — no `готова`.
- Do not argue findings away in the report. Disagree → say so separately with a reason;
  the user decides.
- Re-runs after fixes: pass the previous findings list so the skeptic verifies each fix.
