Dir.glob("#{__dir__}/**/*_handler.rb").sort.each(&method(:require))
