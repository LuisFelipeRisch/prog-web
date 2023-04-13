class CartProduct < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  before_create :set_total_value

  private

  def set_total_value
    self.total_value = self.product&.total_value
  end
end