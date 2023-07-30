# frozen_string_literal: true

# Account model
class Account < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence %i[client_id bank_id address_id account_number]
  end
end
