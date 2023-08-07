# frozen_string_literal: true

require 'tty-prompt'
require 'sequel'
require 'sqlite3'
require 'dotenv'
require 'logger'
require 'uuid'
require_relative 'utils/functions'

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

require_relative 'models/client'
require_relative 'models/account'
require_relative 'models/bank'
require_relative 'models/address'
require_relative 'models/telephone'
require_relative 'models/clients_telephone'
require_relative 'models/transaction'
require_relative 'models/transactions_type'
require_relative 'utils/br_state'

# The base UI class
class UI
  def initialize
    @prompt = TTY::Prompt.new
    @main_menu_options = [
      { name: 'Criar Registros', value: :create_records },
      { name: 'Consultar Registros', value: :get_records },
      { name: 'Depositar na conta', value: :deposit_account },
      { name: 'Sacar da conta', value: :withdrawl_account },
      { name: 'Excluir Registros', value: :exclude_records },
      { name: 'Exportar transações', value: :export_transactions },
      { name: '~ Sair ~', value: :exit }
    ]
    @record_options = [
      { value: :address, name: 'Endereço' },
      { value: :client, name: 'Cliente'  },
      { value: :bank, name: 'Banco'    },
      { value: :bank_account, name: 'Conta Bancária' },
      { value: :telephone, name: 'Telefone' },
      { value: :transaction, name: 'Transação' },
      { value: :exit, name: '~ Sair ~' }
    ]
    @export_transactions_options = [
      { value: :csv, name: 'csv' },
      { value: :json, name: 'json' },
      { value: :exit, name: '~ Sair ~' }
    ]
  end

  def main_menu
    loop do
      clear
      action = @prompt.select('O que voce gostaria de fazer?', @main_menu_options)
      case action
      when :create_records
        create_records
      when :deposit_account
        deposit
      when :withdrawl_account
        withdrawl
      when :export_transactions
        export_transactions
      when :get_records
        records
      else
        break
      end
    end
  end

  def deposit
    clear
    user_account = view_accounts('Selecione a conta para depósito: ')
    account = Account[user_account]
    amount = @prompt.ask('Valor: ').to_f
    if amount.negative?
      puts "O valor #{amount} é inválido!"
    else
      account.initial_balance += amount
      account.save
    end
  end

  def withdrawl
    clear
    user_account = view_accounts('Selecione a conta para saque: ')
    account = Account[user_account]
    amount = @prompt.ask('Valor: ').to_f
    if amount > account.initial_balance
      puts "O valor #{amount} é maior que o contído em conta"
    else
      account.initial_balance -= amount
      account.save
    end
  end

  def exclude_records
    loop do
      clear
      action = @prompt.select('Selecione o registro a ser alterado: ', @record_options)
      case action
      when :address
        Address.exclude(
          view_addresses('Selecione o endereço a ser deletado: ')
        )
      when :client
        Client.exclude(
          view_clients('Selecione o cliente a ser deletado: ')
        )
      when :bank
        Bank.exclude(
          view_banks('Selecione o banco a ser excluído: ')
        )
      when :bank_account
        Account.exclude(
          view_accounts('Selecione a conta a ser excluída: ')
        )
      when :telephone
        Telephone.exclude(
          view_telephones('Selecione o telefone a ser deletado: ')
        )
      when :transaction
        Transaction.exclude(
          view_transactions('Selecione a transação a ser excluída: ')
        )
      else
        break
      end
    end
  end

  def export_transactions
    loop do
      clear
      action = @prompt.select('Qual formato gostaria de exportar?')
      transaction = view_user_transactions_detailed
      case action
      when :csv
        build_csv(transaction)
      when :json
        build_json(transaction)
      else
        break
      end
    end
  end

  def create_records
    loop do
      clear
      action = @prompt.select('Selecione um registro...', @record_options)
      case action
      when :address
        create_addresses
      when :client
        create_clients
      when :bank
        create_banks
      when :bank_account
        create_accounts
      when :telephone
        create_telephones
      when :transaction
        create_transactions
      else
        break
      end
    end
  end

  def records
    loop do
      action = @prompt.select('Selecione um registro...', @record_options)
      case action
      when :address
        view_addresses(nil)
      when :client
        view_clients(nil)
      when :bank
        view_banks(nil)
      when :bank_account
        view_accounts(nil)
      when :telephone
        view_telephones(nil)
      when :transaction
        view_transactions(nil)
      else
        break
      end
      loop_pause
    end
  end

  private

  def create_addresses
    loop do
      address = Address.new
      address.street = @prompt.ask('Rua: ')
      address.city   = @prompt.ask('Cidade: ')
      address.number = @prompt.ask('Número: ').to_i
      address.state  = @prompt.ask('Estado: ')
      # Check if the state input is valid by looking it up in the BRAZILIAN_STATES hash
      until BRAZILIAN_STATES.key?(address.state)
        puts 'Estado inválido. Por favor, digite um estado válido.'
        address.state = @prompt.ask('Estado: ')
      end
      address.state_abbreviation = BRAZILIAN_STATES[address.state]
      address.save if save_record?
      break if add_more?
    end
  end

  def create_clients
    loop do
      begin
        client = Client.new
        client.first_name = @prompt.ask('Primeiro nome: ')
        client.last_name  = @prompt.ask('Sobrenome: ')
        client.date_birth = Date.parse(@prompt.ask('Data de nascimento (DD-MM-YYYY):'))
        client.document   = @prompt.ask('Documento [cpf/cnpj]: ')
      rescue StandardError => e
        puts e.message
        retry
      end
      client.save if save_record?
      break if add_more?
    end
  end

  def create_banks
    loop do
      bank = Bank.new
      bank.name = @prompt.ask('Nome do banco: ')
      bank.full_name = @prompt.ask('Nome completo do banco: ')
      bank.code = @prompt.ask('Código do banco: ').to_i
      bank.ispb = @prompt.ask('ISP do banco: ')
      bank.address_id = view_addresses('Selecione um endereço: ')
      bank.save if save_record?
      break if add_more?
    end
  end

  def create_accounts
    loop do
      account = Account.new
      account.client_id = view_clients('Selecione um cliente:')
      account.bank_id = view_banks('Selecione um banco:')
      account.address_id = view_addresses('Selecione um endereço:')
      account.email = @prompt.ask('E-mail: ')
      account.save if save_record?
      break if add_more?
    end
  end

  def create_telephones
    loop do
      telephone = Telephone.new
      telephone.number = @prompt.ask('Número de telefone: ').to_i
      telephone.code_area = @prompt.ask('Código de área: ').to_i
      telephone.is_cellphone = @prompt.yes?('É um celular?')
      telephone.save if save_record?
      break if add_more?
    end
  end

  def create_transactions
    loop do
      transaction = Transaction.new
      if view_accounts.empty?
        puts 'Nenhuma conta criada'
      else
        transaction.from_account_id = view_accounts('Da conta -> : ')
        transaction.to_account_id   = view_accounts('Para a conta <-: ')
        transaction.transaction_type_id = view_transactions_types('Qual o tipo de transação? ')
        transaction.transaction_amount = @prompt.ask('O valor: ').to_f
        if save_record?
          if Bank.make_transaction(
            transaction.from_account_id,
            transaction.to_account_id,
            transaction.transaction_amount
          )
            transaction.save
          end
        end
        break if add_more?
      end
    end
  end

  def view_addresses(message)
    message ||= 'Endereços'
    options = Address.addresses_as_options.empty? ? [{ value: -1, name: 'Nenhum registro' }] : Address.addresses_as_options
    @prompt.select(message, options).to_i
  end

  def view_clients(message)
    message ||= 'Clientes'
    options = Client.clients_as_options.empty? ? [{ value: -1, name: 'Nenhum registro' }] : Client.clients_as_options
    @prompt.select(message, options).to_i
  end

  def view_banks(message)
    message ||= 'Bancos'
    options = Bank.banks_as_options.empty? ? [{ value: -1, name: 'Nenhum registro' }] : Bank.banks_as_options
    @prompt.select(message, options).to_i
  end

  def view_accounts(message)
    message ||= 'Contas'
    options = Account.accounts_as_options.empty? ? [{ value: -1, name: 'Nenhum registro' }] : Account.accounts_as_options
    @prompt.select(message, options).to_i
  end

  def view_telephones(message)
    message ||= 'Telefones'
    options = Telephone.telephones_as_options.empty? ? [{ value: -1, name: 'Nenhum registro' }] : Telephone.telephones_as_options
    @prompt.select(message, options).to_i
  end

  def view_transactions(message)
    message ||= 'Transações'
    options = Transaction.transactions_as_options.empty? ? [{ value: -1, name: 'Nenhum registro' }] : Transaction.transactions_as_options
    @prompt.select(message, options).to_i
  end

  def view_transactions_types(message)
    message ||= 'Tipos de Transações'
    options = TransactionsType.transactions_types_as_options.empty? ? [{ value: -1, name: 'Nenhum registro' }] : TransactionsType.transactions_types_as_options
    @prompt.select(message, options).to_i
  end

  def view_user_transactions_detailed
    user_account_number = @prompt.ask('Digite o número da sua conta')
    user_accounts = Account.where(account_number: user_account_number).first
    transactions  = Transaction.where(Sequel.|(
      :from_account_id => user_account_number,
      :to_account_id   => user_account_number
    ))
    puts "Transactions for the account: #{user_account_number}"
    p transactions
  end

  def view_client_accounts
    client_id = @prompt.ask('Enter Client ID:')
    client = Client[client_id.to_i]

    if client.nil?
      puts 'Client not found.'
    else
      accounts = client.accounts

      if accounts.empty?
        puts 'No accounts found for this client.'
      else
        puts 'Accounts:'
        accounts.each do |account|
          puts "ID: #{account.id}, Account Number: #{account.account_number}, Balance: #{account.initial_balance}"
        end
      end
    end
  end

  def clear
    system 'clear'
  end

  def loop_pause
    gets.chomp
  end

  def save_record?
    @prompt.yes?('Gostaria de salvar o registro?')
  end

  def add_more?
    @prompt.no?('Deseja adicionar outro registro?')
  end

  def case_insensitive_include?(hash, key)
    key_downcase = key.downcase
    hash.keys.any? { |k| k.downcase == key_downcase }
  end

  def build_json(data, data_context)
    file_name = "#{data_context}_#{UUID.new.generate}.json"
    begin
      json_data = JSON.generate(data)
      File.open(file_name, 'w') do |file|
        file.write(json_data)
      end
    rescue StandardError => e
      puts "Failed to create the file '#{file_name}'"
      puts e.message
    end
  end

  def build_csv(data)
    file_name = "#{data_context}_#{UUID.new.generate}.json"
    begin
      CSV.open(file_name, 'w') do |csv|
        data.each do |row|
          csv << row
        end
      end
    rescue StandardError => e
      puts "Failed to create the file '#{file_name}'"
      puts e.message
    end
  end
end

# Call the main menu to start the application
UI.new.main_menu
