module MarketPriceWatcher
  module Container
    extend Dry::Container::Mixin

    register(:db_adapter) { MarketPriceWatcher::DB::Adapters::PgAdapter.instance }

    register(:product_mapper) { MarketPriceWatcher::DB::Mappers::ProductMapper }
    register(:price_history_mapper) { MarketPriceWatcher::DB::Mappers::PriceHistoryMapper }

    register(:product_repository) do
      MarketPriceWatcher::DB::Repositories::ProductRepository.new(db_adapter: Container.resolve(:db_adapter),
                                                                  mapper: Container.resolve(:product_mapper))
    end
    register(:price_history_repository) do
      MarketPriceWatcher::DB::Repositories::PriceHistoryRepository.new(db_adapter: Container.resolve(:db_adapter),
                                                                  mapper: Container.resolve(:price_history_mapper))
    end

    register(:products_with_price_service) do
      MarketPriceWatcher::Services::ProductsWithPriceService.new(product_repository:
                                                                   Container.resolve(:product_repository),
                                                                 price_history_repository:
                                                                   Container.resolve(:price_history_repository))
    end
  end

  Import = Dry::AutoInject(Container)
end
