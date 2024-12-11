require_relative 'common_crud_helper'

module MarketPriceWatcher
  module Repositories
    class PriceHistoryRepository < BaseRepository
      include MarketPriceWatcher::Repositories::CommonCrudHelper

      private def table_name = 'price_histories'
    end
  end
end