class Driver < ApplicationRecord
  has_secure_password

  validates :username, :full_name, :email, :phone, :address, :service_type, presence: true
  validates :username, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: {minimum: 4}, allow_blank: true
  validates :phone, numericality: true
  
end
