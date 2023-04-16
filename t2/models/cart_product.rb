class CartProduct < ActiveRecord::Base
  belongs_to :cart, required: true
  belongs_to :product, required: true

  before_create :set_total_value

  scope :search_with_filter, lambda { |filter| where(filter) }

  def self.humanized_table_name
    "Tabela de Cesta-Produtos"
  end

  def self.editable_columns
    %w[cart_id product_id]
  end

  def introduce_itself(gap: '')
    puts "#{gap}Cesta-Produto ##{self.id}"
    puts "#{gap}\t- Id da Cesta que pertenço: #{self.cart.id}"
    puts "#{gap}\t- Id do Produto que pertenço: #{self.product.id}"
  end

  def self.columns_explanation
    {
      id: "Identificador Único da cesta-produto - (NÃO EDITÁVEL)",
      cart_id: "Chave Estrangeira para Cesta",
      product_id: "Chave Estrangeira para Produto",
      total_value: "Valor Total do produto quando colocado no carrinho - (NÃO EDITÁVEL)",
      created_at: "Data e hora que a cesta-produto foi criada - (NÃO EDITÁVEL)",
      updated_at: "Data e hora da última vez que a cesta-produto foi atualizada - (NÃO EDITÁVEL)"
    }
  end

  private

  def set_total_value
    self.total_value = self.product&.total_value
  end
end