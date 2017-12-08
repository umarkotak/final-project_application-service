class User < ApplicationRecord
  has_secure_password

  validates :username, :full_name, :email, :phone, :address, presence: true
  validates :username, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: {minimum: 4}, allow_blank: true
  validates :phone, numericality: true
  validates :email, format: {
    with: /.+@.+\..+/i,
    message: 'email format is invalid'
  }

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

end
