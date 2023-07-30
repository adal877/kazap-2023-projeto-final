# frozen_string_literal: true

# Clients Telephones model
class ClientsTelephones < Sequel::Model
  plugin :validation_helpers
  many_to_one :client, key: :client_id, class: :Client
  many_to_one :telephone, key: :telephone_id, class: :Telephone

  def validate
    validates_presence %i[client_id telephone_id]
  end
end
