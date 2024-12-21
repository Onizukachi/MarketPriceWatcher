# frozen_string_literal: true

Dir.glob("#{__dir__}/**/*_handler.rb").sort.each(&method(:require))
