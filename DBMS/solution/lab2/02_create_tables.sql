-- ЛР 2. Создание и связывание таблиц базы данных formula1
-- Выполнять, подключившись к базе formula1 (pgAdmin: Query Tool на базе formula1).
-- Образец: пособие, ЛР 3, стр. 76–80. Как в образце, в CREATE TABLE заданы только
-- NOT NULL и PRIMARY KEY, остальные ограничения добавляются отдельными ALTER TABLE.

-------------------------------------------
-- Создание таблицы teams (Команды)
-------------------------------------------
CREATE TABLE teams (
    team_ID integer NOT NULL,
    name varchar(100) NOT NULL,
    base varchar(100) NOT NULL,
    CONSTRAINT teams_PK PRIMARY KEY (team_ID)
);

-------------------------------------------
-- Создание таблицы cars (Болиды)
-------------------------------------------
CREATE TABLE cars (
    car_ID integer NOT NULL,
    model varchar(50) NOT NULL,
    year integer NOT NULL,
    team_ID integer NOT NULL,
    CONSTRAINT cars_PK PRIMARY KEY (car_ID)
);

-------------------------------------------
-- Создание таблицы drivers (Пилоты)
-------------------------------------------
CREATE TABLE drivers (
    driver_ID integer NOT NULL,
    name varchar(100) NOT NULL,
    country varchar(50) NOT NULL,
    team_ID integer NOT NULL,
    CONSTRAINT drivers_PK PRIMARY KEY (driver_ID)
);

-------------------------------------------
-- Создание таблицы parts (Запчасти)
-- Зависимая сущность: идентифицирующая связь с cars,
-- поэтому car_ID входит в составной первичный ключ.
-------------------------------------------
CREATE TABLE parts (
    car_ID integer NOT NULL,
    part_ID integer NOT NULL,
    name varchar(100) NOT NULL,
    type varchar(50) NOT NULL,
    CONSTRAINT parts_PK PRIMARY KEY (car_ID, part_ID)
);

-------------------------------------------
-- Создание таблицы sponsors (Спонсоры)
-------------------------------------------
CREATE TABLE sponsors (
    sponsor_ID integer NOT NULL,
    name varchar(100) NOT NULL,
    budget numeric(12,2) NOT NULL,
    CONSTRAINT sponsors_PK PRIMARY KEY (sponsor_ID)
);

-------------------------------------------
-- Создание таблицы tracks (Трассы)
-------------------------------------------
CREATE TABLE tracks (
    track_ID integer NOT NULL,
    name varchar(100) NOT NULL,
    country varchar(50) NOT NULL,
    length_km numeric(5,3) NOT NULL,
    CONSTRAINT tracks_PK PRIMARY KEY (track_ID)
);

-------------------------------------------
-- Создание таблицы races (Гонки)
-------------------------------------------
CREATE TABLE races (
    race_ID integer NOT NULL,
    name varchar(100) NOT NULL,
    date date NOT NULL,
    track_ID integer NOT NULL,
    sponsor_ID integer NOT NULL,
    CONSTRAINT races_PK PRIMARY KEY (race_ID)
);

-------------------------------------------
-- Определение внешних ключей
-------------------------------------------
ALTER TABLE cars
ADD CONSTRAINT cars_FK FOREIGN KEY (team_ID)
REFERENCES teams (team_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE drivers
ADD CONSTRAINT drivers_FK FOREIGN KEY (team_ID)
REFERENCES teams (team_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE parts
ADD CONSTRAINT parts_FK FOREIGN KEY (car_ID)
REFERENCES cars (car_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE races
ADD CONSTRAINT races_FK1 FOREIGN KEY (track_ID)
REFERENCES tracks (track_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE races
ADD CONSTRAINT races_FK2 FOREIGN KEY (sponsor_ID)
REFERENCES sponsors (sponsor_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-------------------------------------------
-- Ограничения уникальности (потенциальные ключи)
-------------------------------------------
ALTER TABLE teams ADD CONSTRAINT teams_name_UQ UNIQUE (name);
ALTER TABLE sponsors ADD CONSTRAINT sponsors_name_UQ UNIQUE (name);
ALTER TABLE tracks ADD CONSTRAINT tracks_name_UQ UNIQUE (name);

-------------------------------------------
-- Ограничения проверки
-------------------------------------------
ALTER TABLE cars ADD CONSTRAINT cars_year_CHK CHECK (year BETWEEN 1950 AND 2100);
ALTER TABLE sponsors ADD CONSTRAINT sponsors_budget_CHK CHECK (budget >= 0);
ALTER TABLE tracks ADD CONSTRAINT tracks_length_CHK CHECK (length_km > 0);

-------------------------------------------
-- Индексы на внешние ключи
-- PRIMARY KEY и UNIQUE создают индексы автоматически (стр. 72),
-- FOREIGN KEY — нет (стр. 73). parts.car_ID уже покрыт индексом parts_PK.
-------------------------------------------
CREATE INDEX cars_team_IDX ON cars (team_ID);
CREATE INDEX drivers_team_IDX ON drivers (team_ID);
CREATE INDEX races_track_IDX ON races (track_ID);
CREATE INDEX races_sponsor_IDX ON races (sponsor_ID);

-------------------------------------------
-- Комментарии к таблицам
-------------------------------------------
COMMENT ON TABLE teams IS 'Команды';
COMMENT ON TABLE cars IS 'Болиды';
COMMENT ON TABLE drivers IS 'Пилоты';
COMMENT ON TABLE parts IS 'Запчасти';
COMMENT ON TABLE sponsors IS 'Спонсоры';
COMMENT ON TABLE tracks IS 'Трассы';
COMMENT ON TABLE races IS 'Гонки';
