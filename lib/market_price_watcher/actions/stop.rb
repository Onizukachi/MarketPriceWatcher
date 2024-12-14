module MarketPriceWatcher
  module Actions
    class Stop < BaseAction
      def call
        reply_markup = MarketPriceWatcher::Keyboards[:remove].call

        send_message(chat_id: chat_id, text: text, reply_markup: reply_markup)
      end

      private

      def text
        'Надеюсь ты еще вернешься :)'
      end
    end
  end
end
