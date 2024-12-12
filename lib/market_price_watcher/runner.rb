require 'telegram/bot'

module MarketPriceWatcher
  class BotRunner
    attr_reader :bot, :message_handler, :callback_handler

    def initialize
      @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
      @message_handler = MarketPriceWatcher::TextMessageHandler.new(bot)
      @callback_handler = MarketPriceWatcher::CallbackHandler.new(bot)
    end

    def start
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          message_handler.process(message)
        when Telegram::Bot::Types::CallbackQuery
          callback_handler.process(message)
        end
      end
    end
  end
end
