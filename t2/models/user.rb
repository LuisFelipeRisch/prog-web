class User < ActiveRecord::Base
  has_one :cart, dependent: :destroy

  before_create :initialize_cart

  private

  def initialize_cart
    build_cart
  end
end
