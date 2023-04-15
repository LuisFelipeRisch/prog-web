class CartProduct < ActiveRecord::Base
  belongs_to :cart, required: true
  belongs_to :product, required: true

  before_create :set_total_value

  def self.humanized_table_name
    "Tabela de Cesta-Produtos"
  end

  def self.columns_explanation
    {
      id: "Identificador Único da cesta-produto",
      user_id: "Chave Estrangeira para Usuário",
      product_id: "Chave Estrangeira para Produto",
      total_value: "Valor Total do produto quando colocado no carrinho",
      created_at: "Data e hora que a cesta-produto foi criada",
      updated_at: "Data e hora da última vez que a cesta-produto foi atualizada"
    }
  end

  private

  def set_total_value
    self.total_value = self.product&.total_value
  end
end