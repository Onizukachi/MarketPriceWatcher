module MarketPriceWatcher
  module Scrapers
    class WbScraper
      include MarketPriceWatcher::Network::Connection

      attr_reader :url

      ORIGIN = 'https://www.wildberries.ru'.freeze
      API_HOST = 'https://card.wb.ru/cards/v2/detail'.freeze

      def initialize(url)
        @url = url
      end

      def get_product_details
        response = connection.get(API_HOST, build_params, build_headers)
        body = JSON.parse(response.body)
        product = body["data"]["products"].find { |row| row["id"] == url_params[:id]  }

        if url_params[:size]
          size = product["sizes"].find { |row| row["optionId"] == url_params[:size] }
        else
          size = product["sizes"].first
        end

        {
          id: product["id"],
          title: product["name"],
          price: size["price"]["product"],
          total_quantity: product["totalQuantity"],
          market: market_title
        }
      end

      def url_params
        @url_params ||= extract_url_params
      end

      private

      def market_title
        'wb'
      end

      def extract_url_params
        result = {}

        id = url[/(?<=catalog\/)\d+(?=\/)/]
        result.merge!(id: id.to_i) if id

        size = url[/(?<=size=)\d+/]
        result.merge!(size: size.to_i) if size

        result
      end

      def build_params
        {
          appType: '1',
          curr: 'rub',
          dest: '-1257786',
          locale: 'ru',
          spp: '30',
          lang: 'ru',
          ab_testing: 'false',
          nm: url_params[:id].to_s
        }
      end

      def build_headers
        headers = {}

        headers['accept'] = '*/*'
        headers['accept-language'] = 'ru-RU,ru;q=0.9'
        headers['origin'] = ORIGIN
        headers['priority'] = 'u=1, i'
        headers['referer'] = "#{ORIGIN}/catalog/#{url_params[:id]}/detail.aspx"
        headers['sec-ch-ua'] = '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"'
        headers['sec-ch-ua-mobile'] = '?0'
        headers['sec-ch-ua-platform'] = '"macOS"'
        headers['sec-fetch-dest'] = 'empty'
        headers['sec-fetch-mode'] = 'cors'
        headers['sec-fetch-site'] = 'cross-site'
        headers['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'\
          '(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'

        headers
      end
    end
  end
end
