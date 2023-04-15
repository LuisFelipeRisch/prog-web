class Store < ActiveRecord::Base
  has_many :products, dependent: :destroy

  validates :name, presence: true

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

  def self.columns_explanation
    {
      id: "Identificador único da loja",
      name: "Nome da loja",
      description: "Descrição da loja",
      created_at: "Data e hora qua loja foi criada",
      updated_at: "Data e hora da última vez que a loja foi atualizada"
    }
  end

  def add_product(product_attributes)
    self.products.build(product_attributes)
  end
end
