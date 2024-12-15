Dir.glob("#{__dir__}/**/*.rb").sort.each(&method(:require))
