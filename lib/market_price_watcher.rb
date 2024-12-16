require 'dotenv'
require 'dry-container'
require 'dry-auto_inject'
require 'byebug' # For testing

# App configuration
require_relative 'market_price_watcher/configuration'

# Core model
require_relative 'market_price_watcher/models/models'

# Database mappers
require_relative 'market_price_watcher/db/mappers/mappers'

# Database adapters
require_relative 'market_price_watcher/db/adapters/adapters'

# Database repositories
require_relative 'market_price_watcher/db/repositories/repositories'

# Network connection
require_relative 'market_price_watcher/network/connection'

# Data scrapers
require_relative 'market_price_watcher/scrapers/scrapers'
require_relative 'market_price_watcher/scraper_factory'

# Utils
require_relative 'market_price_watcher/utils/utils'

# Message sender
require_relative 'market_price_watcher/message_sender'

# Scheduler
require_relative 'market_price_watcher/scheduler'

# Workers
require_relative 'market_price_watcher/workers/workers'

# Services
require_relative 'market_price_watcher/services/services'

# DI Container
require_relative 'market_price_watcher/container'

# Database migrator
require_relative 'market_price_watcher/db/migrator'

# Request Handlers
require_relative 'market_price_watcher/handlers/handlers'

# Runner
require_relative 'market_price_watcher/runner'

