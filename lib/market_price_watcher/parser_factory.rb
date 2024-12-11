module MarketPriceWatcher
  class ParserFactory
    def self.create(url)
      case url
      when /wildberries/
        MarketPriceWatcher::Scrapers::WbParser.new(url)
      when /ozon/
        MarketPriceWatcher::Scrapers::OzonParser.new(url)
      end
    end
  end
end
