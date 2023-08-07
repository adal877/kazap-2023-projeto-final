# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :accounts do
      primary_key :id
      foreign_key :client_id, :clients, null: false
      foreign_key :bank_id, :banks, null: false
      foreign_key :address_id, :addresses, null: false
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
      String      :email
      String     :account_number, null: false
      Float     :initial_balance, default: 100
    end
  end
end
