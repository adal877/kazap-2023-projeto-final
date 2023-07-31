# frozen_string_literal: true

# Transaction model
class Transaction < Sequel::Model
  plugin :validation_helpers
  many_to_one :account, key: :from_account_id, class: :Account
  many_to_one :account, key: :to_account_id, class: :Account
  one_to_one :transactions_type, key: :transaction_type_id

  self.raise_on_save_failure = true

  def validate
    validates_presence %i[from_account_id transaction_type_id to_account_id transaction_amount]
  end
end
