module MarketPriceWatcher
  class UrlValidator
    class << self
      WB_PATTERN = /^https:\/\/www.wildberries.ru\/catalog\/\d+\/detail/
      OZON_PATTERN = /^https:\/\/www.ozon.ru\/product/

      def valid?(url)
        [WB_PATTERN, OZON_PATTERN].any? { |pattern| url =~ pattern }
      end
    end
  end
end
