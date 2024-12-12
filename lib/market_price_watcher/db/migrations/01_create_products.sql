-- 1. Создание таблицы продуктов
CREATE TABLE IF NOT EXISTS products (
                                        id BIGINT PRIMARY KEY,
                                        title TEXT NOT NULL,
                                        chat_id BIGINT NOT NULL,
                                        market TEXT NOT NULL,
                                        source_url TEXT NOT NULL,
                                        created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS unique_products_index ON products (id, chat_id, market);