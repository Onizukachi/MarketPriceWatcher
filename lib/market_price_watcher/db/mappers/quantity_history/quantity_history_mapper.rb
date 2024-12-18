module MarketPriceWatcher
  module DB
    module Mappers
      class QuantityHistoryMapper < BaseMapper
        class << self
          def to_domain(entity)
            MarketPriceWatcher::Models::QuantityHistory.new(
              entity['product_id'].to_i,
              entity['quantity'].to_i
            )
          end
        end
      end
    end
  end
end
