module MarketPriceWatcher
  module Parsers
    class OzonParser
      class << self
        def parse(body)
          product = body["data"]["products"].find { |row| row["id"] == url_params[:id] }
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
      end
    end
  end
end