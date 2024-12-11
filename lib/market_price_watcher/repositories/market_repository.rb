require_relative 'common_crud_helper'

module MarketPriceWatcher
  module Repositories
    class MarketRepository < BaseRepository
      include MarketPriceWatcher::Repositories::CommonCrudHelper

      private def table_name = 'markets'
    end
  end
end