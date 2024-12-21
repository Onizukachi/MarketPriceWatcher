# frozen_string_literal: true

module MarketPriceWatcher
  module Models
    class Product
      attr_accessor :id, :source_id, :title, :chat_id, :market, :source_url, :created_at

      def initialize(id, source_id, title, chat_id, market, source_url, created_at)
        @id = id
        @source_id = source_id
        @title = title
        @chat_id = chat_id
        @market = market
        @source_url = source_url
        @created_at = created_at
      end

      def to_h
        {
          id: id,
          source_id: source_id,
          title: title,
          chat_id: chat_id,
          market: market,
          source_url: source_url,
          created_at: created_at
        }
      end
    end
  end
end
