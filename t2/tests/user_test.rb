ENV['RAILS_ENV'] = 'test'

require 'pry'
require 'minitest/autorun'
require 'active_record'
require_relative '../scripts/create_database_test.rb'
require_relative '../models/user.rb'
require_relative '../models/cart.rb'

Minitest.after_run do
  File.delete("database/test.sqlite3")  # to it works, you need to run the script in the root path of t2 (/t2)
end

class UserTest < Minitest::Test

  def test_should_create_user
    user = User.create(name: 'Alice', email: 'alice@example.com')

    assert_equal 'Alice', user.name
    assert_equal 'alice@example.com', user.email
  end

  def test_should_init_cart_when_creating_user
    user = User.create

    assert_equal user.cart, Cart.last
  end

  def test_should_cart_be_destroyed
    user = User.create
    user_id = user.id

    count_before = Cart.where(user_id: user_id).count
    user.destroy
    count_after = Cart.where(user_id: user_id).count

    assert_equal count_after, count_before - 1
  end
end


