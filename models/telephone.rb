# frozen_string_literal: true

# Telephone model
class Telephone < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def validate
    validates_presence %i[number code_area is_cellphone]
    validates_includes [true, false], :is_cellphone, message: 'is_cellphone must be true or false'
  end
end
