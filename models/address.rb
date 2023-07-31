# frozen_string_literal: true

# Address model
class Address < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def validate
    super
    validates_presence %i[street city number state state_abbreviation]
  end
end
