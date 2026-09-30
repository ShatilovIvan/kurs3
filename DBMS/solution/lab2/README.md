# ЛР 2. Создание БД, таблиц, определение индексов и связей в PostgreSQL

Предметная область — чемпионат «Формула-1» (модель данных из ЛР 1, draw.io: IDEF1X, Crow's Foot, физическая схема).
Методика: ЛР 2 «Создание БД, таблиц, определение индексов и связей в PostgreSQL» = пособие ЛР 2 (стр. 64–69) + ЛР 3 (стр. 70–80).

## Файлы

| Файл | Что делает | Где выполнять |
|---|---|---|
| `01_create_database.sql` | `CREATE DATABASE formula1` по образцу стр. 69 — единственная команда в файле | pgAdmin → Query Tool на базе `postgres` |
| `02_create_tables.sql` | 8 таблиц (`CREATE TABLE` c NOT NULL и PK), затем `ALTER TABLE`: 6 внешних ключей, 3 UNIQUE, 3 CHECK; 5 индексов на внешние ключи; комментарии к базе и таблицам | pgAdmin → Query Tool на базе `formula1` |
| `03_check.sql` | Проверка: список таблиц, полей, ограничений, индексов; тест ограничений на данных внутри транзакции с `ROLLBACK` (база остаётся пустой) | Query Tool на базе `formula1` |
| `check_output.txt` | Вывод `03_check.sql` на PostgreSQL 15 | — |
| `build_report.py` | Сборка `report.docx` (вставляет скриншоты из `img/`, если они есть) | `python build_report.py` |
| `report.docx` | Отчёт | — |

## Таблицы

| Таблица (сущность ЛР 1) | Первичный ключ | Внешние ключи | Прочие ограничения |
|---|---|---|---|
| `teams` (Команды) | `team_ID` | — | `name` UNIQUE |
| `cars` (Болиды) | `car_ID` | `team_ID` → `teams` CASCADE/CASCADE | `year` 1950–2100 |
| `drivers` (Пилоты) | `driver_ID` | `team_ID` → `teams` CASCADE/CASCADE | — |
| `parts` (Запчасти) | `part_ID` | — | — |
| `car_parts` (Запчасти болидов, связь M:N) | `(car_ID, part_ID)` | `car_ID` → `cars` CASCADE/CASCADE; `part_ID` → `parts` ON DELETE RESTRICT, ON UPDATE CASCADE | индекс `car_parts_part_IDX` |
| `sponsors` (Спонсоры) | `sponsor_ID` | — | `name` UNIQUE, `budget` ≥ 0 |
| `tracks` (Трассы) | `track_ID` | — | `name` UNIQUE, `length_km` > 0 |
| `races` (Гонки) | `race_ID` | `track_ID` → `tracks`, `sponsor_ID` → `sponsors`: ON DELETE RESTRICT, ON UPDATE CASCADE | — |

## Запуск в pgAdmin (Windows, как в пособии)

1. Query Tool на базе `postgres` → открыть `01_create_database.sql` → Execute (F5). В файле только `CREATE DATABASE`: pgAdmin выполняет несколько команд одной транзакцией, а `CREATE DATABASE` в транзакции запрещён (`ERROR: CREATE DATABASE cannot run inside a transaction block`, SQLSTATE 25001). Поэтому `COMMENT ON DATABASE` перенесён в `02_create_tables.sql`.
2. В браузере pgAdmin: Refresh на Databases → появится `formula1`.
3. Query Tool на базе `formula1` → `02_create_tables.sql` → F5.
4. Refresh на `formula1 → Schemas → public → Tables` — 8 таблиц.
5. Query Tool на базе `formula1` → `03_check.sql` → F5 (вкладки Messages и Data Output).
6. Tools → ERD Tool → ERD for Database на `formula1` (стр. 80, рис. 21).

Локаль `Russian_Russia.1251` в `01_create_database.sql` — как в образце, она есть только в Windows. В Linux/Docker её нет, поэтому при проверке подставляется локаль сервера.

## Проверка запуском (Docker, PostgreSQL 15)

```bash
docker start dbms-pg   # или: docker run -d --name dbms-pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:15
docker exec dbms-pg psql -U postgres -c "DROP DATABASE IF EXISTS formula1"
sed 's/Russian_Russia\.1251/en_US.utf8/' DBMS/solution/lab2/01_create_database.sql | docker exec -i dbms-pg psql -U postgres -v ON_ERROR_STOP=1
docker exec -i dbms-pg psql -U postgres -d formula1 -v ON_ERROR_STOP=1 < DBMS/solution/lab2/02_create_tables.sql
docker exec -i dbms-pg psql -U postgres -d formula1 -v ON_ERROR_STOP=1 < DBMS/solution/lab2/03_check.sql
```

## Скриншоты для отчёта (`img/`)

Сняты на тестовом стенде (PostgreSQL 15 + pgAdmin 4 в Docker, Linux), поэтому на `01_database.png` локаль `en_US.utf8`. Если преподаватель требует скриншоты со своего компьютера — снять те же экраны в своём pgAdmin, сохранить под теми же именами и выполнить `python build_report.py`.

| Файл | Что на нём | Как получить в pgAdmin |
|---|---|---|
| `01_database.png` | база `formula1` в браузере, вкладка SQL | выделить `formula1` → вкладка SQL |
| `02_tables.png` | 8 таблиц с комментариями | `formula1 → Schemas → public → Tables` → вкладка Properties |
| `03_constraints.png` | `cars`: PK, FK, CHECK, индекс | раскрыть `cars → Constraints, Indexes`, выделить `cars` → вкладка SQL |
| `07_parts_pk.png` | `car_parts`: составной PK и FK на `cars` и `parts` | то же для `car_parts` |
| `04_indexes.png` | `races`: два FK с RESTRICT и два индекса | то же для `races` |
| `05_check_messages.png` | строки `OK ...` и `ROLLBACK` | Query Tool на `formula1` → открыть `03_check.sql` → F5 → вкладка Messages |
| `06_erd.png` | ER-диаграмма | ПКМ на `formula1` → ERD For Database |
