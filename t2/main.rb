ENV['RUBY-ENV'] = 'dev'

require 'pry'
require 'active_record'
require_relative 'scripts/create_database.rb'
require_relative 'models/user.rb'
require_relative 'models/cart.rb'
require_relative 'models/store.rb'
require_relative 'models/product.rb'
require_relative 'models/cart_product.rb'
require_relative 'scripts/seed.rb'

def operations
  %w[lista insere altera exclui]
end

def models
  %w[User Store Product Cart CartProduct]
end

def tables_name
  models.map(&:constantize).map(&:table_name)
end

def print_instructions
  puts "Olá!"
  puts "Bem vindo a minha lojinha de compra e venda via console :)"
  puts "Antes de começar a digitar um monte de código, aqui vai algumas instruções"
  puts "\t* Esquema do Banco de Dados:"

  models.map(&:constantize).each do |model|
    puts "\t\t - Colunas da #{model.humanized_table_name} (#{model.table_name})"
    model.columns_explanation.each { |k, v| puts "\t\t\t ° #{k}: #{v}" }
  end

  puts "\t* Como funciona?"
  puts "\t\tBasicamente, você precisa digitar um comando, o qual é formado pelo seguinte formato: {operação} {tabela}"
  puts "\t\tOs valores possíveis para operação são: #{operations.join(', ')}"
  puts "\t\tOs valores possíveis para tabela são: #{tables_name.join(', ')}"
  puts "\n\nIMPORTANTE: Existem mais instruções, mas vamos por partes para não ficar confuso"
  puts "OBSERVAÇÃO: Se desejar sair do programa, basta digitar exit\n\n"
end

def is_command_valid?(command: )
  begin
    splitted_command = command.split(' ').map(&:strip)
    return operations.include?(splitted_command.first) && tables_name.include?(splitted_command.last), splitted_command
  rescue
    return false, []
  end
end

def handle_command(splitted_command: )
  puts "\n\nEntendido!"
  puts "Operação escolhida: #{splitted_command.first}"
  puts "Tabela escolhida: #{splitted_command.last}"
end

print_instructions

begin
  loop do
    puts "\nInsira um comando válido, exemplo: lista users"
    command = (gets&.chomp).to_s

    break if command =~ /exit/

    valid, splitted_command = is_command_valid?(command: command)

    next if !valid

    handle_command(splitted_command: splitted_command)
  end

  exit 0
rescue SystemExit
  puts "Tchau!. Do inglês... Bye!"
rescue => exception
  puts exception.message
  puts exception.backtrace
end

