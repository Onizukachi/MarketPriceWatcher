# frozen_string_literal: true

module MarketPriceWatcher
  class MessageSender
    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def call(**args)
      bot.api.send_message(args)
    end
  end
end
