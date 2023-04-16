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

def table_name_to_model(table_name: )
  models.find { |model| model.constantize.table_name == table_name }
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

def build_filter(model:, choice:)
  filter = Hash.new

  model.column_names.each do |column_name|
    if (index = choice =~ Regexp.new("#{column_name}: ")).present?
      if(index - 1 < 0 || choice[index - 1] == " ") #gambi
        part_of_choice = choice[(index + (column_name.size - 1) + 2)..]

        if (content = part_of_choice.match(/"([^"]+)"/)).present?
          filter[column_name] = content[1]
        end
      end
    end
  end

  filter
end

def handle_list(model:)
  puts "\n\n"
  puts "Se você quiser listar todos, basta digitar todos"
  puts 'Se você quiser aplicar um filtro na listagem, basta digitar no seguinte formato: {identificador da coluna}: "{valor}" {identificador da coluna 2}: "{valor 2}" {identificador da coluna 3}: "{valor 3}"'
  puts 'Por favor, siga estritamente esse formato, só desconsidere "{" "}"'

  choice = (gets&.chomp).to_s

  if choice == 'todos'
    model.find_each { |instance| instance.introduce_itself }
  else
    model.search_with_filter(build_filter(model: model, choice: choice)).find_each { |instance| instance.introduce_itself }
  end
end

def handle_insert(model:)
  puts "\n\n"
  puts 'Agora, basta digitar os dados no seguinte formato: {identificador da coluna}: "{valor}" {identificador da coluna 2}: "{valor 2}" {identificador da coluna 3}: "{valor 3}"'
  puts 'Por favor, siga estritamente esse formato, só desconsidere "{" "}"'

  instance = nil

  loop do
    choice = (gets&.chomp).to_s

    model_attr = build_filter(model: model, choice: choice)
    model_attr.keys.each { |key| model_attr.delete(key) if model.editable_columns.exclude?(key) }

    instance = model.new(model_attr)

    break if instance.save

    puts "Ocorreu alguns errors de validação..."

    instance.errors.full_messages.each { |error_message| puts "\t- #{error_message}" }
  end

  instance.introduce_itself
end

def handle_update(model:)
  puts "\n\n"
  puts 'Antes de atualizar, é preciso buscar o(s) registro(s) que você esta querendo atualizar. Ou atualizar todos os registros'
  puts 'Para atualizar todos os registros, é preciso digitar todos'
  puts 'Para buscar os registros, digite os dados no seguinte formato: {identificador da coluna}: "{valor}" {identificador da coluna 2}: "{valor 2}" {identificador da coluna 3}: "{valor 3}"'
  puts 'Por favor, siga estritamente esse formato, só desconsidere "{" "}"'

  loop do
    choice = (gets&.chomp).to_s

    instances = choice == "todos" ? model.all : model.search_with_filter(build_filter(model: model, choice: choice))

    next if !instances.exists?

    puts 'Pronto, agora insira os dados a serem alterados no seguinte formato: {identificador da coluna}: "{valor}" {identificador da coluna 2}: "{valor 2}" {identificador da coluna 3}: "{valor 3}"'
    puts 'Por favor, siga estritamente esse formato, só desconsidere "{" "}"'

    loop do
      choice = (gets&.chomp).to_s

      model_attr = build_filter(model: model, choice: choice)
      model_attr.keys.each { |key| model_attr.delete(key) if model.editable_columns.exclude?(key) }

      next if model_attr.blank?

      instances.update_all(model_attr)
      break
    end

    break
  end
end

def handle_exclude(model:)
  puts "\n\n"
  puts 'Antes de atualizar, é preciso buscar o(s) registro(s) que você esta querendo atualizar. Ou excluir todos os registros'
  puts 'Para excluir todos os registros, é preciso digitar todos'
  puts 'Para buscar os registros, digite os dados no seguinte formato: {identificador da coluna}: "{valor}" {identificador da coluna 2}: "{valor 2}" {identificador da coluna 3}: "{valor 3}"'
  puts 'Por favor, siga estritamente esse formato, só desconsidere "{" "}"'

  loop do
    choice = (gets&.chomp).to_s

    instances = choice == "todos" ? model.all : model.search_with_filter(build_filter(model: model, choice: choice))

    next if !instances.exists?

    instances.destroy_all

    break
  end
end

def handle_command(splitted_command: )
  operation = splitted_command.first
  table_name = splitted_command.last

  puts "\n\nEntendido!"
  puts "Operação escolhida: #{operation}"
  puts "Tabela escolhida: #{table_name}"

  model = table_name_to_model(table_name: table_name).constantize

  puts "Relembrando esquema da #{model.humanized_table_name}..."
  model.columns_explanation.each { |k, v| puts " ° #{k}: #{v}" }

  case operation
  when "lista"
    handle_list(model: model)
  when "insere"
    handle_insert(model: model)
  when "altera"
    handle_update(model: model)
  when "exclui"
    handle_exclude(model: model)
  else
    raise "A combinação da operação: #{operation} com a tabela: #{table} é IMPOSSÍVEL de acontecer! Brigue com o dev responsável por fazer esse script"
  end
end

print_instructions

begin
  loop do
    puts "\nInsira um comando válido, exemplo: lista users"
    command = (gets&.chomp).to_s

    break if command == 'exit'

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

