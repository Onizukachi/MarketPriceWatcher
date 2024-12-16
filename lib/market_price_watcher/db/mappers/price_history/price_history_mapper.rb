module MarketPriceWatcher
  module DB
    module Mappers
      class PriceHistoryMapper < BaseMapper
        class << self
          def to_domain(entity)
            MarketPriceWatcher::Models::PriceHistory.new(
              entity['product_id'],
              entity['price']
            )
          end
        end
      end
    end
  end
end
