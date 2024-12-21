# frozen_string_literal: true

require_relative "../common_sql_crud_impl"

module MarketPriceWatcher
  module DB
    module Repositories
      class ProductRepository < BaseRepository
        include MarketPriceWatcher::DB::Repositories::CommonSQLCrudImpl

        private

        def table_name
          "products"
        end

        def connection
          db_adapter.connection
        end
      end
    end
  end
end
