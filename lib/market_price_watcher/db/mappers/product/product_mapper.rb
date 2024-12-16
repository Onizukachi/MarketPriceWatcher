module MarketPriceWatcher
  module DB
    module Mappers
      class ProductMapper < BaseMapper
        class << self
          def to_domain(entity)
            MarketPriceWatcher::Models::Product.new(
              entity['id'],
              entity['title'],
              entity['chat_id'],
              entity['market'],
              entity['source_url'],
              Time.parse(entity['created_at'])
            )
          end
        end
      end
    end
  end
end
