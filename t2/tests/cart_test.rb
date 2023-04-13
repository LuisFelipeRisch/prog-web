require 'pry'
require 'minitest/autorun'
require 'active_record'
require_relative '../scripts/create_database_test.rb'
require_relative '../models/user.rb'
require_relative '../models/cart.rb'
require_relative '../models/store.rb'
require_relative '../models/product.rb'
require_relative '../models/cart_product.rb'

Minitest.after_run do
  File.delete("database/test.sqlite3")  # to it works, you need to run the script in the root path of t2 (/t2)
end

class CartTest < Minitest::Test

  EPSILON = 0.0005

  def test_should_user_be_required_on_cart_creation
    cart = Cart.new
    refute cart.valid?

    assert_equal cart.errors.messages[:user], ['must exist']
  end

  def test_should_be_possible_to_add_products_to_cart
    cart = Cart.new
    cart.save!(validate: false)

    product = Product.new(name: 'Dummy Name', description: 'Dummy Description', total_value: 10.0)
    product.save!(validate: false)

    cart.add_product(product: product)
    cart.save!(validate: false)

    assert cart.products.exists?(id: product.id)
  end

  def test_should_delete_cart_products_relation_when_cart_is_deleted_but_should_not_delete_product
    cart = Cart.new
    cart.save!(validate: false)

    product = Product.new
    product.save!(validate: false)
    cart.add_product(product: product)

    count_before = CartProduct.where(cart: cart).count
    cart.save!(validate: false)
    count_after = CartProduct.where(cart: cart).count

    assert_equal count_after - count_before, 1

    cart.destroy

    refute CartProduct.exists?(cart: cart)
    assert Product.exists?(id: product.id)
  end

  def test_should_not_be_possible_to_change_total_value_of_a_product_inserted_in_cart
    cart = Cart.new
    cart.save!(validate: false)

    product = Product.new(total_value: 10.0)
    product.save!(validate: false)

    cart.add_product(product: product)
    cart.save!(validate: false)

    assert cart.products.exists?(id: product.id)
    assert_in_epsilon cart.cart_products.last.total_value, 10.0, EPSILON

    product.total_value = 20.0
    product.save!(validate: false)
    assert_in_epsilon cart.cart_products.last.total_value, 10.0, EPSILON
  end

  def test_should_raise_exception_if_type_mismatch
    cart = Cart.new
    cart.save!(validate: false)

    assert_raises ActiveRecord::AssociationTypeMismatch do
      cart.add_product(product: 'fake product')
    end
  end
end


