require_relative 'base_adapter'

Dir.glob("#{__dir__}/**/*_adapter.rb").sort.each(&method(:require))
