class CreateDummyDriverLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :dummy_driver_locations do |t|
      t.belongs_to :driver, index: true
      t.belongs_to :order, index: true

      t.text :location
      t.decimal :lat
      t.decimal :lng
      t.string :status
      
      t.timestamps
    end
  end
end
