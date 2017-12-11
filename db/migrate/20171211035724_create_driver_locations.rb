class CreateDriverLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_locations do |t|
      t.belongs_to :driver, index: true

      t.decimal :lat
      t.decimal :lng
      t.string :status

      t.timestamps
    end
  end
end
