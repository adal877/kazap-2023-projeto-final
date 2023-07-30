# frozen_string_literal: true

# Telephone model
class Telephone < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence %i[number code_area is_cellphone]
    validates_boolean is_cellphone
    validates_integer code_area
    validates_integer number
  end
end
