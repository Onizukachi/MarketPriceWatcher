module MarketPriceWatcher
  module DB
    module Adapters
      class Base
        def connection
          raise NotImplementedError, 'This method should be implemented in a subclass'
        end

        def close
          raise NotImplementedError, 'This method should be implemented in a subclass'
        end

        def execute_sql_file(file_path)
          raise NotImplementedError, 'This method should be implemented in a subclass'
        end
      end
    end
  end
end
