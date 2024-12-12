module MarketPriceWatcher
  module UseCases
    class AddProduct
      attr_reader :bot, :message

      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def call
        bot.api.send_message(chat_id: message.from.id, text: text)
      end

      private

      def text
        <<~TEXT
          💻 На компьютере: пришлите ссылку на товар, цену которого хотите отслеживать.
          📱 На мобильном: кликните в браузере или приложении магазина "Поделиться", выберите Telegram и отправьте сообщение со ссылкой на товар боту.
          ℹ️ Каждый раз нажимать данную кнопку для добавления товара совсем необязательно, просто присылайте ссылку или делитесь ссылкой из приложения.
        TEXT
      end
    end
  end
end