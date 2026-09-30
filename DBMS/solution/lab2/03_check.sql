SELECT c.relname AS table_name,
       obj_description(c.oid, 'pg_class') AS comment
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public' AND c.relkind = 'r'
ORDER BY c.relname;

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

SELECT conrelid::regclass AS table_name,
       conname AS constraint_name,
       contype AS type,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass::text, contype, conname;

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

BEGIN;

INSERT INTO teams VALUES (1, 'Ferrari', 'Маранелло'), (2, 'McLaren', 'Уокинг');
INSERT INTO cars VALUES (1, 'SF-24', 2024, 1), (2, 'MCL38', 2024, 2);
INSERT INTO drivers VALUES (1, 'Шарль Леклер', 'Монако', 1), (2, 'Ландо Норрис', 'Великобритания', 2);
INSERT INTO parts VALUES (1, 'Силовая установка 066/12', 'двигатель'), (2, 'Переднее антикрыло', 'аэродинамика'),
                         (3, 'Коробка передач', 'трансмиссия');
INSERT INTO car_parts VALUES (1, 1), (1, 2), (2, 2), (2, 3);
INSERT INTO sponsors VALUES (1, 'Aramco', 50000000.00);
INSERT INTO tracks VALUES (1, 'Монца', 'Италия', 5.793);
INSERT INTO races VALUES (1, 'Гран-при Италии', '2024-09-01', 1, 1);
INSERT INTO results VALUES (1, 1, 1, 1, 25), (1, 2, 2, 2, 18);

DO $$
BEGIN
    BEGIN
        INSERT INTO cars VALUES (3, 'X', 2024, 99);
        RAISE NOTICE 'FAIL: болид с несуществующей командой вставлен';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK  cars_FK: болид с несуществующей командой отклонён';
    END;
    BEGIN
        INSERT INTO car_parts VALUES (1, 1);
        RAISE NOTICE 'FAIL: дубль (car_ID, part_ID) вставлен';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'OK  car_parts_PK: повтор пары (car_ID, part_ID) отклонён';
    END;
    BEGIN
        INSERT INTO car_parts VALUES (1, 99);
        RAISE NOTICE 'FAIL: несуществующая запчасть привязана к болиду';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK  car_parts_FK2: несуществующая запчасть не привязана к болиду';
    END;
    BEGIN
        DELETE FROM parts WHERE part_ID = 2;
        RAISE NOTICE 'FAIL: установленная запчасть удалена';
    EXCEPTION WHEN foreign_key_violation OR restrict_violation THEN
        RAISE NOTICE 'OK  car_parts_FK2 RESTRICT: запчасть, установленная в болиды, не удалена';
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
        INSERT INTO results VALUES (1, 99, 1, 3, 15);
        RAISE NOTICE 'FAIL: результат несуществующего пилота вставлен';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK  results_FK2: результат несуществующего пилота отклонён';
    END;
    BEGIN
        UPDATE results SET position = 1 WHERE race_ID = 1 AND driver_ID = 2;
        RAISE NOTICE 'FAIL: второй пилот на 1-м месте записан';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'OK  results_position_UQ: второй пилот на том же месте гонки отклонён';
    END;
    BEGIN
        INSERT INTO results VALUES (1, 1, 1, 5, 10);
        RAISE NOTICE 'FAIL: второй результат пилота в гонке вставлен';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'OK  results_PK: второй результат пилота в одной гонке отклонён';
    END;
    BEGIN
        UPDATE results SET points = -1 WHERE race_ID = 1 AND driver_ID = 1;
        RAISE NOTICE 'FAIL: отрицательные очки записаны';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'OK  results_points_CHK: отрицательные очки отклонены';
    END;
    BEGIN
        DELETE FROM tracks WHERE track_ID = 1;
        RAISE NOTICE 'FAIL: трасса с гонками удалена';
    EXCEPTION WHEN foreign_key_violation OR restrict_violation THEN
        RAISE NOTICE 'OK  races_FK1 RESTRICT: трасса, на которой есть гонки, не удалена';
    END;
    BEGIN
        DELETE FROM sponsors WHERE sponsor_ID = 1;
        RAISE NOTICE 'FAIL: спонсор гонки удалён';
    EXCEPTION WHEN foreign_key_violation OR restrict_violation THEN
        RAISE NOTICE 'OK  races_FK2 RESTRICT: спонсор, у которого есть гонки, не удалён';
    END;
END $$;

UPDATE teams SET team_ID = 10 WHERE team_ID = 1;
SELECT 'после UPDATE teams 1 -> 10' AS step, car_ID, team_ID FROM cars ORDER BY car_ID;

DELETE FROM teams WHERE team_ID = 10;
SELECT 'после DELETE команды 10' AS step,
       (SELECT count(*) FROM cars) AS cars,
       (SELECT count(*) FROM drivers) AS drivers,
       (SELECT count(*) FROM car_parts) AS car_parts,
       (SELECT count(*) FROM results) AS results,
       (SELECT count(*) FROM parts) AS parts;

ROLLBACK;
