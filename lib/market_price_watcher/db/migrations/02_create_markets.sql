-- 2. Создание таблицы маркетов
CREATE TABLE IF NOT EXISTS markets (
                                       id SERIAL PRIMARY KEY,
                                       title TEXT NOT NULL UNIQUE
);