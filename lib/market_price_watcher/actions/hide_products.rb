module MarketPriceWatcher
  module Actions
    class HideProducts < BaseAction
      def call
        message_sender.call(chat_id: message.from.id, text: 'Hello')
      end
    end
  end
end
