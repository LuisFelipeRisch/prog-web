class Product < ActiveRecord::Base
  belongs_to :store, required: true
  has_many :cart_products, dependent: :destroy
  has_many :carts, through: :cart_products

  validates :name, :total_value, presence: true

  def introduce_itself(gap: '', should_show_owner: false)
    puts "#{gap}Produto ##{self.id}"
    puts "#{gap}\t- Nome: #{self.name}"
    puts "#{gap}\t- Descrição: #{self.description}"
    puts "#{gap}\t- Valor Original do Produto: #{self.total_value}"
    puts "#{gap}\t- Vendido pela loja: #{self.store&.name}" if should_show_owner
  end

  def self.humanized_table_name
    "Tabela de Produtos"
  end

  def self.columns_explanation
    {
      id: "Identificador Único do produto",
      name: "Nome do produto",
      description: "Descrição do produto",
      total_value: "Valor Total do produto",
      store_id: "Chave Estrangeira para Loja",
      created_at: "Data e hora que o produto foi criada",
      updated_at: "Data e hora da última vez que o produto foi atualizada"
    }
  end
end
