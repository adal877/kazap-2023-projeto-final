# frozen_string_literal: true

# Telephone model
class Telephone < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def self.telephones_as_options
    records = []
    Telephone.all.each do |telephone|
      records << {
        value: telephone[:id].to_i,
        name: "#{telephone[:code_area]} - #{telephone[:number]}"
      }
    end
    records << {
      value: -1,
      name: '~ Sair ~'
    }
    records
  end

  def validate
    validates_presence %i[number code_area is_cellphone]
    validates_includes [true, false], :is_cellphone, message: 'is_cellphone must be true or false'
  end
end
