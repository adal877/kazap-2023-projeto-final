# frozen_string_literal: true

require 'sequel'
require 'sqlite3'

# Client model
class Client < Sequel::Model
  plugin :validation_helpers

  self.raise_on_save_failure = true

  def self.clients_as_options
    records = []
    Client.all.each do |client|
      records << {
        value: client[:id].to_i,
        name: "#{client[:first_name]} #{client[:last_name]}, #{client[:document]}"
      }
    end
    records << {
      value: -1,
      name: '~ Sair ~'
    }
    records
  end

  def validate
    super
    validates_presence %i[first_name last_name document date_birth]
    validates_unique :document
    validates_format /^((\d{3}-?\d{3}-?\d{3}-?\d{2})|(\d{14}))$/i, :document
  end
end
