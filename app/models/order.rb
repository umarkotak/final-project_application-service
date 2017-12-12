class Order < ApplicationRecord
  has_many :driver_locations

  validates :user_id, :origin, :destination, :service_type, :payment_type, presence: true
  
  def get_coordinate(location_name)
    result = {}
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name.gsub(' ', '%20')}+&key=AIzaSyD9eO9WPUr-KKTqUM8Q3uzHcZpThY4NIDM"
    request = HTTP.get(url).to_s
    request = JSON.parse(request)
    result[:lat] = request["results"][0]["geometry"]["location"]["lat"]
    result[:lng] = request["results"][0]["geometry"]["location"]["lng"]
    result
  end

  def validate_route(origin, destination)
    status = true
    begin
      gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
      distance_matrix = gmaps.distance_matrix(origin, destination)

      status = false if distance_matrix[:rows][0][:elements][0][:status] == "NOT_FOUND"

      status = distance_matrix
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

  def get_available_drivers
    drivers = Driver.joins(:driver_locations)
    drivers = drivers.where("driver_locations.status = 'online'").where("drivers.service_type = '#{self.service_type}'")
    
    drivers.order("RANDOM()").first
  end

  private

end
