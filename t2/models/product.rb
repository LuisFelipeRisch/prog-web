class Product < ActiveRecord::Base
  belongs_to :store, required: true
  has_many :cart_products, dependent: :destroy
  has_many :carts, through: :cart_products

  validates :name, :total_value, presence: true
end
