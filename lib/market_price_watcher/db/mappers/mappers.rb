require_relative 'base_mapper'

Dir.glob("#{__dir__}/**/*_mapper.rb").sort.each(&method(:require))
