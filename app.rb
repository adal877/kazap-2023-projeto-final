# frozen_string_literal: true

require 'sequel'
require 'dotenv'

DB_PATH = ENV['DB_LOCATION']
DB_NAME = ENV['DB_NAME']

Sequel.sqlite("#{DB_PATH}/#{DB_NAME}")

require_relative 'models/account'
require_relative 'models/address'
require_relative 'models/bank'
require_relative 'models/client'
require_relative 'models/clients_telephone'
require_relative 'models/telephone'
require_relative 'models/transaction'
require_relative 'models/transactions_type'
