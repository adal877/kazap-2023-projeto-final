# frozen_string_literal: true

# Client model
class Client < Sequel::Model
  attr_accessor :db

  plugin :validation_helpers

  self.raise_on_save_failure = true

  def initialize
    super
    @db = Sequel.sqlite('../db/bank.db')
  end

  def self.clients_as_options
    clients = []
    @db[:clients].all.each do |client|
      clients << {
        value: client[:id],
        name: "#{client[:first_name]}, #{client[:last_name]}"
      }
    end
    clients
  end

  def validate
    super
    validates_presence %i[first_name last_name document date_birth]
    validates_unique :document
    validates_format /^((\d{3}-?\d{3}-?\d{3}-?\d{2})|(\d{14}))$/i, :document
  end
end
