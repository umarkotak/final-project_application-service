class Order < ApplicationRecord
  has_many :driver_locations

  validates :user_id, :origin, :destination, :service_type, :payment_type, presence: true
  
  def apikey
    "AIzaSyAxXs-AipMveHRNInl7P3HubboAWgK4aqU"
  end

  def get_coordinate(location_name)
    result = {}
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name.gsub(' ', '%20')}+&key=#{apikey}"
    request = HTTP.get(url).to_s
    request = JSON.parse(request)
    result[:lat] = request["results"][0]["geometry"]["location"]["lat"]
    result[:lng] = request["results"][0]["geometry"]["location"]["lng"]
    result
  end

  def validate_route(origin, destination)
    status = true
    begin
      gmaps = GoogleMapsService::Client.new(key: apikey)
      distance_matrix = gmaps.distance_matrix(origin, destination)

      status = distance_matrix
      status = false if distance_matrix[:rows][0][:elements][0][:status] == "NOT_FOUND"
    rescue
      status = false
    end
    status
  end

  def set_distance(distance_matrix)
    distance = distance_matrix[:rows][0][:elements][0][:distance][:value] / 1000.0
    self.distance = distance.to_f.round(2)
  end

  def set_price
    if self.service_type == 'gojek'
      self.price = 1500 * self.distance
    elsif self.service_type == 'gocar'
      self.price = 2500 * self.distance
    end
  end

  def set_order_data(temp_data)
    self.user_id      = temp_data["user_id"]
    self.driver_id    = temp_data["driver_id"]
    self.origin       = temp_data["origin"]
    self.destination  = temp_data["destination"]
    self.distance     = temp_data["distance"]
    self.service_type = temp_data["service_type"]
    self.price        = temp_data["price"]
    self.status       = 'on_process'
  end

  def check_gopay(user_id)
    user = User.find(self.user_id)
    user.credit > self.price ? status = true : status = false
  end

  private

end
