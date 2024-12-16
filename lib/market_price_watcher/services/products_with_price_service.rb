module MarketPriceWatcher
  module Services
    class ProductsWithPriceService
      include MarketPriceWatcher::Import[:product_repository, :price_history_repository]

      attr_reader :chat_id

      def initialize(chat_id:, **deps)
        @chat_id = chat_id
        super(**deps)
      end

      def call
        products = product_repository.list(chat_id: chat_id)
        sorted_products = sort_products(products)
        add_price_to_products(sorted_products)
      end

      private

      def sort_products(products)
        products.sort_by(&:created_at)
      end

      def add_price_to_products(products)
        products.map do |product|
          price_history = price_history_repository.current_price(product.id)
          product.to_h.merge(price: price_history.price)
        end
      end
    end
  end
end
