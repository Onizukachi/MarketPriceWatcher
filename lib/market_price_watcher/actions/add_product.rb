module MarketPriceWatcher
  module Actions
    class AddProduct < BaseAction

      def call
        message_sender.call(chat_id: chat_id, text: text)
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
