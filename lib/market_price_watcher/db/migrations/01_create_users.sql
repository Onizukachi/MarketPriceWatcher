-- 1. Создание таблицы пользователей
CREATE TABLE IF NOT EXISTS users (
                                     id SERIAL PRIMARY KEY,
                                     chat_id BIGINT NOT NULL UNIQUE,
                                     first_name TEXT,
                                     last_name TEXT
);