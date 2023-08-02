# frozen_string_literal: true

# Address model
class Address < Sequel::Model
  attr_accessor :db

  plugin :validation_helpers

  self.raise_on_save_failure = true

  def initialize
    super
    @db = Sequel.sqlite('../db/bank.db')
  end

  def self.addressess_as_options
    addresses = []
    @db[:addresses].all.each do |address|
      addresses << {
        value: address[:id],
        name: "#{address[:street]}, #{address[:city]}. #{address[:number]}"
      }
    end
    addresses
  end

  def validate
    super
    validates_presence %i[street city number state state_abbreviation]
  end
end
