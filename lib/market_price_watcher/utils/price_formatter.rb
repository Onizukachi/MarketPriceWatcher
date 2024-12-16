module MarketPriceWatcher
  module Utils
    class PriceFormatter
      def self.format(price)
        "#{price.to_s.gsub(/(\d\d$)/, '.\1')} RUB"
      end
    end
  end
end
