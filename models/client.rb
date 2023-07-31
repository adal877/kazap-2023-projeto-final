# frozen_string_literal: true

# Client model
class Client < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def validate
    super
    validates_presence %i[first_name last_name document date_birth]
    validates_unique :document
    validates_format /^((\d{3}-?\d{3}-?\d{3}-?\d{2})|(\d{14}))$/i, :document
  end
end
