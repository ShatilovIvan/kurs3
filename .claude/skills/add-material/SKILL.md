---
name: add-material
description: Register a new course material (PDF, DOCX, DOC, notebook, dataset, screenshot of a task) in a subject — extract text to materials/notes/, add a row to materials/INDEX.md, log, commit. Use on /add-material, or when the user drops a new file into materials/ or says "добавил методичку / задание".
---

# /add-material

CLAUDE.md «Материалы», rule 10, as one fixed procedure.

## Invocation
```
/add-material <Предмет> <путь к файлу>
```
The file may be outside the repo — then copy it into `<Предмет>/materials/` (subfolder by
kind: `lectures/`, `datasets/`, `variants/`, or the root). Keep the original file name.

## Steps
1. **Extract text** into `<Предмет>/materials/notes/<имя без расширения>.md`:
   - PDF — `pypdf`, page by page, marker `<!-- стр. N -->` before each page;
   - DOCX — `python .claude/scripts/docx2txt.py <файл> <notes/…md>`;
   - DOC — `antiword -m UTF-8.txt <файл>`;
   - `.ipynb` — do not copy; list cells (markdown headings, imports) via `json` in INDEX;
   - datasets — no notes; in INDEX: size, separator, encoding, target, share of NaN;
   - image of a task (screenshot) — transcribe the text into `task.md` word for word.
   Empty or garbled text (scan) → say so in INDEX, do not guess the content.
2. **INDEX.md** — a row in «Файлы»: file, notes link, what is inside, when needed. Deadlines,
   points, criteria, variants → into their INDEX sections with page references. Contradicts an
   existing source → «Замечания» + «Открытые вопросы» in `progress.md`.
3. **task.md** — if the file contains a lab text / variant / deadline, add it (with source).
4. **Record**: `log.md` entry «материалы: <что>» (what was added, what is new in it);
   `progress.md` — update «Следующий шаг» / «Открытые вопросы» if they changed.
5. **Commit** the file, notes, INDEX, task/log/progress:
   `docs(<scope>): add <what>`. `git add` exact paths.
