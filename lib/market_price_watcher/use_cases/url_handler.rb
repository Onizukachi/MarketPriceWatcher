module MarketPriceWatcher
  module UseCases
    class UrlHandler
      attr_reader :bot, :message
      attr_accessor :product_repository, :price_history_repository

      def initialize(bot, message)
        @bot = bot
        @message = message
        @product_repository = MarketPriceWatcher::Repositories::ProductRepository.new
        @price_history_repository = MarketPriceWatcher::Repositories::PriceHistoryRepository.new
      end

      def call
        handle_incorrect_msg and return unless MarketPriceWatcher::Utils::UrlValidator.valid?(message.text)

        id = message.text[/(?<=catalog\/)\d+(?=\/)/]
        product = product_repository.list(id: id, chat_id: message.from.id, market: 'wb')

        if !product.empty?
          msg = "🔅 Товар с артикулом #{product.first[:id]} пропущен, так как добавлялся в список отслеживания ранее."
          send_message(message.from.id, msg)
        else
          scraper = MarketPriceWatcher::ScraperFactory.create(message.text)
          result = scraper.get_product_details
          product_repository.create(id: id,
                                    title: result[:title],
                                    chat_id: message.from.id,
                                    market: result[:market],
                                    source_url: message.text)

          price_history_repository.create(product_id: id, price: result[:price])

          text = "🎬 Начат мониторинг цены и наличия"\
            "\n[#{result[:title]}](#{message.text})"\
            "\nТекущая цена: #{result[:price].to_s.gsub(/(\d\d$)/, '.\1')} RUB"\

            kb = [
              [
                Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{2705} Купить", url: message.text),
                Telegram::Bot::Types::InlineKeyboardButton.new(text: "\u{1F6AB} Не отслеживать", callback_data: '/stop_tracking')
              ]
            ]

          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
          bot.api.send_message(parse_mode: 'Markdown', chat_id: message.from.id, text: text, reply_markup: markup)
        end
      end

      private

      def chat_id
        message.chat.id
      end

      def handle_incorrect_msg
        bot.api.send_message(chat_id: chat_id, text: incorrect_text)
      end

      def incorrect_text
        <<-TEXT
          Пришлите мне URL адрес товара, цену которого хотите отслеживать, либо выберите одну из опций меню 👇🏼
        TEXT
      end
    end
  end
end