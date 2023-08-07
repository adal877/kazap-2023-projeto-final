# frozen_string_literal: true

# Clients Telephones model
class ClientsTelephones < Sequel::Model
  plugin :validation_helpers
  many_to_one :client, key: :client_id, class: :Client
  many_to_one :telephone, key: :telephone_id, class: :Telephone

  self.raise_on_save_failure = true

  def self.clients_telephones_as_options
    records = []
    ClientsTelephones.all.each do |client_telephone|
      records << {
        value: client_telephone[:id],
        name: "Client id: #{client_telephone[:client_id]}. Telephone id: #{client_telephone[:telephone_id]}"
      }
    end
    records << {
      value: -1, name: '~ Sair ~'
    }
    records
  end

  def validate
    validates_presence %i[client_id telephone_id]
  end
end
