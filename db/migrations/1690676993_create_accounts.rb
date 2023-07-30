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
      Integer     :account_number, null: false
      Integer     :initial_balance, null: false
    end
  end
end
