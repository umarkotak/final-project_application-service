class DriverLocation < ApplicationRecord
  belongs_to :driver
  belongs_to :order, optional: true

  validates :driver_id, :location, :lat, :lng, :status, presence: true
  validates :status, inclusion: { in: %w(online offline busy), message: "%{value} is not a valid status type"  }
  validate :validate_location

  def get_coordinate(location_name)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name}+&key=AIzaSyD9eO9WPUr-KKTqUM8Q3uzHcZpThY4NIDM"
    request = HTTP.get(url).to_s
    request = JSON.parse(request)
    self.lat = request["results"][0]["geometry"]["location"]["lat"]
    self.lng = request["results"][0]["geometry"]["location"]["lng"]
  end

  def complete_job
    self.status = 'online'
    self.order_id = nil
  end

  def cancel_job(order)
    self.status = 'online'
    self.order_id = nil

    user = User.find(order.user_id)
    driver = Driver.find(order.driver_id)

    user.credit += order.price
    driver.credit -= order.price

    user.save
    driver.save
  end

  private
    def validate_location
      if location != nil && location != ''
        # Setup API keys
        gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
        distance_matrix = gmaps.distance_matrix(location, location)
        status = distance_matrix[:rows][0][:elements][0][:status]
        errors.add(:location, "is invalid") if status == "NOT_FOUND"
      end
    end
end
