require_relative 'base_action'

Dir.glob("#{__dir__}/**/*.rb").sort.each(&method(:require))
