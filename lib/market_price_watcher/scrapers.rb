Dir.glob("#{__dir__}/scrapers/*_scraper.rb").each(&method(:require))
