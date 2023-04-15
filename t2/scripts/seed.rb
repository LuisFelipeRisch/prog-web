require 'active_record'
require_relative '../models/user.rb'
require_relative '../models/cart.rb'
require_relative '../models/store.rb'
require_relative '../models/product.rb'
require_relative '../models/cart_product.rb'

now = Time.now.utc

user_one = User.find_or_create_by(name: "Bruno Muller", email: "bmuller@inf.ufpr.br")

user_two = User.find_or_create_by(name: "Luis Felipe Risch", email: "lfr20@inf.ufpr.br")

store_one = Store.find_or_create_by(name: "BCC - CAAD", description: "Monster a preço de bala!!!!!")
store_two = Store.find_or_create_by(name: "Burguer King", description: "Melhor que Mcdonald's")

if store_one.created_at > now
  store_one.add_product({name: "Monster", description: "Não tome quando for meia noite, se não vai te dar vontade de fazer trabalho 2 de prog web :). Já são 3 da manhã, socorro", total_value: 7.90})
  store_one.add_product({name: "Trento de Morango", description: "Hmmmm moranguinho...", total_value: 1.50})
  store_one.add_product({name: "Trento de Limão", description: "Hmmmm azedinho...", total_value: 2.53})
  store_one.save
end

if store_two.created_at > now
  store_two.add_product({name: "Whopper", description: "Chora Big Mac", total_value: 11.90})
  store_two.add_product({name: "Bk Fritas", description: "Chora Mac fritas", total_value: 7.50})
  store_two.add_product({name: "Coquinha", description: "Hmmmm docinho...", total_value: 5.74})
  store_two.save
end

if user_one.created_at > now
  user_one_cart = user_one.cart

  user_one_cart.add_product(product: store_one.products.first)
  user_one_cart.add_product(product: store_one.products.second)
  user_one_cart.add_product(product: store_two.products.first)
  user_one_cart.add_product(product: store_two.products.second)
  user_one_cart.save
end

if user_two.created_at > now
  user_two_cart = user_two.cart

  user_two_cart.add_product(product: store_one.products.first)
  user_two_cart.add_product(product: store_one.products.second)
  user_two_cart.add_product(product: store_two.products.first)
  user_two_cart.add_product(product: store_two.products.last)
  user_two_cart.save
end





