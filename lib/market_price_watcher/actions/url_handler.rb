module MarketPriceWatcher
  module Actions
    class UrlHandler < BaseAction
      attr_accessor :product_repository, :price_history_repository
      attr_reader :scraper

      def initialize(bot, message)
        super(bot, message)

        @scraper = MarketPriceWatcher::ScraperFactory.create(message.text)
        @product_repository = MarketPriceWatcher::Repositories::ProductRepository.new
        @price_history_repository = MarketPriceWatcher::Repositories::PriceHistoryRepository.new
      end

      def call
        handle_invalid_url and return unless MarketPriceWatcher::Utils::UrlValidator.valid?(message.text)

        db_product = find_product_in_db

        handle_already_tracked_product(db_product.first) and return unless db_product.empty?

        new_product = scraper.get_product_details
        # передавать новый обьект надо вниз лучше
        create_product(new_product)
        create_price_history(new_product)
        reply_with_success(new_product)
      end

      private

      def handle_invalid_url
        message_sender.call(chat_id: chat_id, text: invalid_url_msg)
      end

      def invalid_url_msg
        'Пришлите мне URL адрес товара, цену которого хотите отслеживать, либо выберите одну из опций меню 👇🏼'
      end

      def handle_already_tracked_product(product)
        message_sender.call(chat_id: chat_id, text: already_tracked_product_msg(product))
      end

      def already_tracked_product_msg(product)
        "🔅 Товар с артикулом #{product[:id]} пропущен, так как добавлялся в список отслеживания ранее."
      end

      def find_product_in_db
        product_repository.list(id: scraper.product_id, chat_id: chat_id, market: scraper.market)
      end

      def create_product(data)
        product_repository.create(id: data[:id],
                                  title: data[:title],
                                  chat_id: chat_id,
                                  market: scraper.market,
                                  source_url: message.text)
      end

      def create_price_history(data)
        price_history_repository.create(product_id: data[:id], price: data[:price])
      end

      def reply_with_success(product)
        reply_markup = MarketPriceWatcher::Keyboards[:inline_product].call(product[:id], product[:source_url])

        message_sender.call(parse_mode: 'Markdown', chat_id: chat_id,
                            text: start_tracking_msg(product), reply_markup: reply_markup)
      end

      def start_tracking_msg(product)
        <<-TEXT
          🎬 Начат мониторинг цены и наличия
          [#{product[:title]}](#{message.text})
          Текущая цена: #{MarketPriceWatcher::Utils::PriceFormatter.format(product[:price])}
        TEXT
      end
    end
  end
end
