# frozen_string_literal: true

require 'tty-prompt'
require 'rainbow'
require 'sequel'
require 'dotenv'
require 'logger'
require_relative './utils/br_state'
require_relative './utils/functions'

# Load environment variables from .env file
Dotenv.load

DB_PATH = ENV['DB_LOCATION']
DB_NAME = ENV['DB_NAME']

LOG_LEVEL = case ENV['LOG_LEVEL']
            when 1
              Logger::INFO
            when 2
              Logger::WARN
            when 3
              Logger::ERROR
            when 4
              Logger::DEBUG
            when 5
              Logger::FATAL
            else
              $stdout
            end

# Enable query logging
DB = load_db("#{DB_PATH}/#{DB_NAME}")
DB.loggers << Logger.new(LOG_LEVEL)

require_relative 'models/account'
require_relative 'models/address'
require_relative 'models/bank'
require_relative 'models/client'
require_relative 'models/clients_telephone'
require_relative 'models/telephone'
require_relative 'models/transaction'
require_relative 'models/transactions_type'

DB = Sequel.sqlite('db/bank.db')

options = [
  { value: 1, name: 'Criar Registros' },
  { value: 2, name: 'Consultar Registros' },
  { value: 0, name: 'Sair' }
]



def telephones_as_options
  telephones = []
  DB[:telephones].all.each do |telephone|
    telephones << {
      value: telephone.id,
      name: "(#{telephone.code_area}) #{telephone.number}"
    }
  end
  telephones
end

def transactions_as_options
  transactions = []
  DB[:transactions].all.each do |transaction|
    transactions << {
      value: transaction.id,
      name: "#{transaction.transaction_amount}"
    }
  end
  transactions
end

def create_client
  clients_input = []
  prompt = TTY::Prompt.new

  loop do
    client = Client.new

    client.first_name = prompt.ask('Primeiro nome: ')
    client.last_name = prompt.ask('Sobrenome: ')
    client.document = prompt.ask('Documento: ')
    client.date_birth = Date.parse(prompt.ask('Data de nascimento (DD-MM-YYYY):'))

    clients_input << client if save_record?

    break unless add_more?
  end
end

def create_bank
  banks_input = []
  prompt = TTY::Prompt.new

  loop do
    bank = Bank.new

    bank.name = prompt.ask('Nome do banco: ')
    bank.full_name = prompt.ask('Nome completo do banco: ')
    bank.code = prompt.ask('Código do banco: ').to_i
    bank.ispb = prompt.ask('ISP do banco: ')

    banks_input << bank if save_record?

    break unless add_more?
  end
end

def create_account
  accounts_input = []
  prompt = TTY::Prompt.new

  loop do
    account = Account.new

    account.client_id = prompt.ask('ID do cliente: ').to_i
    account.bank_id = prompt.ask('ID do banco: ').to_i
    account.address_id = prompt.ask('ID do endereço: ').to_i
    account.email = prompt.ask('E-mail: ')
    account.account_number = prompt.ask('Número da conta: ').to_i
    account.initial_balance = prompt.ask('Saldo inicial: ').to_f

    accounts_input << account if save_record?

    break unless add_more?
  end
end

def create_telephone
  telephones_input = []
  prompt = TTY::Prompt.new

  loop do
    telephone = Telephone.new

    telephone.number = prompt.ask('Número de telefone: ').to_i
    telephone.code_area = prompt.ask('Código de área: ').to_i
    telephone.is_cellphone = prompt.yes?('É um celular?')

    telephones_input << telephone if save_record?

    break unless add_more?
  end
end

def create_transaction
  transactions_input = []
  prompt = TTY::Prompt.new

  loop do
    transaction = Transaction.new

    transaction.from_account_id = prompt.ask('ID da conta de origem: ').to_i
    transaction.to_account_id = prompt.ask('ID da conta de destino: ').to_i
    transaction.amount = prompt.ask('Valor da transação: ').to_f

    transactions_input << transaction if save_record?

    break unless add_more?
  end
end



def create_record
  create_record_options = [
    { value: 1, name: 'Endereço' },
    { value: 2, name: 'Cliente'  },
    { value: 3, name: 'Banco'    },
    { value: 4, name: 'Conta Bancária' },
    { value: 5, name: 'Telefone' },
    { value: 6, name: 'Transação' },
    { value: 7, name: '~ Exit ~' }
  ]

  prompt = TTY::Prompt.new

  clear
  create_record = prompt.select('', create_record_options)
  case create_record
  when 1
    # addressess = DB[:addresses]
    addresses_input = []
    loop do
      address = Address.new
      # While it is invalid keep asking for user input
      address.street = prompt.ask('Rua: ')
      address.city   = prompt.ask('Cidade: ')
      address.number = prompt.ask('Número: ').to_i
      address.state  = prompt.ask('Estado: ')
      # Check if the state input is valid by looking it up in the BRAZILIAN_STATES hash
      until BRAZILIAN_STATES.key?(address.state)
        puts 'Estado inválido. Por favor, digite um estado válido.'
        address.state = prompt.ask('Estado: ')
      end
      address.state_abbreviation = BRAZILIAN_STATES[address.state]
      (addresses_input << address) if save_record?

      break if add_more?
    end
  when 2
  when 3
    banks = DB[:banks]
    p banks.all
  when 4
    accounts = DB[:accounts]
    p accounts.all
  when 5
    telephones = DB[:telephones]
    p telephones.all
  when 6
    transactions = DB[:transactions]
    p transactions.all
  else
    return
  end
end

loop do
  prompt = TTY::Prompt.new
  clear

  user_choice = prompt.select('', options)
  case user_choice
  when 1
    loop do
      create_record
    end
    loop_pause
  when 2
    loop do
    end
    loop_pause
  else
    break
  end
end
