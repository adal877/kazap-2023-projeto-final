# frozen_string_literal: true

require 'sequel'

# Account model
class Account < Sequel::Model
  attr_accessor :db

  plugin :validation_helpers

  self.raise_on_save_failure = true

  def initialize
    super
    @db = Sequel.sqlite('../db/bank.db')
  end

  def self.accounts_as_options
    accounts = []
    @db[:accounts].all.each do |account|
      accounts << {
        value: account[:id],
        name: account[:account_number]
      }
    end
    accounts
  end

  def validate
    validates_presence %i[client_id bank_id address_id account_number]
  end
end
