# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :transactions_types do
      primary_key :id
      String      :code, null: false
    end
  end
end
