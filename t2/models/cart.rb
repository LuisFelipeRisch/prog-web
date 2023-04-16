class Cart < ActiveRecord::Base
  belongs_to :user, required: true
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  scope :search_with_filter, lambda { |filter| where(filter) }

  def add_product(product: )
    self.cart_products.build(product: product)
  end

  def introduce_itself(gap: '')
    puts "#{gap}Cesta ##{self.id}"
    puts "#{gap}\t- Usuário que pertenço: #{self.user.name}"
  end

  def self.humanized_table_name
    "Tabela de Cestas"
  end

  def self.editable_columns
    %w[user_id]
  end

  def self.columns_explanation
    {
      id: "Identificador Único do carrinho - (NÃO EDITÁVEL)",
      user_id: "Chave Estrangeira para Usuário",
      created_at: "Data e hora que a cesta foi criada - (NÃO EDITÁVEL)",
      updated_at: "Data e hora da última vez que a cesta foi atualizada - (NÃO EDITÁVEL)"
    }
  end
end
