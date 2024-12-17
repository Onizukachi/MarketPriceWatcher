module MarketPriceWatcher
  module Scrapers
    class WbScraper < BaseScraper
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
          total_quantity: product['totalQuantity'],
          market: market,
          source_url: url.to_s
        }
      end

      def product_id
        @product_id ||= url.path[%r{(?<=catalog/)\d+(?=/)}].to_i
      end

      def market
        'wb'
      end

      private

      def query_product_size
        query_hash['size'].to_i
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
        {
          'accept' => '*/*',
          'accept-language' => 'ru-RU,ru;q=0.9',
          'origin' => ORIGIN,
          'priority' => 'u=1, i',
          'referer' => "#{ORIGIN}/catalog/#{product_id}/detail.aspx",
          'sec-ch-ua' => '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
          'sec-ch-ua-mobile' => '?0',
          'sec-ch-ua-platform' => '"macOS"',
          'sec-fetch-dest' => 'empty',
          'sec-fetch-mode' => 'cors',
          'sec-fetch-site' => 'cross-site',
          'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'\
            '(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
        }
      end
    end
  end
end
