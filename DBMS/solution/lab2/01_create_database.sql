-- ЛР 2. Создание новой базы данных formula1
-- Выполнять, подключившись к базе postgres (pgAdmin: Query Tool на базе postgres).
-- В файле только одна команда: pgAdmin выполняет несколько команд одной транзакцией,
-- а CREATE DATABASE внутри транзакции запрещён (SQLSTATE 25001). Комментарий к базе
-- задаётся в начале 02_create_tables.sql.
-- Образец: пособие, ЛР 2, стр. 69.

-- Database: formula1

-- DROP DATABASE IF EXISTS formula1;

CREATE DATABASE formula1
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
