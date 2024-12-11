-- 3. Создание таблицы продуктов
CREATE TABLE IF NOT EXISTS products (
                                        id SERIAL PRIMARY KEY,
                                        title TEXT NOT NULL,
                                        user_id INTEGER NOT NULL,
                                        market_id INTEGER NOT NULL,
                                        source_id BIGINT NOT NULL UNIQUE,
                                        source_url TEXT NOT NULL,
                                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                                        FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE CASCADE
);