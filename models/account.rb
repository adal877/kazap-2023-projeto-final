# frozen_string_literal: true

require 'sequel'
require 'uuid'

# Account model
class Account < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def self.accounts_as_options
    records = []
    Account.all.each do |account|
      records << {
        value: account[:id],
        name: "Number: #{account[:account_number]}. Balance: #{account[:initial_balance]}"
      }
    end
    records << {
      value: -1, name: '~ Sair ~'
    }
    records
  end

  def validate
    validates_presence %i[client_id bank_id address_id email]
    validates_unique :email
  end

  def before_create
    self.account_number = UUID.new.generate
    super
  end
end
