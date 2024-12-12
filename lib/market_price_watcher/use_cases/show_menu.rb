module MarketPriceWatcher
  module UseCases
    class ShowMenu
      attr_reader :bot, :message

      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def call
        reply_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: reply_buttons,
          resize_keyboard: true
        )

        bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: reply_markup)
      end

      private

      def reply_buttons
        [[{ text: "\u{1F4E6} Мои товары" }, { text: "\u{2795} Добавить товары" }],
         [{ text: "\u{2753} О боте / Помощь" }]]
      end

      def text
        <<-TEXT
          Пришлите мне URL адрес товара, цену которого хотите отслеживать, либо выберите одну из опций меню 👇🏼
        TEXT
      end
    end
  end
end