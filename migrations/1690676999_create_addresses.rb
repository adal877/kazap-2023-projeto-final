# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :addresses do
      primary_key :id
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
      String   :street, null: false
      String   :city, null: false
      String   :number, null: false
      String   :state, null: false
      String   :state_abbreviation, null: false
    end
  end
end
