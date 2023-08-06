# frozen_string_literal: true

require 'logger'
require 'sequel'
require 'json'
require 'uuid'

def clear
  system 'clear'
end

def loop_pause
  gets.chomp
end

def save_record?
  prompt = TTY::Prompt.new
  prompt.yes?('Gostaria de salvar o endereço?')
end

def add_more?
  prompt = TTY::Prompt.new
  prompt.no?('Deseja adicionar outro endereço?')
end

def load_db(path)
  begin
    Sequel.sqlite(path)
  rescue StandardError => e
    puts "Failed to open the db file '#{path}'"
    puts e.message
  end
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
