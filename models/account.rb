# frozen_string_literal: true

require 'sequel'

# Account model
class Account < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def self.accounts_as_options
    accounts = Account.all
    if accounts.empty?
      puts 'Nenhum registro encontrado!'
    else
      accounts.each do |account|
        accounts << {
          value: account[:id],
          name: account[:account_number]
        }
        accounts << {
          value: -1, name: '~ Sair ~'
        }
      end
    end
  end

  def validate
    validates_presence %i[client_id bank_id address_id account_number]
  end
end
