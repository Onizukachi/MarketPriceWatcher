module MarketPriceWatcher
  module Handlers
    class CallbackHandler
      attr_accessor :message_sender

      def initialize(message_sender:, **deps)
        @message_sender = message_sender
        super(**deps)
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
