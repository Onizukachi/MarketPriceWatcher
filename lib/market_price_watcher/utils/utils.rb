# frozen_string_literal: true

Dir.glob("#{__dir__}/**/*.rb").sort.each(&method(:require))
