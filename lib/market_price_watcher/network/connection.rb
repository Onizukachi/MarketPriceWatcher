require 'faraday'
require_relative 'socksify_net_http'

module MarketPriceWatcher
  module Network
    module Connection
      SSL_OPTS = { verify: false }.freeze

      def connection
        proxy_url = MarketPriceWatcher.config.proxy_url

        @connection ||= Faraday.new(proxy: proxy_url, ssl: SSL_OPTS) do |f|
          f.response :logger
          f.adapter :net_http
        end
      end
    end
  end
end
