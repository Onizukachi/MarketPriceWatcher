module MarketPriceWatcher
  module Actions
    class ShowMenu < BaseAction
      def call
        reply_markup = MarketPriceWatcher::Keyboards[:main_menu].call

        message_sender.call(chat_id: chat_id, text: text, reply_markup: reply_markup)
      end

      private

      def text
        <<-TEXT
          Пришлите мне URL адрес товара, цену которого хотите отслеживать, либо выберите одну из опций меню 👇🏼
        TEXT
      end
    end
  end
end
