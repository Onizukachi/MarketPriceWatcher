module MarketPriceWatcher
  module Actions
    class BaseAction
      attr_reader :message, :message_sender

      def initialize(message, message_sender)
        @message = message
        @message_sender = message_sender
      end

      private def chat_id = message.chat.id
    end
  end
end
