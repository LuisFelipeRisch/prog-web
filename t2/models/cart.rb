class Cart < ActiveRecord::Base
  # has_many :cart_products, dependent: :destroy
  # has_many :products, through: :cart_products
end
