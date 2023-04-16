class User < ActiveRecord::Base
  has_one :cart, dependent: :destroy

  before_create :initialize_cart

  validates :name, presence: true

  scope :search_with_filter, lambda { |filter| where(filter) }

  def introduce_itself(gap: '')
    puts "#{gap}Usuário ##{self.id}"
    puts "#{gap}\t- Nome: #{self.name}"
    puts "#{gap}\t- Email: #{self.email}"
    puts "#{gap}\t- Carrinho:"

    self.cart.cart_products.find_each do |cart_product|
      product = cart_product.product

      product.introduce_itself(gap: "#{gap}\t\t")
    end
  end

  def self.humanized_table_name
    "Tabela de Usuários"
  end

  def self.editable_columns
    %w[name email]
  end

  def self.columns_explanation
    {
      id: "Identificador Único do usuário - (NÃO EDITÁVEL)",
      name: "Nome do usuário",
      email: "Email do usuário",
      created_at: "Data e hora que usuário foi criado - (NÃO EDITÁVEL)",
      updated_at: "Data e hora da última vez que o usuário foi atualizado - (NÃO EDITÁVEL)"
    }
  end

  private

  def initialize_cart
    build_cart
  end
end
