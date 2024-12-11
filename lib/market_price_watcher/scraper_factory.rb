module MarketPriceWatcher
  class ScraperFactory
    def self.create(url)
      case url
      when /wildberries/
        MarketPriceWatcher::Scrapers::WbScraper.new(url)
      when /ozon/
        MarketPriceWatcher::Scrapers::OzonScraper.new(url)
      end
    end
  end
end
