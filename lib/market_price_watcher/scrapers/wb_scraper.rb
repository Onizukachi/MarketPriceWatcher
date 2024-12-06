module MarketPriceWatcher
  module Scrapers
    class WbScraper
      include Connection

      attr_accessor :url_params

      ORIGIN = 'https://www.wildberries.ru'.freeze
      API_HOST = 'https://card.wb.ru/cards/v2/detail'.freeze

      def initialize(url)
        @url_params = parse_url(url)
      end

      def get_product_details
        response = connection.get(API_HOST, build_params, build_headers)
        body = JSON.parse(response.body)
        product = body["data"]["products"].find { |row| row["id"] == url_params[:id]  }
        byebug
        id = product["id"]
        total_quantity = product["totalQuantity"]
        title = product["name"]

        if url_params[:size]
          size = product["sizes"].find { |row| row["optionId"] == url_params[:size] }
        else
          size = product["sizes"].first
        end

      end

      private

      def parse_url(url)
        result = {}

        id = extract_id(url)
        result.merge!(id: id.to_i) if id

        size = extract_size(url)
        result.merge!(size: size.to_i) if size

        result
      end

      def extract_id(url)
        url[/(?<=catalog\/)\d+(?=\/)/]
      end

      def extract_size(url)
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
