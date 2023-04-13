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

class StoreTest < Minitest::Test

  def test_should_validate_store_name
    store = Store.new
    refute store.valid?

    assert_equal store.errors.messages[:name], ["can't be blank"]

    store.name = 'Dummy'
    assert store.valid?
  end

  def test_should_create_store
    store = Store.new(name: 'Dummy name', description: 'Dummy description')
    store.save!(validate: false)

    assert_equal 'Dummy name', store.name
    assert_equal 'Dummy description', store.description
  end

  def test_should_associate_products_to_store
    store = Store.new
    store.save!(validate: false)

    store.add_product({name: 'Dummy product name', description: 'Dummy product description', total_value: 10.0})
    store.save!(validate: false)

    assert store.products.exists?(id: Product.last.id)
  end

  def test_should_raise_exception_if_tries_to_pass_unknow_product_attr
    store = Store.new
    store.save!(validate: false)

    assert_raises ActiveModel::UnknownAttributeError do
      store.add_product({unknow_attr: 'unknow'})
    end
  end

  def test_should_delete_all_products_when_store_is_deleted
    store = Store.new
    store.save!(validate: false)

    product = store.add_product({name: 'Dummy product name', description: 'Dummy product description', total_value: 10.0})
    store.save!(validate: false)

    assert store.products.exists?(id: product.id)

  end
end


