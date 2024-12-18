module MarketPriceWatcher
  module Services
    class StopTrackingProductService
      include MarketPriceWatcher::Import[:product_repository, :price_history_repository]

      attr_reader :product_id

      def initialize(product_id:, **deps)
        @product_id = product_id

        super(**deps)
      end

      def call
        source_id = product_repository.find(product_id).source_id
        product_repository.delete(product_id)

        source_id
      end
    end
  end
end
