require 'pry'
require 'minitest/autorun'
require 'active_record'
require_relative '../scripts/create_database.rb'
require_relative '../models/user.rb'
require_relative '../models/cart.rb'
require_relative '../models/store.rb'
require_relative '../models/product.rb'
require_relative '../models/cart_product.rb'

Minitest.after_run do
  File.delete("database/test.sqlite3")  # to it works, you need to run the script in the root path of t2 (/t2)
end

class CartProductTest < Minitest::Test

  EPSILON = 0.0005

  def test_should_cart_and_product_required
    cart_product = CartProduct.new
    refute cart_product.valid?

    assert_equal cart_product.errors.messages[:cart], ["must exist"]
    assert_equal cart_product.errors.messages[:product], ["must exist"]
  end

  def test_should_product_total_value_be_set_before_creation
    cart = Cart.new
    product = Product.new(total_value: 1.0)

    cart.save!(validate: false)
    product.save!(validate: false)

    cart_product = CartProduct.new(cart: cart, product: product)
    cart_product.save!(validate: false)

    assert_in_epsilon cart_product.total_value, 1.0, EPSILON
  end
end


