# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  username: 'umarkotak',
  password: 'umarkotak',
  full_name: 'umar kotak',
  email: 'umarkotak@email.com',
  phone: '01',
  address: 'address 1'
)

Driver.create!(
  username: 'driver1',
  password: 'driver1',
  full_name: 'driver 1',
  email: 'driver1@email.com',
  phone: '001',
  address: 'driver address 1',
  service_type: 'gojek'
)