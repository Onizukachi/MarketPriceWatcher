require_relative 'base_repository'

Dir.glob("#{__dir__}/**/*_repository.rb").sort.each(&method(:require))
