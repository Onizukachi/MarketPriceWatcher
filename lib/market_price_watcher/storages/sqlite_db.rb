require 'sqlite3'

module MarketPriceWatcher
  module Storages
    class SqliteDB < BaseStorage
      DB_NAME = 'market_price_watcher'.freeze

      attr_reader :db

      def initialize
        create_database
        run_migrations
      end

      def list_products(chat_id)
        db.query("SELECT * FROM products INNER JOIN users on products.user_id = users.id WHERE users.chat_id = ?", [chat_id])
      end

      def insert_product(chat_id, product)
        user = db.get_first_row("SELECT id FROM users WHERE chat_id = ?", [chat_id])
        raise "User not found" unless user

        db.execute <<~SQL, [product[:title], product[:market_id], product[:source_id], product[:source_url], user[:id]]
          INSERT INTO products (title, market_id, source_id, source_url, user_id)
          VALUES (?, ?, ?, ?, ?)
        SQL
      end

      def close
        db.close
      end

      private

      def create_database
        @db = SQLite3::Database.new(DB_NAME)
        @db.results_as_hash = true
      end

      def run_migrations
        db.transaction do
          create_users_table
          create_markets_table
          create_products_table
          create_price_history_table
          add_markets
        end
      end

      def create_users_table
        db.execute <<~SQL
          CREATE TABLE IF NOT EXISTS users(
            id INTEGER NOT NULL PRIMARY KEY,
            chat_id INTEGER NOT NULL UNIQUE,
            first_name TEXT,
            last_name TEXT
          )
        SQL
      end

      def create_markets_table
        db.execute <<~SQL
          CREATE TABLE IF NOT EXISTS markets(
            id INTEGER NOT NULL PRIMARY KEY,
            title TEXT NOT NULL UNIQUE
          )
        SQL
      end

      def create_products_table
        db.execute <<~SQL
          CREATE TABLE IF NOT EXISTS products(
            id INTEGER NOT NULL PRIMARY KEY,
            title TEXT NOT NULL,
            user_id INTEGER NOT NULL,
            market_id INTEGER NOT NULL,
            source_id INTEGER NOT NULL UNIQUE, 
            source_url TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (market_id) REFERENCES markets(id) ON DELETE CASCADE
          )
        SQL
      end

      def create_price_history_table
        db.execute <<~SQL
          CREATE TABLE IF NOT EXISTS price_history(
            id INTEGER NOT NULL PRIMARY KEY,
            product_id INTEGER NOT NULL,
            price INTEGER NOT NULL,
            created_at TIMESTAMP NOT NULL,
            FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
          )
        SQL
      end

      def add_markets
        MarketPriceWatcher.config.markets.each do |market|
          db.execute "INSERT OR IGNORE INTO markets (title) VALUES (?)", market
        end
      end
    end
  end
end
