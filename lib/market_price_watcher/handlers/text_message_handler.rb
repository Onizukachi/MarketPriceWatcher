module MarketPriceWatcher
  module Handlers
    class TextMessageHandler
      include MarketPriceWatcher::Import[:products_with_price_service]

      attr_accessor :message_sender

      def initialize(message_sender:, **deps)
        @message_sender = message_sender
        super(**deps)
      end

      def process(message)
        chat_id = chat_id(message)

        case message.text
        when '/start'
          start(chat_id)
        when '/stop'
          stop(chat_id)
        when '/menu'
          show_menu(chat_id)
        when /Мои товары/
          show_products(chat_id)
        when /Добавить товары/
          add_products(chat_id)
        when /Помощь/
          help(chat_id)
        else
          handle_url(chat_id)
          #MarketPriceWatcher::Actions::UrlHandler.new(message, message_sender).call
        end
      end

      private

      def chat_id(message)
        message.chat.id
      end

      def start(chat_id)
        show_menu(chat_id)
      end

      def stop(chat_id)
        reply_markup = MarketPriceWatcher::Keyboards[:remove].call
        text = MarketPriceWatcher::Messages[:goodbye].call

        message_sender.call(chat_id: chat_id, text: text, reply_markup: reply_markup)
      end

      def show_menu(chat_id)
        reply_markup = MarketPriceWatcher::Keyboards[:main_menu].call
        text = MarketPriceWatcher::Messages[:request_url].call

        message_sender.call(chat_id: chat_id, text: text, reply_markup: reply_markup)
      end

      def show_products(chat_id)
        products = products_with_price_service.call(chat_id)

        products.each_with_index do |product, index|
          text = MarketPriceWatcher::Messages[:show_product].call(product[:title], product[:source_url],
                                                                  product[:price], product[:created_at], index)
          reply_markup = MarketPriceWatcher::Keyboards[:inline_product].call(product[:id], product[:source_url])

          message_sender.call(parse_mode: 'Markdown', chat_id: chat_id, text: text, reply_markup: reply_markup)
        end
      end

      def add_products(chat_id)
        text = MarketPriceWatcher::Messages[:add_products].call

        message_sender.call(chat_id: chat_id, text: text)
      end

      def help(chat_id)
        text = MarketPriceWatcher::Messages[:help].call

        message_sender.call(chat_id: chat_id, text: text)
      end

      def handle_url(chat_id)

      end
    end
  end
end
