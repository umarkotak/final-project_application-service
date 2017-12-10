class Order < ApplicationRecord
  t.text :origin
  t.text :destination
  t.decimal :distance
  t.string :service_type
  t.string :payment_type
  t.decimal :price
  t.string :status
end
