-- 3. Создание таблицы истории цен
CREATE TABLE IF NOT EXISTS price_history (
                                        id SERIAL PRIMARY KEY,
                                        product_id BIGINT NOT NULL,
                                        price BIGINT NOT NULL,
                                        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                                        FOREIGN KEY (product_id) REFERENCES products(id)
);