# frozen_string_literal: true

# Transaction model
class Transaction < Sequel::Model
  plugin :validation_helpers
  many_to_one :account, key: :from_account_id, class: :Account
  many_to_one :account, key: :to_account_id, class: :Account
  one_to_one :transactions_type, key: :transaction_type_id

  self.raise_on_save_failure = true

  def self.transactions_as_options
    records = []
    Transaction.all.each do |transaction|
      records << {
        value: transaction[:id].to_i,
        name: "#{transaction[:from_account_id]} -> #{transaction[:to_account_id]}: #{transaction[:transaction_amount]}."
      }
    end
    records << {
      value: -1,
      name: '~ Sair ~'
    }
    records
  end

  def validate
    validates_presence %i[from_account_id transaction_type_id to_account_id transaction_amount]
  end
end
