# frozen_string_literal: true

module MarketPriceWatcher
  module DB
    module Repositories
      class BaseRepository
        attr_reader :db_adapter, :mapper

        def initialize(db_adapter:, mapper:)
          @db_adapter = db_adapter
          @mapper = mapper
        end

        def find(_id)
          raise NotImplementedError
        end

        def list(**options)
          raise NotImplementedError
        end

        def create(**attributes)
          raise NotImplementedError
        end

        def update(_id, **attributes)
          raise NotImplementedError
        end

        def delete(_id)
          raise NotImplementedError
        end
      end
    end
  end
end
