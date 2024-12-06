require 'telegram/bot'

module MarketPriceWatcher
  class BotRunner
    attr_reader :bot, :storage, :message_handler

    def initialize
      @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
      @storage = MarketPriceWatcher.config.storage.new
      @message_handler = MessageHandler.new(bot, storage)
    end

    def start
      bot.listen do |message|
        message_handler.process(message)
      end
    ensure
      storage.close
    end
  end
end
