# frozen_string_literal: true

module MarketPriceWatcher
  module Keyboards
    class << self
      def [](key)
        keyboards[key] || raise("Keyboard #{key} not found")
      end

      def keyboards
        {
          remove: lambda {
            Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
          },
          main_menu: lambda {
            Telegram::Bot::Types::ReplyKeyboardMarkup.new(
              keyboard: [
                [{text: "\u{1F4E6} Мои товары"}, {text: "\u{2795} Добавить товар"}],
                [{text: "\u{2753} О боте / Помощь"}]
              ],
              resize_keyboard: true
            )
          },
          inline_product: lambda { |id, source_url|
            Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [
                                                             [
                                                               MarketPriceWatcher::Keyboards[:buy].call(source_url),
                                                               MarketPriceWatcher::Keyboards[:stop_tracking].call(id)
                                                             ]
                                                           ])
          },
          buy: lambda { |url|
            Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{2705} Купить", url: url)
          },
          stop_tracking: lambda { |id|
            Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{1F6AB} Не отслеживать",
                                                           callback_data: "stop_tracking_#{id}")
          },
          hide_products: lambda {
            Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{1F648} Скрыть список отслеживания",
                                                           callback_data: "/hide_products")
          }
        }
      end
    end
  end
end
