class Order < ApplicationRecord
  
  

  def get_distance
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
    distance_matrix = gmaps.distance_matrix(origin, address)
    distance = distance_matrix[:rows][0][:elements][0][:distance][:value] / 1000.0
    self.distance = distance.to_f.round(2)
    distance.to_f.round(2)
  end

  def get_coordinate(location_name)
    result = {}
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location_name}+&key=AIzaSyD9eO9WPUr-KKTqUM8Q3uzHcZpThY4NIDM"
    request = HTTP.get(url).to_s
    request = JSON.parse(result)
    result["lat"] = request["results"][0]["geometry"]["location"]["lat"]
    result["lng"] = request["results"][0]["geometry"]["location"]["lng"]
    result
  end

  private
    def validate_address
      if address != ""
        # Setup API keys
        gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
        distance_matrix = gmaps.distance_matrix(address, address)
        status = distance_matrix[:rows][0][:elements][0][:status]
        errors.add(:address, "is invalid") if status == "NOT_FOUND"
      end
    end
end
