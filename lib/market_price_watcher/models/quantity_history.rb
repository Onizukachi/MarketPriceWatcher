# frozen_string_literal: true

module MarketPriceWatcher
  module Models
    class QuantityHistory
      attr_accessor :product_id, :quantity

      def initialize(product_id, quantity)
        @product_id = product_id
        @quantity = quantity
      end

      def to_h
        {
          product_id: product_id,
          quantity: quantity
        }
      end
    end
  end
end
