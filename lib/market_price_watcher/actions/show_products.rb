module MarketPriceWatcher
  module Actions
    class ShowProducts < BaseAction
      attr_accessor :product_repository, :price_history_repository

      def initialize(message, message_sender)
        super(message, message_sender)

        @product_repository = MarketPriceWatcher::Repositories::ProductRepository.new
        @price_history_repository = MarketPriceWatcher::Repositories::PriceHistoryRepository.new
      end

      def call
        products = product_repository.list(chat_id: chat_id)

        handle_empty_products and return if products.empty?

        sorted_products = sort_products(products)
        products_with_price = merge_price_to_products(sorted_products)

        products_with_price.each_with_index do |product, index|
          is_last = index == sorted_products.size - 1

          show_product(product, index, is_last)
        end
      end

      private

      def handle_empty_products
        message_sender.call(chat_id: chat_id, text: empty_products_text)
      end

      def empty_products_text
        'Пока не отслеживается цена ни одного товара! Пришлите ссылку на товар, чтобы начать отслеживать его цену.'
      end

      def show_product(product, index, is_last)
        reply_markup = if is_last
                         MarketPriceWatcher::Keyboards[:last_inline_product]
                       else
                         MarketPriceWatcher::Keyboards[:inline_product]
                       end

        reply_markup = reply_markup.call(product['id'], product['source_url'])

        message_sender.call(parse_mode: 'Markdown', chat_id: chat_id,
                            text: show_product_text(product, index + 1), reply_markup: reply_markup)
      end

      def sort_products(products)
        products.sort_by { |product| Time.parse(product['created_at']) }
      end

      def merge_price_to_products(products)
        products.map do |product|
          price_history = price_history_repository.current_price(product['id'])
          product['price'] = price_history['price']

          product
        end
      end

      def show_product_text(product, index)
        <<~TEXT
          #{index}. [#{product['title']}](#{product['source_url']})
          Текущая цена: #{MarketPriceWatcher::PriceFormatter.format(product['price'])}
          Отслеживание начато: #{days_until_today(Time.parse(product['created_at']))} дня(ей) назад
        TEXT
      end

      def days_until_today(date)
        (Date.today - date.to_date).to_i
      end
    end
  end
end
