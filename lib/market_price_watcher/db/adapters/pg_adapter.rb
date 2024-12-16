require 'pg'
require 'singleton'

module MarketPriceWatcher
  module DB
    module Adapters
      class PgAdapter < BaseAdapter
        include Singleton

        def initialize
          super

          build_connection
        end

        def connection
          build_connection unless connected?

          @connection
        end

        def close
          connection&.close
          @connection = nil
        end

        def execute_sql_file(file_path)
          sql = File.read(file_path)
          connection.exec(sql)
        end

        private

        def build_connection
          connection_params = {
            dbname: ENV['DB_NAME'],
            user: ENV['DB_USERNAME'],
            password: ENV['DB_PASSWORD'],
            host: ENV['DB_HOST'],
            port: ENV['DB_PORT']
          }

          @connection = PG.connect(connection_params)
        rescue PG::Error => e
          raise e
        end

        def connected?
          !(@connection.nil? || @connection.finished?)
        end
      end
    end
  end
end
