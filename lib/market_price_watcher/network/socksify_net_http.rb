require 'socksify/http'

module MarketPriceWatcher
  module Network
    # redirects any TCP connection initiated by a Ruby script through a SOCKS5 proxy
    class Faraday::Adapter::NetHttp
      def net_http_connection(env)
        if (proxy = env[:request][:proxy])
          proxy_class(proxy)
        else
          Net::HTTP
        end.new(env[:url].hostname, env[:url].port || (env[:url].scheme == 'https' ? 443 : 80))
      end

      def proxy_class(proxy)
        if proxy.uri.scheme == 'socks'
          TCPSocket.socks_username = proxy[:user] if proxy[:user]
          TCPSocket.socks_password = proxy[:password] if proxy[:password]
          Net::HTTP::SOCKSProxy(proxy[:uri].host, proxy[:uri].port)
        else
          Net::HTTP::Proxy(proxy[:uri].host, proxy[:uri].port, proxy[:uri].user, proxy[:uri].password)
        end
      end
    end
  end
end
