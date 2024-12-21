# frozen_string_literal: true

module MarketPriceWatcher
  module Workers
    class ProductTrackerWorker
      include MarketPriceWatcher::Import[:product_repository, :price_history_repository]

      attr_reader :product_id, :message_sender

      def initialize(product_id:, message_sender:, **deps)
        @product_id = product_id
        @message_sender = message_sender

        super(**deps)
      end

      def call(job)
        product = find_product_ib_db

        job.unschedule and return unless product

        scraper = create_scraper(product.source_url)
        scrapped_product_data = scraper.fetch_product_details

        current_price = current_price(product.id).price
        new_price = scrapped_product_data[:price]

        return if current_price == new_price

        create_price_history(product.id, new_price)
        max_price, min_price = [max_price(product.id), min_price(product.id)].map(&:price).map(&:to_i)

        text = MarketPriceWatcher::Messages[:price_change].call(product.title, product.source_url,
                                                                new_price, current_price,
                                                                max_price, min_price, product.created_at)
        reply_markup = MarketPriceWatcher::Keyboards[:inline_product].call(product.id, product.source_url)

        message_sender.call(parse_mode: "Markdown", chat_id: product.chat_id, text:, reply_markup:)
      end

      private

      def find_product_ib_db
        product_repository.find(product_id)
      end

      def create_scraper(url)
        MarketPriceWatcher::ScraperFactory.create(url)
      end

      def current_price(product_id)
        price_history_repository.current_price(product_id)
      end

      def max_price(product_id)
        price_history_repository.max_price(product_id)
      end

      def min_price(product_id)
        price_history_repository.min_price(product_id)
      end

      def create_price_history(product_id, price)
        price_history_repository.create(product_id:, price:)
      end
    end
  end
end
