module MarketPriceWatcher
  module Scrapers
    class WbScraper < BaseScraper
      ORIGIN = 'https://www.wildberries.ru'.freeze
      API_HOST = 'https://card.wb.ru/cards/v2/detail'.freeze

      def get_product_details
        response = connection.get(API_HOST, build_params, build_headers)
        body = JSON.parse(response.body)
        product = body["data"]["products"].find { |row| row["id"] == product_id  }

        if product_size
          size = product["sizes"].find { |row| row["optionId"] == product_id }
        else
          size = product["sizes"].first
        end

        {
          id: product["id"],
          title: product["name"],
          price: size["price"]["product"],
          total_quantity: product["totalQuantity"]
        }
      end

      def product_id
        @product_id ||= url[/(?<=catalog\/)\d+(?=\/)/]
      end

      def market
        'wb'
      end

      private

      def product_size
        url[/(?<=size=)\d+/]
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
          nm: product_id.to_s
        }
      end

      def build_headers
        headers = {}

        headers['accept'] = '*/*'
        headers['accept-language'] = 'ru-RU,ru;q=0.9'
        headers['origin'] = ORIGIN
        headers['priority'] = 'u=1, i'
        headers['referer'] = "#{ORIGIN}/catalog/#{product_id}/detail.aspx"
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
