module MarketPriceWatcher
  module Scrapers
    class OzonScraper < BaseScraper
      ORIGIN = 'https://www.wildberries.ru'.freeze
      API_HOST = 'https://card.wb.ru/cards/v2/detail'.freeze

      def fetch_product_details
        response = connection.get(API_HOST, build_params, build_headers)
        body = JSON.parse(response.body)
        product = extract_product(body)
        product_size = extract_product_size(product)

        {
          id: product['id'],
          title: product['name'],
          price: product_size['price']['product'],
          total_quantity: product['totalQuantity']
        }
      end

      def product_id
        @product_id ||= url[%r{(?<=catalog/)\d+(?=/)}]
      end

      def market
        'ozon'
      end

      private

      def query_product_size
        url[/(?<=size=)\d+/]
      end

      def extract_product(body)
        body['data']['products'].find { |row| row['id'] == product_id }
      end

      def extract_product_size(product)
        return product['sizes'].first unless query_product_size

        product['sizes'].find { |row| row['optionId'] == query_product_size }
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
