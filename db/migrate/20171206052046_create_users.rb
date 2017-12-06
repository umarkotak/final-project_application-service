class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :full_name
      t.string :email
      t.string :phone
      t.text :address
      t.decimal :credit, precision: 8, scale: 2

      t.timestamps
    end
  end
end
