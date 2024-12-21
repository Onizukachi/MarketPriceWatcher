# frozen_string_literal: true

module MarketPriceWatcher
  module DB
    module Mappers
      class PriceHistoryMapper < BaseMapper
        class << self
          def to_domain(entity)
            MarketPriceWatcher::Models::PriceHistory.new(
              entity["product_id"].to_i,
              entity["price"].to_i
            )
          end
        end
      end
    end
  end
end
