module MarketPriceWatcher
  class TextMessageHandler
    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def process(message)
      case message.text
      when '/start'
        MarketPriceWatcher::UseCases::Start.new(bot, message).call
      when '/stop'
        MarketPriceWatcher::UseCases::Stop.new(bot, message).call
      when '/menu'
        MarketPriceWatcher::UseCases::ShowMenu.new(bot, message).call
      when /Мои товары/
        MarketPriceWatcher::UseCases::MyProducts.new(bot, message).call
      when /Добавить товары/
        MarketPriceWatcher::UseCases::AddProduct.new(bot, message).call
      when /Помощь/
        MarketPriceWatcher::UseCases::Help.new(bot, message).call
      else
        MarketPriceWatcher::UseCases::UrlHandler.new(bot, message).call
      end
    end
  end
end
