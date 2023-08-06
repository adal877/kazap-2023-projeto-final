# frozen_string_literal: true

Sequel.migration do
	change do
		create_table :banks do
			primary_key :id
			foreign_key :address_id, :addresses, null: false
			DateTime    :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
			String      :name, null: false
			String      :full_name, null: false
			String      :ispb, null: false
			Integer     :code, null: false
		end
	end
end
