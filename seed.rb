# frozen_string_literal: true

require 'faker'

require_relative 'dependencies'

# Enable query logging
# By default, uses DEBUG for seed.
Sequel.sqlite("#{DB_PATH}/#{DB_NAME}").loggers << Logger.new(Logger::DEBUG)

SEED_RECORDS_AMOUNT = ENV['SEED_RECORDS_AMOUNT'].to_i

begin
  # Seed data for clients table
  SEED_RECORDS_AMOUNT.times do
    Client.create(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      document: Faker::IDNumber.brazilian_citizen_number.to_s,
      date_birth: Faker::Date.birthday(min_age: 18, max_age: 65)
    )
  end

  # Seed data for addresses table
  SEED_RECORDS_AMOUNT.times do
    Address.create(
      street: Faker::Address.street_address.to_s,
      city: Faker::Address.city.to_s,
      number: Faker::Address.building_number,
      state: Faker::Address.state.to_s,
      state_abbreviation: Faker::Address.state_abbr.to_s
    )
  end

  # Seed data for banks table
  SEED_RECORDS_AMOUNT.times do
    Bank.create(
      name: Faker::Bank.name,
      full_name: Faker::Bank.name,
      code: Faker::Number.between(from: 1, to: 1000),
      ispb: Faker::Number.number(digits: 8).to_s,
      address_id: Address.order(Sequel.lit('RANDOM()')).first.id
    )
  end

  # Seed data for telephones table
  SEED_RECORDS_AMOUNT.times do
    Telephone.create(
      number: Faker::PhoneNumber.phone_number.to_i,
      code_area: Faker::Number.number(digits: 2).to_i,
      is_cellphone: [true, false].sample
    )
  end

  # Seed data for client_telephones table
  SEED_RECORDS_AMOUNT.times do
    ClientsTelephones.create(
      client_id: Client.order(Sequel.lit('RANDOM()')).first.id,
      telephone_id: Telephone.order(Sequel.lit('RANDOM()')).first.id
    )
  end

  # Seed data for accounts table
  SEED_RECORDS_AMOUNT.times do
    Account.create(
      client_id: Client.order(Sequel.lit('RANDOM()')).first.id,
      bank_id: Bank.order(Sequel.lit('RANDOM()')).first.id,
      address_id: Address.order(Sequel.lit('RANDOM()')).first.id,
      email: Faker::Internet.email,
      account_number: Faker::Number.number(digits: 6).to_i,
      initial_balance: Faker::Number.decimal(l_digits: 4, r_digits: 2)
    )
  end

  # Seed data for transaction_type table
  transaction_types = [
    { code: 'P' },
    { code: 'T' },
    { code: 'W' }
  ]

  transaction_types.each do |type|
    TransactionsType.create(
      code: type[:code]
    )
  end

  # Seed data for transactions table
  SEED_RECORDS_AMOUNT.times do
    Transaction.create(
      from_account_id: Account.order(Sequel.lit('RANDOM()')).first.id,
      to_account_id: Account.order(Sequel.lit('RANDOM()')).first.id,
      transaction_type_id: TransactionsType.order(Sequel.lit('RANDOM()')).first.id,
      transaction_amount: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    )
  end
rescue StandardError => e
  retry if e.message == 'code is already taken'
  puts '########## Error ##########'
  puts "Message: #{e.message}"
  puts "Backtrace: #{e.backtrace}"
  p e
  puts '###########################'
ensure
  puts "Generated #{SEED_RECORDS_AMOUNT} record(s)"
  puts 'Seed finalized'
end
