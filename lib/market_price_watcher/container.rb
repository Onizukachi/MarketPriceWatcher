require 'dry/container'
require 'dry/auto_inject'

module MarketPriceWatcher
  module Container
    extend Dry::Container::Mixin

    register(:db_adapter) { MarketPriceWatcher::DB::Adapters::PgAdapter.instance }

    register(:product_mapper) { MarketPriceWatcher::DB::Mappers::ProductMapper }
    register(:price_history_mapper) { MarketPriceWatcher::DB::Mappers::PriceHistoryMapper }
    register(:quantity_history_mapper) { MarketPriceWatcher::DB::Mappers::QuantityHistoryMapper }

    register(:product_repository) do
      MarketPriceWatcher::DB::Repositories::ProductRepository.new(db_adapter: Container.resolve(:db_adapter),
                                                                  mapper: Container.resolve(:product_mapper))
    end
    register(:price_history_repository) do
      MarketPriceWatcher::DB::Repositories::PriceHistoryRepository.new(db_adapter: Container.resolve(:db_adapter),
                                                                       mapper: Container.resolve(:price_history_mapper))
    end
    register(:quantity_history_repository) do
      MarketPriceWatcher::DB::Repositories::PriceHistoryRepository.new(db_adapter: Container.resolve(:db_adapter),
                                                                       mapper: Container.resolve(:quantity_history_mapper))
    end
  end

  Import = Dry::AutoInject(Container)
end
