# frozen_string_literal: true

require "faraday"
require_relative "socksify_net_http"

module MarketPriceWatcher
  module Network
    module Connection
      SSL_OPTS = {verify: false}.freeze

      def connection
        @connection ||= Faraday.new(connection_options) do |f|
          f.response :logger
          f.adapter :net_http
        end
      end

      def connection_options
        proxy_url = MarketPriceWatcher.config.proxy_url

        options = {ssl: SSL_OPTS}
        options[:proxy] = proxy_url if proxy_url

        options
      end
    end
  end
end
