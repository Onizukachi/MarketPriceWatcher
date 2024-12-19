module MarketPriceWatcher
  module Handlers
    class TextMessageHandler
      attr_accessor :message_sender

      def initialize(message_sender)
        @message_sender = message_sender
      end

      def process(event)
        chat_id = chat_id(event)

        case event.text
        when '/start', '/menu'
          show_menu(chat_id)
        when '/stop'
          stop(chat_id)
        when /Мои товары/
          show_products(chat_id)
        when /Добавить товар/
          add_product(chat_id)
        when /Помощь/
          help(chat_id)
        else
          handle_url(chat_id, event.text)
        end
      end

      private

      def chat_id(event)
        event.chat.id
      end

      def stop(chat_id)
        reply_markup = MarketPriceWatcher::Keyboards[:remove].call
        text = MarketPriceWatcher::Messages[:goodbye].call

        message_sender.call(chat_id:, text:, reply_markup:)
      end

      def show_menu(chat_id)
        reply_markup = MarketPriceWatcher::Keyboards[:main_menu].call
        text = MarketPriceWatcher::Messages[:request_url].call

        message_sender.call(chat_id:, text:, reply_markup:)
      end

      def show_products(chat_id)
        products = MarketPriceWatcher::Services::ProductsWithPriceService.new(chat_id:).call

        if products.empty?
          text = MarketPriceWatcher::Messages[:empty_products].call
          message_sender.call(chat_id:, text:)
        else
          products.each_with_index do |product, index|
            text = MarketPriceWatcher::Messages[:show_product].call(product[:title], product[:source_url],
                                                                    product[:price], product[:created_at], index + 1)
            reply_markup = MarketPriceWatcher::Keyboards[:inline_product].call(product[:id], product[:source_url])

            message_sender.call(parse_mode: 'Markdown', chat_id:, text:, reply_markup:)
          end
        end
      end

      def add_product(chat_id)
        text = MarketPriceWatcher::Messages[:add_product].call

        message_sender.call(chat_id: chat_id, text: text)
      end

      def help(chat_id)
        text = MarketPriceWatcher::Messages[:help].call

        message_sender.call(chat_id: chat_id, text: text)
      end

      def handle_url(chat_id, message)
        product = MarketPriceWatcher::Services::UrlHandlerService.new(chat_id:, message:, message_sender:).call

        reply_markup = MarketPriceWatcher::Keyboards[:inline_product].call(product[:id], product[:source_url])
        text = MarketPriceWatcher::Messages[:start_tracking].call(product[:title], product[:source_url], product[:price])

        message_sender.call(parse_mode: 'Markdown', chat_id:, text:, reply_markup:)
      rescue MarketPriceWatcher::Services::UrlHandlerService::NotValidUrlError
        text = MarketPriceWatcher::Messages[:request_url].call
        message_sender.call(chat_id:, text:)
      rescue MarketPriceWatcher::Services::UrlHandlerService::AlreadyTrackedProductError => e
        text = MarketPriceWatcher::Messages[:already_tracked_product].call(e.message)
        message_sender.call(chat_id:, text:)
      end
    end
  end
end
