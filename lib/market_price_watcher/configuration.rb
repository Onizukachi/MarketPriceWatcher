module MarketPriceWatcher
  class Configuration
    attr_accessor :telegram_token, :proxy_url, :storage, :markets

    def initialize
      @telegram_token = '7793281977:AAGN5f1VsrQyvJUwSeXD8_Tk2nQ_DDLHo5Q'
      @proxy_url = 'socks://89.22.238.204:43555'
      @markets = %w[ozon wildberries]
      @storage = MarketPriceWatcher::Storages::SqliteDB
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)
    end
  end
end
