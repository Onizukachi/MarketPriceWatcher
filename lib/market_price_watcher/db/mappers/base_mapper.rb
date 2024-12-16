module MarketPriceWatcher
  module DB
    module Mappers
      class BaseMapper
        class << self
          def to_domain(entity)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
