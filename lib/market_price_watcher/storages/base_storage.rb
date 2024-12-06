module MarketPriceWatcher
  module Storages
    class BaseStorage
      def list_products(chat_id)
        raise NotImplementedError, 'This method should be implemented in a subclass'
      end

      def insert_product(chat_id, product)
        raise NotImplementedError, 'This method should be implemented in a subclass'
      end

      def close
        raise NotImplementedError, 'This method should be implemented in a subclass'
      end
    end
  end
end