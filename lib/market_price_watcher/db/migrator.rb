module MarketPriceWatcher
  module DB
    class Migrator
      attr_accessor :path, :db_adapter

      def initialize(path: '/migrations', db_adapter: MarketPriceWatcher::DB::Adapters::Postgresql.instance)
        @path = path
        @db_adapter = db_adapter
      end

      def apply
        Dir.glob("#{__dir__}#{path}/*.sql").sort.each do |file|
          db_adapter.execute_sql_file(file)
        end
      end
    end
  end
end
