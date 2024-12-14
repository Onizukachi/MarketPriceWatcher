module MarketPriceWatcher
  class CallbackHandler
    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def process(message)
      case message.data
      when /stop_tracking/
        MarketPriceWatcher::Actions::StopTracking.new(message, message_sender).call
      when /hide_products/
        MarketPriceWatcher::Actions::HideProducts.new(message, message_sender).call
      end
    end
  end
end
