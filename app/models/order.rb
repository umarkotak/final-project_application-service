class Order < ApplicationRecord
  
  

  def get_distance
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyBtGoQM9mdzHQiyjcxpxfJmSfjK0rUbGEI')
    distance_matrix = gmaps.distance_matrix(origin, address)
    distance = distance_matrix[:rows][0][:elements][0][:distance][:value] / 1000.0
    self.distance = distance.to_f.round(2)
    distance.to_f.round(2)
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
