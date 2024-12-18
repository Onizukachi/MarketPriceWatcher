-- 3. Creating a table of the history of balances by quantity
CREATE TABLE IF NOT EXISTS quantity_history (
                                               id SERIAL PRIMARY KEY,
                                               product_id BIGINT NOT NULL,
                                               quantity BIGINT NOT NULL,
                                               created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                                               FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Index to speed up queries by product_id
CREATE INDEX IF NOT EXISTS idx_quantity_history_product_id ON quantity_history (product_id);