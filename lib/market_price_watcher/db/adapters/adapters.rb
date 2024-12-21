# frozen_string_literal: true

require_relative "base_adapter"

Dir.glob("#{__dir__}/**/*_adapter.rb").sort.each(&method(:require))
