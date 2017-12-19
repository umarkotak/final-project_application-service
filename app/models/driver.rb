class Driver < ApplicationRecord
  has_secure_password

  has_many :order
  has_many :driver_locations

  validates :username, :full_name, :email, :phone, :address, :service_type, presence: true
  validates :username, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: {minimum: 4}, allow_blank: true
  validates :phone, numericality: true
  validates :email, format: {
    with: /.+@.+\..+/i,
    message: 'email format is invalid'
  }
  validates :service_type, inclusion: { in: %w(gojek gocar), message: "%{value} is not a valid service type"  }


  def topup(amount)
    if ensure_amount_is_valid(amount)
      self.credit += amount.to_f
    else
      return false
    end
  end

  def ensure_amount_is_valid(amount)
    if is_number?(amount) && amount.to_f > 0
      return true
    else
      return false
    end
  end

  def is_number?(amount)
    true if Float(amount) rescue false
  end

  def self.get_available_drivers(service_type)
    drivers = Driver.joins(:driver_locations)
    drivers = drivers.where("driver_locations.status = 'online'")
    drivers = drivers.where("drivers.service_type = '#{service_type}'")

    drivers.order("RANDOM()").first
  end

  def self.complete_job(order)
    if order.payment_type == 'gopay'
      user = User.find(order.user_id)
      driver = Driver.find(order.driver_id)

      user.credit -= order.price
      driver.credit += order.price

      user.save
      driver.save
    end

    # working on moving driver after complete job
  end
end
