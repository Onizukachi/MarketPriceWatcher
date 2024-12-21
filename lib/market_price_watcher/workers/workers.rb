# frozen_string_literal: true

Dir.glob("#{__dir__}/**/*_worker.rb").sort.each(&method(:require))
