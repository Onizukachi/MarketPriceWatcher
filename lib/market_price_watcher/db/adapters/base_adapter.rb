# frozen_string_literal: true

module MarketPriceWatcher
  module DB
    module Adapters
      class BaseAdapter
        def connection
          raise NotImplementedError
        end

        def close
          raise NotImplementedError
        end
      end
    end
  end
end
