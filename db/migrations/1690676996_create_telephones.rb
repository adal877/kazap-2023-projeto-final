# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :telephones do
      primary_key :id
      DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
      String     :number, null: false
      String     :code_area, null: false
      Boolean    :is_cellphone, default: true
    end
  end
end
