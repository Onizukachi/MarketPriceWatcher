-- 1. Creating a product table
CREATE TABLE IF NOT EXISTS products (
                                        id SERIAL PRIMARY KEY,
                                        source_id BIGINT NOT NULL,
                                        title TEXT NOT NULL,
                                        chat_id BIGINT NOT NULL,
                                        market TEXT NOT NULL,
                                        source_url TEXT NOT NULL,
                                        created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- An index for the uniqueness of added products within a single chat
CREATE UNIQUE INDEX IF NOT EXISTS unique_products_index ON products (source_id, chat_id, market);