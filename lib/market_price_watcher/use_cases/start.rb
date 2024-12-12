module MarketPriceWatcher
  module UseCases
    class Start
      attr_reader :bot, :message

      def initialize(bot, message)
        @bot = bot
        @message = message
      end

      def call
        MarketPriceWatcher::UseCases::ShowMenu.new(bot, message).call
      end
    end
  end
end
