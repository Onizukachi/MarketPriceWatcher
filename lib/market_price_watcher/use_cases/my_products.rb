module MarketPriceWatcher
  module UseCases
    class MyProducts
      attr_reader :bot, :message
      attr_accessor :product_repository, :price_history_repository

      def initialize(bot, message)
        @bot = bot
        @message = message
        @product_repository = MarketPriceWatcher::Repositories::ProductRepository.new
        @price_history_repository = MarketPriceWatcher::Repositories::PriceHistoryRepository.new
      end

      def call
        products = product_repository.list(chat_id: chat_id)

        handle_empty_products and return if products.empty?

        sorted_products = sort_products(products)

        sorted_products.each_with_index do |product, index|
          is_last = index == sorted_products.size - 1

          show_product(product, index, is_last)
        end
      end

      private

      def chat_id
        message.chat.id
      end

      def handle_empty_products
        bot.api.send_message(chat_id: chat_id, text: empty_products_text)
      end

      def empty_products_text
        "Пока не отслеживается цена ни одного товара! Пришлите ссылку на товар, чтобы начать отслеживать его цену."
      end

      def show_product(product, index, is_last)
        product['price'] = get_current_price(product)

        inline_keyboard = product_keyboard(product)
        inline_keyboard.push([hide_products_button]) if is_last

        reply_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_keyboard)
        bot.api.send_message(parse_mode: 'Markdown', chat_id: chat_id,
                             text: show_product_text(product, index + 1), reply_markup: reply_markup)
      end

      def sort_products(products)
        products.sort_by { |product| Time.parse(product['created_at']) }
      end

      def get_current_price(product)
        price_history_repository.current_price(product['id'])['price']
      end

      def show_product_text(product, index)
        <<~TEXT
          #{index}. [#{product['title']}](#{product['source_url']})
          Текущая цена: #{MarketPriceWatcher::Utils::PriceFormatter.format(product['price'])}
          Отслеживание начато: #{days_until_today(Time.parse(product['created_at']))} дня(ей) назад
        TEXT
      end

      def days_until_today(date)
        (Date.today - date.to_date).to_i
      end

      def product_keyboard(product)
        [
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{2705} Купить",
                                                           url: product['source_url']),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{1F6AB} Не отслеживать",
                                                           callback_data: "stop_tracking_#{product["id"]}")
          ]
        ]
      end

      def hide_products_button
          Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{1F648} Скрыть список отслеживания",
                                                         callback_data: '/hide_products')
      end
    end
  end
end