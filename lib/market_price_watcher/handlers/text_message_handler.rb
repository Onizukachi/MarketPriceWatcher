module MarketPriceWatcher
  class TextMessageHandler
    attr_reader :bot, :message_sender

    def initialize(bot, message_sender: MarketPriceWatcher::MessageSender)
      @bot = bot
      @message_sender = message_sender.new(bot)
    end

    def process(message)
      case message.text
      when '/start'
        MarketPriceWatcher::Actions::Start.new(message, message_sender).call
      when '/stop'
        MarketPriceWatcher::Actions::Stop.new(message, message_sender).call
      when '/menu'
        MarketPriceWatcher::Actions::ShowMenu.new(message, message_sender).call
      when /Мои товары/
        MarketPriceWatcher::Actions::ShowProducts.new(message, message_sender).call
      when /Добавить товары/
        MarketPriceWatcher::Actions::AddProduct.new(message, message_sender).call
      when /Помощь/
        MarketPriceWatcher::Actions::Help.new(message, message_sender).call
      else
        MarketPriceWatcher::Actions::UrlHandler.new(message, message_sender).call
      end
    end
  end
end
