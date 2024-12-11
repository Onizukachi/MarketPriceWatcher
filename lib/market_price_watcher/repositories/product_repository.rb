require_relative 'common_crud_helper'

module MarketPriceWatcher
  module Repositories
    class ProductRepository < BaseRepository
      include MarketPriceWatcher::Repositories::CommonCrudHelper

      private def table_name = 'products'
    end
  end
end