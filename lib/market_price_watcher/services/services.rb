Dir.glob("#{__dir__}/**/*_service.rb").sort.each(&method(:require))
