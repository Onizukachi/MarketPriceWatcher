module MarketPriceWatcher
  module DB
    module Mappers
      class ProductMapper < BaseMapper
        class << self
          def to_domain(entity)
            MarketPriceWatcher::Models::Product.new(
              entity['id'].to_i,
              entity['source_id'].to_i,
              entity['title'],
              entity['chat_id'].to_i,
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
