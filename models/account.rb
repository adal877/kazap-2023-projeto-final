# frozen_string_literal: true

# Account model
class Account < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def validate
    validates_presence %i[client_id bank_id address_id account_number]
  end
end
