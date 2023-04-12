class Store < ActiveRecord::Base
  has_many :products, inverse_of: :store, dependent: :destroy
end
