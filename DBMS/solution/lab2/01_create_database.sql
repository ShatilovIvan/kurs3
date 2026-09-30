-- ЛР 2. Создание новой базы данных formula1
-- Выполнять, подключившись к базе postgres (pgAdmin: Query Tool на базе postgres).
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

COMMENT ON DATABASE formula1
    IS 'База данных чемпионата «Формула-1»: команды, болиды, запчасти, пилоты, спонсоры, трассы и гонки';
