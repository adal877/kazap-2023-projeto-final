# frozen_string_literal: true

Sequel.migration do
	change do
		create_table :transactions_types do
			primary_key :id
			foreign_key :transaction_id, :transactions, null: false
			String      :name, null: false
			String      :code, null: false
		end
	end
end
