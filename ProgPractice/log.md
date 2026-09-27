# Журнал — Практикум по программированию (5 сем, ML)

Только дописывать вниз. Формат — в корневом CLAUDE.md.

## 2026-09-27 13:02 — папка создана
- Сделано: скачаны с wiki.pmifi.ru ЛР 1, шаблон `materials/template.ipynb`, 13 вариантов (`materials/variants/`) и датасетов (`materials/datasets/`), лекции 1–2 (`materials/lectures/`). Старые ЛР 6-го семестра → `materials/archive_2025-26_6sem/`.
- Решения: текущий семестр = ML-трек с вики (по методике 5 сем 2026/27).
- Дальше: выбрать вариант.

## 2026-09-27 13:21 — индекс материалов
- Сделано: текст всех PDF/DOCX/DOC → `materials/notes/`, оглавление `materials/INDEX.md` (файлы, сроки, критерии, карта по работам, страницы).
- Результат: таблица 13 вариантов (размер, задача, пропуски, формат, проблемы данных). Методы с пар: OneHotEncoder(drop='first'), IterativeImputer + NRMSE, missingno, scipy.
- Дальше: выбрать вариант.

## 2026-09-27 13:50 — окружение для проверки ноутбуков
- Сделано: `solution/requirements.txt` (библиотеки лекций 1–2 + jupyter, nbconvert, ipykernel); venv `%USERPROFILE%\.venvs\studies2026-progpractice`.
- Результат: pandas 2.3.3, scikit-learn 1.9.1, nbconvert 7.17.1; `python -m jupyter nbconvert --version` работает.
- Решения: pandas < 3 — ноутбуки лекций написаны под 2.x (на машине глобально 3.0.3). venv вне OneDrive, чтобы не синхронизировать тысячи файлов. Точные версии проекта всё равно фиксируются в ноутбуке через `pip list --format=freeze` (Лекция 1, ячейки 16–18).
- Дальше: выбрать вариант датасета, `/start-lab ProgPractice 1`.
