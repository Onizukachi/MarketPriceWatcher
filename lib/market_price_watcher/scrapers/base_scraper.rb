module MarketPriceWatcher
  module Scrapers
    class BaseScraper
      include MarketPriceWatcher::Network::Connection

      attr_reader :url

      def initialize(url)
        @url = url #  URI.parse(url)
      end

      def fetch_product_details
        raise 'Not implemented'
      end

      def product_id
        raise 'Not implemented'
      end

      def market
        raise 'Not implemented'
      end
    end
  end
end
