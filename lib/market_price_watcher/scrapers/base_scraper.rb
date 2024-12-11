module MarketPriceWatcher
  module Scrapers
    class Scraper
      def get_product_details
        raise NotImplementedError, 'This method should be implemented in a subclass'
      end
    end
  end
end
