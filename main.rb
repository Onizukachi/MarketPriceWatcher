require 'dotenv'
require 'byebug'
require_relative 'lib/market_prices_watcher'

Dotenv.load

bot = MarketPriceWatcher::BotRunner.new
bot.start
