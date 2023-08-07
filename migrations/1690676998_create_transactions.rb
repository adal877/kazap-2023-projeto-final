# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :transactions do
      primary_key :id
      foreign_key :from_account_id, :accounts, null: false
      foreign_key :to_account_id, :accounts, null: false
      foreign_key :transaction_type_id, :transactions, null: false
      Decimal     :transaction_amount, null: false
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
    end
  end
end
