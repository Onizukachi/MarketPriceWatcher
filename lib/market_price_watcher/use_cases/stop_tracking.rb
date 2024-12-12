module MarketPriceWatcher
  module UseCases
    class StopTracking
      attr_reader :bot, :message

      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def call
        kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)

        bot.api.send_message(chat_id: message.from.id, text: 'Надеюсь ты еще вернешься :)', reply_markup: kb)
      end
    end
  end
end
