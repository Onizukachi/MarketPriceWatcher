require_relative '../common_sql_crud_impl'

module MarketPriceWatcher
  module DB
    module Repositories
      class QuantityHistoryRepository < BaseRepository
        include MarketPriceWatcher::DB::Repositories::CommonSQLCrudImpl

        def current_quantity(product_id)
          query = "SELECT * FROM #{table_name} WHERE product_id = $1 ORDER BY created_at DESC LIMIT 1"

          entity = connection.exec_params(query, [product_id]).to_a.first

          mapper.to_domain(entity)
        end

        private

        def table_name
          'quantity_history'
        end

        def connection
          db_adapter.connection
        end
      end
    end
  end
end
