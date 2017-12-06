class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :username
      t.string :password_digest
      t.string :full_name
      t.string :email
      t.string :phone
      t.text :address
      t.string :service_type
      t.decimal :credit, precision: 8, scale: 2, default: 50000

      t.timestamps
    end
  end
end
