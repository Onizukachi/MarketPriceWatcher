require_relative 'common_crud_helper'

module MarketPriceWatcher
  module Repositories
    class UserRepository < BaseRepository
      include MarketPriceWatcher::Repositories::CommonCrudHelper

      private def table_name = 'users'
    end
  end
end