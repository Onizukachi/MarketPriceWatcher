module MarketPriceWatcher
  module Scrapers
    class OzonScraper
      include MarketPriceWatcher::Network::Connection

      attr_accessor :id

      ORIGIN = 'https://www.wildberries.ru'.freeze
      API_HOST = 'https://card.wb.ru/cards/v2/detail'.freeze

      def initialize(id)
        @id = id
      end

      def get_product_details
        response = connection.get(API_HOST, build_params, build_headers)
        byebug
      end

      private

      def build_params
        {
          appType: '1',
          curr: 'rub',
          dest: '-1257786',
          locale: 'ru',
          spp: '30',
          lang: 'ru',
          ab_testing: 'false',
          nm: id.to_s
        }
      end

      def build_headers
        headers = {}

        headers['accept'] = '*/*'
        headers['accept-language'] = 'ru-RU,ru;q=0.9'
        headers['origin'] = ORIGIN
        headers['priority'] = 'u=1, i'
        headers['referer'] = "#{ORIGIN}/catalog/#{id}/detail.aspx"
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
