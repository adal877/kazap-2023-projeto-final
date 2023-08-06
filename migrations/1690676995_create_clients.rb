# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :clients do
      primary_key :id
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
      String   :first_name, null: false
      String   :last_name, null: false
      String   :document, null: false
      Date     :date_birth, null: false
    end
  end
end
