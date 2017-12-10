# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  username: 'user1',
  password: 'umarkotak',
  full_name: 'user1 fullname',
  email: 'user1@email.com',
  phone: '01',
  address: 'address 1'
)

User.create!(
  username: 'user2',
  password: 'umarkotak',
  full_name: 'user2 fullname',
  email: 'user2@email.com',
  phone: '02',
  address: 'address 2'
)

Driver.create!(
  username: 'driver1',
  password: 'umarkotak',
  full_name: 'driver1 fullname',
  email: 'driver1@email.com',
  phone: '001',
  address: 'driver address 1',
  service_type: 'gojek'
)

Driver.create!(
  username: 'driver2',
  password: 'umarkotak',
  full_name: 'driver2 fullname',
  email: 'driver2@email.com',
  phone: '002',
  address: 'driver address 2',
  service_type: 'gojek'
)