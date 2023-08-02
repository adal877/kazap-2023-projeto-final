# frozen_string_literal: true

# Bank model
class Bank < Sequel::Model
  attr_accessor :db

  plugin :validation_helpers
  one_to_one :address

  self.raise_on_save_failure = true

  def initialize
    super
    @db = Sequel.sqlite('../db/bank.db')
  end

  def self.banks_as_options
    banks = []
    @db[:banks].all.each do |bank|
      banks << {
        value: bank[:id],
        name: "#{bank[:full_name]}. #{bank[:ispb]}"
      }
    end
    banks
  end

  def validate
    super
    validates_presence %i[address_id name full_name code ispb]
    validates_unique :code
    validates_unique :ispb
    validates_integer :code
    validates_format /^\d{8}$/, :ispb
  end
end
