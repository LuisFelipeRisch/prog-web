class CartProduct < ActiveRecord::Base
  belongs_to :cart, required: true
  belongs_to :product, required: true

  before_create :set_total_value

  private

  def set_total_value
    self.total_value = self.product&.total_value
  end
end