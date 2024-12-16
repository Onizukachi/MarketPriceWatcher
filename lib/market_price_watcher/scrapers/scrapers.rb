require_relative 'base_scraper'

Dir.glob("#{__dir__}/**/*_scraper.rb").sort.each(&method(:require))
