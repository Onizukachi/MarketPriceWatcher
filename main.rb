require_relative 'lib/market_price_watcher'

Dotenv.load

MarketPriceWatcher::DB::Migrator.new.apply

bot = MarketPriceWatcher::BotRunner.new
bot.start
