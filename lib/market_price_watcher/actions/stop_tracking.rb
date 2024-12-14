module MarketPriceWatcher
  module Actions
    class StopTracking < BaseAction
      def call
        reply_markup = MarketPriceWatcher::Keyboards[:remove].call

        message_sender.call(chat_id: chat_id, text: text, reply_markup: reply_markup)
      end

      private

      def text
        'Надеюсь ты еще вернешься :)'
      end
    end
  end
end
