# frozen_string_literal: true

# Bank model
class Bank < Sequel::Model
  plugin :validation_helpers
  one_to_one :address

  self.raise_on_save_failure = true

  def self.banks_as_options
    records = []
    Bank.all.each do |bank|
      records << {
        value: bank[:id].to_i,
        name: "#{bank[:full_name]}. #{bank[:ispb]}"
      }
    end
    records << {
      value: -1,
      name: '~ Sair ~'
    }
    records
  end

  def self.make_transaction(from_id, to_id, value)
    from_account_id = Bank[from_id]
    to_account_id   = Bank[to_id]

    if from_account_id.initial_balance < value
      puts 'Valor da conta insuficiente'
    elsif value.negative?
      puts 'Valor inválido'
    else
      from_account_id.initial_balance -= value
      to_account_id.initial_balance += value
    end
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
