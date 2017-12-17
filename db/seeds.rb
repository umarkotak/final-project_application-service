# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Driver.delete_all
DriverLocation.delete_all

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

Driver.create!(
  username: 'driver3',
  password: 'umarkotak',
  full_name: 'driver3 fullname',
  email: 'driver3@email.com',
  phone: '002',
  address: 'driver address 3',
  service_type: 'gojek'
)

Driver.create!(
  username: 'driver4',
  password: 'umarkotak',
  full_name: 'driver4 fullname',
  email: 'driver4@email.com',
  phone: '002',
  address: 'driver address 4',
  service_type: 'gocar'
)

Driver.create!(
  username: 'driver5',
  password: 'umarkotak',
  full_name: 'driver5 fullname',
  email: 'driver5@email.com',
  phone: '002',
  address: 'driver address 5',
  service_type: 'gocar'
)

# DriverLocation.create!(
#   driver_id: 1,
#   service_type: 'gojek',
#   order_id: nil,
#   location: 'kemang',
#   lat: -6.2622689,
#   lng: 106.8134181,
#   status: 'online'
# )

# DriverLocation.create!(
#   driver_id: 2,
#   service_type: 'gojek',
#   order_id: nil,
#   location: 'jakarta',
#   lat: -6.17511,
#   lng: 106.8650395,
#   status: 'online'
# )

# DriverLocation.create!(
#   driver_id: 4,
#   service_type: 'gocar',
#   order_id: nil,
#   location: 'jakarta',
#   lat: -6.17511,
#   lng: 106.8650395,
#   status: 'online'
# )