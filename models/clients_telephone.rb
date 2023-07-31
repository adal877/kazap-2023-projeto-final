# frozen_string_literal: true

# Clients Telephones model
class ClientsTelephones < Sequel::Model
  plugin :validation_helpers
  many_to_one :client, key: :client_id, class: :Client
  many_to_one :telephone, key: :telephone_id, class: :Telephone

  self.raise_on_save_failure = true

  def validate
    validates_presence %i[client_id telephone_id]
  end
end
