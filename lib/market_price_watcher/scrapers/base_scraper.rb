module MarketPriceWatcher
  module Scrapers
    class BaseScraper
      include MarketPriceWatcher::Network::Connection

      attr_reader :url

      def initialize(url)
        @url = URI.parse(url)
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

      private

      def query_hash
        Hash[URI.decode_www_form(url.query)]
      end
    end
  end
end
