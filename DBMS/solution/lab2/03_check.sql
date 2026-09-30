-- ЛР 2. Проверка структуры базы данных formula1
-- Выполнять, подключившись к базе formula1, после 02_create_tables.sql.
-- Данные в конце вставляются внутри транзакции и откатываются (ROLLBACK):
-- база остаётся пустой, заполнение — предмет ЛР 3.

-- 1. Таблицы и комментарии
SELECT c.relname AS table_name,
       obj_description(c.oid, 'pg_class') AS comment
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public' AND c.relkind = 'r'
ORDER BY c.relname;

-- 2. Поля, типы и NOT NULL
SELECT table_name, column_name,
       CASE WHEN character_maximum_length IS NOT NULL
            THEN data_type || '(' || character_maximum_length || ')'
            WHEN data_type = 'numeric'
            THEN data_type || '(' || numeric_precision || ',' || numeric_scale || ')'
            ELSE data_type END AS type,
       is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 3. Ограничения целостности (p — PK, f — FK, u — UNIQUE, c — CHECK)
--    Для FK: действия ON UPDATE / ON DELETE (c — CASCADE, r — RESTRICT)
SELECT conrelid::regclass AS table_name,
       conname AS constraint_name,
       contype AS type,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, contype, conname;

-- 4. Индексы (автоматические для PK/UNIQUE и созданные вручную)
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- 5. Проверка ограничений на тестовых данных
BEGIN;

INSERT INTO teams VALUES (1, 'Ferrari', 'Маранелло'), (2, 'McLaren', 'Уокинг');
INSERT INTO cars VALUES (1, 'SF-24', 2024, 1), (2, 'MCL38', 2024, 2);
INSERT INTO drivers VALUES (1, 'Шарль Леклер', 'Монако', 1), (2, 'Ландо Норрис', 'Великобритания', 2);
INSERT INTO parts VALUES (1, 1, 'Силовая установка 066/12', 'двигатель'), (1, 2, 'Переднее антикрыло', 'аэродинамика'),
                         (2, 1, 'Коробка передач', 'трансмиссия');
INSERT INTO sponsors VALUES (1, 'Aramco', 50000000.00);
INSERT INTO tracks VALUES (1, 'Монца', 'Италия', 5.793);
INSERT INTO races VALUES (1, 'Гран-при Италии', '2024-09-01', 1, 1);

DO $$
BEGIN
    BEGIN
        INSERT INTO cars VALUES (3, 'X', 2024, 99);
        RAISE NOTICE 'FAIL: болид с несуществующей командой вставлен';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK  cars_FK: болид с несуществующей командой отклонён';
    END;
    BEGIN
        INSERT INTO parts VALUES (1, 1, 'Дубль', 'двигатель');
        RAISE NOTICE 'FAIL: дубль (car_ID, part_ID) вставлен';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'OK  parts_PK: повтор пары (car_ID, part_ID) отклонён';
    END;
    BEGIN
        INSERT INTO teams VALUES (3, 'Ferrari', 'Рим');
        RAISE NOTICE 'FAIL: дубль названия команды вставлен';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'OK  teams_name_UQ: повтор названия команды отклонён';
    END;
    BEGIN
        INSERT INTO cars VALUES (3, 'X', 1900, 1);
        RAISE NOTICE 'FAIL: болид 1900 года вставлен';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'OK  cars_year_CHK: год 1900 отклонён';
    END;
    BEGIN
        INSERT INTO tracks VALUES (2, 'Пустая', 'Нигде', 0);
        RAISE NOTICE 'FAIL: трасса длиной 0 км вставлена';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'OK  tracks_length_CHK: длина 0 км отклонена';
    END;
    BEGIN
        INSERT INTO sponsors VALUES (2, 'Банкрот', -1);
        RAISE NOTICE 'FAIL: отрицательный бюджет вставлен';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'OK  sponsors_budget_CHK: отрицательный бюджет отклонён';
    END;
    BEGIN
        INSERT INTO drivers VALUES (3, NULL, 'Италия', 1);
        RAISE NOTICE 'FAIL: пилот без имени вставлен';
    EXCEPTION WHEN not_null_violation THEN
        RAISE NOTICE 'OK  NOT NULL: пилот без имени отклонён';
    END;
    BEGIN
        DELETE FROM tracks WHERE track_ID = 1;
        RAISE NOTICE 'FAIL: трасса с гонками удалена';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK  races_FK1 RESTRICT: трасса, на которой есть гонки, не удалена';
    END;
    BEGIN
        DELETE FROM sponsors WHERE sponsor_ID = 1;
        RAISE NOTICE 'FAIL: спонсор гонки удалён';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK  races_FK2 RESTRICT: спонсор, у которого есть гонки, не удалён';
    END;
END $$;

-- ON UPDATE CASCADE: новый team_ID команды переходит в болиды и пилотов
UPDATE teams SET team_ID = 10 WHERE team_ID = 1;
SELECT 'после UPDATE teams 1 -> 10' AS step, car_ID, team_ID FROM cars ORDER BY car_ID;

-- ON DELETE CASCADE: удаление команды удаляет её болиды, пилотов и запчасти болидов
DELETE FROM teams WHERE team_ID = 10;
SELECT 'после DELETE команды 10' AS step,
       (SELECT count(*) FROM cars) AS cars,
       (SELECT count(*) FROM drivers) AS drivers,
       (SELECT count(*) FROM parts) AS parts;

ROLLBACK;
