class Product < ActiveRecord::Base
  belongs_to :store, required: true
  has_many :cart_products, dependent: :destroy
  has_many :carts, through: :cart_products

  validates :name, :total_value, presence: true

  scope :search_with_filter, lambda { |filter| where(filter) }

  def introduce_itself(gap: '')
    puts "#{gap}Produto ##{self.id}"
    puts "#{gap}\t- Nome: #{self.name}"
    puts "#{gap}\t- Descrição: #{self.description}"
    puts "#{gap}\t- Valor Original do Produto: #{self.total_value}"
    puts "#{gap}\t- Vendido pela loja: #{self.store&.name}"
  end

  def self.humanized_table_name
    "Tabela de Produtos"
  end

  def self.editable_columns
    %w[name description total_value store_id]
  end

  def self.columns_explanation
    {
      id: "Identificador Único do produto - (NÃO EDITÁVEL)",
      name: "Nome do produto",
      description: "Descrição do produto",
      total_value: "Valor Total do produto",
      store_id: "Chave Estrangeira para Loja",
      created_at: "Data e hora que o produto foi criada - (NÃO EDITÁVEL)",
      updated_at: "Data e hora da última vez que o produto foi atualizada - (NÃO EDITÁVEL)"
    }
  end
end
