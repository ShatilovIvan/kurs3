---
name: start-lab
description: Start a lab — build «Карта ЛР N» in `<Предмет>/progress.md` from materials (INDEX → notes → task.md), then run /check-lab plan. Use on /start-lab, or when the user says "начнём ЛР N", "делаем лабу N по <предмету>".
---

# /start-lab

Builds the lab map by one fixed procedure (CLAUDE.md «Материалы», rules 1–8, and «Цикл ЛР»),
so it looks the same after every `/clear`.

## Invocation
```
/start-lab <Предмет> <N>
```
`<Предмет>` — folder name, case-insensitive.

## Steps
1. **Read** `<Предмет>/task.md`, `<Предмет>/progress.md`, `<Предмет>/materials/INDEX.md`.
   - Task text for ЛР N missing in `task.md` and INDEX → stop, add to «Открытые вопросы»,
     ask the user for the text / screenshot (rule 8: do not invent the task).
   - Variant not chosen and the lab depends on it → ask the user first.
2. **Collect sources** by INDEX: the rows for ЛР N (lab text, methodics, template, example,
   lectures, textbook pages). Grep `materials/notes/` for the needed pages — do not read whole
   files, do not open originals unless a picture/table is needed.
3. **Write «Карта ЛР N»** into `progress.md` by the template in CLAUDE.md «Цикл ЛР»:
   - every requirement and criterion as a checkbox with its source and page;
   - «Делает студент руками» — every step in a GUI tool (Visual Paradigm, ELMA, Rose,
     IDEF1X editor, screenshots) with the tool and screenshot file name; none → «нет»;
   - «Отчёт» — whether the lab is submitted as a document, template, title page (ФИТ-242);
   - «Проверка запуском» — the command from CLAUDE.md «Окружение» (check the venv / Docker
     exists; missing → write the setup command into «Следующий шаг»);
   - «Вне курса» — topics absent from materials that will need general knowledge.
   Source conflicts → do not choose, add to «Открытые вопросы» and ask.
4. **Update** `progress.md`: ЛР N status `в работе`, «Текущий фокус», «Следующий шаг»
   (= `/check-lab <Предмет> N plan`). Append `log.md` entry «ЛР N: карта». Commit
   `docs(<scope>): lab N map`.
5. **Run** `/check-lab <Предмет> N plan` (skill `check-lab`) and follow its routing.
