
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

class ProductTest < Minitest::Test

  def test_should_validate_name_and_total_value_and_store
    product = Product.new
    refute product.valid?

    assert_equal product.errors.messages[:name], ["can't be blank"]
    assert_equal product.errors.messages[:total_value], ["can't be blank"]
    assert_equal product.errors.messages[:store], ["must exist"]

    store = Store.new
    store.save!(validate: false)

    product.name = "Dummy product"
    product.total_value = 10.0
    product.store = store

    assert product.valid?
  end

  def test_should_delete_cart_products_when_product_is_deleted
    product = Product.new
    product.save!(validate: false)

    cart = Cart.new
    cart.add_product(product: product)
    cart.save!(validate: false)

    product.destroy

    refute CartProduct.exists?(product: product)
  end

end


