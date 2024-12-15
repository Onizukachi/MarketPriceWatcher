module MarketPriceWatcher
  module Workers
    class ProductTracker
      attr_reader :product_id, :message_sender, :product_repository, :price_history_repository

      def initialize(product_id, message_sender, product_repository, price_history_repository)
        @product_id = product_id
        @message_sender = message_sender
        @product_repository = product_repository
        @price_history_repository = price_history_repository
      end

      # TODO: сделать по нормальному воркер щас все работает так то и сделать так чтоб база отдавала сразу массив хешей чтобы везде были  :
      def call(job)
        product = product_repository.find(product_id)

        job.unschedule and return if product.nil?

        message_sender.call(chat_id: product['chat_id'], text: product['title'])

        # scraper = MarketPriceWatcher::ScraperFactory.create(product['source_url'])
        # current_price = price_history_repository.current_price(product['id'])
        #
        # api_product_details = scraper.fetch_product_details
        # new_price = api_product_details[:price]
        #
        # return unless current_price != new_price
        #
        # message_sender.call(chat_id: product['chat_id'], text: text, reply_markup: reply_markup)
      end

      private

      def text
        'AAAAAAAAAAA'
      end

      def reply_markup

      end
    end
  end
end

