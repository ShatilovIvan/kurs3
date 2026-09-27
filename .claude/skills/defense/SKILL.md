---
name: defense
description: Defense rehearsal for a lab — ask the student questions one at a time, grade each answer against the solution and materials, list what to re-learn. Use only on /defense or when the user asks "потренируй защиту", "погоняй по вопросам ЛР N".
---

# /defense

Checks that the **student** can explain the lab, not the agent. Russian, one question per
message, wait for the answer.

## Invocation
```
/defense <Предмет> <N> [число вопросов, по умолчанию 7]
```

## Steps
1. **Read** «Карта ЛР N» and the last «Проверка ЛР N (solution)» block in `progress.md`,
   `log.md` entries for ЛР N (the «Решения» lines), the solution in `solution/labN/`.
2. **Questions**: start with `defense_questions` from the last skeptic check, then add from
   the solution itself — why this method / parameter / notation, what this number means,
   what if the data changed, where the requirement comes from (source + page), terms from
   the lectures. Mix easy and hard. Do not show the list in advance.
3. **Loop**: ask one question → wait → grade `верно` / `частично` / `неверно` with a short
   reason and the correct answer grounded in the solution / materials (quote file and page).
   Do not accept «ну, так принято» — ask «почему?» once.
4. **Summary**: score, weak topics, what to reread (notes file + page, notebook cell).
5. **Record**: `progress.md` — block «Защита ЛР N: тренировка (<date>)» with weak topics as
   checkboxes; `log.md` entry with the score. Commit `docs(<scope>): lab N defense rehearsal`.
