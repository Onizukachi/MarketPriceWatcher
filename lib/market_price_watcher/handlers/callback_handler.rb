# frozen_string_literal: true

module MarketPriceWatcher
  module Handlers
    class CallbackHandler
      attr_accessor :message_sender

      def initialize(message_sender)
        @message_sender = message_sender
      end

      def process(event)
        chat_id = chat_id(event)

        case event.data
        when /stop_tracking/
          stop_tracking(chat_id, event.data)
        when /hide_products/
          nil
        end
      end

      private

      def chat_id(event)
        event.message.chat.id
      end

      def stop_tracking(chat_id, data)
        product_id = data[/(?<=stop_tracking_)(\d+)/].to_i

        source_id = MarketPriceWatcher::Services::StopTrackingProductService.new(product_id:).call

        text = MarketPriceWatcher::Messages[:remove_from_tracking].call(source_id)
        message_sender.call(chat_id:, text:)
      end
    end
  end
end
