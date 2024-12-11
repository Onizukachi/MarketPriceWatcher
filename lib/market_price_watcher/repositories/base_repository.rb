module MarketPriceWatcher
  module Repositories
    class BaseRepository
      attr_reader :db_adapter

      def initialize(db_adapter: MarketPriceWatcher::DB::Adapters::Postgresql.instance)
        @db_adapter = db_adapter
      end

      def find(id)
        raise NotImplementedError
      end

      def list(**options)
        raise NotImplementedError
      end

      def create(**attributes)
        raise NotImplementedError
      end

      def update(id, **attributes)
        raise NotImplementedError
      end

      def delete(id)
        raise NotImplementedError
      end

      private

      def connection
        db_adapter.connection
      end
    end
  end
end
