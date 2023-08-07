# frozen_string_literal: true

require 'sequel'
require 'dotenv'
require 'logger'

# Load environment variables from .env file
Dotenv.load

DB_PATH = ENV['DB_LOCATION']
DB_NAME = ENV['DB_NAME']

LOG_LEVEL = case ENV['LOG_LEVEL']
            when 1
              Logger::INFO
            when 2
              Logger::WARN
            when 3
              Logger::ERROR
            when 4
              Logger::DEBUG
            when 5
              Logger::FATAL
            else
              $stdout
            end

# Enable query logging
# Sequel.sqlite(DB_PATH_NAME.to_s).loggers << Logger.new(LOG_LEVEL)
Sequel.sqlite("#{DB_PATH}/#{DB_NAME}").loggers << Logger.new(LOG_LEVEL)

require_relative 'models/account'
require_relative 'models/address'
require_relative 'models/bank'
require_relative 'models/client'
require_relative 'models/clients_telephone'
require_relative 'models/telephone'
require_relative 'models/transaction'
require_relative 'models/transactions_type'
