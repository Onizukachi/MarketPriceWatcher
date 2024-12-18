-- 2. Creating a price history table
CREATE TABLE IF NOT EXISTS price_history (
                                        id SERIAL PRIMARY KEY,
                                        product_id BIGINT NOT NULL,
                                        price BIGINT NOT NULL,
                                        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                                        FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Index to speed up queries by product_id
CREATE INDEX IF NOT EXISTS idx_price_history_product_id ON price_history (product_id);