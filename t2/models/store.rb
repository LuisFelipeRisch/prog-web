class Store < ActiveRecord::Base
  has_many :products, dependent: :destroy

  validates :name, presence: true

  scope :search_with_filter, lambda { |filter| where(filter) }

  def introduce_itself(gap: '')
    puts "#{gap}Loja ##{self.id}"
    puts "#{gap}\t- Nome: #{self.name}"
    puts "#{gap}\t- Descrição: #{self.description}"
    puts "#{gap}\t- Produtos:"

    self.products.find_each { |product| product.introduce_itself(gap: "#{gap}\t\t") }
  end

  def self.humanized_table_name
    "Tabela de Lojas"
  end

  def self.editable_columns
    %w[name description]
  end

  def self.columns_explanation
    {
      id: "Identificador único da loja - (NÃO EDITÁVEL)",
      name: "Nome da loja",
      description: "Descrição da loja",
      created_at: "Data e hora qua loja foi criada - (NÃO EDITÁVEL)",
      updated_at: "Data e hora da última vez que a loja foi atualizada - (NÃO EDITÁVEL)"
    }
  end

  def add_product(product_attributes)
    self.products.build(product_attributes)
  end
end
