# frozen_string_literal: true

require 'sequel'
require 'sqlite3'

# Address model
class Address < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def self.addresses_as_options
    addresses = Address.all
    if addresses.empty?
      puts 'Nenhum registro encontrado!'
    else
      addresses.map do |address|
        {
          value: address[:id],
          name: "#{address[:street]}, #{address[:city]}. #{address[:number]}"
        }
        addresses << {
          value: -1, name: '~ Sair ~'
        }
      end
    end
  end

  def validate
    super
    validates_presence %i[street city number state state_abbreviation]
  end
end
