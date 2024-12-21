# frozen_string_literal: true

module MarketPriceWatcher
  class Configuration
    attr_accessor :telegram_token, :proxy_url, :track_interval

    def initialize
      @telegram_token = ENV["TELEGRAM_BOT_TOKEN"]
      @proxy_url = ENV["PROXY_URL"]
      @track_interval = ENV["TRACKING_INTERVAL"]
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
