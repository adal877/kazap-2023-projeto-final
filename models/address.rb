# frozen_string_literal: true

# Address model
class Address < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence %i[street city number state state_abbreviation]
    validates_integer number
  end
end
