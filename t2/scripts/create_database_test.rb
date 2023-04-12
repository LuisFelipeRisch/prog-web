require 'rubygems'
require 'active_record'

puts ENV['RAILS_ENV']

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "database/test.sqlite3"

if !ActiveRecord::Base.connection.table_exists? 'users'
  ActiveRecord::Base.connection.create_table :users do |t|
    t.string :name
    t.string :email
  end
end

if !ActiveRecord::Base.connection.table_exists? 'stores'
  ActiveRecord::Base.connection.create_table :stores do |t|
    t.string :name
    t.string :description
  end
end

if !ActiveRecord::Base.connection.table_exists? 'carts'
  ActiveRecord::Base.connection.create_table :carts do |t|
    t.belongs_to :user
  end
end

if !ActiveRecord::Base.connection.table_exists? 'products'
  ActiveRecord::Base.connection.create_table :products do |t|
    t.string     :name
    t.string     :description
    t.float      :total_value
    t.belongs_to :store
  end
end

if !ActiveRecord::Base.connection.table_exists? 'cart_products'
  ActiveRecord::Base.connection.create_table :cart_products do |t|
    t.belongs_to :cart
    t.belongs_to :product
    t.float      :total_value
  end
end