require_relative 'common_crud_helper'

module MarketPriceWatcher
  module Repositories
    class PriceHistoryRepository < BaseRepository
      include MarketPriceWatcher::Repositories::CommonCrudHelper

      def current_price(product_id)
        query = "SELECT * FROM #{table_name} WHERE product_id = $1 ORDER BY created_at DESC LIMIT 1"

        connection.exec_params(query, [product_id]).to_a.first
      end

      private def table_name = 'price_histories'
    end
  end
end