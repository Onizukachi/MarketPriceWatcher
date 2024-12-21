# frozen_string_literal: true

module MarketPriceWatcher
  module Utils
    class UrlValidator
      class << self
        WB_PATTERN = %r{^https://www.wildberries.ru/catalog/\d+/detail}
        OZON_PATTERN = %r{^https://www.ozon.ru/product}

        def valid?(url)
          [WB_PATTERN, OZON_PATTERN].any? { |pattern| url =~ pattern }
        end
      end
    end
  end
end
