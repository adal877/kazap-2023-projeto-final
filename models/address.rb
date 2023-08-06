# frozen_string_literal: true

require 'sequel'
require 'sqlite3'

# Address model
class Address < Sequel::Model
  attr_accessor :db

  plugin :validation_helpers

  self.raise_on_save_failure = true

  # def initialize
  #   super
  #   # begin
  #   #   @db = Sequel.sqlite('../db/bank.db')
  #   # rescue SQLite3::CantOpenException => e
  #   #   puts e.message
  #   # end
  # end

  def self.addresses_as_options(addresses)
    if addresses.all.empty?
      puts 'Nenhum registro encontrado!'
    else
      addresses.all.map do |address|
        {
          value: address[:id],
          name: "#{address[:street]}, #{address[:city]}. #{address[:number]}"
        }
      end
    end
  end

  def validate
    super
    validates_presence %i[street city number state state_abbreviation]
  end
end
