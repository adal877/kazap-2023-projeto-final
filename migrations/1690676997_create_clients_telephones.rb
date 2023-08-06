# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :clients_telephones do
      primary_key :id
      foreign_key :client_id, :clients, null: false
      foreign_key :telephone_id, :telephones, null: false
    end
  end
end
