module MarketPriceWatcher
  module Services
    class UrlHandlerService
      include MarketPriceWatcher::Import[:product_repository, :price_history_repository]

      class NotValidUrlError < StandardError; end
      class AlreadyTrackedProductError < StandardError; end

      attr_reader :chat_id, :message, :message_sender, :scraper

      def initialize(chat_id:, message:, message_sender:, **deps)
        @chat_id = chat_id
        @message = message
        @message_sender = message_sender
        @scraper = MarketPriceWatcher::ScraperFactory.create(message)

        super(**deps)
      end

      def call
        handle_invalid_url unless MarketPriceWatcher::UrlValidator.valid?(message.text)

        db_product = find_product_in_db

        handle_already_tracked_product(db_product.first) unless db_product.empty?

        scrapped_product_data = scraper.fetch_product_details

        new_product = create_product(scrapped_product_data)
        new_price_history = create_price_history(new_product.id, scrapped_product_data[:price])

        schedule_track_worker(new_product.id)

        new_product.to_h.merge(price: new_price_history.price)
      end

      private

      def handle_invalid_url
        raise NotValidUrlError
      end

      def handle_already_tracked_product(product)
        raise AlreadyTrackedProductError, product.id
      end

      def find_product_in_db
        product_repository.list(id: scraper.product_id, chat_id: chat_id, market: scraper.market)
      end

      def create_product(data)
        product_repository.create(id: data[:id],
                                  title: data[:title],
                                  chat_id: chat_id,
                                  market: data[:market],
                                  source_url: data[:source_url])
      end

      # TODO:
      #  Во первых цена тут привязывается к айди продукта из апи а они могут дублироваться у нас
      # надо сделать обычный id автоинкрмент у продуктов
      # и потом легче с ним работать будет при трекинге или удалении
      def create_price_history(product_id, price)
        price_history_repository.create(product_id: product_id, price: price)
      end

      def schedule_track_worker(product_id)
        worker = MarketPriceWatcher::Workers::ProductTrackerWorker.new(product_id, message_sender)

        MarketPriceWatcher::Scheduler.instance.interval(MarketPriceWatcher.config.track_interval, worker)
      end
    end
  end
end
