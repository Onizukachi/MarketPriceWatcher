module MarketPriceWatcher
  module UseCases
    class Stop
      attr_reader :bot, :message

      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def call
        reply_markup = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)

        bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: reply_markup)
      end

      private

      def text
        'Надеюсь ты еще вернешься :)'
      end
    end
  end
end
