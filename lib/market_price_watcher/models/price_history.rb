# frozen_string_literal: true

module MarketPriceWatcher
  module Models
    class PriceHistory
      attr_accessor :product_id, :price

      def initialize(product_id, price)
        @product_id = product_id
        @price = price
      end

      def to_h
        {
          product_id: product_id,
          price: price
        }
      end
    end
  end
end
