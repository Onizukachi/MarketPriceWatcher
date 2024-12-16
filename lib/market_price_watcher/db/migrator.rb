module MarketPriceWatcher
  module DB
    class Migrator
      include MarketPriceWatcher::Import[:db_adapter]

      attr_reader :path

      def initialize(path: '/migrations', **deps)
        @path = path
        super(**deps)
      end

      def apply
        Dir.glob("#{__dir__}#{path}/*.sql").sort.each do |file|
          db_adapter.execute_sql_file(file)
        end
      end
    end
  end
end
