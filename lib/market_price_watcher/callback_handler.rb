module MarketPriceWatcher
  class CallbackHandler
    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def process(message)
      case message.data
      when /stop_tracking/
        MarketPriceWatcher::UseCases::StopTracking.new(bot, message).call
      when /hide_products/
        MarketPriceWatcher::UseCases::HideProducts.new(bot, message).call
      end
    end
  end
end