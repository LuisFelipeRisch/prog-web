class Cart < ActiveRecord::Base
  belongs_to :user, required: true
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  def add_product(product: )
    self.cart_products.build(product: product)
  end

  def self.humanized_table_name
    "Tabela de Cestas"
  end

  def self.columns_explanation
    {
      id: "Identificador Único do carrinho",
      user_id: "Chave Estrangeira para Usuário",
      created_at: "Data e hora que a cesta foi criada",
      updated_at: "Data e hora da última vez que a cesta foi atualizada"
    }
  end
end
