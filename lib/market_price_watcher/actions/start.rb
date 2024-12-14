module MarketPriceWatcher
  module Actions
    class Start < BaseAction
      def call
        MarketPriceWatcher::Actions::ShowMenu.new(message, message_sender).call
      end
    end
  end
end
