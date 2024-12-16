module MarketPriceWatcher
  module Utils
    class DaysUntilToday
      def self.call(time)
        time = time.is_a?(Time) ? time : Time.parse(time)

        (Date.today - time.to_date).to_i
      end
    end
  end
end
