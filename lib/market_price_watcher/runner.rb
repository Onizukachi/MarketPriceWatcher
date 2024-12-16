require 'telegram/bot'

module MarketPriceWatcher
  class BotRunner
    attr_reader :bot, :message_sender, :message_handler, :callback_handler

    def initialize
      @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
      @message_sender = MarketPriceWatcher::MessageSender.new(bot)
      @message_handler = MarketPriceWatcher::Handlers::TextMessageHandler.new(message_sender)
      @callback_handler = MarketPriceWatcher::Handlers::CallbackHandler.new(message_sender)
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
