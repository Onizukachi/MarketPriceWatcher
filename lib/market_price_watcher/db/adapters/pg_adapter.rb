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
            dbname: ENV['POSTGRES_DB'],
            user: ENV['POSTGRES_USER'],
            password: ENV['POSTGRES_PASSWORD'],
            host: ENV['POSTGRES_HOST'],
            port: ENV['POSTGRES_PORT']
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
