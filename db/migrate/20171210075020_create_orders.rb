class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true
      t.belongs_to :driver, index: true
      
      t.text :origin
      t.text :destination
      t.decimal :distance
      t.string :service_type
      t.string :payment_type
      t.decimal :price
      t.string :status

      t.timestamps
    end
  end
end
