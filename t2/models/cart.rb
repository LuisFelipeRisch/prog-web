class Cart < ActiveRecord::Base
  belongs_to :user, required: true
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  def add_product(product: )
    self.cart_products.build(product: product)
  end
end
