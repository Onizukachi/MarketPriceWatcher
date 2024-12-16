require_relative 'base_adapter'

Dir.glob("#{__dir__}/**/*.rb").sort.each(&method(:require))
