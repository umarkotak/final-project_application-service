class CreateDummyDriverLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :dummy_driver_locations do |t|

      t.timestamps
    end
  end
end
