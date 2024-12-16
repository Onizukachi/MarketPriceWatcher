module MarketPriceWatcher
  module Handlers
    class CallbackHandler
      attr_accessor :message_sender

      def initialize(message_sender)
        @message_sender = message_sender
      end

      def process(message)
        case message.data
        when /stop_tracking/
          nil
        when /hide_products/
          nil
        end
      end
    end
  end
end
