module MarketPriceWatcher
  class MessageHandler
    attr_reader :bot, :storage

    def initialize(bot, storage)
      @bot = bot
      @storage = storage
    end

    def process(message)
      case message.text
      when '/start'
        user_full_name = "#{message.from.first_name} #{message.from.last_name}"
        send_message(message.from.id, "Hello #{user_full_name} 👋")
      when '/menu'
        reply_buttons = [[{ text: "\u{1F4E6} Мои товары" }],
                         [{ text: "\u{2795} Добавить товары" }],
                         [{ text: "\u{2753} О боте / Помощь" }]]

        reply_buttons_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: reply_buttons, resize_keyboard: true)
        send_message(message.from.id, 'Here are your reply buttons', reply_buttons_markup)
      when '/add_product'
        # kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
        # bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
        # byebug
        # products = storage.list_products(message.from.id)
        #
        # return if products.include?(message.text)
        #
        # product_data = MarketPriceWatcher::Scrapers::WbScraper.get_product_details(extract_product_id(@message.text))
      else
        if valid_url?(message.text)
          scraper = MarketPriceWatcher::ScraperFactory.create(message.text)
          product = scraper.get_product_details
        end

        byebug
      end
    end

    private

    def valid_url?(url)
      url.match?(/^https?:\/\//)
    end

    def send_message(chat_id, message, reply_markup = nil)
      bot.api.send_message(chat_id: chat_id, text: message, reply_markup: reply_markup)
    end
  end
end
