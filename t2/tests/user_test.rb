
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

class UserTest < Minitest::Test

  def test_should_validate_user_name
    user = User.new
    refute user.valid?

    assert_equal user.errors.messages[:name], ["can't be blank"]

    user.name = 'Dummy'
    assert user.valid?
  end

  def test_should_create_user
    user = User.new(name: 'Alice', email: 'alice@example.com')
    user.save!(validate: false)

    assert_equal 'Alice', user.name
    assert_equal 'alice@example.com', user.email
  end

  def test_should_init_cart_when_creating_user
    user = User.new
    user.save!(validate: false)

    assert_equal user.cart, Cart.last
  end

  def test_should_cart_be_destroyed
    user = User.new
    user.save!(validate: false)
    user_id = user.id

    user.destroy

    refute Cart.exists?(user: user)
  end
end


