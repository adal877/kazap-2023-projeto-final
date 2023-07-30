# frozen_string_literal: true

# Bank model
class Bank < Sequel::Model
  plugin :validation_helpers
  one_to_one :address

  def validate
    super
    validates_presence %i[address_id name full_name code ispb]
    validates_unique :code
    validates_unique :ispb
    validates_integer :code
    validates_format /^\d{8}$/, :ispb
  end
end
