require 'rufus-scheduler'
require 'singleton'

module MarketPriceWatcher
  class Scheduler
    include Singleton

    def initialize
      @scheduler = Rufus::Scheduler.new
    end

    def method_missing(method_name, *args, &block)
      if @scheduler.respond_to?(method_name)
        @scheduler.public_send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @scheduler.respond_to?(method_name) || super
    end
  end
end
