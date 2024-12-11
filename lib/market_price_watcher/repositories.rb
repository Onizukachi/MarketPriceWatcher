Dir.glob("#{__dir__}/repositories/**/*_repository.rb").each(&method(:require))
