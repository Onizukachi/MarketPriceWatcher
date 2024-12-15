module MarketPriceWatcher
  class CallbackHandler
    attr_reader :bot
    attr_accessor :message_sender

    def initialize(bot, message_sender: MarketPriceWatcher::MessageSender.new(bot))
      @bot = bot
      @message_sender = message_sender
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
