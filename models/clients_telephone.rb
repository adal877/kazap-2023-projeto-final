# frozen_string_literal: true

# Clients Telephones model
class ClientsTelephones < Sequel::Model
  attr_accessor :db

  plugin :validation_helpers
  many_to_one :client, key: :client_id, class: :Client
  many_to_one :telephone, key: :telephone_id, class: :Telephone

  self.raise_on_save_failure = true

  def initialize
    super
    @db = Sequel.sqlite('../db/bank.db')
  end

  def self.clients_telephones_as_options
    @db[:clients_telephones].all.each do |telephone|
    end
  end

  def validate
    validates_presence %i[client_id telephone_id]
  end
end
