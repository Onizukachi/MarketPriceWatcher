module MarketPriceWatcher
  module Services
    class ProductsWithPriceService
      attr_reader :product_repository, :price_history_repository

      def initialize(product_repository:, price_history_repository:)
        @product_repository = product_repository
        @price_history_repository = price_history_repository
      end

      def call(chat_id)
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
