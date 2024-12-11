require 'telegram/bot'

module MarketPriceWatcher
  class BotRunner
    attr_reader :bot, :storage, :commands_handler

    def initialize
      @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
      user_repository = MarketPriceWatcher::Repositories::UserRepository.new
      product_repository = MarketPriceWatcher::Repositories::ProductRepository.new

      @commands_handler = MarketPriceWatcher::CommandsHandler.new(bot, user_repository, product_repository)
    end

    def start
      bot.listen do |message|
        commands_handler.process(message)
      end
    end
  end
end
